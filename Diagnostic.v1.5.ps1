#Provide server name and all active instances will scan
$serverName = "EXPSQL22"

# get list of instances on server
$instanceList = Get-DbaService -Computername $serverName | ?{$_.displayname -like "SQL Server (*"} | select InstanceName

# Loop through each server instance
#ForEach ($Instance in $instanceList) 
 #       {
  #      if ($Instance.InstanceName -ne "MSSQLSERVER"){
   #             $serverInstanceName = "$($serverName)\$($Instance)"
 #               $serverInstanceName = $serverInstanceName -replace ("@{InstanceName=|}")
  #      }else{
   #             $serverInstanceName = $serverName            
    #    }
     $serverInstanceName = "EXPSQL22"

#$serverInstanceName
#}

  #      try 
   #         {
   
            #test if instance can be connected, if not go to next instance
            $server = Connect-DbaInstance -SqlInstance $serverInstanceName -TrustServerCertificate #-ClientName $serverInstanceName  #"SQL5\FIRECHECK\DBATools"
            
            $queryOutputPath = 'C:\Users\argaither\Documents\Diags' #  <--- is the path correct
	        
            $resultsOutputPath = "$($queryOutputPath)\results\$($serverInstanceName)_diag.xlsx"
    	 
            # create all the diag querries for this instance
               # instance only
           # Invoke-DbaDiagnosticQuery -SqlInstance $serverInstanceName -ExportQueries -OutputPath $queryOutputPath -InstanceOnly
               # all user databases only
#            Invoke-DbaDiagnosticQuery -SqlInstance $serverInstanceName -ExportQueries -OutputPath $queryOutputPath -DatabaseSpecific

	 
	        $scriptList = Get-ChildItem "$($queryOutputPath)\*.sql"
	        # loop through each diag query for instance
	        foreach ($script in $scriptList) 
                {
	              # Clean File Name for Excel output of Worksheet and Table Name
	              # Remove invalid Characters, set Pascal Case
                  
                    
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
                 Invoke-DbaQuery -SqlInstance $server -File $fn | Export-CSV -Path $resultsOutputPath -NoTypeInformation -UseQuotes AsNeeded
                # Invoke-DbaQuery -SqlInstance $server -File $fn | Export-Excel -Path $resultsOutputPath -TableName $tblname -WorksheetName $name -AutoSize -AutoFilter -ClearSheet
                } #end query loop, clean folder out
          #      Get-ChildItem -Path "$($queryOutputPath)" *.sql -File -Recurse | foreach { $_.Delete()}
         #   }
        #catch
           # {
            #Do nothing
          #  Write-Host $serverInstanceName " Is not online"
          #  } # end instance loop
#}  #Instance Loop

$PSVersionTable