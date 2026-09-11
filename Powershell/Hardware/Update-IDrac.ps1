

$host = Read-Host -Prompt "What is the IP of the IDrac you wish to update: "
$username = Read-Host -Prompt "What is the username (press enter for root) "

# research concatenation
# ssh $username + "@" + $host
# needs additional steps for 