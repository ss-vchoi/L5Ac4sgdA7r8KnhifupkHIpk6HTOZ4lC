#powershell "IEX(New-Object Net.WebClient).downloadString('https://raw.githubusercontent.com/ss-vchoi/L5Ac4sgdA7r8KnhifupkHIpk6HTOZ4lC/refs/heads/main/a.ps1')"
# Gather KB from all patches installed
function returnHotFixID {
  param(
    [string]$title
  )
  # Match on KB or if patch does not have a KB, return end result
  if (($title | Select-String -AllMatches -Pattern 'KB(\d{4,6})').Matches.Value) {
    return (($title | Select-String -AllMatches -Pattern 'KB(\d{4,6})').Matches.Value)
  }
  elseif (($title | Select-String -NotMatch -Pattern 'KB(\d{4,6})').Matches.Value) {
    return (($title | Select-String -NotMatch -Pattern 'KB(\d{4,6})').Matches.Value)
  }
}

$session = (New-Object -ComObject 'Microsoft.Update.Session')
$UpdateSearcher = $session.CreateupdateSearcher()
$Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0").Updates)
$history | Select-Object ResultCode, Date, Title

#create an array for unique HotFixes
$HotfixUnique = @()
#$HotfixUnique += ($history[0].title | Select-String -AllMatches -Pattern 'KB(\d{4,6})').Matches.Value

$HotFixReturnNum = @()
#$HotFixReturnNum += 0 

for ($i = 0; $i -lt $history.Count; $i++) {
  $check = returnHotFixID -title $history[$i].Title
  if ($HotfixUnique -like $check) {
    #Do Nothing
  }
  else {
    $HotfixUnique += $check
    $HotFixReturnNum += $i
  }
}
$FinalHotfixList = @()

$hotfixreturnNum | ForEach-Object {
  $HotFixItem = $history[$_]
  $Result = $HotFixItem.ResultCode
  # https://learn.microsoft.com/en-us/windows/win32/api/wuapi/ne-wuapi-operationresultcode?redirectedfrom=MSDN
  switch ($Result) {
    1 {
      $Result = "Missing/Superseded"
    }
    2 {
      $Result = "Succeeded"
    }
    3 {
      $Result = "Succeeded With Errors"
    }
    4 {
      $Result = "Failed"
    }
    5 {
      $Result = "Canceled"
    }
  }
  $FinalHotfixList += [PSCustomObject]@{
    Result = $Result
    Date   = $HotFixItem.Date
    Title  = $HotFixItem.Title
  }    
}
$FinalHotfixList | Format-Table -AutoSize


Write-Host ""
if ($TimeStamp) { TimeElapsed }
Write-Host ""
if ($TimeStamp) { TimeElapsed }
