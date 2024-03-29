<#
    DESCRIPTION
    Developer:  Matt Waldeck
    Date:       07-09-2019
    Purpose:    Generates a CSV containing all computers in the current domain.
    Last Edit:  06-02-2021
    Version:    v1.1.3
#>

# Allow AD commands
Import-Module ActiveDirectory

# Console feedback
Write-Output "Generating $env:USERPROFILE\Desktop\Domain Computers.csv..."

# Select all computers in the domain and pick out the specified information
Get-ADComputer -Filter * -Properties Name, Enabled, OperatingSystem, OperatingSystemVersion, Created, CanonicalName |`
Select-Object -Property Name, Enabled, OperatingSystem, OperatingSystemVersion, Created, CanonicalName | Sort-Object Name |`
Export-Csv "$env:USERPROFILE\Downloads\Domain Computers.csv" -NoTypeInformation #CSV saves to desktop.

# Console feedback
Write-Output "Done!"
Write-Output ""
Start-Sleep -Seconds 5