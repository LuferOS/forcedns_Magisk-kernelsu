#!/system/bin/sh

(
MAX_WAIT_SECONDS=120
COUNTER=0
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5
  COUNTER=$((COUNTER + 5))
  if [ $COUNTER -ge $MAX_WAIT_SECONDS ]; then
    log -p e -t ForceDNS "Error: El sistema no completó el arranque en ${MAX_WAIT_SECONDS}s. Saliendo."
    exit 1
  fi
done

PRIMARY_DNS_V4="1.1.1.1"
PRIMARY_DNS_V6="2606:4700:4700::1111"
SECONDARY_DNS_V4="8.8.8.8"
SECONDARY_DNS_V6="2001:4860:4860::8888"
DNS_PORT="53"
CURRENT_DNS_V4=""

check_dns_health() {
  ping -c 1 -W 2 $1 > /dev/null 2>&1
}

cleanup_rules() {
  iptables -t nat -F OUTPUT 2>/dev/null
  ip6tables -t nat -F OUTPUT 2>/dev/null
}

apply_rules() {
  local ipv4_dest="$1"
  local ipv6_dest="$2"
  local success=true

  cleanup_rules

  iptables -t nat -A OUTPUT -p udp --dport ${DNS_PORT} -j DNAT --to-destination "${ipv4_dest}:${DNS_PORT}"
  if [ $? -ne 0 ]; then
    log -p e -t ForceDNS "Error: Fallo al aplicar la regla IPv4 UDP."
    success=false
  fi

  iptables -t nat -A OUTPUT -p tcp --dport ${DNS_PORT} -j DNAT --to-destination "${ipv4_dest}:${DNS_PORT}"
  if [ $? -ne 0 ]; then
    log -p e -t ForceDNS "Error: Fallo al aplicar la regla IPv4 TCP."
    success=false
  fi

  if ip6tables -t nat -L OUTPUT > /dev/null 2>&1; then
    ip6tables -t nat -A OUTPUT -p udp --dport ${DNS_PORT} -j DNAT --to-destination "[${ipv6_dest}]:${DNS_PORT}"
    if [ $? -ne 0 ]; then
      log -p e -t ForceDNS "Error: Fallo al aplicar la regla IPv6 UDP."
      success=false
    fi

    ip6tables -t nat -A OUTPUT -p tcp --dport ${DNS_PORT} -j DNAT --to-destination "[${ipv6_dest}]:${DNS_PORT}"
    if [ $? -ne 0 ]; then
      log -p e -t ForceDNS "Error: Fallo al aplicar la regla IPv6 TCP."
      success=false
    fi
  fi

  if $success; then
    log -p i -t ForceDNS "Reglas de DNS actualizadas para usar ${ipv4_dest}."
    CURRENT_DNS_V4=$ipv4_dest
  else
    log -p e -t ForceDNS "Error: No se pudieron aplicar todas las reglas de DNS. Limpiando para restaurar la conectividad."
    cleanup_rules
    CURRENT_DNS_V4=""
  fi
}

while true; do
  if check_dns_health $PRIMARY_DNS_V4; then
    if [ "$CURRENT_DNS_V4" != "$PRIMARY_DNS_V4" ]; then
      log -p i -t ForceDNS "DNS primario (${PRIMARY_DNS_V4}) está disponible. Cambiando..."
      apply_rules "$PRIMARY_DNS_V4" "$PRIMARY_DNS_V6"
    fi
  elif check_dns_health $SECONDARY_DNS_V4; then
    if [ "$CURRENT_DNS_V4" != "$SECONDARY_DNS_V4" ]; then
      log -p i -t ForceDNS "DNS primario no disponible. Usando DNS secundario (${SECONDARY_DNS_V4})."
      apply_rules "$SECONDARY_DNS_V4" "$SECONDARY_DNS_V6"
    fi
  else
    if [ ! -z "$CURRENT_DNS_V4" ]; then
      log -p e -t ForceDNS "Error: Ningún servidor DNS está disponible. Limpiando reglas."
      cleanup_rules
      CURRENT_DNS_V4=""
    fi
  fi

  sleep 600
done
) &
