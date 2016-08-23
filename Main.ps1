Function Deploy-Files {
param(

    # One or more directories, that are processed in order, listing directories from which to check for files
    [string[]] $Directory = "",
    
    # One or more files, that are processed in order, that specify the directories from which to check for files
    [string[]] $DirectoryList = "",
    
    # One or multiple files, that are processed in order, listing files to be deployed
    [string[]] $FileList = "", 
    
    [boolean] $Recurse = $True
    
    ) 

    $DirectoryList_Fl = $False
    $Directory = $False
    $FileList_Fl = $False

    # Check if we have a directory list or a string of directory(ies)
    if ($DirectoryList  -ne "")
    
    {
    
        $DirectoryList_Fl = $True

    } 
    
    elseif ($Directory  -ne "")
    
    {
    
        $Directory = $True

    }
    
    else
    
    {

        Write-Host "A directory string, or array of strings must be specified"
        return

    }

    # Check if we have a list of files
    if ($FileList -ne "")

    {

        $FileList_Fl = $True

    }



    $DirectoryList | % {

    }



    # Get the current directory location of the executing script
    $CurrentLocation = Split-Path -Parent  $MyInvocation.MyCommand.Path

    # Load the configuration data
    . $CurrentLocation\Config\Config.ps1

    # Get all items in the target folder and its subfolders that are not a folder (Container), if error just carry on
    $Targets = gci $TargetDirectory -Recurse `
        -Force `
        -ErrorAction "Continue" `
        -Filter $Filter |
        Where { ! $_.PSIsContainer }

    # For each file found
    $Targets | %  {

        # Get its full file path
        $TargetFile = $_.FullName

        # Get the difference between the files last write time and now
        $DateTimeDiff = New-Timespan -Start $_.LastWriteTime -End (Get-Date)
    
        Write-Output "$TargetFile`: Modified ($DateTimeDiff.Minutes) minutes ago"

        # If it's been updated within the last five minutes
        if ($DateTimeDiff.Minutes -cle 5)

        {

            Write-Output "Deploying $TargetFile"

            # Deploy the file to the database
            $Output = $DbObj.RunFile([string]$TargetFile)
           # $Output = Invoke-SqlCmd -InputFile $TargetFile `
           #        -ServerInstance $ServerName `
           #        -Database $DatabaseName `
           #        -Username $SQLUser `
           #        -Password $SQLPassword `
           #        -EncryptConnection `
           #        -OutputSqlErrors $True `
           #        -Verbose #| Out-File "C:\log.log" -Append
                
            #Write-Output $Output
        }

    }

}