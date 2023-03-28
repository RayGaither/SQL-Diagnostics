Enable-PSRemoting

New-PSSession

Get-ADDomain


$IsVirtual=((Get-WmiObject win32_computersystem).model -eq 'VMware Virtual Platform' -or ((Get-WmiObject win32_computersystem).model -eq 'Virtual Machine'))
 
Invoke-Command -Session $session -ScriptBlock { $Anser = Get-DbaFeature $serverIp | Select-Object ComputerName }

Invoke-Command -ComputerName EXPSQL25 -ScriptBlock { Get-DbaFeature -ComputerName CLESQL04 | Select-Object ComputerName }

Invoke-Command -ComputerName CLE-QA-NCC01 -ScriptBlock { $IsVirtual=((Get-WmiObject win32_computersystem).model -eq 'VMware Virtual Platform' -or ((Get-WmiObject win32_computersystem).model -eq 'Virtual Machine')) }
$IsVirtual

Find-Module -Name ImportExcel | Install-Module

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Find-Module PSWindowsUpdate



[PSObject[]]$results = Invoke-DbaDiagnosticQuery -SqlInstance localhost -WhatIf
Invoke-DbaDiagnosticQuery -SqlInstance localhost -UseSelectionHelper


Find-Module ?