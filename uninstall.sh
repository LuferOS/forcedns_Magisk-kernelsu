#!/system/bin/sh
# Limpieza total de reglas. Sin residuos.

PORT="53"

# --- Limpiar IPv4 ---
iptables -t nat -D OUTPUT -p udp --dport $PORT -j FORCE_DNS_V4 2>/dev/null
iptables -t nat -D OUTPUT -p tcp --dport $PORT -j FORCE_DNS_V4 2>/dev/null
iptables -t nat -F FORCE_DNS_V4 2>/dev/null
iptables -t nat -X FORCE_DNS_V4 2>/dev/null

# --- Limpiar IPv6 ---
if ip6tables -t nat -L OUTPUT > /dev/null 2>&1; then
    ip6tables -t nat -D OUTPUT -p udp --dport $PORT -j FORCE_DNS_V6 2>/dev/null
    ip6tables -t nat -D OUTPUT -p tcp --dport $PORT -j FORCE_DNS_V6 2>/dev/null
    ip6tables -t nat -F FORCE_DNS_V6 2>/dev/null
    ip6tables -t nat -X FORCE_DNS_V6 2>/dev/null
fi

log -p i -t ForceDNS "Módulo desinstalado. Reglas de redirección y cadenas destruidas."

exit 0
