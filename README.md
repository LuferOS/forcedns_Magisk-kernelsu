# ForceDNS Cloudflare con Monitoreo y Failover - Módulo Magisk/KernelSU

![Magisk](https://img.shields.io/badge/Magisk-%3E%3D20.4-green.svg)
![KernelSU](https://img.shields.io/badge/KernelSU-Compatible-blue.svg)
![Versión](https://img.shields.io/badge/Versión-2.1-blue)
![Autor](https://img.shields.io/badge/Autor-LuferOS%20-lightgrey)

Un módulo avanzado para Magisk y KernelSU que fuerza a tu dispositivo a usar Cloudflare DNS (1.1.1.1) con un failover a Google DNS (8.8.8.8) y un sistema de monitoreo inteligente para volver a Cloudflare automáticamente.

## Descripción

Este módulo redirige todo el tráfico DNS estándar (puerto 53) usando `iptables`. Su principal característica es la resiliencia:
1.  **Prioriza Cloudflare DNS** por su velocidad y privacidad.
2.  Si Cloudflare no está disponible, **cambia automáticamente a Google DNS** para mantener la conectividad.
3.  **Monitorea cada 10 minutos** el estado de Cloudflare. Si vuelve a estar en línea, el módulo **revierte automáticamente** las reglas para usar Cloudflare de nuevo.

**Objetivo:** Ofrecer una solución de DNS forzado que es a la vez rápida, privada y extremadamente fiable, sin necesidad de intervención manual.

## Características

*   **Failover Automático:** Pasa de 1.1.1.1 a 8.8.8.8 si el primero falla.
*   **Reversión Automática:** Vuelve a 1.1.1.1 en cuanto se recupera.
*   **Monitoreo en Segundo Plano:** El servicio se ejecuta de forma ligera cada 10 minutos.
*   **Manejo de Errores Robusto:** Verifica que las reglas de `iptables` se apliquen correctamente para evitar problemas de conectividad.
*   **Systemless y Compatible:** Funciona con Magisk (v20.4+) y KernelSU sin modificar `/system`.
*   **Soporte IPv4/IPv6.**

## Notas Importantes y Limitaciones

*   **No Afecta DNS Cifrado:** Las reglas **no** interceptan tráfico DNS-over-TLS (DoT - Configuración de DNS Privado de Android) ni DNS-over-HTTPS (DoH - Usado por algunos navegadores/apps). Si usas DNS Privado o DoH en tus apps, este módulo no los afectará.
*   **Interacción con VPNs:** Cuando una VPN está activa, generalmente maneja su propio tráfico DNS. Las reglas de este módulo podrían ser ignoradas o entrar en conflicto. El comportamiento depende de la implementación de la VPN.
*   **Aplicaciones Específicas:** Apps que usen DNS "hardcodeados" o protocolos no estándar no se verán afectadas.

## Instalación

1.  Descarga el archivo ZIP del módulo.
2.  Abre **Magisk Manager** o **KernelSU Manager**.
3.  Ve a `Módulos` > `Instalar desde almacenamiento`.
4.  Selecciona el ZIP y espera a que termine la animación.
5.  **Reinicia** tu dispositivo.

## Verificación

Puedes verificar el estado del módulo de las siguientes formas:

1.  **Logs del Sistema:**
    *   Usa una app de logs o `adb logcat` y filtra por la etiqueta `ForceDNS`.
    *   Verás mensajes que indican qué DNS está activo (ej. "Reglas de DNS actualizadas para usar 1.1.1.1") y cuándo se realizan las comprobaciones.

2.  **Reglas `iptables`:**
    *   En una terminal con acceso root (`su`), ejecuta:
        ```bash
        iptables -t nat -L OUTPUT -nv
        ```
    *   La salida mostrará las reglas de redirección hacia el DNS actualmente activo.

3.  **Prueba de Fuga de DNS:**
    *   Visita [DNSLeakTest.com](https://www.dnsleaktest.com/). El resultado debería corresponder al DNS que está activo según los logs.

## Pruebas de Memoria

Se incluye el script `test_memory.sh` para verificar que el servicio en segundo plano no cause fugas de memoria.

**Cómo ejecutar la prueba:**
1.  Copia el script a una ubicación accesible (ej. `/data/local/tmp`).
2.  Dale permisos de ejecución: `chmod +x test_memory.sh`.
3.  Ejecútalo: `sh test_memory.sh`.
4.  Observa si el valor de `RSS` (memoria residente) aumenta de forma descontrolada a lo largo de las iteraciones.

## Desinstalación

1.  Abre tu gestor de root (Magisk o KernelSU).
2.  Desactiva y elimina el módulo.
3.  **Reinicia**. El script `uninstall.sh` limpiará las reglas de `iptables`.

## Créditos
*   **Frameworks:** Creado para [Magisk](https://github.com/topjohnwu/Magisk) y [KernelSU](https://github.com/tiann/KernelSU).
