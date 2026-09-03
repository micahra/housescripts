# Requires Connect-ExchangeOnline


Import-CSV "C:\path\to\members.csv" | foreach {
    Add-DistributionGroupMember -Identity "group@contoso.com" -Member $_.UPN
}