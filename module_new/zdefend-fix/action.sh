#!/system/bin/sh	

SYSLANGVI="$(getprop persist.sys.locale | grep vi-VN)"

INSTALLEN="https://git.disroot.org/mbcp/info_en/wiki/mbcpinstall"
INSTALLVI="https://git.disroot.org/mbcp/info_vi/wiki/mbcpinstall"

notmbcp() {
	echo "MB Bank [com.mbmobile] is installed, but it seems like that the app is NOT MBCP"
	echo "Please install MBCP v6.4.60+ in order to use this module !"
	[[ $SYSLANGVI ]] && am start -a android.intent.action.VIEW -d $INSTALLVI || am start -a android.intent.action.VIEW -d $INSTALLEN 
	exit 1
}

vtapfail() {
	echo "VTAP is not provisioned!"
	echo "App first normal launch required!"
	iptables -t nat -F OUTPUT
	am start -n com.mbmobile/io.flutter.plugins.MainActivity
	logcat -c
	sleep 20
	logcat -d | grep VGFullScreenDialog && vtapstillfail 
	am force-stop com.mbmobile
}

vtapstillfail() {
	echo "VTAP provision failed or triggering! Cannot continue!"
	echo "If you have low-end device (eg : Vsmart Joy 2+)"
	echo "Try to reinstall module again 3 more times."
	if [ $SYSLANGVI ]; then
	am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_vi/wiki/vtapfix
	exit 169
else
	am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_en/wiki/vtapfix	
	exit 169
fi 
}

# Check for original MB Bank app
for library in $(find /data/app -name libvvb2060.so | grep com.mbmobile) ; do notmbcp ; done

# Check VTAP status to ensure that it must be provisioned
echo "Checking VTAP status..."
echo "VTAP status : " && cat '/data/data/com.mbmobile/databases/vtap' | grep "true" && echo "VTAP is provisioned!" || vtapfail || exit 169
echo "Checking VTAP status again..."
cat '/data/data/com.mbmobile/databases/vtap' | grep "true" && echo "VTAP is provisioned!" || vtapstillfail || exit 169


# Delete /data/magisk if it exists so MB doesnt failling when eKYC with error code EKYC3002-MS6998 for Magisk users
echo "Deleting /data/magisk if it exists..."
[[ -d /data/magisk ]] && rm -r /data/magisk
find /data -name 'magisk_backup*' -delete
echo Forcing stop MB Bank...
am force-stop com.mbmobile
logcat -c
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
echo "ATTENTION : Network traffic will be redirected to [medium.com] for 20 seconds !!!"
echo "Press [Try again] after got 1005/1007/VPN error on MB, so it's can bypass device not secure dialog !"
# Reference : https://superuser.com/questions/1248670/redirect-ip-to-another-ip-using-iptables
iptables -t nat -A OUTPUT -p tcp -j DNAT --to-destination 162.159.152.4
am start -n com.mbmobile/io.flutter.plugins.MainActivity
sleep 20
logcat -d | grep VGFullScreenDialog && vtapstillfail 
echo "Restoring network traffic"
# Reference : https://gist.github.com/jstrosch/3190568 (Line 7)
iptables -t nat -F


if [ $SYSLANGVI ]; then
	su -lp 2000 -c "cmd notification post -S bigtext -t 'MBZDefend-Fix' tag 'LƯU Ý : Vui lòng nhấn [Thử lại] tại màn hình báo lỗi 1005/1007/VPN để vào App MBCP.'" >/dev/null 2>&1
else
	su -lp 2000 -c "cmd notification post -S bigtext -t 'MBZDefend-Fix' tag 'WARNING : Please click [Try again] on 1005/1007/VPN screen to continue entering MBCP App.'" >/dev/null 2>&1
fi
sleep 3

