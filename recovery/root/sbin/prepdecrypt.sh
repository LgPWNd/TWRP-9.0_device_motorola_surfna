#!/sbin/sh
set -x

relink()
{
	fname=$(basename "$1")
	target="/sbin/$fname"
	sed 's|/system/bin/linker|///////sbin/linker|' "$1" > "$target"
	chmod 755 $target
}

finish()
{
	umount /v
	umount /s
	rmdir /v
	rmdir /s
	setprop crypto.ready 1
	exit 0
}

suffix=$(getprop ro.boot.slot_suffix)
if [ -z "$suffix" ]; then
	suf=$(getprop ro.boot.slot)
	suffix="_$suf"
fi
venpath="/dev/block/bootdevice/by-name/vendor$suffix"
mkdir /v
mount -t ext4 -o ro "$venpath" /v
syspath="/dev/block/bootdevice/by-name/system$suffix"
mkdir /s
mount -t ext4 -o ro "$syspath" /s


build_prop_path="/s/build.prop"
if [ -f /s/system/build.prop ]; then
	build_prop_path="/s/system/build.prop"
fi

vendor_prop_path="/v/build.prop"
if [ -f "$build_prop_path" ]; then
	# TODO: It may be better to try to read these from the boot image than from /system
	osver=$(grep -i 'ro.build.version.release' "$build_prop_path"  | cut -f2 -d'=')
	patchlevel=$(grep -i 'ro.build.version.security_patch' "$build_prop_path"  | cut -f2 -d'=')
	vendorlevel=$(grep -i 'ro.vendor.build.security_patch' "$vendor_prop_path"  | cut -f2 -d'=')
	setprop ro.build.version.release "$osver"
	setprop ro.build.version.security_patch "$patchlevel"
	setprop ro.vendor.build.security_patch "$vendorlevel"
else
	# Be sure to increase the PLATFORM_VERSION in build/core/version_defaults.mk to override Google's anti-rollback features to something rather insane
	osver=$(getprop ro.build.version.release_orig)
	patchlevel=$(getprop ro.build.version.security_patch_orig)
	setprop ro.build.version.release "$osver"
	setprop ro.build.version.security_patch "$patchlevel"
	setprop ro.vendor.build.security_patch "2018-11-05"
fi

mkdir -p /vendor/lib/hw/

cp /s/system/lib/android.hidl.base@1.0.so /sbin/
cp /s/system/lib/libion.so /sbin/
cp /s/system/lib/libicuuc.so /sbin/
cp /s/system/lib/libxml2.so /sbin/

relink /v/bin/qseecomd

cp /v/lib/libdiag.so /vendor/lib/
cp /v/lib/libdrmfs.so /vendor/lib/
cp /v/lib/libdrmtime.so /vendor/lib/
cp /v/lib/libGPreqcancel.so /vendor/lib/
cp /v/lib/libGPreqcancel_svc.so /vendor/lib/
cp /v/lib/libqdutils.so /vendor/lib/
cp /v/lib/libqisl.so /vendor/lib/
cp /v/lib/libqservice.so /vendor/lib/
cp /v/lib/libQSEEComAPI.so /vendor/lib/
cp /v/lib/librecovery_updater_msm.so /vendor/lib/
cp /v/lib/librpmb.so /vendor/lib/
cp /v/lib/libsecureui.so /vendor/lib/
cp /v/lib/libSecureUILib.so /vendor/lib/
cp /v/lib/libsecureui_svcsock.so /vendor/lib/
cp /v/lib/libspcom.so /vendor/lib/
cp /v/lib/libspl.so /vendor/lib/
cp /v/lib/libssd.so /vendor/lib/
cp /v/lib/libStDrvInt.so /vendor/lib/
cp /v/lib/libtime_genoff.so /vendor/lib/
cp /v/lib/libkeymasterdeviceutils.so /vendor/lib/
cp /v/lib/libkeymasterprovision.so /vendor/lib/
cp /v/lib/libkeymasterutils.so /vendor/lib/
cp /v/lib/libqtikeymaster4.so /vendor/lib/
cp /v/lib/vendor.qti.hardware.tui_comm@1.0.so /vendor/lib/
cp /v/lib/hw/bootctrl.msm8953.so /vendor/lib/hw/
cp /v/lib/hw/android.hardware.boot@1.0-impl.so /vendor/lib/hw/
cp /v/lib/hw/android.hardware.gatekeeper@1.0-impl-qti.so /vendor/lib/hw/
#cp /v/lib/hw/android.hardware.keymaster@3.0-impl-qti.so /vendor/lib/hw/

cp /v/manifest.xml /vendor/
cp /v/compatibility_matrix.xml /vendor/

relink /v/bin/hw/android.hardware.boot@1.0-service
relink /v/bin/hw/android.hardware.gatekeeper@1.0-service-qti
#relink /v/bin/hw/android.hardware.keymaster@3.0-service-qti
relink /v/bin/hw/android.hardware.keymaster@4.0-service-qti
finish
