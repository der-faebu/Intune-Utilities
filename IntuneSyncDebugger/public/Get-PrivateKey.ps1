function Get-PrivateKey { 
    param(
        [string]$Thumbprint,
        [switch]$Unattended
    )
    if ((Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Thumbprint -match $thumbprint }).HasPrivateKey) {
        Write-Host "Nice.. your Intune Device Certificate still has its private key" -foregroundcolor green
    }
    else {
        Write-Host "I guess we need to fix something because the certificate is missing its private key"  -foregroundcolor red 
        Update-PrivateKey -Unattended:$Unattended
    }
}