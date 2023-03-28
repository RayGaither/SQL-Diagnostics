#Provide server name and all active instances will scan
$serverName = "EXPSQL22"
$queryOutputPath = 'C:\Users\argaither\Documents\Diags' #  <--- is the path correct

# get list of instances on server
$instanceList = Get-DbaService -Computername $serverName | ?{$_.displayname -like "SQL Server (*"} | select InstanceName
# Loop through each server instanceForEach ($instance in $instanceList)         {        if ($instance.InstanceName -ne "MSSQLSERVER"){                $serverInstanceName = "$($serverName)\$($instance)"                $serverInstanceName = $serverInstanceName -replace ("@{InstanceName=|}")
        }else{
                $serverInstanceName = $serverName            
        }
            
#$serverInstanceName
#}

        try 
            {
   
            #test if instance can be connected, if not go to next instance
            $server = Connect-DbaInstance -SqlInstance $serverInstanceName -TrustServerCertificate -ClientName $serverInstanceName  #"SQL5\FIRECHECK\DBATools"
            
           # $queryOutputPath = 'C:\Users\rgaither\Documents\GB\DiagQuerriesPostSAN' #  <--- is the path correct
	        
# csv version            $resultsOutputPath = "$($queryOutputPath)\results\$($serverInstanceName)_diag.xlsx"
    	 
            # create all the diag querries for this instance
               # instance only
#            Invoke-DbaDiagnosticQuery -SqlInstance $serverInstanceName -ExportQueries -OutputPath $queryOutputPath -InstanceOnly
               # all user databases only
#            Invoke-DbaDiagnosticQuery -SqlInstance $serverInstanceName -ExportQueries -OutputPath $queryOutputPath -DatabaseSpecific

	 
	        $scriptList = Get-ChildItem "$($queryOutputPath)\*.sql"
	        # loop through each diag query for instance
	        foreach ($script in $scriptList) 
                {
	              # Name file for CSV
$resultsOutputPath = "$($queryOutputPath)\results\$($serverName)-$($instance.InstanceName)-$($script.Name)_diag.csv"                  
                    
	             $name = $script.BaseName -replace "(?:^|_|-|\s|\s-\s)(\p{L}) ", '' #{ $_.Groups.Value.ToUpper() }
                 

                 # Strip Server Name
	             $name = $name -replace $serverName, ''
                 $name = $name -replace $instance, ''   
                 #spaces not allowed in table name in excel
                 $tblname = $name -replace " ", ''   

	              
	              # Truncate name if over length requirements
	              if ($name.Length -gt 25) {$name = $name.Substring(0,25)}
                   
                  #Clean file name
                  $fn = $queryOutputPath + '\' + $script.name 
	 	    
                 # Invoke-DbaQuery -SqlInstance $server -File $fn | Export-Excel -Path $resultsOutputPath -TableName $tblname -WorksheetName $name -AutoSize -AutoFilter -ClearSheet
                 Invoke-DbaQuery -SqlInstance $server -File $fn | Export-CSV -Path $resultsOutputPath -NoTypeInformation
                } #end query loop, clean folder out
#                Get-ChildItem -Path "$($queryOutputPath)" *.sql -File -Recurse | foreach { $_.Delete()}
            }
        catch
            {
            #Do nothing
            Write-Host $serverInstanceName " Is not online"
            } # end instance loop
}  