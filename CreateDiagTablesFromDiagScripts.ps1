# Create tables in DBA server from scripts
    # assumptions scripts have been created against the subject server and path is avaliable

# subject server
$subjectServer = "expsql22"
$dbaServer = "GAROHSQL01"
$dbaDatabase = "Diagnostic"


# set path
$diagSQLPath = "C:\Users\argaither\Documents\Diags"

# itterate through
$scriptList = Get-ChildItem "$($diagSQLPath)\*.sql"
    # loop through each diag query for instance
	foreach ($script in $scriptList) 
    {
        
        # use file name to get table name
        $tableName = $script.BaseName -replace " ", ""
        $tableName = $tableName -replace ".sql", ""
    
        # Use function to get ddl

        $sqlScriptPath = $diagSQLPath + '\' + $script.Name
        
        $tableDDL = "select dbo.ftnGenerateDiagTable($sqlScriptPath, $tableName)"
        
        
        Invoke-DbaQuery -SqlInstance $server -File $tableDDL

        Write-Output $tableDDL


    }

    
    
    # create table in DBA server
        # could possible execute script here but we only need to do this once
# end 