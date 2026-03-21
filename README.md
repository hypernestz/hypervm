<div align="center">
  <a href="https://github.com/hypernestz/hypervm/">
    <img src="https://raw.githubusercontent.com/hypernestz/hypervm/refs/heads/main/qwdz79r.png" alt="HyperVM Logo" width="512" />
  </a>

  # HyperVM
  **High-performance Virtual Machines for Pterodactyl**

  [![Build Status](https://img.shields.io/github/actions/workflow/status/hypernestz/hypervm/build.yml)](https://github.com/hypernestz/hypervm/actions)
  [![Version](https://img.shields.io/github/v/release/hypernestz/hypervm)](https://github.com/hypernestz/hypervm/releases)
  [![License](https://img.shields.io/github/license/hypernestz/hypervm)](https://github.com/hypernestz/hypervm/blob/main/LICENSE)
  [![Pulls](https://img.shields.io/docker/pulls/hypernestz/hypervm)](https://hub.docker.com/r/hypernestz/hypervm)

</div>

---

## 🚀 Features

* **Native KVM Support:** Hardware-accelerated virtualization for near-native performance.
* **Flexible Booting:** Supports ISO installation, UEFI (OVMF), and Legacy BIOS.
* **Storage & Network:** Automatic QCOW2 disk management and VirtIO driver support.
* **Remote Access:** Integrated VNC access with password protection.
* **Optimized Resource Handling:** Better CPU/RAM management for nested virtualization.

---

## 🛠 Installation (Custom Wings Binary)

> [\!WARNING]  
> **Mandatory Check:** Before installing, ensure Virtualization (Intel VT-x or AMD-V) is enabled in your BIOS. Run `ls /dev/kvm` on your host; if the file is missing, KVM is not enabled.
To enable KVM features, you must replace the standard Pterodactyl Wings binary with the HyperVM version.

### 1. Download HyperVM Binary
```bash
cd /opt/pterodactyl
# Stop existing service
systemctl stop wings
# Remove old binary
rm wings
# Download HyperVM (Replace with your specific release link)
curl -L -o wings https://github.com/hypernestz/hypervm/releases/latest/download/wings
chmod +x wings
```

### 2. Configure Systemd Service
Ensure your `/etc/systemd/system/wings.service` is configured to point to the correct binary path:

```ini
[Unit]
Description=Pterodactyl Wings Daemon (HyperVM)
After=docker.service
Requires=docker.service

[Service]
User=root
Group=root
WorkingDirectory=/etc/pterodactyl
ExecStart=/opt/pterodactyl/wings
Restart=on-failure
RestartSec=5
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
```

### 3. Apply Changes
```bash
systemctl daemon-reload
systemctl restart wings
```

---

## ⚡ Enabling KVM Support (`/dev/kvm`)

KVM is **strongly recommended** for performance. Without it, the VM will run in emulation mode (very slow).

### Node Requirements
* CPU Virtualization enabled in BIOS (**Intel VT-x** or **AMD-V**).
* Host supports `/dev/kvm`.

### Permission Fix (Crucial)
If KVM fails with a "Permission Denied" error, create a root crontab to ensure the device is accessible to the Docker container:
```bash
# Run this to add the cron job
(crontab -l 2>/dev/null; echo "@reboot chmod 666 /dev/kvm") | crontab -
# Apply immediately
chmod 666 /dev/kvm
```

---

## 🖥 Panel Configuration

### 1. Create the Mount
1. Go to **Admin -> Mounts**.
2. Create a new Mount:
   * **Source:** `/dev/kvm`
   * **Target:** `/dev/kvm`
3. Assign this mount to your **Node** and the specific **VM Egg**.

### 2. Enable on Server
1. Go to **Admin → Nodes → Your Node** and ensure **"Enable Mount Additional Files"** is checked in Settings.
2. Go to the specific **Server → Mounts**.
3. Add the `/dev/kvm` mount and restart the server.

---

## 📝 Important Notes

### VNC Access
* **Default Password:** `hyper1234` (Check your startup variables to change this).

### RAM Allocation
* **Linux:** 1024MB+ recommended.
* **Windows:** 4096MB (4GB) minimum. Windows installers may hang or BSOD with insufficient memory.

### VirtIO Drivers (Windows)
Windows does not include VirtIO drivers natively. 
1. Install Windows with `USE_VIRTIO=0` and `USE_VIRTIO_NET=0`.
2. Once installed, load the [VirtIO ISO](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso) to install drivers.
3. Enable VirtIO in the panel settings for a massive performance boost.

---

## ⚙️ Recommended Defaults

| Setting | Value |
| :--- | :--- |
| **RAM** | 4096+ (Windows) / 1024+ (Linux) |
| **USE_UEFI** | 1 (Recommended for modern OS) |
| **USE_VIRTIO** | 0 (Enable after driver install) |
| **USE_GPU** | 0 (Standard VGA) |

---

> [!CAUTION]
> This egg is intended for testing and development. It is not a 1:1 replacement for enterprise hypervisors like Proxmox or ESXi.

**© 2026 – HyperVM / Hypernestz**

---
