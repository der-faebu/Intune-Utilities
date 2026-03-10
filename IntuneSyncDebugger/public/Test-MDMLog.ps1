function Test-MDMLog {
    param(
        [Switch]$Unattended
    )
    Write-Host "Hold on a moment... Initializing a sync and checking the MDM logs for sync errors!"  -foregroundcolor yellow
    Try {
        if (Test-IntuneManagementExtension) {
            Start-IntuneSync -ErrorAction Stop
        }
    }
    Catch {
        Write-Warning "Could not start Intune sync. This is expected if the device is not enrolled yet"
    }

    Remove-Item -Path $env:TEMP\diag\* -Force -ErrorAction SilentlyContinue 
    Start-Process MdmDiagnosticsTool.exe -Wait -ArgumentList "-out $env:TEMP\diag\" -NoNewWindow

    $checkmdmlog = Select-String -Path $env:TEMP\diag\MDMDiagReport.html -Pattern "The last sync failed" -ErrorAction SilentlyContinue
    if ($null -eq $checkmdmlog) {
        Write-Host "Not detecting any sync errors in the MDM log" -foregroundcolor green
    }
    else {
        Write-Host "It's a good thing you are running this script because you do have some Intune sync issues going on"  -foregroundcolor red 
    }
}