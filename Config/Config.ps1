$ServerName = "clintonsadvworks.database.windows.net"
$DatabaseName = "AdventureWorksDB"
$SQLUser = "kaizen"
$SQLPassword = "Lorem!Ipsum1"

$TargetDirectory = "C:\Users\Rumor\OneDrive\Code\SQL\StoredProcedures"

try 

{


    # Build a Database object to make queries and calls more concise and modular
    $DbObj = New-Object -TypeName PSCustomObject -Property ([Ordered] @{
                'DatabseName'= $DatabaseName
                'ServerName'=$ServerName
                'SQLUser'= $SQLPassword
                'SQLPassword'= $SqlPassword
                'Error'='';})

    # Add a RunQuery method that will let queries that are strings be run with one line
    $DbObj | Add-Member -MemberType ScriptMethod -Name RunQuery -Value {
    
        param([string]$Query = $(throw "Query must be specified."))
    
        try 
    
        {
    
            $Output = Invoke-SqlCmd -Query $Query `
                -ServerInstance $this.ServerName `
                -Database $this.DatabaseName `
                -Username $this.SQLUser `
                -Password $this.SQLPassword `
                -EncryptConnection `
                -OutputSqlErrors $True `
                -Verbose

            Write-Output $Output
                
        } 
    
        catch [Exception]
    
        {
    
            Write-Error "$($_.Exception.Message) $($_.Exception.ItemName) $Error"

        }

    }


    # Add a RunQuery method that will let queries that are .sql files be run with one line
    $DbObj | Add-Member -MemberType ScriptMethod -Name RunFile -Value {
    
        param([string]$File = $(throw "File must be specified."))
    
        try 
    
        {
    
            Write-Output "hi"

            $Output = Invoke-SqlCmd -InputFile $File `
                -ServerInstance $this.ServerName `
                -Database $this.DatabaseName `
                -Username $this.SQLUser `
                -Password $this.SQLPassword `
                -EncryptConnection `
                -OutputSqlErrors $True `
                -Verbose | Out-File "C:\log.log" -Append
                
            Write-Output $Output
                
        } 
    
        catch [Exception]
    
        {

            Write-Error "$($_.Exception.Message) $($_.Exception.ItemName) $Error"

        }

    }

}

catch [Exception] 

{

    Write-Error "$($_.Exception.Message) $($_.Exception.ItemName) $Error"

}