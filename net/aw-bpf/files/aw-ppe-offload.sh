#!/bin/sh
# Selective PPE: keep QoS/policy hosts on the TC/eBPF path.
# Unpolicy flows may still be hardware-offloaded via nft flowtable.

LOG() { echo "aw-ppe-offload: $*" >&2; }

nft_handle() {
	echo "$1" | sed -n 's/.*# handle \([0-9][0-9]*\).*/\1/p'
}

nft_ftname() {
	local n
	n=$(echo "$1" | sed -n 's/.*flow add @\([^ ]*\).*/\1/p')
	[ -n "$n" ] || n=$(echo "$1" | sed -n 's/.*flow offload @\([^ ]*\).*/\1/p')
	echo "${n:-ft}"
}

ensure_policy_set() {
	command -v nft >/dev/null 2>&1 || return 0
	nft list table inet fw4 >/dev/null 2>&1 || return 0
	nft list set inet fw4 aw_policy_ipv4 >/dev/null 2>&1 || \
		nft add set inet fw4 aw_policy_ipv4 '{ type ipv4_addr; comment "aw-bpf policy hosts; skip PPE"; }' || \
		LOG "failed to add aw_policy_ipv4"
	nft list set inet fw4 aw_policy_ipv6 >/dev/null 2>&1 || \
		nft add set inet fw4 aw_policy_ipv6 '{ type ipv6_addr; comment "aw-bpf policy IPv6 hosts; skip PPE"; }' || \
		LOG "failed to add aw_policy_ipv6"
}

patch_flow_add() {
	local hw nft_off chain ftname handle line v4_ok v6_ok

	hw=$(uci -q get firewall.@defaults[0].flow_offloading_hw 2>/dev/null || echo 0)
	nft_off=0
	command -v nft >/dev/null 2>&1 || return 0
	nft list table inet fw4 >/dev/null 2>&1 || return 0
	if nft list table inet fw4 2>/dev/null | grep -q 'flags offload'; then
		nft_off=1
	fi
	[ "$nft_off" = "1" ] || [ "$hw" = "1" ] || return 0

	chain=$(nft -a list chain inet fw4 forward 2>/dev/null) || return 0
	echo "$chain" | grep -qE 'flow (add|offload)' || return 0

	v4_ok=0
	echo "$chain" | grep -q 'aw_policy_ipv4' && v4_ok=1
	v6_ok=0
	echo "$chain" | grep -q 'aw_policy_ipv6' && v6_ok=1
	[ "$v4_ok" = "1" ] && [ "$v6_ok" = "1" ] && return 0

	ftname=$(echo "$chain" | grep -E 'flow (add|offload) @' | sed -n 's/.*flow \(add\|offload\) @\([^ ]*\).*/\2/p' | head -n 1)
	[ -n "$ftname" ] || ftname="ft"

	# Generic (no ip/ip6 matcher): replace with IPv4 skip, then add IPv6 skip.
	line=$(echo "$chain" | grep -E 'flow (add|offload)' | grep -v 'ip saddr' | grep -v 'ip6 saddr' | head -n 1)
	if [ -n "$line" ]; then
		handle=$(nft_handle "$line")
		if [ -n "$handle" ]; then
			if nft replace rule inet fw4 forward handle "$handle" \
				meta l4proto '{ tcp, udp }' \
				ip saddr != @aw_policy_ipv4 \
				ip daddr != @aw_policy_ipv4 \
				flow add @"$ftname"; then
				v4_ok=1
			else
				LOG "nft replace IPv4 flow add handle $handle failed"
			fi
		fi
	fi

	if [ "$v4_ok" != "1" ]; then
		line=$(echo "$chain" | grep -E 'flow (add|offload)' | grep 'ip saddr' | grep -v 'ip6' | head -n 1)
		if [ -n "$line" ]; then
			handle=$(nft_handle "$line")
			if [ -n "$handle" ]; then
				nft replace rule inet fw4 forward handle "$handle" \
					meta l4proto '{ tcp, udp }' \
					ip saddr != @aw_policy_ipv4 \
					ip daddr != @aw_policy_ipv4 \
					flow add @"$ftname" || LOG "nft replace existing IPv4 flow add failed"
				v4_ok=1
			fi
		fi
	fi

	if [ "$v6_ok" != "1" ]; then
		line=$(echo "$chain" | grep -E 'flow (add|offload)' | grep 'ip6 saddr' | head -n 1)
		if [ -n "$line" ]; then
			handle=$(nft_handle "$line")
			if [ -n "$handle" ]; then
				nft replace rule inet fw4 forward handle "$handle" \
					meta l4proto '{ tcp, udp }' \
					ip6 saddr != @aw_policy_ipv6 \
					ip6 daddr != @aw_policy_ipv6 \
					flow add @"$ftname" || LOG "nft replace IPv6 flow add failed"
				v6_ok=1
			fi
		fi
	fi

	if [ "$v6_ok" != "1" ]; then
		nft add rule inet fw4 forward \
			meta l4proto '{ tcp, udp }' \
			ip6 saddr != @aw_policy_ipv6 \
			ip6 daddr != @aw_policy_ipv6 \
			flow add @"$ftname" || LOG "nft add IPv6 flow add failed"
	fi
}

cleanup_flow_add() {
	local chain line handle ftname

	command -v nft >/dev/null 2>&1 || return 0
	nft list table inet fw4 >/dev/null 2>&1 || return 0
	chain=$(nft -a list chain inet fw4 forward 2>/dev/null) || return 0
	ftname=$(echo "$chain" | grep -E 'flow (add|offload) @' | sed -n 's/.*flow \(add\|offload\) @\([^ ]*\).*/\2/p' | head -n 1)
	[ -n "$ftname" ] || ftname="ft"

	echo "$chain" | grep -E 'flow (add|offload)' | grep 'aw_policy' | while IFS= read -r line; do
		handle=$(nft_handle "$line")
		[ -n "$handle" ] || continue
		nft replace rule inet fw4 forward handle "$handle" \
			meta l4proto '{ tcp, udp }' flow add @"$ftname" 2>/dev/null || \
			nft delete rule inet fw4 forward handle "$handle" 2>/dev/null || true
	done

	# Collapse duplicate generic flow add rules, keep one.
	chain=$(nft -a list chain inet fw4 forward 2>/dev/null) || return 0
	echo "$chain" | grep -E 'flow (add|offload)' | grep -v 'ip saddr' | grep -v 'ip6 saddr' | \
		sed -n 's/.*# handle \([0-9][0-9]*\).*/\1/p' | tail -n +2 | while read -r handle; do
		nft delete rule inet fw4 forward handle "$handle" 2>/dev/null || true
	done

	nft delete set inet fw4 aw_policy_ipv4 2>/dev/null || true
	nft delete set inet fw4 aw_policy_ipv6 2>/dev/null || true
}

case "${1:-}" in
cleanup)
	cleanup_flow_add
	;;
*)
	ensure_policy_set
	patch_flow_add
	;;
esac
exit 0
