Connect-ExchangeOnline -UserPrincipalName gasg@idemitsuno.onmicrosoft.com
Set-Mailbox -Identity "shota.oguchi@inpex-idemitsu.no" -Type Shared
Get-Mailbox -Identity "shota.oguchi@idemitsuno.onmicrosoft.com" | Format-List RecipientTypeDetails
