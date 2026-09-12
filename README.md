<div align="center">

# 🛡️ ForceDNS Premium

**Motor avanzado de redirección DNS a nivel de sistema para Android.**

[![GitHub Release](https://img.shields.io/github/v/release/LuferOS/forcedns?style=for-the-badge&color=blue)](#)
[![Downloads](https://img.shields.io/github/downloads/LuferOS/forcedns/total?style=for-the-badge&color=green)](#)
[![Magisk](https://img.shields.io/badge/Magisk-v24.0+-00bfff?style=for-the-badge&logo=magisk)](https://github.com/topjohnwu/Magisk)
[![KernelSU](https://img.shields.io/badge/KernelSU-Supported-10b981?style=for-the-badge)](https://kernelsu.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

> *Toma el control absoluto de tu red. Evita fugas de DNS, bloquea rastreadores y enruta tu tráfico de forma invisible sin gastar batería adicional.*

</div>

---

## 🚀 Características Principales
<div align="center">
# 🛡️ ForceDNS Premium

| Función | Descripción |
| :--- | :--- |
| 🎛️ **Web UI Local** | Interfaz gráfica inyectada en Magisk/KernelSU para elegir tu proveedor sin tocar terminales. |
| ⚡ **Zero Battery Drain** | No requiere apps en segundo plano ni VPNs simuladas. Todo ocurre a nivel nativo. |
| 🔒 **Anti DNS-Leak** | Captura y redirige forzosamente cualquier app que intente evadir el DNS del sistema por el puerto 53. |
| ⚙️ **NextDNS DoT** | Soporte Premium para NextDNS usando *DNS-over-TLS (DoT)* nativo de Android, vinculando tu ID automáticamente. |
| 🛡️ **Safe Localhost** | Exclusión inteligente de direcciones IP locales (RFC 1918) para no romper tu conexión a routers, Chromecast o Wi-Fi público. |

---
## 🔧 Proveedores Soportados
Puedes alternar entre estos proveedores en cualquier momento desde la interfaz del módulo:
* **Cloudflare (1.1.1.1):** Enfocado en velocidad y máxima privacidad.
* **Google DNS (8.8.8.8):** Alta disponibilidad y resolución global.
* **AdGuard DNS:** Bloqueo de anuncios y rastreadores a nivel de servidor.
* **NextDNS (Premium):** Configuración personalizada usando tu ID único de usuario.
---
## 🛠️ Instalación y Configuración
1. Descarga el `.zip` más reciente desde [Releases](#).
2. Flashea el módulo desde la app de **Magisk** o **KernelSU**.
3. ⚠️ **NO REINICIES EL DISPOSITIVO TODAVÍA.**
4. Vuelve a la pestaña **Módulos**, busca **ForceDNS** y presiona el botón **Ejecutar / Acción**.
5. Se abrirá la **Interfaz Web Segura**. Selecciona tu proveedor (y digita tu ID si usas NextDNS).
6. Presiona **Aplicar a nivel sistema**, cierra el navegador y **Reinicia tu dispositivo**.
---
## 🧠 Bajo el Capó (Technical Specs)
Para los usuarios avanzados, esto es lo que hace el script `service.sh` en segundo plano:
* **Modo Iptables:** Si eliges Cloudflare, Google o AdGuard, el script inyecta reglas `DNAT` en la cadena `OUTPUT` de `iptables`. Todo el tráfico TCP/UDP dirigido al puerto 53 es capturado y redirigido al servidor elegido, ignorando las IPs de red local (`192.168.x.x`, `10.x.x.x`, etc.) para mantener la compatibilidad con redes LAN.
* **Modo DoT (NextDNS):** Si ingresas tu ID de NextDNS, el módulo modifica el Settings Provider de Android (`settings put global private_dns_mode hostname`) inyectando tu subdominio personalizado para aprovechar la encriptación TLS nativa (Puerto 853).
---
## ❓ Preguntas Frecuentes (FAQ)
**¿Funciona si comparto internet (Hotspot/Tethering)?**
> Sí. Al operar en la cadena OUTPUT de iptables, las reglas protegen el tráfico nativo del dispositivo.
**¿Me puedo conectar a redes Wi-Fi públicas con portal cautivo?**
> ¡Absolutamente! El módulo incluye excepciones (Bypass) para localhost y direcciones de portal cautivo para que puedas iniciar sesión en hoteles, aeropuertos y cafeterías sin problemas.
**¿Cómo verifico que mi DNS cambió?**
> Visita [DNSLeakTest](https://dnsleaktest.com) o, si usas NextDNS, comprueba tu estado en [test.nextdns.io](https://test.nextdns.io).
---
<div align="center">
  Hecho con ❤️ para la comunidad de Android Root.
</div>
