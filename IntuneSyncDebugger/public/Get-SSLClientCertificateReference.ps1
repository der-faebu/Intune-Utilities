
function Get-SSLClientCertificateReference {
    try { 
        $ProviderRegistryPath = "HKLM:SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\"
        $ProviderPropertyName = "ServerVer"
        $ProviderPropertyValue = "4.0"
        $GUID = (Get-ChildItem -Path $ProviderRegistryPath -Recurse -ErrorAction SilentlyContinue | ForEach-Object { if ((Get-ItemProperty -Name $ProviderPropertyName -Path $_.PSPath -ErrorAction SilentlyContinue | Get-ItemPropertyValue -Name $ProviderPropertyName -ErrorAction SilentlyContinue) -match $ProviderPropertyValue) { $_ } }).PSChildName
        $ssl = (Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\$guid" -ErrorAction SilentlyContinue).sslclientcertreference
    } 
    catch [System.Exception] {
        Write-Error "Failed to get Enrollment GUID or SSL Client Reference for enrollment from registry, device doesnt seem enrolled or it needs a reboot first" 
        $result = $false
    }

    if ($null -eq $ssl) {
        Write-Host "Thats weird, your device doesnt seem to be enrolled into Intune, lets find out why!.. hold my beer!" -foregroundcolor red
    }
    else {
        Write-Host "Device seems to be Enrolled into Intune... proceeding" -foregroundcolor green
    }                        
}