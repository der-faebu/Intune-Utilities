function Get-EnrollmentId {
    Write-Host "`n"
    Write-Host "Fetching the EnrollmentID" -ForegroundColor Yellow
    try {     
        $ProviderRegistryPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Enrollments"
        $ProviderPropertyName = "ProviderID"
        $ProviderPropertyValue = "MS DM Server"
        $enrollmentid = (Get-ChildItem -Path Registry::$ProviderRegistryPath -Recurse -ErrorAction SilentlyContinue |
            ForEach-Object {
                if ((Get-ItemProperty -Name $ProviderPropertyName -Path $_.PSPath -ErrorAction SilentlyContinue |
                        Get-ItemPropertyValue -Name $ProviderPropertyName -ErrorAction SilentlyContinue) -match $ProviderPropertyValue) { $_ }
            }).PSChildName

        # Return the enrollment ID
        return $enrollmentid
    }
    catch {
        Write-Host "Failed to get guid for enrollment from registry, device doesn't seem enrolled?" -ForegroundColor Red
        return $null
    } 
}