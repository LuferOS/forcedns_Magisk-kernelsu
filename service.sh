#!/system/bin/sh
# Script de Servicio Late Start - Redirección DNS Nivel Experto

# Espera inteligente y pasiva. No bloqueamos el hilo de arranque.
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 3
done

DNS_V4="1.1.1.1"
DNS_V6="2606:4700:4700::1111"
PORT="53"

# ==============================================================================
# CONFIGURACIÓN IPv4
# ==============================================================================
# 1. Crear nuestra propia cadena aislada (evita tocar otras reglas del sistema)
iptables -t nat -N FORCE_DNS_V4 2>/dev/null
iptables -t nat -F FORCE_DNS_V4 # Limpiamos nuestra cadena por si ya existía

# 2. Desvincular de OUTPUT si ya estábamos enganchados (para evitar duplicados si se reinicia el script)
iptables -t nat -D OUTPUT -p udp --dport $PORT -j FORCE_DNS_V4 2>/dev/null
iptables -t nat -D OUTPUT -p tcp --dport $PORT -j FORCE_DNS_V4 2>/dev/null

# 3. Reglas de Exclusión (¡CRÍTICO!)
# Retornamos (ignoramos) el tráfico dirigido a redes locales y privadas (RFC 1918).
# Esto salva tu conexión a routers, localhost y portales cautivos de Wi-Fi público.
iptables -t nat -A FORCE_DNS_V4 -d 127.0.0.0/8 -j RETURN
iptables -t nat -A FORCE_DNS_V4 -d 10.0.0.0/8 -j RETURN
iptables -t nat -A FORCE_DNS_V4 -d 172.16.0.0/12 -j RETURN
iptables -t nat -A FORCE_DNS_V4 -d 192.168.0.0/16 -j RETURN
iptables -t nat -A FORCE_DNS_V4 -d 224.0.0.0/4 -j RETURN

# 4. Regla de Redirección (DNAT)
# Todo lo que no sea red local, cae aquí y se va para Cloudflare.
iptables -t nat -A FORCE_DNS_V4 -j DNAT --to-destination $DNS_V4:$PORT

# 5. Enganchar nuestra cadena maestra a la salida del sistema, con prioridad.
iptables -t nat -I OUTPUT -p udp --dport $PORT -j FORCE_DNS_V4
iptables -t nat -I OUTPUT -p tcp --dport $PORT -j FORCE_DNS_V4

# ==============================================================================
# CONFIGURACIÓN IPv6
# ==============================================================================
if ip6tables -t nat -L OUTPUT > /dev/null 2>&1; then
    ip6tables -t nat -N FORCE_DNS_V6 2>/dev/null
    ip6tables -t nat -F FORCE_DNS_V6
    
    ip6tables -t nat -D OUTPUT -p udp --dport $PORT -j FORCE_DNS_V6 2>/dev/null
    ip6tables -t nat -D OUTPUT -p tcp --dport $PORT -j FORCE_DNS_V6 2>/dev/null

    # Exclusiones IPv6 (Localhost, Link-local, Unique-local)
    ip6tables -t nat -A FORCE_DNS_V6 -d ::1/128 -j RETURN
    ip6tables -t nat -A FORCE_DNS_V6 -d fe80::/10 -j RETURN
    ip6tables -t nat -A FORCE_DNS_V6 -d fc00::/7 -j RETURN

    ip6tables -t nat -A FORCE_DNS_V6 -j DNAT --to-destination [$DNS_V6]:$PORT

    ip6tables -t nat -I OUTPUT -p udp --dport $PORT -j FORCE_DNS_V6
    ip6tables -t nat -I OUTPUT -p tcp --dport $PORT -j FORCE_DNS_V6
    
    log -p i -t ForceDNS "Seguridad DNS Activa: IPv4 e IPv6 redirigidos limpiamente a Cloudflare."
else
    log -p i -t ForceDNS "Seguridad DNS Activa: IPv4 redirigido. IPv6 ignorado (no soportado por el kernel actual)."
fi

exit 0
