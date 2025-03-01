#Set Variables
$SiteURL = "https://idemitsuno.sharepoint.com/sites/HSEQ/"
$ListName = "Documents"
 
#Connect to PnP Online
Connect-PnPOnline -Url $SiteURL -Interactive
 
#Get all list items in batches
$ListItems = Get-PnPListItem -List $ListName -PageSize 500
 
#Iterate through each list item
ForEach($ListItem in $ListItems)
{
    #Check if the Item has unique permissions
    $HasUniquePermissions = Get-PnPProperty -ClientObject $ListItem -Property "HasUniqueRoleAssignments"
    If($HasUniquePermissions)
    {        
        $Msg = "Deleting Unique Permissions on {0} '{1}' at {2} " -f $ListItem.FileSystemObjectType,$ListItem.FieldValues["FileLeafRef"],$ListItem.FieldValues["FileRef"]
        Write-host $Msg
        #Delete unique permissions on the list item
        Set-PnPListItemPermission -List $ListName -Identity $ListItem.ID -InheritPermissions
    }
}