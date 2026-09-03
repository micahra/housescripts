
# Bulk Import
Import-Csv -Path "C:\path\to\contacts.csv" | ForEach-Object {
    New-MailContact -Name $_.Name -Alias $_.Alias -ExternalEmailAddress $_.ExternalEmailAddress
}

# Fill out extra details

# $contact = New-MailContact -Name "Alice Smith" -Alias "asmith" -ExternalEmailAddress "alice@example.com"
# Set-Contact -Identity $contact.Identity -Title "Manager" -Company "Acme Corp" -Phone "555-0199"