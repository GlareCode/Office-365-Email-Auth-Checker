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
