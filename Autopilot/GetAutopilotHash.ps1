

param(
    [Parameter(Mandatory = $false)]
    [string]$TenantName = [string]::Empty,

    [Parameter(Mandatory = $false)]
    [switch]$MergeCSV
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

$TargetFolder = $ProjectRoot

if ([string]::Empty -ne $TenantName) {

    $subPath = Join-Path -Path $ProjectRoot -ChildPath $TargetFolder

    if (-not (Test-Path $subPath )) {
        try {
            New-Item -ItemType Directory -Path $subPath | Out-Null
        }
        catch {
            Write-Warning "Could not create target folder $($TargetFolder). Falling back to script root"
        }
    }
    $TargetFolder = Join-Path $ProjectRoot $TenantName
}


if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -Force -Scope AllUsers -Confirm:$false
}

if (-not (Get-Module -ListAvailable -Name Get-WindowsAutopilotInfo)) {
    Install-Script -Name Get-WindowsAutopilotInfo -Force -Confirm:$false
}

$Serial = Get-ComputerInfo | Select-Object -ExpandProperty BiosSerialNumber -ErrorAction SilentlyContinue

if ($null -eq $Serial) {
    $Serial = $env:COMPUTERNAME
}

$OutputFile = Join-Path $TargetFolder "$Serial-AutopilotHash.csv"
Get-WindowsAutopilotInfo -OutputFile $OutputFile 
Write-Output "Autopilot hash saved to: $OutputFile"
