#CLEDBASQLVM02


#Provides a grid view with all the queries to choose from and will run the selection made by the user on the SQL Server instance specified.
#Then it will export the results to Export-DbaDiagnosticQuery.
#Invoke-DbaDiagnosticQuery -SqlInstance CLEDBASQLVM02 -UseSelectionHelper | Export-DbaDiagnosticQuery -Path D:\DBA\Ray\SQL_GlennBerryGlennRoss\gboutput
#Fails with cert error

#Workaround
#$server = Connect-DbaInstance -SqlInstance CLEDBASQLVM02 -TrustServerCertificate -ClientName "cledba"
#Invoke-DbaDiagnosticQuery $server -UseSelectionHelper | Export-DbaDiagnosticQuery -Path D:\DBA\Ray\SQL_GlennBerryGlennRoss\gboutput
#Works fine

#Invoke-DbaDiagnosticQuery $server


##############  Sample Querry ###############################


	$serverInstanceName = 'CLEDBASQLVM02'
    $server = Connect-DbaInstance -SqlInstance $serverInstanceName -TrustServerCertificate -ClientName "CLEDBASQLVM02"
	$queryOutputPath = 'D:\DBA\Ray\SQL_GlennBerryGlennRoss\AllDiagQuerries'
	$resultsOutputPath = "$($queryOutputPath)\results\$($serverInstanceName)_diag.xlsx"

	 
	#Invoke-DbaDiagnosticQuery -SqlInstance $server -ExportQueries -OutputPath $queryOutputPath
	 
	$scriptList = Get-ChildItem "$($queryOutputPath)\*.sql"
	 
	foreach ($script in $scriptList) {
	              # Clean File Name for Excel output of Worksheet and Table Name
	              # Remove invalid Characters, set Pascal Case
                    
	             $name = $script.BaseName -replace "(?:^|_|-|\s|\s-\s)(\p{L}) ", '' #{ $_.Groups.Value.ToUpper() }
                 
                 #spaces not allowed in table name in excel
                 $tblname = $name -replace " ", ''   
	              
	              # Strip Server Name
	       #       $name = $name -replace $serverInstanceName, ''
	              
	              # Truncate name if over length requirements
	              if ($name.Length -gt 25) {$name = $name.Substring(0,25)}
                   
                  #Clean file name
                  $fn = $queryOutputPath + '\' + $script.name 
	 	    
                 Invoke-DbaQuery -SqlInstance $server -File $fn | Export-Excel -Path $resultsOutputPath -TableName $tblname -WorksheetName $name -AutoSize -AutoFilter -ClearSheet
           
        
}