function Update-MDMUrl {
    Write-Host "`n"
    Write-Host "Determing if the required MDM enrollment urls are configured in the registry" -foregroundcolor yellow

    $key = 'SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\*' 
    $keyinfo = Get-Item "HKLM:\$key" -ErrorAction Ignore
    $url = $keyinfo.name
    $url = $url.Split("\")[-1]
    $path = "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\$url" 

    if (test-path $path) {
        $mdmurl = get-itemproperty -LiteralPath $path -Name 'MdmEnrollmentUrl'
        $mdmurl = $mdmurl.mdmenrollmenturl
    }
    else {
        Write-Host "I guess I am missing the proper tenantinfo" -foregroundcolor red 
    }


    if ($mdmurl -eq "https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc") {
        Write-Host "MDM Enrollment URLS are configured the way I like it!Nice!!" -foregroundcolor green
        
    }
    else {
        Write-Host "MDM enrollment url's are missing! Let me get my wrench and fix it for you!" -foregroundcolor red 
        New-ItemProperty -LiteralPath $path -Name 'MdmEnrollmentUrl' -Value 'https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc' -PropertyType String -Force -ea SilentlyContinue;
        New-ItemProperty -LiteralPath $path  -Name 'MdmTermsOfUseUrl' -Value 'https://portal.manage.microsoft.com/TermsofUse.aspx' -PropertyType String -Force -ea SilentlyContinue;
        New-ItemProperty -LiteralPath $path -Name 'MdmComplianceUrl' -Value 'https://portal.manage.microsoft.com/?portalAction=Compliance' -PropertyType String -Force -ea SilentlyContinue;

            
    }
}