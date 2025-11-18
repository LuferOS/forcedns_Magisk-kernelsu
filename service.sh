#!/system/bin/sh

# MODDIR=${0%/*}

# Esperar a que el sistema complete el arranque para asegurar que la red esté lista.
# Se establece un tiempo máximo para evitar bucles infinitos.
MAX_WAIT_SECONDS=60
COUNTER=0
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5
  COUNTER=$((COUNTER + 5))
  if [ $COUNTER -ge $MAX_WAIT_SECONDS ]; then
    log -p e -t ForceDNS "Error: El sistema no completó el arranque en ${MAX_WAIT_SECONDS}s. Saliendo."
    exit 1
  fi
done

# --- Definición de Servidores DNS ---
# Primario (Cloudflare)
PRIMARY_DNS_V4="1.1.1.1"
PRIMARY_DNS_V6="2606:4700:4700::1111"

# Secundario (Google)
SECONDARY_DNS_V4="8.8.8.8"
SECONDARY_DNS_V6="2001:4860:4860::8888"

# Puerto DNS estándar
DNS_PORT="53"

# --- Comprobación de Conectividad ---
# Función para verificar si un servidor DNS está accesible.
# Envía un solo paquete de ping con un tiempo de espera corto.
check_dns_health() {
  ping -c 1 -W 2 $1 > /dev/null 2>&1
}

# Determinar qué servidor DNS usar.
if check_dns_health $PRIMARY_DNS_V4; then
  ACTIVE_DNS_V4=$PRIMARY_DNS_V4
  ACTIVE_DNS_V6=$PRIMARY_DNS_V6
  log -p i -t ForceDNS "DNS primario (${PRIMARY_DNS_V4}) está activo. Usándolo."
elif check_dns_health $SECONDARY_DNS_V4; then
  ACTIVE_DNS_V4=$SECONDARY_DNS_V4
  ACTIVE_DNS_V6=$SECONDARY_DNS_V6
  log -p i -t ForceDNS "DNS primario no disponible. Usando DNS secundario (${SECONDARY_DNS_V4})."
else
  log -p e -t ForceDNS "Error: No se pudo alcanzar ningún servidor DNS. No se aplicarán las reglas."
  exit 1
fi

# --- Funciones de Iptables ---

# Limpia las reglas de iptables previas para evitar duplicados.
cleanup_rules() {
  iptables -t nat -F OUTPUT
  ip6tables -t nat -F OUTPUT 2>/dev/null || true # Ignorar error si ip6tables no existe
}

# Aplica las reglas de redirección de DNS.
apply_rules() {
  local ipv4_dest="$1"
  local ipv6_dest="$2"

  # Reglas IPv4
  iptables -t nat -A OUTPUT -p udp --dport ${DNS_PORT} -j DNAT --to-destination "${ipv4_dest}:${DNS_PORT}"
  iptables -t nat -A OUTPUT -p tcp --dport ${DNS_PORT} -j DNAT --to-destination "${ipv4_dest}:${DNS_PORT}"
  log -p i -t ForceDNS "Reglas de redirección DNS (IPv4) aplicadas a ${ipv4_dest}."

  # Reglas IPv6 (solo si ip6tables está disponible)
  if ip6tables -t nat -L OUTPUT > /dev/null 2>&1; then
    ip6tables -t nat -A OUTPUT -p udp --dport ${DNS_PORT} -j DNAT --to-destination "[${ipv6_dest}]:${DNS_PORT}"
    ip6tables -t nat -A OUTPUT -p tcp --dport ${DNS_PORT} -j DNAT --to-destination "[${ipv6_dest}]:${DNS_PORT}"
    log -p i -t ForceDNS "Reglas de redirección DNS (IPv6) aplicadas a [${ipv6_dest}]."
  else
    log -p i -t ForceDNS "ip6tables no disponible. Omitiendo reglas IPv6."
  fi
}

# --- Ejecución Principal ---
cleanup_rules
apply_rules "$ACTIVE_DNS_V4" "$ACTIVE_DNS_V6"

exit 0
