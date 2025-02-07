# Connect-PnPOnline -Url https://idemitsuno.sharepoint.com/sites/IINLicences -DeviceLogin -ClientId f615da9f-04ae-4a4a-80cd-4e32baeff53c -Tenant "idemitsuno.onmicrosoft.com" -LaunchBrowser
 


# $siteName = Read-Host "Oppgi SharePoint Område navn "
 
# Spesifiser filstien til filen som holder på standardverdien til dokumentbiblioteket
 
 
$fileRelativeURL = "https://idemitsuno.sharepoint.com/sites/IINLicences/License%20Documents/Forms/client_LocationBasedDefaults.html"
 
 
# Henter filinnholdet

$fileContent = Get-PnPFile -Url $fileRelativeURL -AsMemoryStream
 
 
# Konverterer filinnholdet til en teksstreng

$fileContentString = [System.Text.Encoding]::UTF8.GetString($fileContent.ToArray())
 
 
# Lokal filsti med filnavn for hvor filen skal lagres

$localFilePath = "C:\Temp\client_LocationBasedDefaults.html"
 
 
# Lagre filen lokalt

$fileContentString | Set-Content -Path $localFilePath


Add-PnPFile -Path "C:\Temp\client_LocationBasedDefaults.html" -Folder "License%20Documents/Forms"