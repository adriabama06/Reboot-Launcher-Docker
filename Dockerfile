FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV RESOLUTION=1280x720x24
ENV VNC_PORT=5900
ENV NOVNC_PORT=6080
ENV WINEPREFIX=/root/.wine
ENV WINEARCH=win64
ENV RebootLauncherVersion=10.0.9

# Install VNC server, noVNC, Wine and essential GUI/X11 dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wine \
        wine32 \
        wine64 \
        winbind \
        xvfb \
        x11vnc \
        tigervnc-standalone-server \
        novnc \
        websockify \
        xfce4 \
        net-tools \
        procps \
        ca-certificates \
        curl \
        wget \
        x11-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Symlink vnc.html to index.html for convenient noVNC access
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html || true

# Set working directory and unpack RebootLauncher
WORKDIR /root/RebootLauncher
ADD RebootLauncher.tar.gz /root/RebootLauncher/

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5900 6080

ENTRYPOINT ["/entrypoint.sh"]
