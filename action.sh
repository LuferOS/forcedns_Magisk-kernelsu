#!/system/bin/sh
MODDIR="${0%/*}"

killall httpd 2>/dev/null
busybox httpd -p 8080 -h "$MODDIR/web"
am start -a android.intent.action.VIEW -d "http://127.0.0.1:8080" >/dev/null 2>&1
