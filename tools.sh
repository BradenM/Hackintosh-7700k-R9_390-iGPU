#!/usr/bin/env zsh

# Rebuild Kernal Cache
alias kernal_rebuild="sudo touch /System/Library/Extensions && sudo kextcache -i /"

# Open System Kexts folder
alias kexts="open /System/Library/Extensions"

# Open L/E Kexts Folder
alias lekexts="open /Library/Extensions"

# Repair Permissions
repair_kexts () {
	echo "Repairing Kexts..."
	sudo chown -R root:wheel /Library/Extensions/*.kext
	sudo chmod -R 755 /Library/Extensions/*.kext
	echo "Finished. Rebuilding Cache..."
	sleep 4
	kernal_rebuild
	echo "Kext Repair Complete"
}