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
	am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_vi/wiki/afterinstall
	exit 169
else
	am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_en/wiki/afterinstall
	exit 169
fi 
}

# Check for original MB Bank app
for library in $(find /data/app -name libtoolChecker.so | grep com.mbmobile) ; do notmbcp ; done

# Check VTAP status to ensure that it must be provisioned
echo "Checking VTAP status..."
echo "VTAP status : " && cat '/data/data/com.mbmobile/databases/vtap' | grep -q "true" && echo "VTAP is provisioned!" || vtapfail || exit 169
echo "Checking VTAP status again..."
cat '/data/data/com.mbmobile/databases/vtap' | grep -q "true" && echo "VTAP is provisioned!" || vtapstillfail || exit 169


# Delete /data/magisk if it exists so MB doesnt failling when eKYC with error code EKYC3002-MS6998 for Magisk users
[[ -d /data/adb/magisk ]] && rm -r /data/magisk
[[ -d /data/adb/magisk ]] && find /data/. -name 'magisk_backup*' -delete

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
	rm -rf /data/data/com.mbmobile/files/zxpolicy*
	rm -rf /data/data/com.mbmobile/files/policyme*
	find /data/data/com.mbmobile/files -size +2000k -delete


oldzimperium() {
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
}

nometamodule() {
	echo "No meta-module installed! Please install one and reboot then try again!!!!"
	echo "We recommend Hybird Mount..."
	echo "Opening release page in 5 seconds..."
	am start -a android.intent.action.VIEW -d https://github.com/Hybrid-Mount/meta-hybrid_mount/releases
	sleep 5
	exit 1
}

checkmetamodule() {
	[ ! -d /data/adb/metamodule ] && nometamodule
}


zimperiumpresent() {
	echo "Zimperium still present! Cannot continue :("
	echo "Checking if your current root implementation has metamodule..."
	[ -f /data/adb/modules/mountify ] && echo "You are using [Mountify] metamodule!" && echo "Please install [bindhosts] module and use MBZDefend-Fix bindhosts variant or use custom DNS with host blocking instead!" && exit 1
	[ -f /data/adb/metamodule/disable ] && echo "Current installed metamodule is disabled, enabling again!" && rm -f /data/adb/metamodule/disable && echo "Reboot and try again?" && exit 1
	[ -f /data/adb/ksud ] && cat /data/adb/ksud | grep -q ksud::metamodule && checkmetamodule
        [ -f /data/adb/apd ] && cat /data/adb/apd | grep -q apd::metamodule && checkmetamodule
	echo "Please remove any module override hosts, or use alternative DNS with zimperium host blocking!"
	exit 1
}

strongerzimperium() {
	echo "Testing network..."
	curl -s --max-time 5 google.com | grep -q html* || echo "No network available, Cannot continue:(" || exit 1
	echo "Testing zimperium..."
	curl -s --max-time 10 gts.zimperium.com | grep -q html* && zimperiumpresent
	echo "Enabling [com.mbmobile] app..."
	pm enable com.mbmobile | grep -q enabled* && echo "[com.mbmobile] is now enabled!"
	echo "Opening app..."
	am start -n com.mbmobile/io.flutter.plugins.MainActivity

}

# check v6.5.7+
find /data/app -name libcode.so | grep -q com.mbmobile && strongerzimperium || oldzimperium
