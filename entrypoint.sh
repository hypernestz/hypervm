#!/bin/bash

# --- 1. Define ANSI Color Codes ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- 2. Display ASCII Art ---
echo -e "${CYAN}"
cat << "EOF"
 _    _                    __    ____  __ 
| |  | |                   \ \  / /  \/  |
| |__| |_  _ _ __  ___ _ _\ \  / /| \  / |
|  __  | | | | '_ \ / _ \ '__\ \/ / | |\/| |
| |  | | |_| | |_) |  __/ |   \  /  | |  | |
|_|  |_|\__, | .__/ \___|_|    \/   |_|  |_|
         __/ | |                            
        |___/|_|                            
EOF
echo -e "${NC}"

echo -e "${GREEN}[+] Initializing environment...${NC}"

cd /home/container

# Fix QEMU temp write
export TMPDIR=/home/container/tmp
mkdir -p $TMPDIR

VNC_PORT=5901

echo -e "${GREEN}[+] Network Configuration:${NC}"
echo -e " ↳ QEMU VNC : ${YELLOW}1 → 5901${NC}"
echo -e " ↳ noVNC Web: ${YELLOW}$SERVER_PORT${NC}"
echo -e "${CYAN}=======================================${NC}"

# --- 3. Start noVNC (Background) ---
echo -e "${GREEN}[+] Starting noVNC in the background...${NC}"
cd /opt/novnc

# Run websockify in the background and discard logs to keep the console clean
./utils/websockify/run \
  --web /opt/novnc \
  0.0.0.0:${SERVER_PORT} \
  localhost:${VNC_PORT} > /dev/null 2>&1 &

# Wait briefly to ensure websockify binds to the port successfully
sleep 2

# --- 4. Start QEMU Console (Foreground) ---
cd /home/container
echo -e "${GREEN}[+] Entering QEMU Console. You can type your commands now!${NC}"
echo -e "${CYAN}=======================================${NC}\n"

MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

# Use 'exec' to replace the current shell with QEMU, attaching stdin/stdout directly
eval exec ${MODIFIED_STARTUP}
