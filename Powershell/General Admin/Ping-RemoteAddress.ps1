# This is a windows script
# This script will ping a remote address with timestamps, and also echo to a text file, located at %userprofile%\Documents\remote_ping.txt


$REMOTE_ADDRESS = Read-Host("Enter Remote IP: ")
$BASE_FILE = "remote_ping.txt"
$FILE_NAME_COUNTER = 0


ping.exe -t $REMOTE_ADDRESS | ForEach-Object {"$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $_"} | Tee-Object -FilePath "remote_ping.txt"

# make Tee-Object create a new file when file reaches certain size
# append file numering to end of file name when files reach a certain size