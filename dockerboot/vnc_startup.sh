#!/bin/bash
### every exit != 0 fails the script
set -e

# should also source $STARTUPDIR/generate_container_user
source ~/.bashrc

# add `--skip` to startup args, to skip the VNC startup procedure
if [[ $1 =~ --skip ]]; then
    echo -e "\n\n------------------ SKIP VNC STARTUP -----------------"
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '${@:2}'"
    exec "${@:2}"
fi

## resolve_vnc_connection
VNC_IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')

## start vncserver and noVNC webclient
vncserver -kill :1 || rm -rfv /tmp/.X*-lock /tmp/.X11-unix || echo "remove old vnc locks to be a reattachable container"
vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION

echo -e "\n------------------ startup of Xfce4 window manager ------------------"
### disable screensaver and power management
xset -dpms &
xset s noblank &
xset s off &

/usr/bin/startxfce4 --replace > $HOME/wm.log &
sleep 1
cat $HOME/wm.log

## log connect options
echo -e "\n\n------------------ VNC environment started ------------------"

if [[ $1 =~ -t|--tail-log ]]; then
    # if option `-t` or `--tail-log` block the execution and tail the VNC log
    echo -e "\n------------------ $HOME/.vnc/*$DISPLAY.log ------------------"
    tail -f $HOME/.vnc/*$DISPLAY.log
elif [ -z "$1" ] ; then
    echo -e "..."
else
    # unknown option ==> call command
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '$@'"
    exec "$@"
fi