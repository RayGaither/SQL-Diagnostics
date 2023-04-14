$listPath = 'C:\Users\argaither\HubbellHealthCheck'
$listFile = 'SQL2019InstanceList.txt'

# Open server/instance list and loop through them
$instanceList = get-content -path "$($listPath)\$($listFile)"

# Loop through each server instance
ForEach ($Instance in $instanceList) {
	# connect to instance
	 try {
			$serverConn = Connect-DbaInstance -SqlInstance $Instance -TrustServerCertificate
            Write-Output "Get-DbaConnectedInstance"
            $serverConn | Disconnect-DbaInstance
            Write-Output "Get-DbaConnectedInstance"
            
     }
     catch{
        Write-Output "Get-DbaConnectedInstance"  
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