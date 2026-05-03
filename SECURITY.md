# 🛡️ Política de Seguridad - FORCE DNS TABLE
Como desarrollador de **FORCE DNS TABLE**, me tomo la seguridad y la integridad de tu red muy en serio. Este documento explica qué versiones están bajo soporte y cómo reportar cualquier vulnerabilidad que encuentres de manera responsable.
---
## ✅ Versiones Soportadas
Actualmente, solo las versiones que utilizan la arquitectura de **Cadenas Personalizadas (Custom Chains)** reciben actualizaciones de seguridad y parches críticos.

| Versión | Soportada | Notas |
| :--- | :--- | :--- |
| v2.x | :white_check_mark: | Versión Pro actual (Arquitectura de Cadenas) |
| v1.x | :x: | Deprecada (Riesgo de colisión de iptables) |
| < 1.0 | :x: | No soportada |

---
## 🚨 Cómo Reportar una Vulnerabilidad
Si descubres un fallo de seguridad que podría comprometer la privacidad del usuario, permitir una fuga de DNS o causar inestabilidad en el sistema, por favor **no abras un Issue público**.
Para reportar vulnerabilidades, sigue estos pasos:
1.  **Reporte Privado:** Utiliza la función de [GitHub Private Vulnerability Reporting](https://docs.github.com/en/code-security/security-advisories/working-with-repository-security-advisories/configuring-private-vulnerability-reporting-for-a-repository) si está habilitada en este repositorio.
2.  **Contacto Directo:** Si prefieres el contacto directo, puedes enviarme un mensaje detallado a través de mis redes o perfiles vinculados en [LuferOS GitHub](https://github.com/LuferOS).
3.  **Detalles:** Incluye una descripción del fallo, pasos para reproducirlo y, si es posible, un log de `iptables` o `logcat` que demuestre el problema.
### 🕒 Tiempo de Respuesta
Me esfuerzo por reconocer el reporte en menos de **48 horas** y trabajar en un parche lo antes posible. Una vez solucionado el problema, se publicará un agradecimiento (si así lo deseas) en el log de cambios de la nueva versión.
---
## 🛡️ Mejores Prácticas para el Usuario
Para garantizar que el módulo funcione de forma segura:
* **Verifica el ZIP:** Descarga el módulo únicamente desde la sección oficial de [Releases](https://github.com/LuferOS/forcedns_Magisk-kernelsu/releases).
* **Sin Modificaciones Externas:** No instales versiones modificadas por terceros que no hayan sido auditadas.
* **Root Limpio:** Asegúrate de que tu entorno Magisk/KernelSU sea auténtico y no tenga módulos sospechosos que puedan interceptar tus cadenas de red.
---
<div align="center">
  Mantenido con rigor técnico por <b>LuferOS</b>
</div>
