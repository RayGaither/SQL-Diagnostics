# This version will use a list to connect to all servers of a certain version
# Create the diag scripts once
# Run scrits on each instance and save to excel
# Workbooks will be named as ServerInstance name
# Spreadsheets will be called script name without server/instance name, with no space
# Diag files will be script name with no spaces or file extentions

# create boolean set to true to create the diag files once.  All servers in list are same version
$createDiagScripts = $true

# Set path and file name for server/instance list
$listPath = 'C:\Users\argaither\HubbellHealthCheck\\'
$listFile = 'SQL2019InstanceList.txt'

# Open server/instance list and loop through them
$instanceList = get-content -path $listPath + $listFile

# Loop through each server instance
ForEach ($Instance in $instanceList) {
	# connect to instance
	try {
			$serverConn = Connect-DbaInstance -SqlInstance $Instance -TrustServerCertificate
			if($createDiagScripts) {
				$createDiagScripts = $False
				# delete folder content before creating new scripts
				$queryOutputPath = 'C:\Users\argaither\Documents\Diag\Instance_Diags' #  <--- is the path correct
				# instance only
				Invoke-DbaDiagnosticQuery -SqlInstance $serverConn -ExportQueries -OutputPath $queryOutputPath -InstanceOnly
			} # end if
			# use instance name for workbook name
			$resultsOutputPath = "$($queryOutputPath)\results\$($Instance)_diag.xlsx"  
				 
			# loop through diagnostic scripts
			$scriptList = Get-ChildItem "$($queryOutputPath)\*.sql"
			foreach ($script in $scriptList) {
				# Clean File Name for Excel output of Worksheet and Table Name
				# Remove invalid Characters, set Pascal Case
				$name = $script.BaseName -replace "(?:^|_|-|\s|\s-\s)(\p{L}) ", '' #{ $_.Groups.Value.ToUpper() }
				$tblname = $name -replace " ", ''
				if ($name.Length -gt 25) {$name = $name.Substring(0,25)}
				
				# write diagnostic results to excel tab
				Invoke-DbaQuery -SqlInstance $serverConn -File $tblname | Export-CSV -Path $resultsOutputPath -NoTypeInformation -UseQuotes AsNeeded
			} # end Diag Script Loop
		}
		catch {
				Write-Output "Not able to connect to: $($Instance) "
		} # End catch
		
	}   # INSTANCE LOOP END                       
					