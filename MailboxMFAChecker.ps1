<#
    .SYNOPSIS
    Finds all mailbox auth methods and places them into table.csv
    EG.
        MailBox                    AuthType
        -------                    --------
        user0@NightCorp.com        phone, password, softwareOath,
        user1@NightCorp.com        password, softwareOath, softwareOath,
        user2@NightCorp.com        password, softwareOath,
        user3@NightCorp.com        password,
        user4@NightCorp.com        password, softwareOath,

    .DESCRIPTION
    Connects to MgGraph
    Finds all mailboxes
    Parses each mailboxes enabled auth methods
    Consolidates results to ./table.csv
    Disconnects from MgGraph

    .INPUTS
    Will prompt to login to Office 365

    .OUTPUTS
    Would you like to install Microsoft.Graph Powershell Module?
    Press 1 yes, 2 for No
    Please wait for installation...
    Welcome to Microsoft Graph!
    Finding Mailbox Authentication Methods now...
    Would you like to restart?
    Press 1 for yes, 2 to exit.
    Goodbye

    .EXAMPLE
    PS> import-csv ./table.csv

    .EXAMPLE
    PS> ./MailboxMFAChecker.ps1

    .LINK
    https://lazyadmin.nl/powershell/install-microsoft-graph-module/
    https://activedirectorypro.com/mfa-status-powershell/
    https://regexr.com/
    https://stackoverflow.com/questions/3850074/regex-until-but-not-including
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json?view=powershell-7.3
    https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.identity.signins/get-mguserauthenticationmethod?view=graph-powershell-1.0
    https://devblogs.microsoft.com/scripting/powertip-create-empty-string-with-powershell/
#>

function Connect-Msft{
    $findMod = Find-Module Microsoft.Graph | Select-Object -ExpandProperty Name
    $response = Read-Host "`nWould you like to install Microsoft.Graph Powershell Module? `n`nPress 1 yes, 2 for No`n`n"

    if ($response -eq 1){
        Write-Host "`n`nPlease wait for installation...`n`n"
        try {
            $ErrorActionPreference = 'silentlycontinue'
            Install-Module Microsoft.Graph -Scope CurrentUser -Confirm:$false
        }
        catch {
            Write-Host "`nsomething Happend during module installation.`n"
        }finally{
            try {
                Write-Host "`n`nMicrosoft.Graph Powerhsell Module is installed, connecting now...`n`n"
                Start-Sleep -Seconds 1.5
                $ErrorActionPreference = 'silentlyContinue'
                Connect-MgGraph -Scopes ([string[]]('UserAuthenticationMethod.Read.All','User.ReadWrite.All'))
            }
            catch {
                Write-Host "`nSomething happend during the connection to Microsoft.Graph`n"
            }
        }
    }elseif ($response -eq 2){
        return "`nexiting now`n"
    }else{
        Write-Host "`n`nWrong input, try 1 or 2.`n`n"
        Connect-Msft
    }
    Get-AuthData
}


function Get-AuthData{
    # Create CSV
    $table = New-Object System.Data.Datatable
    [void]$table.Columns.Add("MailBox")
    [void]$table.Columns.Add("AuthType")
    $users = get-mguser -All

    Write-Host "`n`nFinding Mailbox Authentication Methods now...`n`n"

    for($i = 0; $i -lt $users.length; $i ++){
        $rando = Get-Random -Minimum 502 -Maximum 660 # randomize
        start-sleep -Milliseconds $rando

        $currentMailbox = $users[$i].UserPrincipalName; $currentMailbox
        $GrabMethods = Get-MGUserAuthenticationMethod -userid $users.UserPrincipalName[$i] | ConvertTo-Json | ConvertFrom-Json # get info on mailbox
        $countMethods = $GrabMethods | Measure-Object
        $string = [string]::Empty  # empty string

        for($j = 0; $j -lt $countMethods.count; $j ++){
            $test = [regex]::match(($GrabMethods.additionalproperties."@odata.type"[$j]), "(?<=graph.).*?(?=(?:AuthenticationMethod)|$)").value
            $isEmpty = [string]::IsNullOrEmpty($test)

            if($isEmpty -eq $true){
                $test = [regex]::match(($GrabMethods.additionalproperties."@odata.type"), "(?<=graph.).*?(?=(?:AuthenticationMethod)|$)").value
                $string += "$test, "
            }else{
                $string += "$test, "
            }
        }
        [void]$table.Rows.Add("$currentMailbox", "$string") # fill mailbox and string to row
    }
    $table | Export-Csv table.csv
}


Connect-Msft

try {
    Disconnect-MgGraph | out-null
    $restart = Read-Host "`n`nWould you like to restart?`n`nPress 1 for yes, 2 to exit.`n`n"

    if($restart -eq 1){
        import-csv ./table.csv
        Connect-Msft
    }else{
        import-csv ./table.csv
        return "Goodbye"
    }
}
catch {
    Write-Host "something went wrong"
}
