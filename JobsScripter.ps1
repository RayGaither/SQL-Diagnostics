#param($sqlserver)

#$sqlserver = 'CLEDBASQLVM02'

$serverInstanceName = 'CLEDBASQLVM02'
$server = Connect-DbaInstance -SqlInstance $serverInstanceName -TrustServerCertificate -ClientName 'CLEDBASQLVM02'


#[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.Smo') | Out-Null

#$srv = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $sqlserver

#$jobs = $srv.JobServer.Jobs | Where-Object {$_.category -notlike "*repl*" -and $_.category -notlike "*shipping*" -and $_.category -notlike "*Maintenance*" } 

$jobs = $server.JobServer.Jobs | Where-Object {$_.category -notlike "*repl*" -and $_.category -notlike "*shipping*" } #-and $_.category -notlike "*Maintenance*" } 

ForEach ( $job in $jobs )
    {
        $jobname = "D:\DBA\PowerShellScript\JobsOut\" + $job.Name.replace(" ","_").replace("\","_").replace("[","_").replace("]","_").replace(".","_").replace(":","_").replace("*","_") + ".sql"
        $job.Script() | Out-File $jobname
    }