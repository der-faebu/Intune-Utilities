function Test-IMELog { 
    param(
        [string]$Thumbprint
    )
    $path = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\IntuneManagementExtension.log"
    If (Test-Path $path) { 
        $checklog = (Get-Content -Path $path -raw) -match "Add MdmDeviceCertificate $Thumbprint"
        if ($null -ne $checklog) {
            Write-Host "I guess you need to quit your job and go to the casino as the proper Intune certificate with $thumbprint is also mentioned in the IME" -foregroundcolor green
        }
        else {
            $checklogzero = Select-String -Path 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\IntuneManagementExtension.log' -Pattern "Find 0 MDM certificates"
            $firstline = $checklogzero | select-object -first 1         
            Write-Host "Ow my.. this is could not be a good thing... $firstline"  -foregroundcolor red 
        }
    }
    Else { Write-Host "Uhhhhh... the log is missing... it seems the IME is not installed"  -foregroundcolor red }
    Test-IMEService -Unattended:$Unattended
}