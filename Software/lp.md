* Show all printers
```sh
lpstat -t
```
* Print double sided
```sh
lp -d HP-LaserJet-MFP-M232-M237-2 -o sides=two-sided-long-edge contract_szust.pdf
```
* Modify printer parameter (after the printer got a new IP via AP)
```sh
lpadmin -p HP-LaserJet-MFP-M232-M237-2 -v socket://172.16.10.14 -E
```
### Troubleshotting
* scheduler is not running
```sh
# lpstat -r
scheduler is not running

# systemctl status cups cups-browsed
○ cups.service - CUPS Scheduler
     Loaded: loaded (/usr/lib/systemd/system/cups.service; disabled; preset: enabled)
     Active: inactive (dead)
TriggeredBy: ○ cups.socket
       Docs: man:cupsd(8)

○ cups-browsed.service - Make remote CUPS printers available locally
     Loaded: loaded (/usr/lib/systemd/system/cups-browsed.service; disabled; preset: enabled)
     Active: inactive (dead)

# systemctl start cups cups-browsed
# lpstat -r
scheduler is running
```
