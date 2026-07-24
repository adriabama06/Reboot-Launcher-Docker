#!/bin/bash
set -e

# Setup runtime directory
export XDG_RUNTIME_DIR=/tmp/runtime-root
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Remove any existing X locks
rm -f /tmp/.X0-lock /tmp/.X11-unix/X0

RESOLUTION="${RESOLUTION:-1280x720x24}"
if [[ "$RESOLUTION" =~ ^[0-9]+x[0-9]+$ ]]; then
    RESOLUTION="${RESOLUTION}x24"
fi

echo "Starting Xvfb display server (${RESOLUTION})..."
Xvfb :0 -screen 0 ${RESOLUTION} -ac +extension GLX +render -noreset &

echo "Waiting for X server to start..."
for i in {1..30}; do
    if xset q >/dev/null 2>&1; then
        echo "X server is ready."
        break
    fi
    sleep 0.5
done

echo "Starting desktop environment (XFCE4)..."
startxfce4 &
sleep 1

echo "Starting VNC server..."
x11vnc -display :0 -forever -shared -nopw -rfbport ${VNC_PORT:-5900} -quiet &
sleep 1

echo "Starting noVNC web interface..."
if [ -d "/usr/share/novnc" ]; then
    websockify --web /usr/share/novnc ${NOVNC_PORT:-6080} localhost:${VNC_PORT:-5900} &
fi
sleep 1

echo "Launching RebootLauncher via Wine..."
cd /root/RebootLauncher
exec wine reboot_launcher.exe
