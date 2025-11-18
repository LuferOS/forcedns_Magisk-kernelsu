#!/system/bin/sh

# Script de prueba para simular el uso de memoria de la lógica de service.sh a lo largo del tiempo.
# Esto ayuda a identificar posibles fugas de memoria en el script.

# --- Función de Registro de Memoria ---
# Imprime el uso de memoria actual del script.
log_memory_usage() {
    echo "--- Iteración $1 ---"
    # Usamos 'ps' para obtener el PID, VSZ (Tamaño de Memoria Virtual) y RSS (Tamaño de Conjunto Residente)
    # del proceso actual ($$). Un aumento constante y significativo en RSS podría indicar una fuga.
    echo "PID  VSZ      RSS      COMMAND"
    ps -o pid,vsz,rss,comm | grep $$
}

# --- Simulación de la Lógica de service.sh ---
# Replicamos las funciones y la lógica para probarlas sin necesidad de un entorno rooteado.

# Definiciones de DNS
PRIMARY_DNS_V4="1.1.1.1"
SECONDARY_DNS_V4="8.8.8.8"
DNS_PORT="53"

# Función de comprobación de conectividad
check_dns_health() {
  ping -c 1 -W 2 $1 > /dev/null 2>&1
}

# Simulación de las funciones de iptables (no se ejecutan los comandos reales)
cleanup_rules_mock() {
  echo "MOCK: iptables -t nat -F OUTPUT"
  echo "MOCK: ip6tables -t nat -F OUTPUT"
}

apply_rules_mock() {
  local ipv4_dest="$1"
  echo "MOCK: iptables -t nat -A OUTPUT -p udp --dport ${DNS_PORT} -j DNAT --to-destination ${ipv4_dest}:${DNS_PORT}"
  echo "MOCK: iptables -t nat -A OUTPUT -p tcp --dport ${DNS_PORT} -j DNAT --to-destination ${ipv4_dest}:${DNS_PORT}"
}

# --- Bucle Principal de la Prueba ---
ITERATIONS=10 # Número de veces que se ejecutará la lógica
echo "Iniciando prueba de memoria para ${ITERATIONS} iteraciones..."
echo "Observa los valores de VSZ y RSS. Un aumento constante podría indicar una fuga de memoria."

for i in $(seq 1 $ITERATIONS); do
    log_memory_usage $i

    # Lógica de failover de DNS
    if check_dns_health $PRIMARY_DNS_V4; then
        ACTIVE_DNS_V4=$PRIMARY_DNS_V4
        echo "DNS primario está activo."
    else
        ACTIVE_DNS_V4=$SECONDARY_DNS_V4
        echo "DNS primario no disponible, usando secundario."
    fi

    # Lógica de aplicación de reglas (simulada)
    cleanup_rules_mock
    apply_rules_mock "$ACTIVE_DNS_V4"

    sleep 2 # Esperar 2 segundos entre cada iteración
done

echo "--- Prueba de Memoria Completada ---"
exit 0
