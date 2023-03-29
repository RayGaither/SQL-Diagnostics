#Source
$sourceServer = "EXPSQL22"
$database = "master"

# Provide SQL Server connection to Source database server
$SourceDBconnString = "Server=$sourceServer;Database=$database;Integrated Security=True"

#Provide server name and all active sourceInstances will scan
#$sourceServer = "EXPSQL22"
$queryOutputPath = 'C:\Users\argaither\Documents\Diags' #  <--- is the path correct

# get list of sourceInstances on server
$sourceInstanceList = Get-DbaService -Computername $sourceServer | ?{$_.displayname -like "SQL Server (*"} | select InstanceName
# Loop through each server sourceInstanceForEach ($sourceInstance in $instanceList)         {        if ($sourceInstance.InstanceName -ne "MSSQLSERVER"){                $serversourceInstanceName = "$($sourceServer)\$($sourceInstance)"                $serversourceInstanceName = $serversourceInstanceName -replace ("@{InstanceName=|}")
        }else{
                $serversourceInstanceName = $sourceServer            
        }
            
#$serversourceInstanceName
#}

        try 
            {
   
            #test if sourceInstance can be connected, if not go to next sourceInstance
            $server = Connect-DbaInstance -SqlInstance $serversourceInstanceName -TrustServerCertificate -ClientName $serversourceInstanceName  #"SQL5\FIRECHECK\DBATools"
            
           # $queryOutputPath = 'C:\Users\rgaither\Documents\GB\DiagQuerriesPostSAN' #  <--- is the path correct
	        
# csv version            $resultsOutputPath = "$($queryOutputPath)\results\$($serversourceInstanceName)_diag.xlsx"
    	 
            # create all the diag querries for this sourceInstance
               # instance only
#            Invoke-DbaDiagnosticQuery -SqlInstance $serversourceInstanceName -ExportQueries -OutputPath $queryOutputPath -InstanceOnly
               # all user databases only
#            Invoke-DbaDiagnosticQuery -SqlInstance $serversourceInstanceName -ExportQueries -OutputPath $queryOutputPath -DatabaseSpecific

	 
	        $scriptList = Get-ChildItem "$($queryOutputPath)\*.sql"
	        # loop through each diag query for sourceInstance
	        foreach ($script in $scriptList) 
                {

                    #get each script name without the extention for table name
# $script = "Configuration Values.sql"     
                    $tablename = $script -replace ".sql",""
                    $tablename = $tablename -replace " ", ""
                   

                    # Read the SQL script file contents
                    $sqlDiagScript = $($queryOutputPath)+"\"+$($script)
                    $sqlDiagScript = Get-content $sqlDiagScript -Raw

                    	# Create SQL connection and command objects                    $connection = New-Object System.Data.SqlClient.SqlConnection($TargetDBconnString)                    $command = New-Object System.Data.SqlClient.SqlCommand($sqlDiagScript, $connection)

 
 
 
 
 
 
                 # Strip Server Name
	             $name = $name -replace $sourceServer, ''
                 $name = $name -replace $sourceInstance, ''   
                 #spaces not allowed in table name in excel
                 #$tblname = $name -replace " ", ''   

	              
	              # Truncate name if over length requirements
	              if ($name.Length -gt 25) {$name = $name.Substring(0,25)}
                   
                  #Clean file name
                  $fn = $queryOutputPath + '\' + $script.name 
	 	    
                 # Invoke-DbaQuery -SqlInstance $server -File $fn | Export-Excel -Path $resultsOutputPath -TableName $tblname -WorksheetName $name -AutoSize -AutoFilter -ClearSheet
                 # Invoke-DbaQuery -SqlInstance $server -File $fn | Export-CSV -Path $resultsOutputPath -NoTypeInformation
                } #end query loop, clean folder out
#                Get-ChildItem -Path "$($queryOutputPath)" *.sql -File -Recurse | foreach { $_.Delete()}
            }
        catch
            {
            #Do nothing
            Write-Host $serversourceInstanceName " Is not online"
            } # end sourceInstance loop
}  