# Connect to the source database
$sourceConnStr = "Server=EXPSQL22;Database=master;Integrated Security=True"
$sourceConn = New-Object System.Data.SqlClient.SqlConnection($sourceConnStr)
$sourceConn.Open()

# Connect to the target database
$targetConnStr = "Server=GAROHSQL01;Database=Diagnostic;Integrated Security=True"
$targetConn = New-Object System.Data.SqlClient.SqlConnection($targetConnStr)
$targetConn.Open()

# Get all the SQL scripts in the folder
$scriptFolder = "C:\Users\argaither\Documents\Diags"
$scriptList = Get-ChildItem -Path $scriptFolder -Filter *.sql

# Loop through the scripts and create the tables in the target database
foreach ($script in $scriptList) {
    $tableName = $script.BaseName
    $tableName = $tableName -replace  " ",""
    $query = Get-Content $script.FullName | Out-String
    $query = "select * into $($tableName) from (" + $query + ") t"

    # Create the table in the target database
    $createTableCommand = New-Object System.Data.SqlClient.SqlCommand($query, $targetConn)
    $createTableCommand.ExecuteNonQuery()
}

# Close the connections
$sourceConn.Close()
$targetConn.Close()
