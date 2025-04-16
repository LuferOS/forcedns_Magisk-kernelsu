# ForceDNS Cloudflare (1.1.1.1) - Módulo Magisk/KernelSU

![Magisk](https://img.shields.io/badge/Magisk-%3E%3D20.4-green.svg)
![KernelSU](https://img.shields.io/badge/KernelSU-Compatible-blue.svg)
![Versión](https://img.shields.io/badge/Versión-1.1-blue)
![Autor](https://img.shields.io/badge/Autor-LuferOS%20-lightgrey)

Un módulo simple pero efectivo para Magisk y KernelSU que fuerza a tu dispositivo Android a usar los servidores DNS de Cloudflare (1.1.1.1 y 2606:4700:4700::1111) para todas las consultas DNS estándar (puerto 53 UDP/TCP).

## Descripción

Este módulo utiliza reglas `iptables` (y `ip6tables` para IPv6) para interceptar y redirigir todo el tráfico DNS que sale de tu dispositivo por el puerto 53 hacia los servidores rápidos y centrados en la privacidad de Cloudflare. Esto sobrescribe eficazmente cualquier configuración DNS proporcionada por tu red Wi-Fi o de datos móviles.

**Objetivo:** Mejorar la privacidad, potencialmente la velocidad de navegación y eludir ciertos bloqueos basados en DNS.

## Características

* **Forzado a Nivel de Sistema:** Redirige *todo* el tráfico DNS estándar (puerto 53) a 1.1.1.1.
* **Systemless:** No modifica la partición `/system`.
* **Soporte IPv4/IPv6:** Aplica reglas para ambos protocolos.
* **Compatibilidad:** Funciona tanto con Magisk (v20.4+) como con KernelSU.
* **Limpieza Automática:** Incluye un script `uninstall.sh` para eliminar las reglas al desinstalar el módulo.

## Notas Importantes y Limitaciones

* **Sin Failover:** Este módulo redirige *exclusivamente* a 1.1.1.1. **No** utiliza 8.8.8.8 (Google DNS) como respaldo si Cloudflare no está disponible.
* **No Afecta DNS Cifrado:** Las reglas **no** interceptan tráfico DNS-over-TLS (DoT - Configuración de DNS Privado de Android) ni DNS-over-HTTPS (DoH - Usado por algunos navegadores/apps). Si usas DNS Privado o DoH en tus apps, este módulo no los afectará. Para forzar *todo*, deberías desactivar el DNS Privado y el DoH en tus aplicaciones.
* **Interacción con VPNs:** Cuando una VPN está activa, generalmente maneja su propio tráfico DNS. Las reglas de este módulo podrían ser ignoradas o entrar en conflicto. El comportamiento depende de la implementación de la VPN.
* **Aplicaciones Específicas:** Apps que usen DNS "hardcodeados" o protocolos no estándar no se verán afectadas.

## Requisitos

* Dispositivo Android con root.
* **Magisk** (versión 20.4 o superior) o **KernelSU** instalado.

## Instalación

1.  Descarga el archivo ZIP del módulo desde la sección [Releases]([forcedns_cf_v1.1.zip](https://github.com/user-attachments/files/19783545/forcedns_cf_v1.1.zip)).
2.  Abre **Magisk Manager** o **KernelSU Manager**.
3.  Ve a la sección `Módulos`.
4.  Pulsa `Instalar desde almacenamiento`.
5.  Selecciona el archivo ZIP descargado (ej. `forcedns_cf_v1.1.zip`).
6.  Espera a que la instalación finalice.
7.  **Reinicia** tu dispositivo.

## Verificación

Después de reiniciar, puedes verificar que el módulo funciona:

1.  **Comprobar Reglas `iptables`:**
    * Abre una terminal (Termux, ADB Shell, etc.).
    * Obtén acceso root: `su`
    * Ejecuta:
        ```bash
        iptables -t nat -L OUTPUT -nv
        ip6tables -t nat -L OUTPUT -nv
        ```
    * Deberías ver reglas `DNAT` para `udp` y `tcp` con `dpt:53` redirigiendo a `1.1.1.1:53` y `[2606:4700:4700::1111]:53`. Las columnas `pkts` y `bytes` deberían aumentar con el uso de la red.

2.  **Prueba de Fuga de DNS:**
    * Abre un navegador web en tu dispositivo.
    * Visita sitios como [DNSLeakTest.com](https://www.dnsleaktest.com/) o [IPLeak.net](https://ipleak.net/).
    * Ejecuta la prueba estándar. Los resultados **deberían** mostrar servidores asociados a Cloudflare y **no** los de tu proveedor de internet (ISP).

## Desinstalación

1.  Abre **Magisk Manager** o **KernelSU Manager**.
2.  Ve a la sección `Módulos`.
3.  Busca el módulo "Forzar DNS Cloudflare".
4.  Desactívalo y/o pulsa el icono de eliminar/basura.
5.  **Reinicia** tu dispositivo.
    * El script `uninstall.sh` intentará eliminar las reglas `iptables` automáticamente antes del reinicio.

## Créditos
* **Frameworks:** Creado para [Magisk](https://github.com/topjohnwu/Magisk) por topjohnwu y [KernelSU](https://github.com/tiann/KernelSU) por tiann.
