#!/sbin/sh
# Instalador de Módulo - Optimizado para Magisk / KernelSU

ui_print "*************************************************"
ui_print "* 🔥 Instalando FORCE DNS TABLE                 *"
ui_print "* ⚡ Optimizado al extremo. Cero fugas.         *"
ui_print "*************************************************"

# Damos permisos tácticos. Magisk suele hacerlo solo, pero nos aseguramos.
ui_print "- Configurando permisos de ejecución..."
set_perm $MODPATH/service.sh 0 0 0755
set_perm $MODPATH/uninstall.sh 0 0 0755

ui_print "- Arquitectura de red lista."
ui_print "- ¡Listo, chico! Reinicia la máquina para activar."
ui_print "- Configurando permisos de interfaz web..."
set_perm $MODPATH/action.sh 0 0 0755
set_perm_recursive $MODPATH/web 0 0 0755 0755

exit 0
