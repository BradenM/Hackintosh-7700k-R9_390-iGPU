#!/bin/bash

extensionsPath="/Library/Extensions"
launchDaemons="/Library/LaunchDaemons"
haxmKextName="intelhaxm.kext"
kextResources="$extensionsPath/$haxmKextName/Contents/Resources"
haxmPlistName="com.intel.haxm.plist"
haxmPreferPlist="com.intel.kext.haxm.plist"
haxmPkgName="com.intel.kext.haxm"

ext="1"
silent_mode="0"
answ="no"

check_root()
{
    if [ $UID -eq 0 ]
    then
        return 0
    fi
    CURDIR=$(pwd)
    if [ $silent_mode == "0" ]
    then
        echo
        echo "Please run the script with sudo:"
        echo "sudo $0 $*"
        echo
        echo Failed to uninstall Intel HAXM
        echo
    fi
    exit 1
}

check_root

if [[ $1 = "-silent" ]]
then
    silent_mode="1"
fi


while [ $ext != "0" ]
do
    if [ $silent_mode == "0" ]; then
        echo ""
        echo "This will remove Intel(R) HAXM from your computer."
        echo ""
        echo "Important: Removing Intel HAXM will disable acceleration of all Intel(R) x86"
        echo "Android emulators. Your Android Virtual Devices will continue to function, but"
        echo "will no longer be accelerated."
        echo "Installing Intel HAXM again will re-enable Android emulator acceleration."
        echo ""
        echo "Warning: Please close all instances of the Android x86 emulator before"
        echo "proceeding."
        echo ""

        echo -n "Do you wish to uninstall Intel HAXM (y/n)? "
        read answ
    fi
    if [ "$answ" == "y" ] || [ $silent_mode == "1" ]
    then
        if [ $silent_mode == "0" ]
        then 
            echo "Removing Intel HAXM files"
        fi

        # Verify emulator is not running
        "$kextResources/haxm-isRunning" &> /dev/null
        if [ $? -ne 0 ]
        then 
            if [ $silent_mode == "0" ]; then
                echo ""
                echo "Error: An Android x86 emulator instance is running."
                echo "Please close all emulator instances and re-run uninstallation."
                echo ""
                echo "Failed to uninstall Intel HAXM"
                echo ""
            fi
            exit 0
        fi
        
        kextstat | grep 'com.intel.kext.intelhaxm' &> /dev/null
        if [ $? -ne 0 ]
        then 
            if [ $silent_mode == "0" ]; then
                echo "Intel HAXM. Kext has already been unloaded, will continue uninstalling"
            fi
        else
            /sbin/kextunload -b 'com.intel.kext.intelhaxm' &> /dev/null
            if [ $? -ne 0 ]
            then
                 if [ $silent_mode == "0" ]; then
                     echo "Failed to uninstall Intel HAXM. Kext could not be unloaded."
                     exit 0
                 fi
            fi
        fi
        rm -rf $launchDaemons/$haxmPlistName &> /dev/null
        rm -rf /private/var/db/receipts/${haxmPkgName}* &> /dev/null
        rm -rf /Library/Preferences/$haxmPreferPlist &> /dev/null
        rm -rf $extensionsPath/$haxmKextName &> /dev/null
        touch $extensionsPath &> /dev/null
        if [ $silent_mode == "0" ]
        then 
            echo ""
            echo "Intel HAXM has been successfully uninstalled"
            echo ""
        fi
        break

    elif [ "$answ" == "n" ]; then
        ext="0"
    else
        echo "Incorrect input. Try on of \"y\" or \"n\""
    fi
done

exit 0
