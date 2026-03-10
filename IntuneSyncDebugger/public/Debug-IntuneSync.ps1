function Debug-IntuneSync {
    param(
        [switch]$Unattended
    )

    Write-Debug "Starting Diagnose-IntuneSync"
    if ($Unattended) {
        Write-Debug "Running in 'Unattended' mode. All prompts will be suppressed and default to 'yes'."
    }

    $EnrollmentID = Get-EnrollmentId

    if ($null -eq $EnrollmentID) {
        Write-Host "`n"
        Write-Host "Device doesn't seem to be enrolled" -ForegroundColor Yellow
    }
    if ($null -eq $EnrollmentID) {
        Test-MDMLog -Unenrolled
    }

    Write-Host "`n"
    Write-Host "Determining if the device is enrolled and fetching the SSLClientCertReference registry key" -ForegroundColor Yello
    try { 
        $ProviderRegistryPath = "HKLM:SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\$EnrollmentID"
        $ProviderPropertyName = "SslClientCertReference"
        $GUID = (Get-Item -Path $ProviderRegistryPath -ErrorAction SilentlyContinue | ForEach-Object { if ((Get-ItemProperty -Name $ProviderPropertyName -Path $_.PSPath -ErrorAction SilentlyContinue | Get-ItemPropertyValue -Name $ProviderPropertyName -ErrorAction SilentlyContinue)) { $_ } }).PSChildName
        $ssl = (Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\$guid" -ErrorAction SilentlyContinue).sslclientcertreference
    } 
    catch [System.Exception] {
        Write-Error "Failed to get Enrollment GUID or SSL Client Reference for enrollment from registry... that's odd almost as if the Intune Certificate is gone" 
        $result = $false
    }
    if ($null -eq $ssl) {
        Write-Host "Thats weird, your device doesnt seem to be enrolled into Intune, lets find out why!.. hold my beer!" -foregroundcolor red
    }
    else {
        Write-Host "Device seems to be Enrolled into Intune... proceeding" -foregroundcolor green
    }

    Write-Host "`n"
    Write-Host "Checking the Certificate Prefix.. to find out if it is configured as SYSTEM or USER" -foregroundcolor yellow

    try {
        $thumbprintPrefix = "MY;System;"
        $thumbprint = $ssl.Replace($thumbprintPrefix, "")         
        if ($ssl.StartsWith($thumbprintPrefix) -eq $true) { 
            Write-Host "The Intune Certificate Prefix is configured as $thumbprintprefix" -foregroundcolor green
            Write-Host "`n"
            Write-Host "Determing if the certificate is installed in the local machine certificate store" -foregroundcolor yellow
            if (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Thumbprint -eq $thumbprint }) {
                Write-Host "Intune Device Certificate is installed in the Local Machine Certificate store" -foregroundcolor green
                Write-Host "`n"
                Test-CertificateDate -Thumbprint $thumbprint
                Write-Host "`n"
                Write-Host "Checking if the Certificate is also mentioned in the IME log" -foregroundcolor yellow
                Test-IMELog -Thumbprint $thumbprint
            }
            else {
                Write-Host "Intune device Certificate is missing in the Local Machine Certificate store" -foregroundcolor red    
                Update-Certificate -Unattended:$Unattended
                Write-Host "Running some tests to determine if the device has the SSLClientCertReference registry key configured!" -foregroundcolor yellow
                Get-SSLClientCertificateReference
            }
            Write-Host "`n"
            Write-Host "Determing if the certificate has a Private Key Attached" -foregroundcolor yellow
            Get-PrivateKey -Thumbprint $thumbprint -Unattended:$Unattended
            Test-DMPCertificate
        }
        else {
            Write-Host "Damn... the SSL prefix is not configured as SYSTEM but as $SSL" -foregroundcolor red
            $thumbprintPrefix = "MY;User;"
            $thumbprint = $ssl.Replace($thumbprintPrefix, "")
    
            Write-Host "`n"
            Write-Host "Determing if the certificate is also not in the System Certificate Store" -foregroundcolor yellow
    
            if (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Thumbprint -eq $thumbprint }) {
                Write-Host "Intune Device Certificate is installed in the Local Machine Certificate store" -foregroundcolor green
                Write-Host "`n"
                Test-CertificateDate -Thumbprint $thumbprint
                Write-Host "`n"
                Write-Host "Determing if the certificate has a Private Key Attached" -foregroundcolor yellow
                Get-PrivateKey -Thumbprint $thumbprint -Unattended:$Unattended
                Test-DMPCertificate
            }
            else {
                Write-Host "Intune device Certificate is installed in the wrong user store. I will fix it for you!" -foregroundcolor red
                Update-CertificateStore -Unattended:$Unattended
                Write-Host "Determing if the certificate is now been installed in the proper store" -foregroundcolor yellow
                Test-IntuneCertificate
            }
        }
    }
    catch {
        Write-Host "Failed to get the Certificate Details, device doesnt seem enrolled? Who cares?Let's fix it" -foregroundcolor red
        Update-Certificate -Unattended:$Unattended
    }

    Test-EntDMID  
}