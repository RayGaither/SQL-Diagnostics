$listPath = 'C:\Users\argaither\HubbellHealthCheck'
$listFile = 'SQL2017InstanceList.txt'

# Open server/instance list and loop through them
$instanceList = get-content -path "$($listPath)\$($listFile)"

# Loop through each server instance
ForEach ($Instance in $instanceList) {
   # connect to instance
   write-output "instance: $Instance"
   try {
      write-output "try: $Instance"
      $serverConn = Connect-DbaInstance -SqlInstance $Instance -TrustServerCertificate
      Write-Output "Get-DbaConnectedInstance"
      $serverConn | Disconnect-DbaInstance
      Write-Output "Get-DbaConnectedInstance"            
   }
   catch {
      Write-Output "Blew up: $error"  
   }

}
# Get-DbaConnectedInstance | Disconnect-DbaInstance
# Get-DbaConnectedInstance
# Connect-DbaInstance -SqlInstance EXP92SQLT -TrustServerCertificate
# $error = ""