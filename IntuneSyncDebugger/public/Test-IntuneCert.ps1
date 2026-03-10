function Test-IntuneCertificate {
    if (Get-ChildItem Cert:\LocalMachine\My\ | Where-Object { $_.issuer -like "*Microsoft Intune MDM Device CA*" }) {
        Write-Host "Intune Device Certificate is in installed in the Local Machine Certificate store" -foregroundcolor green
    }
    else {
        Write-Host "Intune device Certificate still seems to be missing... sorry!" -foregroundcolor red    
    }
}