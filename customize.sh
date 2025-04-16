#!/sbin/sh
# Este script se ejecuta durante la instalación del módulo en Magisk Manager / KernelSU Manager.
# Utiliza funciones proporcionadas por el entorno de instalación para configurar el módulo.

# --- Lógica de Instalación ---

# 1.Mostrar mensaje
ui_print "*****************************************"
ui_print "* Instalando Módulo Forzar DNS Cloudflare *"
ui_print "*****************************************"

# 2. Establecer Permisos para service.sh (¡MUY IMPORTANTE!)
# Es crucial que service.sh tenga permisos de ejecución para que funcione.
# Propietario: root (0)
# Grupo: root (0)
# Permisos: 0755 (rwxr-xr-x) - Lectura/escritura/ejecución para root, lectura/ejecución para grupo y otros.
ui_print "- Estableciendo permisos para service.sh..."
set_perm $MODPATH/service.sh 0 0 0755
ui_print "- Permisos establecidos correctamente (0755)."


ui_print "- Estableciendo permisos para uninstall.sh..."
set_perm $MODPATH/uninstall.sh 0 0 0755
ui_print "- Permisos establecidos correctamente (0755)."

# 3.Mensaje final 
ui_print "- Instalación completada."
ui_print "- Reinicia tu dispositivo para activar el módulo."

exit 0
