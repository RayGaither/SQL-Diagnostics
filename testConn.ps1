$listPath = 'C:\Users\argaither\HubbellHealthCheck'
$listFile = 'SQL2016InstanceList.txt'

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
     catch{
        Write-Output "conn catch"  
     }
    }    
    	
    # Get-DbaConnectedInstance | Select *
    # Connect-DbaInstance
    # Disconnect-DbaInstance | UseasTeamMateVM
    # Get-DbaConnectedInstance
    # Get-DbaConnection
    # Test-DbaConnection -sqlinstance UseasTeamMateVM
    # winrm help config

    # Get-DbaConnectedInstance | Disconnect-DbaInstance