function Test-DMPCertificate {
    Write-Host "`n"
    Write-Host "Determing if the certificate mentioned in the SSLClientCertreference is also configured in the Enrollments part of the registry " -foregroundcolor yellow
    try {     
        $ProviderRegistryPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Enrollments"
        $ProviderPropertyName = "ProviderID"
        $ProviderPropertyValue = "MS DM Server"
        $GUID = (Get-ChildItem -Path Registry::$ProviderRegistryPath -Recurse -ErrorAction SilentlyContinue | ForEach-Object { if ((Get-ItemProperty -Name $ProviderPropertyName -Path $_.PSPath -ErrorAction SilentlyContinue | Get-ItemPropertyValue -Name $ProviderPropertyName -ErrorAction SilentlyContinue) -match $ProviderPropertyValue) { $_ } }).PSChildName
        $cert = (Get-ChildItem Cert:\LocalMachine\My\ | Where-Object { $_.issuer -like "*Microsoft Intune MDM Device CA*" })
        $certthumbprint = $cert.thumbprint
        $certsubject = $cert.subject
        $subject = $certsubject -replace "CN=", ""
    }
    catch {
        Write-Host "Failed to get guid for enrollment from registry, device doesnt seem enrolled?" -foregroundcolor red
    } 

    if ((Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Enrollments\$guid").DMPCertThumbPrint -eq $certthumbprint) {
        Write-Host "Great!!! The Intune Device Certificate with the Thumbprint $certthumbprint is configured in the registry Enrollments" -foregroundcolor green
    }
    else {
        Write-Host "Intune Device Certificate is not configured in the Registry Enrollments" -foregroundcolor red
    }
}