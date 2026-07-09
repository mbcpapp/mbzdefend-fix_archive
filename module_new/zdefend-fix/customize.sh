#!/system/bin/sh

SYSLANGVI="$(getprop persist.sys.locale | grep vi-VN)"
ANDROIDSDK="$(getprop ro.build.version.sdk)"

INSTALLVI="https://git.disroot.org/mbcp/info_vi/wiki/mbcpinstall"
INSTALLEN="https://git.disroot.org/mbcp/info_en/wiki/mbcpinstall"

SELINUXSTATUS="$(getenforce)"

echo "SELinux status : $SELINUXSTATUS"

[ -f /data/local/tmp/lastappfail ] && echo "Last app installation fail: YES"

[ ! -f /data/local/tmp/lastappfail ] && echo "Last app installation fail : NO"

getapkpath() {
	dumpsys package com.mbmobile | grep path: > /data/local/tmp/path.txt
	sed -i 's|    path: ||g' /data/local/tmp/path.txt
	APKPATH="$(cat /data/local/tmp/path.txt)"
	echo "APK Path: $APKPATH"
}

# Clear old iptables
iptables -t nat -F

alreadybypassed() {
	echo "Current MBCP app comes with Zimperium bypass patches"
	echo "There is no need to install this module."
	echo "Continue anyway then."
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
	echo "MB Bank [com.mbmobile] is installed, but the app is NOT MBCP :("
	echo "Please install MBCP v6.4.60+ in order to use this module !"
	[[ $SYSLANGVI ]] && am start -a android.intent.action.VIEW -d $INSTALLVI >/dev/null 2>&1 || am start -a android.intent.action.VIEW -d $INSTALLEN >/dev/null 2>&1
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
	pm hide com.tsng.hidemyapplist >/dev/null 2>&1
}

oldlsposed() {
	echo "--------INCOMPATIBLE LSPOSED DETECTED--------"
	echo "You are using older version of LSPosed!"
	echo "From MB v6.4.80+, you need to use LSPosed with 7199+"
	echo "Please install newer LSPosed to continue."
	echo "We recommend to use Vector, which is formly named as LSPosed."
	echo "You can choose other LSPosed, as long as it newer than 7199+"
	echo "---------------------------------------------"
	am start -a android.intent.action.VIEW -d https://github.com/JingMatrix/Vector/releases >/dev/null 2>&1
	echo "Also remove old LSPosed module if you install Vector!"
	echo "After installed, reboot your device, clear MBCP app data, then install this module again."
	exit 1
}

removeoldfw() {
	echo "Removing old VTAP (V-Key) firmware..."
	[ -f /data/data/com.mbmobile/files/firmware ] && rm -rf /data/data/com.mbmobile/files/firmware
	[ -f /data/data/com.mbmobile/files/profile ] rm -rf /data/data/com.mbmobile/files/profile
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
	echo "Please follow [afterinstall] for fix steps."
	echo "In case if you already done :"
	echo "Try to reinstall module again 3 more times."
	sleep 3
	if [ $SYSLANGVI ]; then
	am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_vi/wiki/afterinstall >/dev/null 2>&1
	am force-stop com.mbmobile
	exit 169
else
	am start -a android.intent.action.VIEW -d https://git.disroot.org/mbcp/info_en/wiki/afterinstall >/dev/null 2>&1	
	exit 169
fi 
}

checkvtapagain() {
	echo "Checking VTAP status again..."
	cat '/data/data/com.mbmobile/databases/vtap' | grep -q 'isProvisioningDone :true' && echo "VTAP is provisioned !" || vtapstillfail || exit 169

}

installfail() {
        echo "App reinstallation failed, please check if CorePatch / Disable App Verification is working or not!" 
	touch /data/local/tmp/lastappfail
	exit 1
}

selinuxhandle() {
	getapkpath > /dev/null 2&>1
	echo "SELinux is Permissive! Enforcing is required!"
	echo "Forcing SELinux state to Enforcing..."
	setenforce enforcing
	echo "Reinstalling app..."
	[ $(pm install $APKPATH | grep Success) ] && echo "Successful reinstall app!" || installfail
	rm -rf /data/local/tmp/lastappfail
}

magiskhosts() {
	echo "Magisk systemless hosts detected!"
	echo "This module should be disabled to work with this module!"
	touch /data/adb/modules/hosts/disable && echo "Disabled systemless hosts module!"
}

[[ -d /data/adb/modules/hosts ]] && magiskhosts

[[ -d /data/data/com.tsng.hidemyapplist ]] && tsnghma 

[[ -d /data/data/io.github.Nirtal0.magisk ]] && maliciousmagisk 

[[ -d /data/data/io.github.x0eg0.magisk ]] && nonfosskitsune

[ -d /data/adb/modules/zygisk_lsposed ] && cat /data/adb/modules/zygisk_lsposed/module.prop | grep versionCode=7024 && oldlsposed

# Check if MB is installed or nope
# Remove this one can cause the module does not work properly!
if [ -d /data/data/com.mbmobile ]; then
	echo "MB/MBCP app found on device!"
else
	echo "MB/MBCP not found! Please install it!"
	[[ $SYSLANGVI ]] && am start -a android.intent.action.VIEW -d $INSTALLVI || am start -a android.intent.action.VIEW -d $INSTALLEN >/dev/null 2>&1
	exit 1
fi

# Check for original MB Bank app
# The module does NOT work with original unpatched app. It's pointless to remove the check. You think it works with original app? Nah.
unzip -l "$APKPATH" | grep -q mbcp* || notmbcp

# last app reinstallation fail with selinux permissive
[ -f /data/local/tmp/lastappfail ] && selinuxhandle

# get apk path first
# only get apkpath if selinux is enforcing
# if the selinux state is permissive, handle app installation first, then getapkpath after it
[ $(getenforce | grep Enforcing) ] && getapkpath

# v6.4.80+ requires enforcing SELinux in order to prevent 40202 VTAP fail (Runtime Tampering) error
[ $(getenforce | grep Permissive) ] && selinuxhandle && getapkpath

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

# Remove vtap (v-key) firmware from data folder (in case if fix vtap cert patch is applied)
# Helpful for older app version (v6.4.92+) or restore to older detection behavior in newer app
unzip -l $APKPATH | grep -q fix_vtap_cert* && removeoldfw 

# Check for bypassed app
unzip -l $APKPATH | grep -q remove_new_zimperium_check* && alreadybypassed 

# Grant permission for MB/MBCP app 

if [ $ANDROIDSDK -gt 32 ]; then
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
	cat /data/adb/magisk.db | grep mbmobile* > /dev/null 2>&1 && echo "[com.mbmobile] is in Denylist now, nice!" || echo "Failed to put [com.mbmobile] to Denylist! Please do it manually or follow afterinstall steps !!!"
else
	echo "Magisk not detected! Skipping Denylist"
fi

# Check VTAP status to ensure that it must be provisioned
echo "------VTAP (V-Key) phase------"
echo "Checking VTAP (V-Key) status..."
cat '/data/data/com.mbmobile/databases/vtap' | grep -q 'isProvisioningDone :true' && echo "VTAP is provisioned !" || vtapfail || exit 169
echo Force closing MBCP app...
am force-stop com.mbmobile
echo "------------------------------"

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

oldzimperium() {
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
}

strongerzimperium() {
	echo "You are using v6.5.7+, old method no longer work."
	echo "Using new method instead."
	echo "Disabling [com.mbmobile] app (to prevent open before fix)"
	pm disable com.mbmobile | grep -q disabled* && echo "Reboot your device, and run [Action] for this module from root manager to continue!" || echo "Do not open app, reboot your device, run [Action] from root manager for this module to continue!"

}

# check for v6.5.7+ and notify to use new method
unzip -l $APKPATH | grep -q libcode.so && strongerzimperium || oldzimperium

# cleanup
rm -rf /data/local/tmp/path.txt
rm -rf /data/local/tmp/lastappfail
