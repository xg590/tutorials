# 安装fcitx5
sudo apt install -y fcitx5 fcitx5-rime fcitx5-config-qt fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 fcitx5-frontend-qt5

# 设置输入法框架
im-config -n fcitx5

# 写环境变量
cat << EOF >> ~/.profile
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
EOF

# 写用户配置
echo "run_im fcitx5" > ~/.xinputrc


# 设置默认输入法
mkdir -p ~/.config/fcitx5

cat <<EOF > ~/.config/fcitx5/profile
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=rime

[Groups/0/Items/0]
Name=rime
Layout=

[Groups/0/Items/1]
Name=keyboard-us
Layout=

[GroupOrder]
0=Default
EOF

fcitx5-remote -r