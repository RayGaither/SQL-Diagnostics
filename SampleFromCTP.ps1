	$serverInstanceName = 'CFDSQL9'
	$queryOutputPath = 'C:\Users\PLAFROMBOISE\Documents\diag'
	$resultsOutputPath = "$($queryOutputPath)\results\$($serverInstanceName)_diag.xlsx"
	 
	Invoke-DbaDiagnosticQuery -SqlInstance $serverInstanceName -ExportQueries -OutputPath $queryOutputPath
	 
	$scriptList = Get-ChildItem "$($queryOutputPath)\*.sql"
	 
	#foreach ($script in $scriptList) {
	              # Clean File Name for Excel output of Worksheet and Table Name
	              # Remove invalid Characters, set Pascal Case
	              $name = $script.BaseName -replace "(?:^|_|-|\s|\s-\s)(\p{L})", { $_.Groups[1].Value.ToUpper() }
	              
	              # Strip Server Name
	              $name = $name -replace $serverInstanceName, ''
	              
	              # Truncate name if over length requirements
	              if ($name.Length -gt 25) {$name = $name.Substring(0,25)}
	 
	              Invoke-DbaQuery -SqlInstance $serverInstanceName -File $script | Export-Excel -Path $resultsOutputPath -TableName $name -WorksheetName $name -AutoSize -AutoFilter -ClearSheet
	#}
