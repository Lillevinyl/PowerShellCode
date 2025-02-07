$userinput = Read-Host
# Connect to the SharePoint site
$siteUrl = "https://m365x29701895.sharepoint.com/sites/InpexDemo/"
Connect-PnPOnline -Url $siteUrl -Interactive
$listItems = Get-PnPListItem -List "Shared Documents" | Where-Object { $_.FileSystemObjectType -eq"Folder"}
 
# Loop through each folder
foreach ($folder in $listItems) {
 
  if (($folder["FileRef"]) -like "*$userinput*") {
    Write-Host "Folder Path: $($folder["FileRef"])"
      Write-Output $folder
        Set-PnPTaxonomyFieldValue -ListItem $folder -InternalFieldName 'Department' -TermId 8f01cb4e-4cfc-43d2-8cb3-f0fc43c964e3
 
       # Write-Output $folder
    }
}