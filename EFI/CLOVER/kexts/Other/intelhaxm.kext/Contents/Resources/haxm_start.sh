#!/bin/bash

is_32_platform=0

function strstr()
{
  echo $1 | grep --quiet $2
}

os_ver=`uname -a`

if $( strstr "$os_ver" 'i386')
then
  is_32_platform=1
fi

haxm_dir=/Library/Extensions/intelhaxm.kext
haxm_dir_old=/System/Library/Extensions/intelhaxm.kext
launch_file_old=/System/Library/LaunchDaemons/com.intel.haxm.plist
haxm_res=$haxm_dir/Contents/Resources

if [ -d "$haxm_dir_old" ]; then
    rm -rf "$haxm_dir_old"
fi

if [ -e "$launch_file_old" ]; then
    rm -f "$launch_file_old"
fi

if [ -d "$haxm_dir" ]; then
    /sbin/kextunload -b 'com.intel.kext.intelhaxm'
fi
/sbin/kextload "$haxm_dir"

"$haxm_res/haxm_configure" $is_32_platform

exit 0

