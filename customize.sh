#!/sbin/sh

# Función para mostrar una animación de progreso
show_animation() {
  local message="$1"
  local pid=$!
  local delay=0.15
  local count=0
  local spinner="◐◓◑◒" # Usamos un string en lugar de un array

  while [ "$(ps -p $pid -o s=)" ]; do
    count=$(( (count + 1) % 4 ))
    # Extraemos el carácter del string usando 'cut'
    char=$(echo "$spinner" | cut -c $((count + 1)))
    ui_print -n "\r$message $char"
    sleep $delay
  done
  ui_print "\r$message ✓ "
  ui_print "" # Nueva línea para limpiar
}

# --- Lógica de Instalación ---
ui_print "**********************************************"
ui_print "*    Instalando Módulo Forzar DNS           *"
ui_print "*    con Failover y Monitoreo               *"
ui_print "**********************************************"
ui_print ""

(sleep 2) &
show_animation "- Configurando entorno..."

ui_print "- Estableciendo permisos para los scripts..."
(
  set_perm $MODPATH/service.sh 0 0 0755
  set_perm $MODPATH/uninstall.sh 0 0 0755
  sleep 2
) &
show_animation "  Aplicando permisos (0755)..."

(sleep 1) &
show_animation "- Finalizando instalación..."

ui_print "**********************************************"
ui_print "*    Instalación Completada                 *"
ui_print "*    Reinicia para activar los cambios      *"
ui_print "**********************************************"

exit 0
