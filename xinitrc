VBoxClient-all &
xset +fp /usr/share/fonts/local
xset fp rehash
xscreensaver -nosplash &
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
exec ck-launch-session dbus-launch awesome
