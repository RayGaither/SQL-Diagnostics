# Define connection string for the remote SQL Server instance where you want to create the new tables and insert data
$srcServer = "EXPSQL22"
$srcDatabase = "master"
# Define target
$targetServerName = "GAROHSQL01"
$targetDB = "Diagnostic"
# Define list of SQL script file paths
#$scriptList = "C:\Users\argaither\Documents\Diags\Configuration Values.sql", "C:\Users\argaither\Documents\Diags\\Database Properties.sql"
#$scriptPath = "C:\Users\argaither\Documents\Diags\Configuration Values.sql"
 #   $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($scriptPath)

    # Read the SQL script file contents
 #   $sqlScript = Get-Content $scriptPath -Raw
    
    
    # Specify connection strings for source and target databases
$sourceConnectionString = "Data Source=$srcServer;Initial Catalog=$srcDatabase;Integrated Security=SSPI;"
$targetConnectionString = "Data Source=$targetServerName;Initial Catalog=$targetDB;Integrated Security=SSPI;"

# Get list of SQL scripts to execute
$scriptPath = "C:\Users\argaither\Documents\Diags\"
$scriptList = Get-ChildItem -Path $scriptPath -Filter "*.sql"

# Loop through scripts
foreach ($script in $scriptList) {
    # Read contents of script file
    $scriptContents = Get-Content $script.FullName


    # Set up SQL connection and command objects
    $sourceConnection = New-Object System.Data.SqlClient.SqlConnection($sourceConnectionString)
    $sourceCommand = New-Object System.Data.SqlClient.SqlCommand($scriptContents, $sourceConnection)

    # Execute query and get results
    $dataAdapter = New-Object System.Data.SqlClient.SqlDataAdapter($sourceCommand)
    $dataTable = New-Object System.Data.DataTable
    $dataAdapter.Fill($dataTable)

    # Set up target SQL connection and insert command object
    $targetConnection = New-Object System.Data.SqlClient.SqlConnection($targetConnectionString)
    $targetConnection.Open()
    $targetCommand = $targetConnection.CreateCommand()

    # Generate CREATE TABLE statement from source query results
    $columnDefinitions = $dataTable.Columns | ForEach-Object { "[{0}] {1}" -f $_.ColumnName, $_.DataType.Name }
    $createTableStatement = "CREATE TABLE [{0}] ({1})" -f $script.Name.Replace(".sql", ""), ($columnDefinitions -join ", ")

    # Execute CREATE TABLE statement on target SQL instance
    $targetCommand.CommandText = $createTableStatement
    $targetCommand.ExecuteNonQuery()

    # Generate INSERT statements from source query results and execute on target SQL instance
    $insertCommands = $dataTable.Rows | ForEach-Object { "INSERT INTO [{0}] VALUES ({1})" -f $script.Name.Replace(".sql", ""), ($_.ItemArray -join ", ") }
    $insertCommands | ForEach-Object {
        $targetCommand.CommandText = $_
        $targetCommand.ExecuteNonQuery()
    }

    # Clean up resources
    $sourceConnection.Close()
    $targetConnection.Close()
}
