# MB ZDefend Bypass Module for MB/MBCP


- Download from [releases tab](/mbcp/mbzdefend-fix/releases)

- Author : [Cuynu](/cuynu) and [backslashxx](https://github.com/backslashxx) for sed script

- Status : Working with MBCP!

- Required app version : MBCP `v6.4.67` and up for `v3.2-mb+` | MB `v6.4.15` up to `v6.4.58` for `v3.0-mb` or lower

- Required Biz MBBank v2.0 app version : `v1.0.85` and newer :>

## Why this exists ?
- Zimperium and MB Bank development team didn't respect our freedom and privacy by blocking rooted devices (KernelSU/KernelSU-Next/Magisk/APatch), device using LSPosed with a screen showing "THIẾT BỊ JAILBROKEN HOẶC ROOTED" or "JAILBROKEN DEVICE OR ROOTED" (in English) with only "Close app" option.

## Building
```
git clone https://git.disroot.org/mbcp/mbzdefend-fix.git
cd mbzdefend-fix
./createmodule.sh
```

## Source code

This project are licensed under [MIT License](https://git.disroot.org/cuynu/mbzdefend-fix).

- For module : Located on [module_new](https://git.disroot.org/cuynu/mbzdefend-fix/src/branch/main/module_new/zdefend-fix)

- For patched lib (Deprecated) : There is no source code for that as it belong to MB Bank development team and Zimperium. You can make your own patched lib with old method below if you don't want to use my pre-patched lib :)

## Usage (Module)
- Ensure that old root detection (vtap) is bypassed by hiding MB Bank or Biz MBBank v2.0 App from root with any old ways, like Denylist as the module does not handle this old root detection method (For Magisk : [Here](https://www.youtube.com/watch?v=OfFoRltRlME) | For Magisk Delta/Kitsune : [Here](https://www.youtube.com/watch?v=tToyWfJQ-yw)
- Download mbzdefend-fix module from [releases](https://git.disroot.org/cuynu/mbzdefend-fix/releases) or clone the repo, then `./createmodule.sh`
- Flash with your root app (Magisk, KernelSU, KernelSU Next, APatch, etc)
- It should automatically patches `libZDefend.so` and `libapp.so` then open MB/MBCP or Biz MB Bank v2.0 app once it finished.
- NOTE : Every time you need to use MB Bank, you MUST run "Action" on root app -> Modules -> MB ZDefend Bypass instead of open app directly from app drawer (Applies for v6.4.56+ due to server-side MB changes)
- NOTE : App will open with 1005/1007 error or stuck on MB logo, DON'T PANIC and wait for error popup appears, then press "Try again" until app enter login screen !!!


# Tested app version (Outdated)
- Checked mark is the version that already tested and working~

- [x] [MB Bank v6.4.58](https://t.me/embeeapks/48) (MBShield) (need workaround)

- [x] [MB Bank v6.4.57](https://t.me/embeeapks/47) (MBShield) (need workaround)

- [x] [MB Bank v6.4.56](https://t.me/embeeapks/46) (MBShield) (need workaround)

- [x] [MB Bank v6.4.55](https://t.me/embeeapks/45) (MBShield) (no crashes)

- [x] [MB Bank v6.4.54](https://t.me/embeeapks/43) (MBShield) (no crashes)

- [x] [MB Bank v6.4.53](https://t.me/embeeapks/42) (MBShield) (no crashes)

- [x] [MB Bank v6.4.52](https://t.me/embeeapks/41) (MBShield) (no crashes)

- [x] [MB Bank v6.4.51](https://t.me/embeeapks/36) (MBShield) (no crashes)

- [x] [MB Bank v6.4.50](https://t.me/embeeapks/35) (MBShield) (no crashes) 

- [x] [MB Bank v6.4.49](https://t.me/embeeapks/32) (MBShield) (no crashes) 

- [x] [MB Bank v6.4.48](https://t.me/embeeapks/30) (MBShield) (no crashes)

- [x] [MB Bank v6.4.47](https://t.me/embeeapks/29) (MBShield) (no crashes)

- [x] [MB Bank v6.4.46](https://t.me/embeeapks/28) (MBShield) (no crashes)

- [x] [MB Bank v6.4.45](https://t.me/embeeapks/25) (no crashes)

- [x] [MB Bank v6.4.44](https://t.me/embeeapks/24) -  No Zimperium found. (MBShield)

- [x] [MB Bank v6.4.43](https://t.me/embeeapks/23) (MBShield) (no crashes)

- [x] [MB Bank v6.4.42](https://t.me/embeeapks/22) (MBShield) (no crashes)

- [x] [MB Bank v6.4.41](https://t.me/embeeapks/21) (MBShield) (no crashes)

- [x] [MB Bank v6.4.40](https://t.me/embeeapks/20) (MBShield) (no crashes)

- [x] [MB Bank v6.4.39](https://t.me/embeeapks/19) (MBShield) (no crashes)

- [x] [MB Bank v6.4.38](https://t.me/embeeapks/18) (MBShield) (no crashes)

- [x] [MB Bank v6.4.37](https://t.me/embeeapks/17) (MBShield) (no crashes)

- [x] [MB Bank v6.4.36](https://t.me/embeeapks/16) (MBShield) (no crashes)

- [x] [MB Bank v6.4.35](https://t.me/embeeapks/14) (MBShield) (no crashes)

- [x] [MB Bank v6.4.34](https://t.me/embeeapks/13) (MBShield) (no crashes)

- [x] [MB Bank v6.4.33](https://t.me/embeeapks/11) (MBShield) (no crashes)

- [x] [MB Bank v6.4.32](https://t.me/embeeapks/9) (MBShield) (no crashes)

- [x] [MB Bank v6.4.31](https://t.me/embeeapks/6) (MBShield)

- [x] [MB Bank v6.4.30](https://t.me/mbmobileold/198) (MBShield) 

- [x] [MB Bank v6.4.29](https://t.me/mbmobileold/197) (MBShield) 

- [x] [MB Bank v6.4.28](https://t.me/mbmobileold/196) (MBShield) 

- [x] [MB Bank v6.4.27](https://t.me/mbmobileold/195) (MBShield) 



## How this was done (Pre-patched binary only) (OUTDATED)
- Use HxD Hex Editor (can be run on Linux env with wine)
- Get `libZDefend.so` from MB Bank app, APKs can be get from Google Play or Aurora Store
- For `libvvb2060.so`, create a empty file and name it as `libvvb2060.so`
- Open `libZDefend.so` with HxD Hex Editor, use Replace feature (Ctrl + R)
- In search for field, type `zimperium`
- In replace with field, fill 9 empty blank space characters or any random words that has 9 characters  -> Replace all (Be careful, if something went wrong then modified `libZDefend.so` file will not work at all)
- After HxD replaced zimperium with 9 empty black space characters or empty, save it with (Ctrl + S)
- Copy that`libZDefend.so` you just modified to MB Bank lib folder
- Force close MB Bank app if its not completely stopped, then open MB Bank app again, from now its should load new library and the root & hook detection from Zimperium should be bypassed
