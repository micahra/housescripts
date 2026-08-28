#Program that will prompt for a process name and then kill
#Give options for conflicts if multiple are identified
#Give option to kill all associated processes or parents

$process_to_delete = Read-Host -prompt "Enter process to stop: "

$processes_to_delete = Get-Process "*$process_to_delete*"

Write-Host "$processes_to_delete"