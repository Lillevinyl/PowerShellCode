# Specify output file path
$outputFilePath = "C:\Temp\TeamsOwnersReport.csv"

# Get all Teams
Write-Host "Fetching all Teams..." -ForegroundColor Green
$allTeams = Get-Team

# Prepare an array to store the data
$exportData = @()

# Iterate through each Team
foreach ($team in $allTeams) {
    Write-Host "Processing Team: $($team.DisplayName)" -ForegroundColor Yellow
    
    # Get Team Owners
    $owners = Get-TeamUser -GroupId $team.GroupId -Role Owner
    
    foreach ($owner in $owners) {
        $exportData += [PSCustomObject]@{
            TeamName     = $team.DisplayName
            OwnerName    = $owner.User
            OwnerEmail   = $owner.UserPrincipalName
        }
    }
}

# Export the data to CSV
if ($exportData.Count -gt 0) {
    $exportData | Export-Csv -Path $outputFilePath -NoTypeInformation -Encoding UTF8
    Write-Host "Export complete! File saved to $outputFilePath" -ForegroundColor Green
} else {
    Write-Host "No data to export. Ensure you have the necessary permissions and Teams in your organization." -ForegroundColor Red
}