# Asks if File System Auditing is enabled before Adding Audit Rules:

file_system_answer = Read-Host "Is File System Auditing enabled? Y or N: "
# sanitize this input

# if no:
AuditPol.exe /set /category:"Object Access" /subcategory:"File System" /success:enable /failure:enable

# if yes, skip

# File Path Sanitizer:
param([string]$UserInputPath)

# Resolve the absolute path
$FullyResolvedPath = Resolve-Path -LiteralPath $UserInputPath -ErrorAction Stop

# Verify the target path stays inside the intended directory
$AllowedFolder = "C:\SafeFolder"
if (-not $FullyResolvedPath.Path.StartsWith($AllowedFolder, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Access Denied: Path traversal detected."
}


# Folder selector
$Path = "C:\SensitiveData"
$Identity = "Everyone" # Or a specific user/group like "Domain\Username"
$Rights = "FullControl" # Choose specific rights like ReadData, WriteData, Delete
$Inheritance = "ContainerInherit, ObjectInherit"
$Propagation = "None"
$AuditType = "Success, Failure"

# Get current ACL
$Acl = Get-Acl $Path

# Create the new audit rule
$AuditRule = New-Object System.Security.AccessControl.FileSystemAuditRule($Identity, $Rights, $Inheritance, $Propagation, $AuditType)

# Add the audit rule to the ACL
$Acl.AddAuditRule($AuditRule)

# Apply the updated ACL to the path
Set-Acl -Path $Path -Audit $Acl