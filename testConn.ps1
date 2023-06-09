$listPath = 'C:\Users\argaither\HubbellHealthCheck'
$listFile = 'SQL2014InstanceList.txt'

# Open server/instance list and loop through them
$instanceList = get-content -path "$($listPath)\$($listFile)"

# Loop through each server instance
ForEach ($Instance in $instanceList) {
   # connect to instance
   write-output "instance: $Instance"
   try {
      write-output "try: $Instance"
      $serverConn = Connect-DbaInstance -SqlInstance $Instance -TrustServerCertificate
      if ($serverConn -ne $null) {
        $cn = Get-DbaConnectedInstance
        Write-Output "Instance connected: $cn"
        $serverConn | Disconnect-DbaInstance
        Write-Output "Get-DbaConnectedInstance"            
        }
   }
   catch {
      Write-Output "Blew up: $error"  
   }

}
# Get-DbaConnectedInstance | Disconnect-DbaInstance
# Get-DbaConnectedInstance
# Connect-DbaInstance -SqlInstance EXP92SQLT -TrustServerCertificate
# $error = ""
<<<<<<< HEAD
# Connect-DbaInstance -SqlInstance "SOMDEVSQL01\CMX_COMMERCIAL,55539" -TrustServerCertificate

=======

# Connect-DbaInstance -SqlInstance 'JUAMXSQL02,1433' -TrustServerCertificate

# Get-DbaConnectedInstance | Disconnect-DbaInstance
>>>>>>> 669e146cba2a98fe8b90e7e07c9ce46106d5b63d
