#!/system/bin/sh

SYSLANGVI="$(getprop persist.sys.locale | grep vi-VN)"
ANDROIDSDK="$(getprop ro.build.version.sdk)"

INSTALLVI="https://git.disroot.org/mbcp/info_vi/wiki/mbcpinstall"
INSTALLEN="https://git.disroot.org/mbcp/info_en/wiki/mbcpinstall"

# Get base.apk path 
dumpsys package com.mbmobile | grep path: > /data/local/tmp/path.txt
sed -i 's|    path: ||g' /data/local/tmp/path.txt

APKPATH="$(cat /data/local/tmp/path.txt)"

echo "APK Path: $APKPATH"

# Clear old iptables
iptables -t nat -F

alreadybypassed() {
	echo "Current MBCP app comes with Zimperium bypass patches"
	echo "There is no need to install this module."
	echo "If you want to install this module, do not apply Zimperium bypass patch or use Minimal variant."
	rm -rf /data/local/tmp/path.txt
	exit 1
}

nonfosskitsune() {
	echo "Proprietary Kitsune found! Your data might be at risk!"
	echo "Consider install older FOSS Kitsune Mask to protect your data!"
	echo "If you agree with the risk, wait 15 seconds then module will continue to install"
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
	[[ $SYSLANGVI ]] && am start -a android.intent.action.VIEW -d $INSTALLVI >/dev/null 2>&1 || am start -a android.intent.action.VIEW -d $INSTALLEN >/dev/null 2>&1
	exit 1
}

# old HideMyAppList is triggering VTAP, that's why it's must be hidden
tsnghma() {
	echo "Dr-TSNG HideMyAppList detected!"
	echo "Hiding app..."
	pm hide com.tsng.hidemyapplist >/dev/null 2>&1
}

vtapfail() {
	echo "VTAP is not provisioned!"
	echo "App first normal launch required!"
	iptables -t nat -F 
	am start -n com.mbmobile/io.flutter.plugins.MainActivity
	logcat -c
	sleep 20
	logcat -d | grep VGFullScreenDialog && vtapstillfail
	logcat -d | grep -q com.vtap.MaintenanceActivity && vtapstillfail
	am force-stop com.mbmobile
	checkvtapagain
}

vtapstillfail() {
	iptables -t nat -F
	echo "VTAP provision failed or triggering! Cannot continue!"
	echo "Please follow vtapfix for fix steps."
	echo "In case if you already done :"
	echo "Try to reinstall module again 3 more times."
	sleep 3
	if [ $SYSLANGVI ]; then
	am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_vi/wiki/vtapfix >/dev/null 2>&1
	am force-stop com.mbmobile
	exit 169
else
	am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_en/wiki/vtapfix >/dev/null 2>&1	
	exit 169
fi 
}

checkvtapagain() {
	echo "Checking VTAP status again..."
	cat '/data/data/com.mbmobile/databases/vtap' | grep -q 'isProvisioningDone :true' && echo "VTAP is provisioned !" || vtapstillfail || exit 169

}

[[ -d /data/data/com.tsng.hidemyapplist ]] && tsnghma 

[[ -d /data/data/io.github.Nirtal0.magisk ]] && maliciousmagisk 

[[ -d /data/data/io.github.x0eg0.magisk ]] && nonfosskitsune

# Check if MB is installed or nope
# Remove this one can cause the module does not work properly!
if [ -d /data/data/com.mbmobile ]; then
	echo "MB/MBCP app found on device!"
else
	echo "MB/MBCP not found! Please install it!"
	[[ $SYSLANGVI ]] && am start -a android.intent.action.VIEW -d $INSTALLVI || am start -a android.intent.action.VIEW -d $INSTALLEN >/dev/null 2>&1
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

# Check for bypassed app
unzip -l $APKPATH | grep remove_new_zimperium_check* && alreadybypassed 

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
echo "------VTAP phase------"
echo "Checking VTAP status..."
cat '/data/data/com.mbmobile/databases/vtap' | grep -q 'isProvisioningDone :true' && echo "VTAP is provisioned !" || vtapfail || exit 169
echo Force closing MBCP app...
am force-stop com.mbmobile
echo "----------------------"

# Clear device logcat to ensure that no previous VTAP activity exists
logcat -c

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
echo "------Start app phase------"
echo Starting Flutter activity...
echo "ATTENTION : Network traffic will be redirected to [medium.com] for 20 seconds !!!"
echo "Press [Try again] after got 1005/1007/VPN error on MB, so it's can bypass device not secure dialog !"
# Reference : https://superuser.com/questions/1248670/redirect-ip-to-another-ip-using-iptables
iptables -t nat -A OUTPUT -p tcp -j DNAT --to-destination 162.159.152.4
am start -n com.mbmobile/io.flutter.plugins.MainActivity >/dev/null 2>&1
sleep 20
echo "---------------------------"

# Look for VTAP activity from logcat 
logcat -d | grep -q VGFullScreenDialog && vtapstillfail 
logcat -d | grep -q com.vtap.MaintenanceActivity && vtapstillfail

echo "Restoring network traffic"
# Reference : https://gist.github.com/jstrosch/3190568 (Line 7)
iptables -t nat -F 

if [ $SYSLANGVI ]; then
	su -lp 2000 -c "cmd notification post -S bigtext -t 'MBZDefend-Fix' tag 'LƯU Ý : Vui lòng nhấn [Thử lại] tại màn hình báo lỗi 1005/1007/VPN để vào App MBCP. Sau khi thao tác xong, nên khởi động lại thiết bị ngay.'" >/dev/null 2>&1
else
	su -lp 2000 -c "cmd notification post -S bigtext -t 'MBZDefend-Fix' tag 'WARNING : Please click [Try again] on 1005/1007/VPN screen to continue entering MBCP App, then reboot your device ASAP.'" >/dev/null 2>&1	
fi
	sleep 3



