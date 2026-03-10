function Update-CertificateStore { 
    param(
        [switch]$Unattended
    )
    $decision = 0
    if (-not $Unattended) {

        $title = 'Fixing missing Certificate in the System Store'
        $question = 'Are you sure you want to proceed?'
        $choices = '&Yes', '&No'
        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    }
                
    if ($decision -eq 0) {        
        $progressPreference = 'silentlyContinue'
        Write-Host "Exporting and Importing the Intune certificate to the proper Certificate Store" -foregroundcolor yellow
        Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/PSTools.zip' -OutFile 'pstools.zip'
        Expand-Archive -Path 'pstools.zip' -DestinationPath "$env:TEMP\pstools" -force
        #Move-Item -Path "$env:TEMP\pstools\psexec.exe" -force
        reg.exe ADD HKCU\Software\Sysinternals /v EulaAccepted /t REG_DWORD /d 1 /f | out-null
        Start-Process -windowstyle hidden -FilePath "$env:TEMP\pstools\psexec.exe" -ArgumentList '-s cmd /c "powershell.exe -ExecutionPolicy Bypass -encodedcommand JABjAGUAcgB0AGkAZgBpAGMAYQB0AGUAIAA9ACAARwBlAHQALQBDAGgAaQBsAGQASQB0AGUAbQAgAC0AUABhAHQAaAAgAEMAZQByAHQAOgBcAEMAdQByAHIAZQBuAHQAdQBzAGUAcgBcAE0AeQBcAAoAJABwAGEAcwBzAHcAbwByAGQAPQAgACIAcwBlAGMAcgBlAHQAIgAgAHwAIABDAG8AbgB2AGUAcgB0AFQAbwAtAFMAZQBjAHUAcgBlAFMAdAByAGkAbgBnACAALQBBAHMAUABsAGEAaQBuAFQAZQB4AHQAIAAtAEYAbwByAGMAZQAKAEUAeABwAG8AcgB0AC0AUABmAHgAQwBlAHIAdABpAGYAaQBjAGEAdABlACAALQBDAGUAcgB0ACAAJABjAGUAcgB0AGkAZgBpAGMAYQB0AGUAIAAtAEYAaQBsAGUAUABhAHQAaAAgAGMAOgBcAGkAbgB0AHUAbgBlAC4AcABmAHgAIAAtAFAAYQBzAHMAdwBvAHIAZAAgACQAcABhAHMAcwB3AG8AcgBkAAoASQBtAHAAbwByAHQALQBQAGYAeABDAGUAcgB0AGkAZgBpAGMAYQB0AGUAIAAtAEUAeABwAG8AcgB0AGEAYgBsAGUAIAAtAFAAYQBzAHMAdwBvAHIAZAAgACQAcABhAHMAcwB3AG8AcgBkACAALQBDAGUAcgB0AFMAdABvAHIAZQBMAG8AYwBhAHQAaQBvAG4AIABDAGUAcgB0ADoAXABMAG8AYwBhAGwATQBhAGMAaABpAG4AZQBcAE0AeQAgAC0ARgBpAGwAZQBQAGEAdABoACAAYwA6AFwAaQBuAHQAdQBuAGUALgBwAGYAeAA="'
    }
    else {
        Write-Host 'You dont like me fixing it...?Fine...exiting now' -foregroundcolor red
        if (-not $Unattended) {
            Read-Host -prompt "Press any key to continue..."
        }
        exit
    }
}    
