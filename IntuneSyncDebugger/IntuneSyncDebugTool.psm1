<#PSScriptInfo
.VERSION 0.20
.GUID 715a6707-796c-445f-9e8a-8a0fffd778a4
.AUTHOR Rudy Ooms
.COMPANYNAME
.COPYRIGHT
.TAGS Windows, AutoPilot, Powershell
.LICENSEURI
.PROJECTURI https://www.github.com
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.RELEASENOTES
Version 0.1: Initial Release.
version 0.2: added way more checks and fixes
version 0.3: added the mdmurls check
version 0.8: added the IME service check and reinstall functionality and improved some error handling
version 0.12: added a failsafe when your device is missing the enrollmentid
version 0.18: MMPC broke the script....
version 0.20: Improved the code and fixed some bugs
.PRIVATEDATA
#>
<#
.DESCRIPTION
.SYNOPSIS
GUI to fix intune sync issues.
MIT LICENSE
Copyright (c) 2022 Rudy Ooms
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
.DESCRIPTION
The goal of this script is to help with the troubleshooting of Attestation issues when enrolling your device with Autopilot for Pre-Provisioned deployments
.EXAMPLE
Blog post with examples and explanations @call4cloud.nl
.LINK
Online version: https://call4cloud.nl/
#>


$FunctionsToImport = @()
#Import public functions
$FunctionsToImport += Get-ChildItem "$PSScriptRoot\public\*.ps1"

#Import private functions
$FunctionsToImport += Get-ChildItem "$PSScriptRoot\private\*.ps1"

foreach ($file in $FunctionsToImport) {
    if (-not $file.Fullname.EndsWith('.Tests.ps1')) {
        . $file.Fullname 
    } 
}