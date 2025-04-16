#!/system/bin/sh
# Este script se ejecuta durante la etapa 'late_start service' del arranque.
# Su propósito es aplicar reglas de iptables para redirigir el tráfico DNS estándar (puerto 53)
# al servidor DNS de Cloudflare (1.1.1.1 y su equivalente IPv6).

# --- Espera Opcional ---
# Esperar hasta que el sistema haya completado el arranque (prop sys.boot_completed = 1)
# Esto asegura que la pila de red y los servicios necesarios estén completamente inicializados.
# Se incluye un límite de tiempo (ej. 60 segundos) para evitar bucles infinitos si la propiedad no se establece.
MAX_WAIT_SECONDS=60
COUNTER=0
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5 # Esperar 5 segundos
  COUNTER=$((COUNTER + 5))
  if [ $COUNTER -ge $MAX_WAIT_SECONDS ]; then
    # Si se supera el tiempo máximo, registrar un error (opcional) y salir para no bloquear.
    log -p e -t ForceDNS "Error: El sistema no completó el arranque en ${MAX_WAIT_SECONDS}s. No se aplicaron las reglas DNS."
    exit 1 # Salir del script
  fi
done

# --- Definición de Servidores DNS ---
# Dirección IPv4 de Cloudflare
DNS1_V4="1.1.1.1"
# Dirección IPv6 de Cloudflare
DNS1_V6="2606:4700:4700::1111"
# Puerto DNS estándar
DNS_PORT="53"

# --- Limpieza de Reglas Anteriores (Buena Práctica) ---
# Elimina reglas previas en la cadena OUTPUT de la tabla nat para evitar duplicados
# o conflictos si el script se ejecuta múltiples veces o si había reglas antiguas.
iptables -t nat -F OUTPUT
# Intenta limpiar ip6tables, ignorando el error si IPv6 o ip6tables no están disponibles/soportados.
ip6tables -t nat -F OUTPUT 2>/dev/null

# --- Aplicación de Reglas iptables (IPv4) ---
# Redirige todo el tráfico UDP generado localmente (-A OUTPUT) destinado al puerto 53 (--dport 53)
# hacia la IP y puerto de Cloudflare IPv4 (${DNS1_V4}:${DNS_PORT}) usando DNAT (-j DNAT).
iptables -t nat -A OUTPUT -p udp --dport ${DNS_PORT} -j DNAT --to-destination ${DNS1_V4}:${DNS_PORT}

# Redirige todo el tráfico TCP generado localmente (-A OUTPUT) destinado al puerto 53 (--dport 53)
# hacia la IP y puerto de Cloudflare IPv4 (${DNS1_V4}:${DNS_PORT}) usando DNAT (-j DNAT).
iptables -t nat -A OUTPUT -p tcp --dport ${DNS_PORT} -j DNAT --to-destination ${DNS1_V4}:${DNS_PORT}

# --- Aplicación de Reglas ip6tables (IPv6) ---
# Primero, verifica si el comando ip6tables existe y la tabla 'nat' es accesible.
# Esto evita errores en sistemas sin soporte IPv6 completo o sin ip6tables.
if ip6tables -t nat -L OUTPUT > /dev/null 2>&1; then
    # Si ip6tables funciona, aplica las reglas para IPv6.
    # Redirige tráfico UDP IPv6 al DNS de Cloudflare IPv6.
    ip6tables -t nat -A OUTPUT -p udp --dport ${DNS_PORT} -j DNAT --to-destination [${DNS1_V6}]:${DNS_PORT}
    # Redirige tráfico TCP IPv6 al DNS de Cloudflare IPv6.
    ip6tables -t nat -A OUTPUT -p tcp --dport ${DNS_PORT} -j DNAT --to-destination [${DNS1_V6}]:${DNS_PORT}
    IPV6_RULES_APPLIED=true
else
    IPV6_RULES_APPLIED=false
fi

# --- Registro Opcional ---
# Puedes usar el comando 'log' para enviar mensajes al logcat de Android y verificar la ejecución.
if $IPV6_RULES_APPLIED; then
    log -p i -t ForceDNS "Reglas de redirección DNS (IPv4/IPv6) aplicadas a ${DNS1_V4} y [${DNS1_V6}]"
else
    log -p i -t ForceDNS "Reglas de redirección DNS (IPv4) aplicadas a ${DNS1_V4}. IPv6 no configurado o no soportado."
fi

exit 0
