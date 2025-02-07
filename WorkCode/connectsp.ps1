Import-Module pnp.powershell
Install-Module Pnp.powershell -Force -AllowClobber
Update-Module pnp.powershell
Connect-PnPOnline -Url https://idemitsuno.sharepoint.com/sites/IINLicences -ClientId 9faa123a-d7aa-43d2-a4b5-841cf7879957 -Interactive


Register-PnPEntraIDAppForInteractiveLogin -ApplicationName "IINPNPInteractive" -Tenant idemitsuno.onmicrosoft.com -Interactive

