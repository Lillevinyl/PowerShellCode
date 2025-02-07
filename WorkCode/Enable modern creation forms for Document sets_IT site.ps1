# SharePoint online site url
$siteUrl = Read-Host -Prompt "Enter your site url (e.g https://<tenant>.sharepoint.com/sites/contoso)";

# https://idemitsuno.sharepoint.com/sites/IT

# Connect to SharePoint Online site
Connect-PnPOnline -Url $siteUrl -ClientId 9faa123a-d7aa-43d2-a4b5-841cf7879957 -Interactive

# Get the doclibs on the site
$lists = Get-PnPList | Where-Object {$_.BaseTemplate -eq 101}

# List the document libraries
foreach($list in $lists){
    Write-Host "[$($lists.IndexOf($list)+1)] $($list.Title)"
}

$index = Read-Host -Prompt "Which list to you wish to modernize your content type"

# Get the "Folder" content types on the document library
$cts = Get-PnPContentType -List $($lists[$index-1]) | Where-Object {$_.Id.StringValue.StartsWith("0x0120")}

foreach($ct in $cts){
    Write-Host "[$($cts.IndexOf($ct)+1)] $($ct.name)"
}

$CTindex = Read-Host -Prompt "Which content type to you wish to modernize"

# Null out the NewFormClientSideComponentId as that seems to bring it to modern UI
$cts[$CTindex-1].NewFormClientSideComponentId = $null;
$cts[$CTindex-1].Update($false);

Invoke-PnPQuery

Write-Host -ForegroundColor Green "All done"