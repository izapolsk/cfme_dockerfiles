#!/bin/sh

# Workaround for https://bugzilla.redhat.com/show_bug.cgi?id=1286787
if [ ! -f /etc/machine-id ]; then
  echo "7f496b3288e64931bd91bf723697e19c" > /etc/machine-id
fi

# Start Xvfb and x11vnc
export DISPLAY=:01
export PATH=":/usr/bin:/root/firefox:/root/chrome-driver:${PATH}"
export SSLKEYLOGFILE="/root/sslkeyfile.log"

touch allout.txt

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
echo "chk1" >> /checkpoints
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
echo "chk2" >> /checkpoints
xsetroot -solid grey
echo "chk3" >> /checkpoints
vncconfig -iconic &
echo "chk4" >> /checkpoints
fluxbox &
echo "chk5" >> /checkpoints
# Start the selenium server
java -jar /root/selenium-server/selenium-server-standalone.jar 2>&1 | tee -a allout.txt
echo "chk6" >> /checkpoints
xterm -maximized -e tail -f allout.txt -ls -title "$VNCDESKTOP Desktop" &
echo "chk7" >> /checkpoints