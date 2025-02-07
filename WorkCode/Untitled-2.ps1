Connect-PnPOnline -Url "https://idemitsuno.sharepoint.com/sites/IINintranet" -Interactive
Connect-SPOService -Url "https://idemitsuno.sharepoint.com/sites/IINintranet" -credential gasg@idemitsuno.onmicrosoft.com
# Connect-PnPOnline -Url "https://idemitsuno.sharepoint.com/sites/IINintranet" -UseWebLogin
Set-PnPSearchSettings -Scope Site -SearchBoxPlaceholderText "Search in SharePoint"
Get-PnPMicrosoft365Group -IncludeSiteUrl | Where-Object { $_.Visibility -eq "Private"}