function Test-EntDMID {
    Write-Host "`n"
    Write-Host "Determing if the certificate subject is also configured in the EntDMID key " -foregroundcolor yellow
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

    if ((Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Enrollments\$guid\DMClient\MS DM Server").entdmid -eq $subject) {
        Write-Host "I have good news!! The subject of the Intune Certificate is also set in the EntDMID registry key. Let's party!!!!" -foregroundcolor green
    }
    else {
        Write-Host "I have some shitty news! The EntDMID key is not configured, you probably need to reboot the device and run the test again" -foregroundcolor red
    }
}