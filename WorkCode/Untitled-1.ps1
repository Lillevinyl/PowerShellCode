Connect-PnPOnline -Url "https://idemitsuno-admin.sharepoint.com/" -Interactive
 
# Path to the CSV file
$csvFilePath = "C:\Users\SveinG\Downloads\csvtestIIN.csv"
$ConfirmPreference
# Get the term group
 
$siteURL = "https://idemitsuno.sharepoint.com/sites/HRandAdm/"
$adminURL = "https://idemitsuno-admin.sharepoint.com/"
 
 
try {
   Get-PnPTermGroup -Identity "HR and Adm"
    #Check if the TermGroup exists      
   
   
}
catch {
# If the term group does not exist, create a new term group
    New-PnPTermGroup -GroupName "HR and Adm"
}
 
Start-sleep 5
try {
    Get-PnPTermSet -Identity "HR and Adm Documentation" -TermGroup "HR and Adm"
 
}
catch {
# If the termSet does not exist, create a new termSet
$getTermSetValue = New-PnPTermSet -Name "HR and Adm Documentation" -TermGroup "HR and Adm"
$getTermSetValue
}
 
Start-Sleep 2
Connect-PnPOnline -Interactive -Url "https://idemitsuno.sharepoint.com/sites/contentTypeHub"
 
 
$contentType = Get-PnPContentType -Identity "Administration Documents"
# Check if the content type is empty
if (-not $contentType) {
 #   # If the content type does not exist, create a new content type
 $testing = Add-PnPContentType -Name "Administration Documents" -Description "Content Type for HR And Admin" -Group "IIN Columns" -ParentContentType (Get-PnPContentType -Identity "IIN Documents")
 $testing
  Start-Sleep 2
 
  Add-PnPTaxonomyField -DisplayName "HR and Adm Documentation" -InternalName "HR_x0020_and_x0020_Adm_x0020_Documentation3" -Group "IIN Columns" -Id "c0480bd7c281490c84b1432a73563d53" -TaxonomyItemId $getTermSetValue.id
 
  Add-PnPFieldToContentType -Field "c0480bd7c281490c84b1432a73563d53" -ContentType $testing.id
  Publish-PnPContentType $testing.id
  Start-Sleep 5
  Add-PnPContentTypesFromContentTypeHub -ContentTypes $testing.id -Site https://idemitsuno.sharepoint.com/sites/HRandAdm/
 
} else {
   
 #   Write-Output "The content type 'IIN HR' already exists."
}
Start-Sleep 2
Connect-PnPOnline -URL $siteURL -Interactive
Add-PnPContentTypeToList -List "Documents" -ContentType "Administration Documents"
Start-Sleep 5
 
# Read the CSV file
$csvData = Import-Csv -Path $csvFilePath -Delimiter ";"
 
# Get column headers
$columnHeaders = $csvData | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
 
# Function to process columns
function Process-Columns {
    param (
        [Parameter(Mandatory=$true)]
        [array]$data,         # The CSV data array
        [Parameter(Mandatory=$true)]
        [array]$headers       # The array of header names
    )
 
    # Initialize the row index to start with the first row
    $rowIndex = 0
 
    # Loop until all rows are processed
    while ($rowIndex -lt $data.Count) {
        $processed = $false   # Flag to track if a non-empty cell was found
 
        # Loop through each header for the current row
        foreach ($header in $headers) {
            # Check if we are still within the bounds of the data array
            if ($rowIndex -ge $data.Count) {
                break
            }
 
            # Get the value of the current cell
            $cellValue = $data[$rowIndex].$header
 
            # If the cell value is not empty
            if (-not [string]::IsNullOrWhiteSpace($cellValue)) {
                # Output the cell value
                if ($header -eq $headers[0])
                 {
                    Connect-PnPOnline -Url $adminURL -Interactive
 
                   $parentTerm =  New-PnPTerm -TermSet "HR and Adm Documentation" -TermGroup "HR and Adm" -Name "$cellValue"
                    $parentTermID = $parentTerm.id
                 Start-Sleep 2
 
                    $gettingValue = Get-PnPTerm -Identity $cellValue -TermSet "HR and Adm Documentation" -TermGroup "HR and Adm"
                    $gettinvalueID = $gettingValue.id
                   
                    Connect-PnPOnline -Url $siteURL -Interactive
 
                   $folderTier1 = "/Shared%20Documents/$cellValue"
                    $folderValue = Resolve-PnPFolder -SiteRelativePath $folderTier1
                    $folderValue
                  #  Write-Output $folderValue
                    Start-Sleep 2
                    Write-Output $gettinvalueID
                 Set-PnPDefaultColumnValues -List Documents -Field "HR_x0020_and_x0020_Adm_x0020_Documentation3" -Value $gettinvalueID -Folder $cellValue
 
                }
 
                elseif ($header -eq $headers[1]) {
                    Start-Sleep 1
                    Connect-PnPOnline -Url $adminURL -Interactive
 
                    Add-PnPTermToTerm -ParentTermId $parentTermID  -Name "$cellValue"
 
                    Start-Sleep 2
                    $gettingValue3 = Get-PnPTerm -Identity $cellValue -TermSet "HR and Adm Documentation" -TermGroup "HR and Adm" -Recursive
                    $gettinvalueID4 = $gettingValue3.id
                    write-output $gettinvalueID4
                   
                   $subfolderpath = "$folderTier1/$cellValue"
                   Connect-PnPOnline -Url $siteURL -Interactive
 
                 $folderValue2 =  Resolve-PnPFolder -SiteRelativePath $subfolderpath
                    $folderValue2
 
                    Start-Sleep 2
                    $testing2 = $folderValue.Name
                    $testing3 = $testing2 +"/" + $cellValue
                    Write-Output $testing3
                  #  Write-Output $gettinvalueID4
                  ##  Write-Output "$folderValue/"$cellValue
                  Set-PnPDefaultColumnValues -List Documents -Field "HR_x0020_and_x0020_Adm_x0020_Documentation3" -Value $gettinvalueID4 -Folder $testing3
 
                }
                elseif ($header -eq $headers[2]) {
                   
                   $subsubfolder = "/$subfolderpath/$cellValue"
                    Resolve-PnpFolder -SiteRelativePath $subsubfolder
                }
                elseif ($header -eq $headers[3]) {
                  #  Write-Output $subsubfolder
                    $subsubsubfolder = "$subsubfolder/$cellValue"
                    Resolve-pnpFolder -SiteRelativePath $subsubsubfolder
                    #Write-Output $subsubsubfolder
                }
               # Write-Output $cellValue
                # Set the processed flag to true
                $processed = $true
                # Move to the next row
                $rowIndex++
                # Break out of the inner loop to start checking from the first header again
 
                break
            }
        }
 
        # If no non-empty cell was found in the current row, move to the next row
        if (-not $processed) {
            $rowIndex++
        }
    }
}
 
# Call the function to process the columns
Process-Columns -data $csvData -headers $columnHeaders