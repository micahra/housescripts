# This is a windows script
# This script will ping a remote address with timestamps, and also echo to a text file, located at %userprofile%\Documents\remote_ping.txt

# Additional changes possible:
#   Accept commandline parameters
#   Format for Additional operating systems

$REMOTE_ADDRESS = Read-Host("Enter Remote IP: ")
$BASE_FILE = "remote_ping.txt"
$CURRENT_FILE = $BASE_FILE
$FILE_NAME_COUNTER = 0 
$MAX_FILE_SIZE_BYTES = 500KB


while ($true) {
    ping.exe -t $REMOTE_ADDRESS | ForEach-Object {
        
        if (Test-Path $CURRENT_FILE) {
            $file_size = (Get-Item $CURRENT_FILE).Length
            if ($file_size -ge $MAX_FILE_SIZE_BYTES) {
                $FILE_NAME_COUNTER++
                $CURRENT_FILE = "remote_ping$FILE_NAME_COUNTER.txt"
                Write-Host "`n[Log Rotated] Size limit reached. New log file created: $CURRENT_FILE"
            }
        }
    
    "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $_" | Tee-Object -FilePath $CURRENT_FILE -Append
    }
}
