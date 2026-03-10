function Test-CertificateDate {
    param(
        [string]$Thumbprint,
        [switch]$Unattended
    )
    Write-Host "Checking If the Certificate hasn't expired" -foregroundcolor yellow
    if ($null -eq (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Thumbprint -eq $thumbprint -and $_.NotAfter -lt (Get-Date) })) {
        Write-Host "Great!!! The Intune Device Certificate is not expired!! WOOP WOOP" -foregroundcolor green
    }
    else {
        Write-Host "Is this a shitstorm? because the Intune Device Certificate is EXPIRED!" -foregroundcolor red
        Update-Certificate -Unattended:$Unattended
    }
}