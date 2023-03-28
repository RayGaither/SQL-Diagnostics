
#Provide server name and all active instances will scan
$serverName = "SQL5"

# get list of instances on server
$instanceList = Get-DbaService -Computername $serverName | ?{$_.displayname -like "SQL Server (*"} | select InstanceName
# Loop through each server instanceForEach ($instance in $instanceList)         {        $serverInstanceName = "$($serverName)\$($instance)"        $serverInstanceName = $serverInstanceName -replace ("@{InstanceName=|}")
#$serverInstanceName
#}

        try 
            {
            #test of instance can be connected, if not go to next instance
            $server = Connect-DbaInstance -SqlInstance $serverInstanceName -TrustServerCertificate -ClientName $serverInstanceName  #"SQL5\FIRECHECK\DBATools"
            $queryOutputPath = 'C:\Users\rgaither\Documents\GB\DiagQuerriesPostSAN'
	        $resultsOutputPath = "$($queryOutputPath)\results\$($serverInstanceName)_diag.xlsx"
    	 
            # create all the diag querries for this instance
            Invoke-DbaDiagnosticQuery -SqlInstance $serverInstanceName -ExportQueries -OutputPath $queryOutputPath -InstanceOnly
	 
	        $scriptList = Get-ChildItem "$($queryOutputPath)\*.sql"
	        # loop through each diag query for instance
	        foreach ($script in $scriptList) 
                {
	              # Clean File Name for Excel output of Worksheet and Table Name
	              # Remove invalid Characters, set Pascal Case
                    
	             $name = $script.BaseName -replace "(?:^|_|-|\s|\s-\s)(\p{L}) ", '' #{ $_.Groups.Value.ToUpper() }
                 
                 # Strip Server Name
	             #$name = $name -replace $serverInstanceName, ''

                 #spaces not allowed in table name in excel
                 $tblname = $name -replace " ", ''   

	              
	              # Truncate name if over length requirements
	              if ($name.Length -gt 25) {$name = $name.Substring(0,25)}
                   
                  #Clean file name
                  $fn = $queryOutputPath + '\' + $script.name 
	 	    
                 Invoke-DbaQuery -SqlInstance $server -File $fn | Export-Excel -Path $resultsOutputPath -TableName $tblname -WorksheetName $name -AutoSize -AutoFilter -ClearSheet
                } #end query loop, clean folder out
                Get-ChildItem -Path "$($queryOutputPath)" *.sql -File -Recurse | foreach { $_.Delete()}
            }
        catch
            {
            #Do nothing
            Write-Host $serverInstanceName " Is not online"
            } # end instance loop
}  