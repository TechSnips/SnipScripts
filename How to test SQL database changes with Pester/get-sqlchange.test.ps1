# This is environment specific
$sqlServerName = 'DESKTOP-NOO7N08\SQLEXPRESS'
$databaseName = 'techsnips'

# Load the SQL Management Objects
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null

# Find all the databases
$AllSql = (New-Object ("Microsoft.SqlServer.Management.Smo.Server") $sqlServerName).databases

# Filter to the one we're looking for
$SqlDB = $AllSql | where {$_.Name -like $databaseName}

# Table and Column filtering
$tableName = $SqlDB.Tables.name
$columnName = $SqlDB.Tables.Columns[0].Name

# Pester tests
Describe 'Read SQL Server' {
    It "Can query the database" {
        $query = "SELECT TOP 1 $columnName FROM $tableName"
        $firstRow = Invoke-Sqlcmd -ServerInstance $SqlServerName -Database $DatabaseName -Query $query
        $firstRow.ItemArray | Should Be "1st_row"
    }

    It "Finds 'test_table" {
        $SqlDB.Tables.name | Should Be "test_table"
   }

    It "Finds 'test_column" {
        $SqlDB.Tables.Columns[0].Name | Should Be "test_column"
    }
}