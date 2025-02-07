#########################################################################
#                                                                       #
# Created by: Infotechtion                                              #
# Note: This script requires PowerShell and PnP PowerShell to work      #
#                                                                       #
#########################################################################

# Variables
# Promt for Site URL
#$siteUrl = Read-Host -Prompt "Enter site URL, e.g. https://tenant.sharepoint.com/sites/yourSite"
# csvFilePath = "C:\Path\To\Your\File.csv"
$csvFilePath = Read-Host -Prompt "Enter path to your CSV file, e.g. C:\Path\To\Your\File.csv"
# Prompt for List name
$listName = Read-Host -Prompt "Enter list name, e.g. Documents"
# Prompt for TermGroup
$termGroupName = Read-Host -Prompt "Enter Term Group name"
# Prompt for Licenses Term Set
$LicenseTermSetName = Read-Host -Prompt "Enter License Term Set Name Set name"
# Prompt for Information type Term Set
$InfotypeTermSetName = Read-Host -Prompt "Enter InfotypeTermSetName Set name"
# Prompt for internal columnnames
$LicensecolumnName = Read-Host -Prompt "Enter the internal name for the Licenses managed metadata column"
$InfotypecolumnName = Read-Host -Prompt "Enter the internal name for the Information types managed metadata column"
# Connect to the SharePoint site
# SGU Connected manually, see notepad document
#Connect-PnPOnline -Url $siteUrl -PnPManagementShell
#Connect-PnPOnline -Url $siteUrl -Interactive
Connect-PnPOnline -Url https://idemitsuno.sharepoint.com/sites/IINLicences -ClientId 9faa123a-d7aa-43d2-a4b5-841cf7879957 -Interactive
# Connect-SPOService -Url $siteUrl
# Connect-PnPOnline -Interactive -Url $siteUrl

# Get list GUID
$list = Get-PnpList -Identity $listName 
$listID = $list.ID

# Import CSV file
$folders = Import-Csv -Path $csvFilePath
Write-Host "Folders:" $folders
$counter = 0

# Loop through each row in the CSV and create folders
foreach ($folder in $folders) {
    $counter++
    $folderPath = ""
    $currentTerm = ""
    $columnValue = $folder.'K1 ;K2;K3;K4;K5'
    $ArrFolder=$columnValue.Split(";")
    Write-Host "ColumnValue:" $columnValue
    Write-Host "Folder" $folder
    $loopcounter=0;
    # Check each column for every row
    foreach ($Folder in $ArrFolder) {
        # If the column value is ".", stop adding to the folder path
        Write-Host "ArrFolder:" $ArrFolder
        if ($folder -eq ".") {
            break
        }
        else{
            # If the column value is not ".", add it to the folder path
            $folderPath += "$folder/"
            Write-Host $folderPath
            $currentTerm = $folder
            Write-Host $folder
            $loopcounter++;
        }
    }

# Remove trailing "/"
$folderPath = $folderPath.TrimEnd('/')

# Create folder if it does not exist
Resolve-PnPFolder -SiteRelativePath "$listName/$($folderPath)"

Start-Sleep 5

# Add default term to created folder
if($loopcounter -eq 2) {
    $termvalue=Get-PnPTerm -Identity $currentTerm -TermSet $LicenseTermSetName -TermGroup $termGroupName -Recursive
    Write-Host $currentTerm
    Write-Host $LicenseTermSetName
    Write-Host $termGroupName
    # Set License value
    Set-PnPDefaultColumnValues -List $listID -Field $LicensecolumnName -Value $termvalue.ID -Folder $folderPath
}
else {
    $termvalue=Get-PnPTerm -Identity $currentTerm -TermSet $InfotypeTermSetName -TermGroup $termGroupName -Recursive
    Write-Host $currentTerm
    Write-Host $InfotypeTermSetName
    Write-Host $termGroupName
    # Set Information type value
    Set-PnPDefaultColumnValues -List $listID -Field $InfotypecolumnName -Value $termvalue.ID -Folder $folderPath    
}
Write-Host "---------------------------------------------------------------------------------------------------"
[decimal] $percentageComplete = (($Counter / $folders.Count) * 100)
Write-Host "Counter: $Counter folders out of "$folders.Count" "
Write-Progress -Activity "Setting up folders and default value" -PercentComplete ($percentageComplete) 
}

Write-Host "Finished setting up folders and managed metadata!" -ForegroundColor green
# Disconnect from the SharePoint site
Disconnect-PnPOnline