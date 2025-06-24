# Rsyslog TLS Configuration Guide

This package supports secure remote logging using TLS encryption. Here's how to configure it:

**Important**: This implementation uses anonymous authentication mode (`anon`) for maximum compatibility 
and ease of deployment. In this mode:
- The TLS connection is encrypted for data protection
- The client verifies the server's identity using the CA certificate
- The client does not need to provide its own certificate
- This is ideal for log forwarding scenarios where encryption is the primary concern

## 1. Generate SSL Certificates

First, generate the necessary SSL certificates:

```bash
rsyslog-gen-certs.sh
```

This will create:
- CA certificate: `/etc/ssl/certs/rsyslog-ca.pem`
- Server certificate: `/etc/ssl/certs/rsyslog-cert.pem`
- Private key: `/etc/ssl/private/rsyslog-key.pem`

## 2. Configure TLS Settings

Enable TLS support and configure CA certificate:

```bash
uci set rsyslog.tls.enabled=1
uci set rsyslog.tls.driver=ossl
uci set rsyslog.tls.ca_file=/etc/ssl/certs/rsyslog-ca.pem
```

Note: 
- TLS support requires the OpenSSL option to be enabled during compilation.
- The `driver` option can be set to `ossl` (OpenSSL) or `gtls` (GnuTLS) depending on your compile-time options.
- Authentication mode is fixed to `anon` (anonymous) - only CA certificate is needed for server verification.
- Client certificates are not required in anonymous mode.

## 3. Configure Remote Server

Set up the remote rsyslog server for secure transmission:

```bash
uci set rsyslog.remote.enabled=1
uci set rsyslog.remote.server_ip=192.168.1.100
uci set rsyslog.remote.server_port=6514
uci set rsyslog.remote.protocol=tcp
uci set rsyslog.remote.use_tls=1
uci set rsyslog.remote.source_selector='*.*'
```

## 4. Apply Configuration

Commit the changes and restart the service:

```bash
uci commit rsyslog
/etc/init.d/rsyslog restart
```

## Configuration Options

### TLS Section (rsyslog.tls)
- `enabled`: Enable/disable TLS support (0/1)
- `driver`: TLS driver to use (`ossl` for OpenSSL, `gtls` for GnuTLS)
- `ca_file`: Path to CA certificate file for server verification

Note: 
- This section is only functional when rsyslog is compiled with OpenSSL or GnuTLS support enabled.
- The appropriate network stream driver module (`lmnsd_ossl` or `lmnsd_gtls`) will be automatically loaded.
- Authentication mode is fixed to `anon` (anonymous) and cannot be changed.
- Only CA certificate is required - client certificates are not needed in anonymous mode.

### Remote Server Section (rsyslog.remote)
- `enabled`: Enable/disable remote logging (0/1)
- `server_ip`: IP address of remote rsyslog server
- `server_port`: Port number (default: 6514 for TLS, 514 for plain)
- `protocol`: Transport protocol (tcp/udp)
- `use_tls`: Enable TLS encryption for this connection (0/1)
- `source_selector`: Log selector pattern (e.g., '*.*', 'kern.*')

## Server Configuration

On the remote rsyslog server, you need to:

1. Enable TLS input module with anonymous authentication:
```
module(load="imtcp" streamDriver.name="gtls" streamDriver.mode="1" streamDriver.authMode="anon")
input(type="imtcp" port="6514")
```

2. Configure certificates on the server side as well.

Note: Both client and server must use `anon` authentication mode for compatibility.

## Troubleshooting

- Check rsyslog configuration: `rsyslogd -N1 -f /var/etc/rsyslog.conf`
- View logs: `logread | grep rsyslog`
- Test connectivity: `openssl s_client -connect server_ip:6514`
