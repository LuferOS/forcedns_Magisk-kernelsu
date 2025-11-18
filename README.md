# ForceDNS Cloudflare (1.1.1.1) con Failover - Módulo Magisk/KernelSU

![Magisk](https://img.shields.io/badge/Magisk-%3E%3D20.4-green.svg)
![KernelSU](https://img.shields.io/badge/KernelSU-Compatible-blue.svg)
![Versión](https://img.shields.io/badge/Versión-2.0-blue)
![Autor](https://img.shields.io/badge/Autor-LuferOS%20-lightgrey)

Un módulo robusto para Magisk y KernelSU que fuerza a tu dispositivo Android a usar los servidores DNS de Cloudflare (1.1.1.1) con un failover automático a Google DNS (8.8.8.8) si el primario no está disponible.

## Descripción

Este módulo utiliza reglas `iptables` (y `ip6tables` para IPv6) para interceptar y redirigir de manera inteligente todo el tráfico DNS estándar (puerto 53) que sale de tu dispositivo. Prioriza los servidores rápidos y centrados en la privacidad de Cloudflare, pero cambia automáticamente a los servidores fiables de Google si detecta problemas de conectividad.

**Objetivo:** Maximizar la disponibilidad, mejorar la privacidad, la velocidad de navegación y eludir ciertos bloqueos basados en DNS.

## Características

*   **Failover Automático de DNS:** Comprueba la disponibilidad de 1.1.1.1 y, si no responde, utiliza 8.8.8.8 como respaldo.
*   **Forzado a Nivel de Sistema:** Redirige *todo* el tráfico DNS estándar (puerto 53).
*   **Systemless:** No modifica la partición `/system`.
*   **Soporte IPv4/IPv6:** Aplica reglas para ambos protocolos.
*   **Compatibilidad:** Funciona tanto con Magisk (v20.4+) como con KernelSU.
*   **Limpieza Automática:** Incluye un script `uninstall.sh` para eliminar las reglas al desinstalar el módulo.

## Notas Importantes y Limitaciones

*   **No Afecta DNS Cifrado:** Las reglas **no** interceptan tráfico DNS-over-TLS (DoT) ni DNS-over-HTTPS (DoH). Si usas estas tecnologías, el módulo no las afectará.
*   **Interacción con VPNs:** Las VPNs suelen gestionar su propio tráfico DNS, por lo que las reglas de este módulo podrían ser ignoradas.
*   **Aplicaciones Específicas:** Apps con DNS "hardcodeados" o protocolos no estándar no se verán afectadas.

## Requisitos

*   Dispositivo Android con root.
*   **Magisk** (versión 20.4 o superior) o **KernelSU** instalado.

## Instalación

1.  Descarga el archivo ZIP del módulo.
2.  Abre **Magisk Manager** o **KernelSU Manager**.
3.  Ve a `Módulos` > `Instalar desde almacenamiento`.
4.  Selecciona el archivo ZIP descargado.
5.  **Reinicia** tu dispositivo.

## Verificación

Después de reiniciar, puedes verificar que el módulo funciona:

1.  **Comprobar Reglas `iptables`:**
    *   Abre una terminal (Termux, ADB Shell, etc.).
    *   Obtén acceso root: `su`
    *   Ejecuta:
        ```bash
        iptables -t nat -L OUTPUT -nv
        ip6tables -t nat -L OUTPUT -nv
        ```
    *   Deberías ver reglas `DNAT` redirigiendo el tráfico del puerto 53 al servidor DNS activo (1.1.1.1 o 8.8.8.8).

2.  **Prueba de Fuga de DNS:**
    *   Visita [DNSLeakTest.com](https://www.dnsleaktest.com/). Los resultados deberían mostrar servidores de Cloudflare o Google.

## Pruebas de Memoria

Para asegurar que el script no introduce fugas de memoria, se incluye un script de prueba (`test_memory.sh`).

**¿Por qué es importante?**
En un entorno de sistema, incluso pequeñas fugas de memoria pueden acumularse con el tiempo y afectar la estabilidad del dispositivo.

**Cómo ejecutar la prueba:**
1.  Abre una terminal en tu dispositivo o a través de ADB.
2.  Navega a la ruta donde se encuentra el script (normalmente `/data/adb/modules/Forcedns/test_memory.sh` si lo copias allí).
3.  Ejecuta el script:
    ```bash
    sh test_memory.sh
    ```
4.  El script simulará la lógica de `service.sh` durante varias iteraciones y mostrará el uso de memoria. Observa los valores de `VSZ` y `RSS`. Un aumento pequeño y estable es normal, pero un crecimiento continuo y sin control podría indicar una fuga.

## Desinstalación

1.  Abre **Magisk Manager** o **KernelSU Manager**.
2.  Desactiva y elimina el módulo.
3.  **Reinicia** el dispositivo.

## Créditos
*   **Frameworks:** Creado para [Magisk](https://github.com/topjohnwu/Magisk) y [KernelSU](https://github.com/tiann/KernelSU).
