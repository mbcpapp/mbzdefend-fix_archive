# MBZDefend-Fix by Cuynu
Bypass MB Bank zimperium root/hook detection (does not bypass VTAP root detection)

* As of v3.1-mb+, MBCP is required due to MB limitations from original app.

## Changelogs :

- v4.2-mb
```
feat: zdefend-fix(customize.sh): handle selinux permissive & move from vtapfix to afterinstall
feat: customize.sh: check for bindhost & require user to install bindhost variant instead
feat: customize.sh: set selinux to enforcing
fix: customize.sh: wrong ANDROIDSDK version
```

- v4.1-mb
```
feat: customize.sh: check for already bypassed app
feat: customize.sh: check vtap status again by call from vtapfail function & misc changes 
feat: new VTAP fail check method & vtapfail/vtapstillfail as a function
fix: customize.sh: wrong second
feat: do not block installation for kitsune 30.6 & nirtal magisk users
fix: customize.sh: reduce to just exit instead of uninstalling malicious magisk app
feat: customize.sh: timer before uninstallation
feat: customize.sh: service.sh: detect and uninstall unknown magisk
```

- v4.0-mb
```
feat: service.sh: delete module itself if proprietary kitsune mask is found
feat: customize.sh: hide com.tsng.hidemyapplist package during module installation
feat: customize.sh: enforce foss kitsune mask
fix: wrong ip
feat: redirect to fake IP instead
fix: customize.sh: unzip shortcut after termux bootstrap is found
feat: customize.sh: depends on syslang to open right mbcpinstall page
```

- v3.9-mb
```
feat: action.sh: also check vtap provision status for action script
```

- v3.8-mb
```
fix: customize.sh: execute denylist fix before vtap check
```
- v3.7-mb
```
feat: bump v3.7-mb
feat: createmodule.sh: commit id after module name
feat: vtapstillfail.sh: open vtapfix after vtap failling to init
feat: customize.sh: handle denylist for magisk & depends on syslang to open proper vtapfix web
```

- v3.6-mb
```
feat: misc changes
- remove old patching code (v6.4.55 or older please use older version)
- new auto granting app permission
- improve code logic
- support english & vietnamese language for MBZDefend-Fix notification
- other changes idk

joke: im not (or is) a developer

```

- v3.5-mb
```
feat: redirect zimperium to localhost
```

- v3.4-mb
```
feat: adapt with new detection point
```

- v3.3-mb
```
fix: customize.sh: typo fix 
feat: vtapstillfail.sh: notice for low-end devices that is failing to properly provision vtap 
feat: implement MB & termux & magisk check 
feat: check if vtap is provisioned or not 
```

- v3.2-mb
```
fix: installation failling on some devices
```

- v3.1-mb
```
moved to new code structure, only works with patched MB app (MBCP)
```

- v3.0-mb
```
added termux script for easier use
```

- v2.9-mb
```
workaround for v6.4.56+, ugly but works :<
- it's now requires you to run "Action" on root app -> modules -> MB ZDefend Bypass everytime you need to use MB Bank app...
```

- v2.8-mb
```
open url that guide users follow step to hide vtap detection
```

- v2.6-mb
```
module name changed to "MB ZDefend Bypass"
delete fake "libZDefend.so" for both MB Bank & BizMB Flutter
add support for Biz MB Bank v2.0 (Flutter)
```

- v2.5-mb
```
fix module description.
```

- v2.4-mb
```
disable provider silently
```

- v2.3-mb
```
disable provider before patching
```

- v2.2-mb
```
patching [com.mbmobile] only and minor other changes
```

- v2.1-mb
```
adapt with v6.4.48+
```

- v2.0-mb
```
deleting /data/magisk to prevent eKYC failling
deleting /data/magisk for startup script and actions
```
- v1.9-mb
```
- change patch arguments
- check for sed version before patching 
```
- v1.8-mb
```
- fix patching failure on startup for Magisk
```
- v1.7-mb
```
- fix patching failure on Magisk by don't use busybox
```
- v1.6-mb
```
- Test fix installation issue on Magisk/Kitsune Mask
```

- v1.5-mb
```
- Initial release
```
