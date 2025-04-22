#!/bin/sh

RES="/usr/share/3ginfo-lite"
DEVICE="$($RES/detect.sh)"

if [ -f "$DEVICE" ]; then
    echo '{"error":"Device not found"}'
    exit 1
fi

band4g() {
# see https://en.wikipedia.org/wiki/LTE_frequency_bands
	echo -n "B${1}"
	case "${1}" in
		"1") echo " (2100 MHz)";;
		"2") echo " (1900 MHz)";;
		"3") echo " (1800 MHz)";;
		"4") echo " (1700 MHz)";;
		"5") echo " (850 MHz)";;
		"7") echo " (2600 MHz)";;
		"8") echo " (900 MHz)";;
		"11") echo " (1500 MHz)";;
		"12") echo " (700 MHz)";;
		"13") echo " (700 MHz)";;
		"14") echo " (700 MHz)";;
		"17") echo " (700 MHz)";;
		"18") echo " (850 MHz)";;
		"19") echo " (850 MHz)";;
		"20") echo " (800 MHz)";;
		"21") echo " (1500 MHz)";;
		"24") echo " (1600 MHz)";;
		"25") echo " (1900 MHz)";;
		"26") echo " (850 MHz)";;
		"28") echo " (700 MHz)";;
		"29") echo " (700 MHz)";;
		"30") echo " (2300 MHz)";;
		"31") echo " (450 MHz)";;
		"32") echo " (1500 MHz)";;
		"34") echo " (2000 MHz)";;
		"37") echo " (1900 MHz)";;
		"38") echo " (2600 MHz)";;
		"39") echo " (1900 MHz)";;
		"40") echo " (2300 MHz)";;
		"41") echo " (2500 MHz)";;
		"42") echo " (3500 MHz)";;
		"43") echo " (3700 MHz)";;
		"46") echo " (5200 MHz)";;
		"47") echo " (5900 MHz)";;
		"48") echo " (3500 MHz)";;
		"50") echo " (1500 MHz)";;
		"51") echo " (1500 MHz)";;
		"53") echo " (2400 MHz)";;
		"54") echo " (1600 MHz)";;
		"65") echo " (2100 MHz)";;
		"66") echo " (1700 MHz)";;
		"67") echo " (700 MHz)";;
		"69") echo " (2600 MHz)";;
		"70") echo " (1700 MHz)";;
		"71") echo " (600 MHz)";;
		"72") echo " (450 MHz)";;
		"73") echo " (450 MHz)";;
		"74") echo " (1500 MHz)";;
		"75") echo " (1500 MHz)";;
		"76") echo " (1500 MHz)";;
		"85") echo " (700 MHz)";;
		"87") echo " (410 MHz)";;
		"88") echo " (410 MHz)";;
		"103") echo " (700 MHz)";;
		"106") echo " (900 MHz)";;
		"*") echo "";;
	esac
}

# 封装单条 AT 命令执行函数
run_at() {
    sms_tool -D -d "$DEVICE" at "$1"
}

getdevicevendorproduct() {
	devname="$(basename $1)"
	case "$devname" in
		'wwan'*'at'*)
			devpath="$(readlink -f /sys/class/wwan/$devname/device)"
			T=${devpath%/*/*/*}
			if [ -e $T/vendor ] && [ -e $T/device ]; then
				V=$(cat $T/vendor)
				D=$(cat $T/device)
				echo "pci/${V/0x/}${D/0x/}"
			fi
			;;
		'ttyACM'*)
			devpath="$(readlink -f /sys/class/tty/$devname/device)"
			T=${devpath%/*}
			echo "usb/$(cat $T/idVendor)$(cat $T/idProduct)"
			;;
		'tty'*)
			devpath="$(readlink -f /sys/class/tty/$devname/device)"
			T=${devpath%/*/*}
			echo "usb/$(cat $T/idVendor)$(cat $T/idProduct)"
			;;
		*)
			devpath="$(readlink -f /sys/class/usbmisc/$devname/device)"
			T=${devpath%/*}
			echo "usb/$(cat $T/idVendor)$(cat $T/idProduct)"
			;;
	esac
}
# 解析温度
parse_chiptemp() {
    echo "$1" | awk -F'[,:]' '/^\^CHIPTEMP/ {
        gsub(/[ \r]/, "")
        t = 0
        for (i = 2; i <= NF; i++) {
            if ($i != 65535) {
                if ($i > 100) $i = $i / 10
                if ($i > t) t = $i
            }
        }
        printf "%.1f", t
    }'
}

# 获取芯片温度
CHIPTEMP_RAW=$(run_at 'AT^CHIPTEMP?')
CHIPTEMP=$(parse_chiptemp "$CHIPTEMP_RAW")


O=""

CONF_DEVICE=$(uci -q get 3ginfo.@3ginfo[0].device)
if echo "x$CONF_DEVICE" | grep -q "192.168."; then
	if grep -q "Vendor=1bbb" /sys/kernel/debug/usb/devices; then
		. $RES/modem/hilink/alcatel_hilink.sh $DEVICE
	fi
	if grep -q "Vendor=12d1" /sys/kernel/debug/usb/devices; then
		. $RES/modem/hilink/huawei_hilink.sh $DEVICE
	fi
	if grep -q "Vendor=19d2" /sys/kernel/debug/usb/devices; then
		. $RES/modem/hilink/zte.sh $DEVICE
	fi
	SEC=$(uci -q get 3ginfo.@3ginfo[0].network)
	SEC=${SEC:-wan}
else
	if [ -e /usr/bin/sms_tool ]; then
		REGOK=0
		[ "x$REG" == "x1" ] || [ "x$REG" == "x5" ] || [ "x$REG" == "x8" ] && REGOK=1
		VIDPID=$(getdevicevendorproduct $DEVICE)
		if [ -e "$RES/modem/$VIDPID" ]; then
			case $(cat /tmp/sysinfo/board_name) in
				"zte,mf289f")
					. "$RES/modem/usb/19d21485"
					;;
				*)
					. "$RES/modem/$VIDPID"
					;;
			esac
		fi
	fi

fi


# convert rsrp to signal
convert_rsrp_to_signal() {
	local rsrp=$1
	
	# Return early if rsrp is not provided
	[ -z "$rsrp" ] && echo "255" && return
	
	# Value out of range (too low)
	[ "$rsrp" -lt -140 ] && echo "0" && return
	
	# Value out of range (too high)
	[ "$rsrp" -ge -43 ] && echo "255" && return
	
	# Calculate signal strength on a scale from 0 to 97
	# Map -140 to 0 and -43 to 97 (linear mapping)
	local adjusted=$(( (rsrp + 140) * 97 / 97 ))
	
	# Ensure the result is within bounds
	[ "$adjusted" -lt 0 ] && adjusted=0
	[ "$adjusted" -gt 97 ] && adjusted=97
	
	echo "$adjusted"
}

# if no rssi, use rsrp to stand for signal
SIGNAL=""
if [ -z "$RSRP" ] || [ "$RSRP" = "-" ] || [ "$RSRP" = "0" ]; then
	if [ -n "$RSSI" ] && [ "$RSSI" != "-" ] && [ "$RSSI" != "0" ]; then
		SIGNAL="$RSSI"
	fi
else
	if [ -z "$RSSI" ] || [ "$RSSI" = "-" ] || [ "$RSSI" = "0" ]; then
		SIGNAL=$(convert_rsrp_to_signal "$RSRP")
	fi
fi


# 输出为结构化 JSON
echo '{'
echo '  "device": "'"$DEVICE"'",'
echo '  "chip_temp": '"$CHIPTEMP"','
echo '  "modem": "'"$MODEL"'",'
echo '  "signal": '"$SIGNAL"
echo '}'

exit 0