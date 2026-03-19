FROM debian:bookworm-slim

RUN apt update && apt install -y \
    qemu-system-x86 \
    qemu-utils \
    iproute2 \
    net-tools \
    curl \
    ca-certificates \
    python3 \
    git \
    python3-numpy \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*


RUN git clone https://github.com/hypernestz/noVNC /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify \
    && cd /opt/novnc \
    && cp vnc.html index.html

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

RUN useradd -m -d /home/container container
USER container

WORKDIR /home/container
CMD ["/bin/bash", "/entrypoint.sh"]
