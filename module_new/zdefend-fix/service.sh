#!/system/bin/sh

while [ "$(getprop sys.boot_completed)" != "1" ]; do
	sleep 1
done

# Delete /data/magisk if it exists so MB doesnt failling when eKYC with error code EKYC3002-MS6998 for Magisk users
[[ -d /data/magisk ]] && rm -r /data/magisk
[[ -d /data/data/io.github.x0eg0.magisk ]] && rm -r /data/adb/modules/zdefend-fix
[[ -d /data/data/io.github.Nirtal0.magisk ]] && rm -r /data/adb/modules/zdefend-fix
	rm -rf /data/data/com.mbmobile/files/0*
        rm -rf /data/data/com.mbmobile/files/1*
        rm -rf /data/data/com.mbmobile/files/2*
        rm -rf /data/data/com.mbmobile/files/3*
        rm -rf /data/data/com.mbmobile/files/4*
        rm -rf /data/data/com.mbmobile/files/5*
	rm -rf /data/data/com.mbmobile/files/6*
        rm -rf /data/data/com.mbmobile/files/7*
        rm -rf /data/data/com.mbmobile/files/8*
        rm -rf /data/data/com.mbmobile/files/9*
	rm -rf /data/data/com.mbmobile/files/KNOV3PN*
	rm -rf /data/data/com.mbmobile/files/zxpolicyme*
	rm -rf /data/data/com.mbmobile/files/policyme*

