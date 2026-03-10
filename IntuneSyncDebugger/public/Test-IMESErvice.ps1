function Test-IMEService {
    param(
        [switch]$Unattended
    )
    Write-Host "`n"
    Write-Host "Determing if the IME service is succesfully installed" -foregroundcolor yellow
    $path = "C:\Program Files (x86)\Microsoft Intune Management Extension\Microsoft.Management.Services.IntuneWindowsAgent.exe"
    If (Test-Path $path) { 
        Write-Host "IntuneWindowsAgent.exe is available on the device"-foregroundcolor green
        Write-Host "Going to check if the IME service is installed" -foregroundcolor yellow
        $service = Get-Service -Name IntuneManagementExtension -ErrorAction SilentlyContinue
        if ($service.Length -gt 0) {
            Write-Host "jippie ka yee, the IME service seems to be installed!" -foregroundcolor green
        }
        else {
            Write-Host "Mmm okay.. The IME software isn't installed" -foregroundcolor red
        }
    }
    else {
        Write-Host "IntuneWindowsAgent.exe seems to be missing, checking if its even installed" -foregroundcolor red
        if ((Get-WmiObject -Class Win32_Product).caption -eq "Microsoft Intune Management Extension") { 
            Write-Host "jippie ka yee, the IME software seems to be installed!" -foregroundcolor green
        }
        else {
            Write-Host "Mmm okay.. The IME software isn't installed" -foregroundcolor red
            $decision = 0
            if (-not $Unattended) {
                $title = 'Fixing the IME'
                $question = 'Are you 100% sure you want to proceed?!!!!!'
                $choices = '&Yes', '&No'
                $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
            }
                
            if ($decision -eq 0) {
                $ProviderRegistryPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EnterpriseDesktopAppManagement\S-0-0-00-0000000000-0000000000-000000000-000\MSI"    
                $ProviderPropertyName = "CurrentDownloadUrl"        
                $ProviderPropertyValue = "*IntuneWindowsAgent.msi*"    
                $GUID = (Get-ChildItem -Path Registry::$ProviderRegistryPath -Recurse -ErrorAction SilentlyContinue | ForEach-Object { if ((Get-ItemProperty -Name $ProviderPropertyName -Path $_.PSPath -ErrorAction SilentlyContinue | Get-ItemPropertyValue -Name $ProviderPropertyName -ErrorAction SilentlyContinue) -like $ProviderPropertyValue) { $_ } }).pschildname | select-object -first 1                      
                $link = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\EnterpriseDesktopAppManagement\S-0-0-00-0000000000-0000000000-000000000-000\MSI\$GUID                    
                $link = $link.currentdownloadurl                    
                Invoke-WebRequest -Uri $link -OutFile 'IntuneWindowsAgent.msi'                    
                .\IntuneWindowsAgent.msi /quiet
            }
            else {
                Write-Host "`n"
                Write-Host 'You dont like me fixing it...? Fine...exiting now' -foregroundcolor red
                                            
            }                

        }

    }
}