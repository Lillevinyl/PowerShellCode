Connect-PnPOnline -Url "https://idemitsuno.sharepoint.com/sites/IT" -Interactive
Add-PnPView -List "Documents" -Title "IT Documents" -Fields "Type","Name","Document Type","Status","IT Document Type","Owner","Digitalization","IT Governance","IT Operations","IT Steering Committee","IT Strategy","Budgets and Costs"
#Remove-PnPTenantDeletedSite -identity "https://idemitsuno.sharepoint.com/sites/IT"i