# Docker nftables Support for OpenWrt

## Overview

Starting from this version, dockerd package supports **native nftables** networking, providing full compatibility with OpenWrt 23.05+ and firewall4.

## Compatibility Matrix

| OpenWrt Version | Firewall | Recommended Mode | Config Option |
|-----------------|----------|------------------|---------------|
| 23.05+ | firewall4 (nftables) | ✅ nftables | `DOCKER_IPTABLES=n` (default) |
| 22.03 and earlier | firewall3 (iptables) | iptables | `DOCKER_IPTABLES=y` |

## Configuration

### Default Mode: nftables (Recommended)

By default, Docker will use native nftables support:

```bash
# /etc/config/dockerd
config globals 'globals'
    option iptables '0'    # Disabled - Docker uses nftables
```

No additional configuration needed on OpenWrt 23.05+. Docker will automatically:
- Detect nftables availability
- Create separate `inet docker` table
- Manage networking rules without conflicts with firewall4

### Legacy Mode: iptables

For OpenWrt 22.03 or earlier, enable iptables mode in menuconfig:

```bash
make menuconfig
# Navigate to: Utilities -> dockerd
# Enable: [*] Enable iptables mode (compatibility)
```

Or manually edit config:
```bash
# /etc/config/dockerd
config globals 'globals'
    option iptables '1'    # Enabled - Docker uses iptables
```

## How It Works

### nftables Mode (Default)

```
Docker Daemon
    ↓
Native nftables API
    ↓
Kernel netfilter (nftables)
    ↓
Tables:
├── inet fw4 (firewall4)      ← OpenWrt firewall
└── inet docker (Docker)       ← Docker networking
    ├── chain prerouting       (port mapping - DNAT)
    ├── chain forward          (container forwarding)
    └── chain postrouting      (NAT/masquerading)
```

**Benefits**:
- ✅ No conflicts with firewall4
- ✅ Better performance
- ✅ Cleaner rule management
- ✅ Native kernel integration

### iptables Mode (Legacy)

```
Docker Daemon
    ↓
iptables-nft compatibility layer
    ↓
Translation to nftables rules
    ↓
Kernel netfilter
```

**Use cases**:
- OpenWrt 22.03 and earlier
- Legacy setups requiring iptables
- Testing compatibility

## Verification

### Check Docker Mode

```bash
# Check configuration
uci get dockerd.globals.iptables
# 0 = nftables mode
# 1 = iptables mode

# Check Docker info
docker info | grep -i iptables
# iptables: false  (nftables mode)
# iptables: true   (iptables mode)
```

### Test Networking

```bash
# Start a test container with port mapping
docker run -d --name test -p 8080:80 nginx

# Verify container is accessible
curl http://localhost:8080

# Check nftables rules (nftables mode)
nft list tables
# Should show: table inet docker

nft list table inet docker
# Shows Docker's networking rules

# Check iptables rules (iptables mode)
iptables -t nat -L DOCKER
iptables -t filter -L DOCKER
```

## Troubleshooting

### Docker fails to start on OpenWrt 23.05+

**Symptom**: Docker daemon fails with iptables errors

**Solution**: Ensure nftables mode is enabled
```bash
uci set dockerd.globals.iptables='0'
uci commit dockerd
/etc/init.d/dockerd restart
```

### Containers cannot access internet

**Check 1**: Verify nftables rules
```bash
nft list table inet docker
# Should show POSTROUTING masquerade rules
```

**Check 2**: Enable IP forwarding
```bash
sysctl net.ipv4.ip_forward
# Should be: net.ipv4.ip_forward = 1
```

**Check 3**: Verify firewall zones
```bash
uci show firewall | grep docker
# Should show docker zone configuration
```

### Port mapping not working

**Check**: Docker networking rules
```bash
# nftables mode
nft list chain inet docker prerouting
# Should show DNAT rules for published ports

# iptables mode
iptables -t nat -L DOCKER -n
# Should show DNAT rules
```

## Migration Guide

### From iptables to nftables mode

1. **Stop Docker**
   ```bash
   /etc/init.d/dockerd stop
   docker ps -aq | xargs docker rm -f  # Remove all containers
   ```

2. **Change configuration**
   ```bash
   uci set dockerd.globals.iptables='0'
   uci commit dockerd
   ```

3. **Restart Docker**
   ```bash
   /etc/init.d/dockerd start
   ```

4. **Verify**
   ```bash
   docker info | grep iptables
   # Should show: iptables: false
   ```

### From nftables to iptables mode

1. **Enable in menuconfig**
   ```bash
   make menuconfig
   # Utilities -> dockerd -> [*] Enable iptables mode
   make package/dockerd/{clean,compile} -j$(nproc)
   ```

2. **Update configuration**
   ```bash
   uci set dockerd.globals.iptables='1'
   uci commit dockerd
   ```

3. **Reinstall package and restart**
   ```bash
   opkg install dockerd_*.ipk --force-reinstall
   /etc/init.d/dockerd restart
   ```

## Package Dependencies

### nftables mode (default)
- `nftables`
- `kmod-nft-core`
- `kmod-nft-inet` (for IPv6)

### iptables mode (optional)
- `iptables-nft`
- `iptables-mod-extra`
- `ip6tables-nft` (for IPv6)

## Advanced Configuration

### Custom nftables rules

Docker's nftables table can be extended with custom rules:

```bash
# Add custom rule to Docker's forward chain
nft add rule inet docker forward \
    iifname "docker0" oifname "eth0" \
    ip daddr 192.168.1.0/24 drop

# Persistent rules: create /etc/nftables.d/docker-custom.nft
table inet docker {
    chain custom_forward {
        type filter hook forward priority 0;
        # Your custom rules here
    }
}
```

### Performance tuning

For high-traffic scenarios, consider:

```bash
# /etc/config/dockerd
config globals 'globals'
    option iptables '0'
    option ip6tables '0'
    option storage_driver 'overlay2'
    option log_level 'error'  # Reduce logging overhead
```

## References

- [Docker Packet filtering and firewalls](https://docs.docker.com/network/packet-filtering-firewalls/)
- [OpenWrt firewall4 documentation](https://openwrt.org/docs/guide-user/firewall/firewall4)
- [nftables wiki](https://wiki.nftables.org/)
- [Docker nftables PR](https://github.com/moby/moby/pull/42708)

## Support

For issues related to:
- **Docker networking**: Check Docker daemon logs: `logread -f | grep dockerd`
- **OpenWrt firewall**: Check firewall logs: `logread -f | grep firewall`
- **nftables**: Debug with: `nft -a list table inet docker`

## Version History

- **v27.3.1-3**: Added native nftables support, made it default
- **v27.3.1-2**: Legacy version with iptables only
