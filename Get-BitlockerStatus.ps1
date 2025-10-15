# Script that queries the Bitlocker status and outputs keys for currently encrypted drives
# add option to dumps to screen or file
# only dumps on the C: (hardcoded)
# add options for checking additional volumes, or finding whichever volumes are "keyprotected", and then dump those keys
# add switch for if the volume is not keyprotected, check windows version and confirm licensing allows for bitlocker, then give option to enable bitlocker
# add option to disable bitlocker

# Get-BitLockerVolume | Format-List volumetype,mountpoint,keyprotector
(Get-BitLockerVolume -mountpoint C:).keyprotector | format-list keyprotectorid,recoverypassword