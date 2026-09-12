#!/system/bin/sh

until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 3
done

MODDIR="${0%/*}"
CONFIG_FILE="$MODDIR/dns_config.txt"
PORT="53"

PROVEEDOR="cloudflare"
DNS_V4="1.1.1.1"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

if [ "$PROVEEDOR" = "nextdns" ]; then
    settings put global private_dns_mode hostname
    settings put global private_dns_specifier ${NEXTDNS_ID}.dns.nextdns.io
    
    iptables -t nat -D OUTPUT -p udp --dport $PORT -j FORCE_DNS_V4 2>/dev/null
    iptables -t nat -D OUTPUT -p tcp --dport $PORT -j FORCE_DNS_V4 2>/dev/null
else
    settings put global private_dns_mode opportunistic
    
    iptables -t nat -N FORCE_DNS_V4 2>/dev/null
    iptables -t nat -F FORCE_DNS_V4
    iptables -t nat -D OUTPUT -p udp --dport $PORT -j FORCE_DNS_V4 2>/dev/null
    iptables -t nat -D OUTPUT -p tcp --dport $PORT -j FORCE_DNS_V4 2>/dev/null

    iptables -t nat -A FORCE_DNS_V4 -d 127.0.0.0/8 -j RETURN
    iptables -t nat -A FORCE_DNS_V4 -d 10.0.0.0/8 -j RETURN
    iptables -t nat -A FORCE_DNS_V4 -d 172.16.0.0/12 -j RETURN
    iptables -t nat -A FORCE_DNS_V4 -d 192.168.0.0/16 -j RETURN
    iptables -t nat -A FORCE_DNS_V4 -d 224.0.0.0/4 -j RETURN

    iptables -t nat -A FORCE_DNS_V4 -j DNAT --to-destination $DNS_V4:$PORT

    iptables -t nat -I OUTPUT -p udp --dport $PORT -j FORCE_DNS_V4
    iptables -t nat -I OUTPUT -p tcp --dport $PORT -j FORCE_DNS_V4
fi

exit 0
