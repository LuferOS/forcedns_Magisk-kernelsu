#!/system/bin/sh
# Este script se ejecuta cuando el usuario desinstala el módulo
# desde Magisk Manager o KernelSU Manager, ANTES de que los archivos del módulo sean eliminados.
# Su propósito es revertir los cambios realizados por service.sh,
# en este caso, eliminar las reglas de redirección de DNS de iptables.

# --- Definición de Servidores DNS (debe coincidir con service.sh) ---
DNS1_V4="1.1.1.1"
DNS1_V6="2606:4700:4700::1111"
DNS_PORT="53"

# --- Eliminación de Reglas iptables (IPv4) ---
# Intenta eliminar las reglas específicas que se agregaron en service.sh.
# Se usa -D (Delete) en lugar de -F (Flush) para ser más específico y evitar
# eliminar otras reglas que puedan existir en la cadena OUTPUT.
# Se ignoran los errores (2>/dev/null) en caso de que la regla ya no exista
# (por ejemplo, si el dispositivo se reinició antes de desinstalar).

iptables -t nat -D OUTPUT -p udp --dport ${DNS_PORT} -j DNAT --to-destination ${DNS1_V4}:${DNS_PORT} 2>/dev/null
iptables -t nat -D OUTPUT -p tcp --dport ${DNS_PORT} -j DNAT --to-destination ${DNS1_V4}:${DNS_PORT} 2>/dev/null

# --- Eliminación de Reglas ip6tables (IPv6) ---
# Intenta eliminar las reglas IPv6 si ip6tables está disponible.
if ip6tables -t nat -L OUTPUT > /dev/null 2>&1; then
    ip6tables -t nat -D OUTPUT -p udp --dport ${DNS_PORT} -j DNAT --to-destination [${DNS1_V6}]:${DNS_PORT} 2>/dev/null
    ip6tables -t nat -D OUTPUT -p tcp --dport ${DNS_PORT} -j DNAT --to-destination [${DNS1_V6}]:${DNS_PORT} 2>/dev/null
fi

# --- Registro Opcional ---
# Puedes añadir un log para confirmar la ejecución.
log -p i -t ForceDNS "Script de desinstalación ejecutado. Intentando eliminar reglas de iptables."

# Salir con 0 indica éxito.
exit 0