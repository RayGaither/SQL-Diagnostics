# Define connection string for the remote SQL Server instance where you want to create the new tables and insert data
$srcServer = "EXPSQL22"
$srcDatabase = "master"

$sourceConnectionString = "Server = $srcServer; Database = $srcDatabase; Integrated Security = True"

# Define target
$targetServerName = "GAROHSQL01"
$targetDB = "Diagnostic"
# Define list of SQL script file paths
$scriptList = "C:\Users\argaither\Documents\Diags\Configuration Values.sql", "C:\Users\argaither\Documents\Diags\\Database Properties.sql"

# Loop through the SQL script file paths and execute each script
###################################################################foreach ($scriptPath in $scriptList) {
    # Get the script file name without the extension
                                                                       $scriptPath = "C:\Users\argaither\Documents\Diags\Configuration Values.sql"
    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($scriptPath)

    # Read the SQL script file contents
    $sqlScript = Get-Content $scriptPath -Raw

    # remove spaces
    $tableName = $scriptName -replace " ", ""

    # Create SQL connection and command objects for the source instance
    $sourceConnection = New-Object System.Data.SqlClient.SqlConnection($sourceConnectionString)
    $sourceCommand = New-Object System.Data.SqlClient.SqlCommand($sqlScript, $sourceConnection)

    # Open the source SQL connection
    $sourceConnection.Open()

    # Execute the SQL query to get the data
    $dataAdapter = New-Object System.Data.SqlClient.SqlDataAdapter($sqlScript, $sourceConnection)
    $dataSet = New-Object System.Data.DataSet
    $dataAdapter.Fill($dataSet)

    # Create SQL connection and command objects for the target instance
   # $targetConnectionString = "Server = $targetServerName; Database = $targetDB; Integrated Security=True"
   # $targetConnection = New-Object System.Data.SqlClient.SqlConnection($targetConnectionString)
   # $targetCommand = New-Object System.Data.SqlClient.SqlCommand($null, $targetConnection)

    
    $targetConnection = New-Object System.Data.SqlClient.SqlConnection
    $targetConnection.ConnectionString = "Server = $targetServerName; Database = $targetDB; Integrated Security=True"
    



    $sqlScript

    # $query = "SELECT * INTO [$tableName] FROM [$sourceConnection].[$sqlScript]"
    # $query = "SELECT * INTO [$tableName] FROM [$sqlScript]"
    $query = "SELECT * INTO [$tableName] FROM [$sqlScript]"
    $targetCommand = New-Object System.Data.SqlClient.SqlCommand("SELECT * INTO [$tableName] FROM ($sqlScript) t;", $targetConnection)
    $targetCommand.ExecuteNonQuery()  
    
    # $targetCommand.Connection = $targetConnection


    
    # Open the target SQL connection
    $targetConnection.Open()
(Get-ItemPropertyValue -LiteralPath 'HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -Name Release) -ge 528040
   

    # Create the new table in the target database
    #$query = "SELECT * INTO [$tableName] FROM [$sourceConnectionString].[$scriptName]"
    $query = "SELECT * INTO [$tableName] FROM [$sourceConnection].[$sqlScript]"
    $targetCommand.CommandText = $query
    $targetCommand.ExecuteNonQuery()         # fails here



    # Insert the data from the source database into the target table
    $table = $dataSet.Tables[0]
    $dataAdapter.InsertCommand = New-Object System.Data.SqlClient.SqlCommandBuilder($dataAdapter).GetInsertCommand() ###fail
    $dataAdapter.UpdateBatchSize = $table.Rows.Count
    $dataAdapter.Update($table)

    # Close the target SQL connection
    $targetConnection.Close()

    # Close the source SQL connection
    $sourceConnection.Close()
#}

# remote = source
# Local = target