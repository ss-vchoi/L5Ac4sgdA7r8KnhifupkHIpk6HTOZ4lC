#powershell "IEX(New-Object Net.WebClient).downloadString('https://raw.githubusercontent.com/ss-vchoi/L5Ac4sgdA7r8KnhifupkHIpk6HTOZ4lC/refs/heads/main/a.ps1')"
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
$Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0").Updates)
$Updates |  Select-Object Title, LastDeploymentChangeTime, IsDownloaded
