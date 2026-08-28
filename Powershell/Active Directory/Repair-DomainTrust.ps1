# This program will reconnect an orphaned computer back to the domain.
# Fixes "trust relationship between this workstation and the primary domain failed"

$credential = Get-Credential
Test-ComputerSecureChannel -Repair -Credential $credential

# If repair fails, use this reset: Reset-ComputerMachinePassword -Credential $credential