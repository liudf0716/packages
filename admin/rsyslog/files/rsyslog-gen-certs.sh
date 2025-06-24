#!/bin/sh
#
# rsyslog SSL certificate generation script
# This script generates self-signed certificates for rsyslog TLS support
#
# Usage: rsyslog-gen-certs.sh [hostname]
#

CERT_DIR="/etc/ssl/certs"
KEY_DIR="/etc/ssl/private"
CA_KEY="${KEY_DIR}/rsyslog-ca-key.pem"
CA_CERT="${CERT_DIR}/rsyslog-ca.pem"
SERVER_KEY="${KEY_DIR}/rsyslog-key.pem"
SERVER_CERT="${CERT_DIR}/rsyslog-cert.pem"

# Show usage if requested
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 [hostname]"
    echo ""
    echo "Generate SSL certificates for rsyslog TLS support"
    echo ""
    echo "Options:"
    echo "  hostname    Custom hostname for the server certificate (optional)"
    echo "  -h, --help  Show this help message"
    echo ""
    echo "If no hostname is provided, the script will try to detect it automatically"
    echo "from uci, /proc/sys/kernel/hostname, or the hostname command."
    echo ""
    echo "Generated files:"
    echo "  ${CA_CERT}"
    echo "  ${SERVER_CERT}"
    echo "  ${SERVER_KEY}"
    exit 0
fi

# Create directories
mkdir -p "${CERT_DIR}"
mkdir -p "${KEY_DIR}"

# Set proper permissions
chmod 755 "${CERT_DIR}"
chmod 700 "${KEY_DIR}"

echo "Generating CA private key..."
openssl genrsa -out "${CA_KEY}" 4096
chmod 600 "${CA_KEY}"

echo "Generating CA certificate..."
openssl req -new -x509 -days 365 -key "${CA_KEY}" -out "${CA_CERT}" \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=IT/CN=rsyslog-ca"
chmod 644 "${CA_CERT}"

# Get hostname from various sources
get_hostname() {
    local hostname=""
    
    # Use command line argument if provided
    if [ -n "$1" ]; then
        hostname="$1"
    # Try uci first (OpenWrt way)
    elif command -v uci >/dev/null 2>&1; then
        hostname=$(uci -q get system.@system[0].hostname)
    fi
    
    # Try /proc/sys/kernel/hostname
    if [ -z "$hostname" ] && [ -f /proc/sys/kernel/hostname ]; then
        hostname=$(cat /proc/sys/kernel/hostname)
    fi
    
    # Try hostname command
    if [ -z "$hostname" ] && command -v hostname >/dev/null 2>&1; then
        hostname=$(hostname)
    fi
    
    # Default fallback
    if [ -z "$hostname" ]; then
        hostname="rsyslog-server"
    fi
    
    echo "$hostname"
}

HOSTNAME=$(get_hostname "$1")

echo "Generating server private key..."
openssl genrsa -out "${SERVER_KEY}" 4096
chmod 600 "${SERVER_KEY}"

echo "Generating server certificate signing request..."
openssl req -new -key "${SERVER_KEY}" -out "/tmp/server.csr" \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=IT/CN=${HOSTNAME}"

echo "Generating server certificate..."
openssl x509 -req -in "/tmp/server.csr" -CA "${CA_CERT}" -CAkey "${CA_KEY}" \
    -CAcreateserial -out "${SERVER_CERT}" -days 365
chmod 644 "${SERVER_CERT}"

# Cleanup
rm -f "/tmp/server.csr"

echo "SSL certificates generated successfully!"
echo "Hostname used: ${HOSTNAME}"
echo ""
echo "Generated certificates:"
echo "CA Certificate (for clients): ${CA_CERT}"
echo "Server Certificate (for server): ${SERVER_CERT}"
echo "Server Private Key (for server): ${SERVER_KEY}"
echo ""
echo "To enable TLS in rsyslog (anonymous mode):"
echo "uci set rsyslog.tls.enabled=1"
echo "uci set rsyslog.tls.driver=ossl"
echo "uci set rsyslog.tls.ca_file=${CA_CERT}"
echo "uci commit rsyslog"
echo "/etc/init.d/rsyslog restart"
echo ""
echo "Note: In anonymous mode, only CA certificate is needed for client configuration."
echo "Server certificate and key are only required on the rsyslog server side."
echo ""
echo "To enable remote logging with TLS:"
echo "uci set rsyslog.remote.enabled=1"
echo "uci set rsyslog.remote.server_ip=<SERVER_IP>"
echo "uci set rsyslog.remote.server_port=6514"
echo "uci set rsyslog.remote.protocol=tcp"
echo "uci set rsyslog.remote.use_tls=1"
echo "uci commit rsyslog"
echo "/etc/init.d/rsyslog restart"
