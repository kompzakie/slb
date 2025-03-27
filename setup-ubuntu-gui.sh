#!/bin/bash

# ==============================================
# Ubuntu Desktop GUI in GitHub Codespaces (VNC)
# ==============================================
# Run this script in your Codespace to get a full Ubuntu GUI.
# After running, forward port 6080 and open the browser URL.
# ==============================================

set -e  # Exit on error

# Install Ubuntu Desktop + VNC
echo "[1] Installing Ubuntu Desktop (XFCE) and VNC..."
sudo apt update && sudo apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    xfce4 \
    xfce4-goodies \
    x11vnc \
    novnc \
    websockify \
    firefox

# Configure VNC password (default: "ubuntu")
echo "[2] Creating VNC password file (default: 'ubuntu')..."
mkdir -p ~/.vnc
# Create password file using x11vnc's storepasswd (alternative to vncpasswd)
x11vnc -storepasswd ubuntu ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Start VNC server (runs in background)
echo "[3] Starting VNC server on port 5900..."
x11vnc -display :0 -forever -shared -rfbauth ~/.vnc/passwd -rfbport 5900 > /dev/null 2>&1 &

# Start noVNC (accessible via port 6080)
echo "[4] Starting noVNC (access at http://localhost:6080)..."
websockify --web /usr/share/novnc 6080 localhost:5900 > /dev/null 2>&1 &

# Install optional GUI apps (uncomment if needed)
# echo "[5] Installing optional apps (VS Code, GIMP)..."
# sudo apt install -y code gimp

# Print instructions
echo "===================================================="
echo "✅ Ubuntu Desktop GUI is now running!"
echo "1️⃣  Forward port 6080 in Codespaces (click 'Ports' tab)"
echo "2️⃣  Open: https://<your-codespace-url>-6080.githubpreview.dev"
echo "🔑 VNC password: ubuntu"
echo "===================================================="
