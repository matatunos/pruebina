#!/bin/bash
################################################################################
# Nextcloud Audit Log Importer - Installer
################################################################################

set -euo pipefail

echo "=========================================="
echo "Nextcloud Audit Log Importer - Installer"
echo "=========================================="
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "ERROR: This script must be run as root" >&2
   exit 1
fi

# Configuration
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="/etc/nextcloud-audit-importer"
STATE_DIR="/var/lib/nextcloud-audit-importer"
LOG_DIR="/var/log"
SYSTEMD_DIR="/etc/systemd/system"

echo "[1/8] Creating directories..."
mkdir -p "$CONFIG_DIR"
mkdir -p "$STATE_DIR"
mkdir -p "$LOG_DIR"

echo "[2/8] Installing dependencies..."
if command -v apt-get &>/dev/null; then
    apt-get update
    apt-get install -y mysql-client jq inotify-tools
elif command -v yum &>/dev/null; then
    yum install -y mysql jq inotify-tools
elif command -v dnf &>/dev/null; then
    dnf install -y mysql jq inotify-tools
else
    echo "WARNING: Could not detect package manager. Please install manually: mysql-client, jq, inotify-tools"
fi

echo "[3/8] Copying script..."
cp nextcloud-audit-importer.sh "$INSTALL_DIR/nextcloud-audit-importer"
chmod +x "$INSTALL_DIR/nextcloud-audit-importer"

echo "[4/8] Creating configuration..."
if [[ ! -f "$CONFIG_DIR/config.conf" ]]; then
    cp config.conf "$CONFIG_DIR/config.conf"
    echo "  ✓ Config file created: $CONFIG_DIR/config.conf"
else
    echo "  ! Config file already exists, skipping"
fi

echo "[5/8] Setting up MySQL credentials..."
if [[ ! -f "$CONFIG_DIR/.my.cnf" ]]; then
    read -p "MySQL user [nextcloud_audit]: " db_user
    db_user=${db_user:-nextcloud_audit}
    
    read -sp "MySQL password: " db_pass
    echo ""
    
    read -p "MySQL host [localhost]: " db_host
    db_host=${db_host:-localhost}
    
    cat > "$CONFIG_DIR/.my.cnf" <<EOF
[client]
user=$db_user
password=$db_pass
host=$db_host
EOF
    chmod 600 "$CONFIG_DIR/.my.cnf"
    echo "  ✓ MySQL config created"
else
    echo "  ! MySQL config already exists, skipping"
fi

echo "[6/8] Creating database and user..."
read -sp "MySQL root password: " mysql_root_pass
echo ""

# Use a temporary defaults file to avoid exposing password in process list
tmp_cnf=$(mktemp)
chmod 600 "$tmp_cnf"
cat > "$tmp_cnf" <<EOF
[client]
user=root
password=$mysql_root_pass
host=localhost
EOF

mysql --defaults-extra-file="$tmp_cnf" <<EOF
CREATE DATABASE IF NOT EXISTS nextcloud_logs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'nextcloud_audit'@'localhost' IDENTIFIED BY '${db_pass//\'/\'\'}';
GRANT ALL PRIVILEGES ON nextcloud_logs.* TO 'nextcloud_audit'@'localhost';
FLUSH PRIVILEGES;
EOF

rm -f "$tmp_cnf"

echo "  ✓ Database created"

echo "[7/8] Installing systemd service..."
cp nextcloud-audit.service "$SYSTEMD_DIR/nextcloud-audit.service"
systemctl daemon-reload
echo "  ✓ Service installed"

echo "[8/8] Setting permissions..."
chown -R root:root "$CONFIG_DIR"
chmod 700 "$CONFIG_DIR"
chmod 600 "$CONFIG_DIR/.my.cnf"
chown root:root "$STATE_DIR"
chmod 755 "$STATE_DIR"

echo ""
echo "=========================================="
echo "Installation complete!"
echo "=========================================="
echo ""
echo "Configuration file: $CONFIG_DIR/config.conf"
echo "MySQL credentials:  $CONFIG_DIR/.my.cnf"
echo "State directory:    $STATE_DIR"
echo "Log file:          /var/log/nextcloud-audit-importer.log"
echo ""
echo "Next steps:"
echo ""
echo "1. Edit configuration if needed:"
echo "   nano $CONFIG_DIR/config.conf"
echo ""
echo "2. Test the importer:"
echo "   nextcloud-audit-importer once"
echo ""
echo "3. Start monitoring service:"
echo "   systemctl start nextcloud-audit"
echo "   systemctl enable nextcloud-audit"
echo ""
echo "4. Check status:"
echo "   systemctl status nextcloud-audit"
echo "   tail -f /var/log/nextcloud-audit-importer.log"
echo ""
echo "5. View statistics:"
echo "   nextcloud-audit-importer stats"
echo ""
