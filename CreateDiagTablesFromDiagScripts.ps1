# Create tables in DBA server from scripts
    # assumptions scripts have been created and converted to create tables, this is for instances only

# subject server
$subjectServer = "expsql22"
$dbaServer = "GAROHSQL01"
$dbaDatabase = "Diagnostic"
$createScripts = "false"


# set path
$diagSQLPath = "C:\Users\argaither\Documents\Diag\TestScripts"

#test if instance can be connected, if not go to next instance
#$server = Connect-DbaInstance -SqlInstance $dbaServer -TrustServerCertificate #-ClientName $serverInstanceName  #"SQL5\FIRECHECK\DBATools"

# itterate through
$scriptList = Get-ChildItem "$($diagSQLPath)\*.sql"
    # loop through each diag query for instance
	foreach ($script in $scriptList) 
    {
        
        # use file name to get table name
#        $tableName = $script.BaseName -replace " ", ""
 #       $tableName = $tableName -replace ".sql", ""
    
        # Use function to get ddl
        
        $sqlScriptPath = $diagSQLPath + '\' + $script.Name
        
        # have to get script into var to pass to SQL SP
       # $sqlScript = Get-Content $sqlScriptPath -Raw 
       # $sqlScript = $sqlScript -replace  "'", "'`'"

        # go to dba server to build table ddl - returns table ddl
        Invoke-DbaQuery -SqlInstance $dbaServer -Database $dbaDatabase -Query $sqlFtnCall 
      #  Write-Output $MyResult

        # go back to DBA server to create table
       # "SELECT * FROM myTable WHERE myColumn = 'It`s a single quote'"

    }

    
    
    # create table in DBA server
        # could possible execute script here but we only need to do this once
# end 