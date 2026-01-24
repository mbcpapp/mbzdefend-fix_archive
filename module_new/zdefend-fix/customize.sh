#!/system/bin/sh

SYSLANGVI="$(getprop persist.sys.locale | grep vi-VN)"
ANDROIDSDK="$(getprop ro.build.version.sdk)"

INSTALLVI="https://git.disroot.org/mbcp/info_vi/wiki/mbcpinstall"
INSTALLEN="https://git.disroot.org/mbcp/info_en/wiki/mbcpinstall"

# Clear old iptables
iptables -t nat -F

nonfosskitsune() {
	echo "Proprietary Kitsune found! Your data might be at risk!"
	echo "Consider install older FOSS Kitsune Mask to protect your data!"
	echo "If you agree with the risk, wait 10 seconds then module will continue to install"
	sleep 15
}
maliciousmagisk() {
	echo "Nirtal Magisk found! Your data might be at risk!"
	echo "Consider install official Magisk to protect your data !"
	echo "If you agree with the risk, wait 15 seconds then module will continue to install"
	sleep 15
}
	
notmbcp() {
	echo "MB Bank [com.mbmobile] is installed, but it seems like that the app is NOT MBCP"
	echo "Please install MBCP v6.4.60+ in order to use this module !"
	[[ $SYSLANGVI ]] && am start -a android.intent.action.VIEW -d $INSTALLVI || am start -a android.intent.action.VIEW -d $INSTALLEN
	exit 1
}

# Replacement for /system/etc/hosts
# Fixes module being disabled due to bindhosts module
nobindhosts() {
	echo "[bindhosts] module not found"
	echo "Please use normal MBZDefend-Fix module instead !"
	exit 169
}

bindhosts() {
	echo "bindhosts module found ! Copying custom.txt"
	unzip -o "$ZIPFILE" 'custom.txt' -d '/data/adb/bindhosts/'
}

[ -d /data/adb/bindhosts ] && bindhosts || nobindhosts


tsnghma() {
	echo "Dr-TSNG HideMyAppList detected!"
	echo "Hiding app..."
	pm hide com.tsng.hidemyapplist
}

[[ -d /data/data/com.tsng.hidemyapplist ]] && tsnghma 

[[ -d /data/data/io.github.Nirtal0.magisk ]] && maliciousmagisk 

[[ -d /data/data/io.github.x0eg0.magisk ]] && nonfosskitsune


# Check if MB is installed or nope
# Remove this one can cause the module does not work properly!
if [ -d /data/data/com.mbmobile ]; then
	echo ""
else
	echo "MB/MBCP not found! Please install it!"
	[[ $SYSLANGVI ]] && am start -a android.intent.action.VIEW -d $INSTALLVI || am start -a android.intent.action.VIEW -d $INSTALLEN
	exit 1
fi

# Check if Termux and it's bootstrap is initialized or not
# Remove this code broke Termux support
if [ -d /data/data/com.termux ]; then
	if [[ -d /data/data/com.termux/files/home ]]; then
	echo "Termux bootstrap found!"
	appops set com.termux SYSTEM_ALERT_WINDOW allow
	unzip -o "$ZIPFILE" 'script/MB_Bank.sh' -d '/data/user/0/com.termux/files/home/.shortcuts/'
	else
	echo "Termux bootstrap not found! Launching Termux..."
	am start -n com.termux/com.termux.app.TermuxActivity
	sleep 20
	am force-stop com.termux
	appops set com.termux SYSTEM_ALERT_WINDOW allow    
	fi
else
	echo "Termux not installed! skipping"
fi

# Check for original MB Bank app
# The module does NOT work with original unpatched app. It's pointless to remove the check. You think it works with original app? Nah.
for library in $(find /data/app -name libvvb2060.so | grep com.mbmobile) ; do notmbcp ; done

# Grant permission for MB/MBCP app
if [ $ANDROIDSDK -gt 33 ]; then
	echo "Granting MB/MBCP app permission..."
	pm grant com.mbmobile android.permission.CAMERA
	pm grant com.mbmobile android.permission.RECORD_AUDIO
	pm grant com.mbmobile android.permission.POST_NOTIFICATIONS
	pm grant com.mbmobile android.permission.ACCESS_FINE_LOCATION
	pm grant com.mbmobile android.permission.READ_CONTACTS
	pm grant com.mbmobile android.permission.READ_PHONE_STATE
	pm grant com.mbmobile android.permission.BLUETOOTH_CONNECT
else
	echo "Android version is lower than 13! Granting basic MB/MBCP app permission..."
	pm grant com.mbmobile android.permission.CAMERA
	pm grant com.mbmobile android.permission.RECORD_AUDIO
	pm grant com.mbmobile android.permission.READ_CONTACTS
	pm grant com.mbmobile android.permission.READ_PHONE_STATE
fi

unzip -o "$ZIPFILE" 'vtapnotinit.sh'
unzip -o "$ZIPFILE" 'vtapstillfail.sh'
chmod +x 'vtapstillfail.sh'
chmod +x 'vtapnotinit.sh'

# Delete /data/magisk if it exists so MB doesnt failling when eKYC with error code EKYC3002-MS6998 for Magisk users 
[ -d /data/magisk ] && echo "Magisk folder found! deleting..." && rm -r /data/magisk 
find /data -name 'magisk_backup*' -delete
echo ---------------------------

if [ -d /data/adb/magisk ]; then
	echo "Enabling Denylist for [com.mbmobile]..."
	magisk --denylist enable
	magisk --denylist add com.mbmobile
else
	echo "Magisk not detected! Skipping Denylist"
fi

# Check VTAP status to ensure that it must be provisioned
echo "Checking VTAP status..."
echo "VTAP status : " && cat '/data/data/com.mbmobile/databases/vtap' | grep "true" && echo "VTAP is provisioned!" || sh 'vtapnotinit.sh'
echo "Checking VTAP status again..."
cat '/data/data/com.mbmobile/databases/vtap' | grep "true" && echo "VTAP is provisioned!" || sh 'vtapstillfail.sh' || exit 169

echo Force closing MBBank app...
am force-stop com.mbmobile

# Support for Biz MB Bank v2.0 (Flutter version)
for library in $(find /data/app -name libholdingshadow.so | grep com.mbbank.biz.prod) ; do rm $library ; done
sleep 2
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
echo Starting Flutter activity...
echo "ATTENTION : Network traffic will be redirected to [medium.com] for 20 seconds !!!"
echo "Press [Try again] after got 1005/1007/VPN error on MB, so it's can bypass device not secure dialog !"
# Reference : https://superuser.com/questions/1248670/redirect-ip-to-another-ip-using-iptables
iptables -t nat -A OUTPUT -p tcp -j DNAT --to-destination 162.159.152.4
am start -n com.mbmobile/io.flutter.plugins.MainActivity
sleep 20
echo "Restoring network traffic"
# Reference : https://gist.github.com/jstrosch/3190568 (Line 7)
iptables -t nat -F 

if [ $SYSLANGVI ]; then
	su -lp 2000 -c "cmd notification post -S bigtext -t 'MBZDefend-Fix' tag 'LƯU Ý : Vui lòng nhấn [Thử lại] tại màn hình báo lỗi 1005/1007/VPN để vào App MBCP. Sau khi thao tác xong, nên khởi động lại thiết bị ngay.'" >/dev/null 2>&1
	[ -d /data/adb/magisk ] && am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_vi/wiki/vtapfix
	[ -d /data/data/me.weishu.kernelsu ] && am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_vi/wiki/vtapfix
else
	su -lp 2000 -c "cmd notification post -S bigtext -t 'MBZDefend-Fix' tag 'WARNING : Please click [Try again] on 1005/1007/VPN screen to continue entering MBCP App, then reboot your device ASAP.'" >/dev/null 2>&1
	[ -d /data/adb/magisk ] && am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_en/wiki/vtapfix
	[ -d /data/data/me.weishu.kernelsu ] && am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_en/wiki/vtapfix

fi
	sleep 3



