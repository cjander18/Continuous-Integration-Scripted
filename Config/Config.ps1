$ServerName = ""
$DatabaseName = ""
$SQLUser = ""
$SQLPassword = ""

$TargetDirectory = "C:\Users\Rumor\OneDrive\Code\SQL\StoredProcedures"

try 

{


    # Build a Database object to make queries and calls more concise and modular
    $DbObj = New-Object -TypeName PSCustomObject -Property ([Ordered] @{
                'DatabaseName'   = $DatabaseName
                'ServerName'    = $ServerName
                'SQLUser'       = $SQLUser
                'SQLPassword'   = $SqlPassword
                'Error'         = ''; })

    # Add a RunQuery method that will let queries that are strings be run with one line
    $method = {

        param([string]$Query = $(throw "Query must be specified."))
        try 
        
        {

            Invoke-SqlCmd -Query $Query `
                -ServerInstance $this.ServerName `
                -Database $this.DatabaseName `
                -Username $this.SQLUser `
                -Password $this.SQLPassword `
                -EncryptConnection `
                -OutputSqlErrors $True `
                -Verbose
            
        }
        
        catch [Exception]
        
        {
        
            Write-Error "$($_.Exception.Message) $($_.Exception.ItemName) $Error"
        
        }

    }

    # Add a RunQuery method that will let queries that are strings be run with one line
    $DbObj | Add-Member -MemberType ScriptMethod -Name RunQuery -Value $method

    # Add a RunQuery method that will let queries that are .sql files be run with one line
    $method = {

        param([string]$File = $(throw "File must be specified."))

        try 
        
        {

             Invoke-SqlCmd -InputFile $File `
                -ServerInstance $this.ServerName `
                -Database $this.DatabaseName `
                -Username $this.SQLUser `
                -Password $this.SQLPassword `
                -EncryptConnection `
                -OutputSqlErrors $True `
                -IncludeSqlUserErrors `
                -Verbose
            
        }
       
        catch [Exception]
        
        {
        
            Write-Error "$($_.Exception.Message) $($_.Exception.ItemName) $Error"
        
        }

    }

    # Add a RunQuery method that will let queries that are .sql files be run with one line
    $DbObj | Add-Member -MemberType ScriptMethod -Name RunFile -Value $method
   
}

catch [Exception] 

{

    Write-Error "$($_.Exception.Message) $($_.Exception.ItemName) $Error"

}