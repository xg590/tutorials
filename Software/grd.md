### Remote Desktop Support on Ubuntu 2204
* Ubuntu 2204 comes with GNOME Remote Desktop (a remote desktop protocol server) by default and let's enable it remotely.
1. Generate the must-have tls-cert/tls-key for the RDP server.
    ```
    export GRDCERTDIR=${HOME}/.local/share/gnome-remote-desktop
    mkdir -p $GRDCERTDIR
    openssl genrsa -out ${GRDCERTDIR}/rdp-tls123.key 4096
    openssl req -new -subj "/C=DE/ST=Private/L=Home/O=Family/OU=IT Department/CN=ubuntu-live" \
                     -key ${GRDCERTDIR}/rdp-tls123.key \
                     -out ${GRDCERTDIR}/rdp-tls123.csr
    openssl x509 -req -days 100000 \
                      -signkey ${GRDCERTDIR}/rdp-tls123.key \
                      -in      ${GRDCERTDIR}/rdp-tls123.csr \
                      -out     ${GRDCERTDIR}/rdp-tls123.crt
    ```
* We cannot set a password for RDP server without dealing with keyring (a Linux security feature) because the password must be stored in it. 
2. Keyring is locked until we login with a password so let's unlock it.
    ```
    USERNAME=${USER}
    PASSWORD=${USER}
    echo -n ${PASSWORD} | gnome-keyring-daemon --daemonize --replace --unlock
    ```
3. With an unlocked keyring, we can set a password and do more by using grdctl [[Man Page]](https://manpages.ubuntu.com/manpages/lunar/man1/grdctl.1.html).
    ```
    grdctl rdp set-credentials ${USERNAME} ${PASSWORD}
    grdctl rdp disable-view-only
    grdctl rdp set-tls-cert ${GRDCERTDIR}/rdp-tls123.crt
    grdctl rdp set-tls-key  ${GRDCERTDIR}/rdp-tls123.key 
    grdctl rdp enable
    ```
4. Start the RDP server. 
    ```
    XDG_RUNTIME_DIR=/run/user/${UID} DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${UID}/bus systemctl start --user gnome-remote-desktop
    ```
5. Check 
    ```
    grdctl status && systemctl status --user gnome-remote-desktop
    ```
6. Lock the keyring
    ```
    pkill -u "$(whoami)" -f gnome-keyring-daemon # lock the keyring
    ```
7. After reboot [evidenced by "RDP Username is not set, denying client"]
    ```
    USERNAME=${USER}
    PASSWORD=${USER}
    echo -n ${PASSWORD} | gnome-keyring-daemon --daemonize --replace --unlock && grdctl rdp set-credentials ${USERNAME} ${PASSWORD}

    XDG_RUNTIME_DIR=/run/user/${UID} DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${UID}/bus systemctl restart --user gnome-remote-desktop
    grdctl status && systemctl status --user gnome-remote-desktop
    ```
* Misc
    ```
    WAYLAND_DISPLAY=wayland-0 gnome-www-browser
    gsettings list-recursively org.gnome.desktop.remote-desktop.rdp 
    gsettings set org.gnome.desktop.remote-desktop.rdp enable true
    apt install -y libsecret-tools
    secret-tool lookup xdg:schema org.gnome.RemoteDesktop.RdpCredentials
    secret-tool store --label "GRD RDP creds" xdg:schema org.gnome.RemoteDesktop.RdpCredentials
    ```
* Right
    ```
    a@office:~$ grdctl status && systemctl status --user gnome-remote-desktop
    RDP:
    	Status: enabled
    	TLS certificate: /home/a/.local/share/gnome-remote-desktop/rdp-tls123.crt
    	TLS key: /home/a/.local/share/gnome-remote-desktop/rdp-tls123.key
    	View-only: no
    	Username: (hidden)
    	Password: (hidden)
    ```
* Trubleshooting
  1. "Failed to start remote desktop session: GDBus.Error:org.freedesktop.DBus.Error.AccessDenied: Session creation inhibited"
    * We need an unlocked desktop session. we can either start a new autologin one
        ```
        echo -e "[daemon]\nAutomaticLogin=${TARGET_USER}\nAutomaticLoginEnable=true\n" | sudo tee /run/gdm/custom.conf
        sudo systemctl restart gdm
        ```
    * Or unlock an existing one
        ```
        sudo loginctl unlock-sessions
        ```
  2. "May 24 11:18:12 office gnome-remote-de[269597]: [RDP] Username is not set, denying client"