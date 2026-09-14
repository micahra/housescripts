# This script will ping a remote address with timestamps, and also echo to a text file, located at C:\remote_ping.txt

$remote_address = Read-Host("Enter Remote IP: ")


ping.exe -t $remote_address | ForEach-Object {"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $_"} | Tee-Object -FilePath "C:\remote_ping.txt"