
Finds all mailbox auth methods and places them into table.csv
EG.
MailBox                    AuthType
-------                    --------
user0@NightCorp.com        phone, password, softwareOath,
user1@NightCorp.com        password, softwareOath, softwareOath,
user2@NightCorp.com        password, softwareOath,
user3@NightCorp.com        password,
user4@NightCorp.com        password, softwareOath,

#steps

Connects to MgGraph
Finds all mailboxes
Parses each mailboxes enabled auth methods
Consolidates results to ./table.csv
Disconnects from MgGraph
