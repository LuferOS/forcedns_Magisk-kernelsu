# 🛡️ FORCE DNS TABLE (Cloudflare 1.1.1.1)

<div align="center">

[![Downloads](https://img.shields.io/github/downloads/LuferOS/forcedns_Magisk-kernelsu/total?style=for-the-badge&color=cyan&logo=github)](https://github.com/LuferOS/forcedns_Magisk-kernelsu/releases)
[![Stars](https://img.shields.io/github/stars/LuferOS/forcedns_Magisk-kernelsu?style=for-the-badge&color=yellow&logo=github)](https://github.com/LuferOS/forcedns_Magisk-kernelsu/stargazers)
[![Forks](https://img.shields.io/github/forks/LuferOS/forcedns_Magisk-kernelsu?style=for-the-badge&color=orange&logo=github)](https://github.com/LuferOS/forcedns_Magisk-kernelsu/network/members)
[![Release](https://img.shields.io/github/v/release/LuferOS/forcedns_Magisk-kernelsu?style=for-the-badge&color=blue&logo=android)](https://github.com/LuferOS/forcedns_Magisk-kernelsu/releases)
[![Magisk](https://img.shields.io/badge/Magisk-v20.4+-00AF9C?style=for-the-badge&logo=magisk)](https://github.com/topjohnwu/Magisk)
[![KernelSU](https://img.shields.io/badge/KernelSU-Compatible-blueviolet?style=for-the-badge&logo=linux)](https://github.com/tiann/KernelSU)

**Secuestro absoluto del tráfico DNS a nivel Kernel. Cero fugas. Cero conflictos.**
<br>
Desarrollado por [LuferOS](https://github.com/LuferOS)
</div>

---

## 📌 ¿Qué hace este módulo?

**FORCE DNS TABLE** no es solo un cambiador de DNS. Es un módulo avanzado para **Magisk** y **KernelSU** que intercepta *todo* el tráfico DNS estándar (puerto 53 UDP/TCP) desde la raíz del sistema operativo y lo redirige a los servidores ultrarrápidos y privados de **Cloudflare (1.1.1.1 y 2606:4700:4700::1111)**.

A diferencia de las configuraciones manuales o aplicaciones de terceros, este módulo sobreescribe cualquier imposición de tu ISP, red Wi-Fi o datos móviles a nivel de `iptables`.

## 🚀 Novedades en v2.0-Pro

Este no es el típico script que vacía tus iptables y rompe tu teléfono. Hemos rediseñado el núcleo:
* **Custom Chains Architecture:** Ahora utiliza Cadenas Personalizadas (`FORCE_DNS_V4` y `FORCE_DNS_V6`). No interfiere con otras aplicaciones, cortafuegos o módulos que utilicen iptables.
* **Smart Bypass (Exclusiones de Red Local):** Ignora inteligentemente el tráfico de redes locales (RFC 1918). ¡Se acabaron los problemas con los portales cautivos de aeropuertos, hoteles o la configuración de tu router!
* **Limpieza Quirúrgica:** El script de desinstalación elimina únicamente nuestras cadenas. No deja residuos en la RAM ni afecta la estabilidad de la red.

## ⚙️ Características Principales

-   ⚡ **Hardcoded Routing:** Todo lo que intente salir por el puerto 53 es capturado y enviado a Cloudflare.
-   🛡️ **Totalmente Systemless:** No modifica un solo byte de la partición `/system`.
-   🌐 **Soporte Dual-Stack:** Interceptación completa para tráfico **IPv4 e IPv6**.
-   🧹 **Auto-Limpieza:** Al desactivar o desinstalar el módulo, la tabla de ruteo vuelve a su estado de fábrica de inmediato.

## ⚠️ Limitaciones Conocidas (Léelo)

1.  **DNS Privado (DoT / DoH):** Las reglas de iptables actúan sobre el puerto 53 (DNS clásico). Si tienes activado el "DNS Privado" en los ajustes de Android (DNS over TLS) o usas navegadores con DNS over HTTPS integrado, ese tráfico viaja cifrado por los puertos 853 o 443. Si quieres que el módulo controle el 100% del tráfico, **desactiva el DNS Privado**.
2.  **Conflictos VPN:** Si usas una VPN, su túnel cifrado tendrá prioridad. El módulo no romperá tu VPN, pero es probable que el tráfico DNS pase a ser gestionado por el servidor VPN.
3.  **Sin Servidor de Respaldo:** Redirige exclusivamente a Cloudflare. Si 1.1.1.1 cae (algo casi imposible), no hará failover a Google DNS.

## 📲 Instrucciones de Instalación

1.  Descarga el archivo `.zip` más reciente desde la sección de [Releases](https://github.com/LuferOS/forcedns_Magisk-kernelsu/releases).
2.  Abre **Magisk Manager** o **KernelSU Manager**.
3.  Dirígete a la pestaña de **Módulos**.
4.  Toca en **Instalar desde el almacenamiento** y selecciona el ZIP descargado.
5.  Observa la terminal de instalación (diseñada a medida) y espera a que termine.
6.  **Reinicia el dispositivo** para que las reglas de iptables se inyecten en el arranque.

## 🕵️‍♂️ Verificación de Funcionamiento

¿No confías a ciegas? Me parece perfecto. Para comprobar que está funcionando:

1.  **Vía Terminal (Termux / ADB Shell):**
    Ejecuta esto como superusuario (`su`):
    ```bash
    iptables -t nat -L FORCE_DNS_V4 -nv
    ```
    Si ves paquetes y bytes en la regla de `DNAT` hacia `1.1.1.1`, el tráfico está siendo secuestrado correctamente.

2.  **Vía Web:**
    Entra a [DNSLeakTest.com](https://www.dnsleaktest.com/) y haz un test extendido. Si tu operadora de internet (Claro, Movistar, Tigo, etc.) no aparece por ningún lado y solo ves los ASNs de Cloudflare, el módulo está haciendo su trabajo.

## 🗑️ Desinstalación

Tan fácil como instalarlo. Bórralo o desactívalo desde Magisk/KernelSU y reinicia. El script `uninstall.sh` se encargará de purgar las cadenas personalizadas sin dejar rastro.

---
<div align="center">
  <b>¿Te sirvió este módulo? ¡No seas tacaño y dale una ⭐ al repositorio!</b>
</div>
