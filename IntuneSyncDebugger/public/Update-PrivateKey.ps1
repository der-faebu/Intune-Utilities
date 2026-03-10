function Update-PrivateKey {       
    param(
        [switch]$Unattended
    )          
    $decision = 0
    if (-not $Unattended) {
        $title = 'Intune Private Key'
        $question = 'Are you sure you want to fix the private key missing??'
        $choices = '&Yes', '&No'
        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    }
                
    if ($decision -eq 0) {
        Write-Host "List certificates without private key: " -NoNewline
        $certsWithoutKey = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.HasPrivateKey -eq $false }
                            
        if ($certsWithoutKey) {
            Write-Host "V" -ForegroundColor Green
            $Choice = $certsWithoutKey | Select-Object Subject, Issuer, NotAfter, ThumbPrint | Out-Gridview -Passthru
                                    
            if ($Choice) {
                Write-Host "Search private key for $($Choice.Thumbprint): " -NoNewline
                $Output = certutil -repairstore my "$($Choice.Thumbprint)"
                $Result = [regex]::match($output, "CertUtil: (.*)").Groups[1].Value
                                        
                if ($Result -eq '-repairstore command completed successfully.') {
                    Write-Host "V" -ForegroundColor Green
                }
                else {
                    Write-Host $Result -ForegroundColor Red
                }
            }
            else {
                Write-Host "No choice was made." -ForegroundColor DarkYellow
            }
        }
        else {
            Write-Host "There were no certificates found without private key." -ForegroundColor DarkYellow
        }
    }
    else {
        if (-not $Unattended) {
            Write-Host 'You cancelled the fix... why?' -foregroundcolor red
            Write-Host "Press any key to continue..."
            $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        exit 1
    }
}
