$serverInstanceName = 'bambam'
$server = Connect-DbaInstance -SqlInstance $serverInstanceName -TrustServerCertificate -ClientName "CLEDBASQLVM02" -SqlCredential "joey"


$queryOutputPath = "C:\temp\GBSQL"
Invoke-DbaDiagnosticQuery -SqlInstance $server -ExportQueries -OutputPath $queryOutputPath -InstanceOnly 




$collection = Get-Content "C:\temp\QueriesList.txt"ForEach ($item in $collection) {write-host $item}


CPU Usage by Database.sql
CPU Utilization History.sql
Global Trace Flags.sql
Last Backup By Database.sql
Memory Clerk Usage.sql
Process Memory.sql
SQL Server Agent Alerts.sql
SQL Server Agent Jobs.sql
System Memory.sql
Top Avg Elapsed Time Queries.sql
Top Logical Reads Queries.sql
Top Waits.sql
Top Worker Time Queries.sql
Total Buffer Usage by Database.sql
