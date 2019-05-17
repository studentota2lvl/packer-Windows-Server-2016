Import-Module WebAdministration

$siteName = 'DemoSite'
$appName ='DemoApp'
$port = 80
$path = 'C:\App'
$appPool = 'DemoSite'

$pools= dir IIS:\AppPools 

cd IIS:\ 

Write-Host "Here we go"

Remove-WebSite -Name "Default web site"

Write-Host "Remove default website"

New-WebAppPool $appPool

Write-Host "App pool created"

New-WebSite -Name $siteName -Port $port  -PhysicalPath $path -ApplicationPool $appPool

Write-Host "website created"

New-WebApplication -Name $appName -Site $siteName -PhysicalPath $path -ApplicationPool $appPool

Write-Host "Web app created"

Set-ItemProperty IIS:\AppPools\$appPool -name processModel -value @{userName="vagrant";password="vagrant";identitytype=3} 