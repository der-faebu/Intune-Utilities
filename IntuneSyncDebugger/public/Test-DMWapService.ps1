function Test-DMWapService {
    Write-Host "`n"
    Write-Host "Determing if the dmwappushservice is running because we don't want to end up with no endpoints left to the endpointmapper" -foregroundcolor yellow
    $ServiceName = "dmwappushservice"
    $ServiceStatus = (Get-Service -Name $ServiceName).status
    if ($ServiceStatus -eq "Running") {
        Write-Host "I am happy...! The DMWAPPUSHSERVICE is Running!" -foregroundcolor green
    }
    else {
        Write-Host "The DMWAPPUSHSERVICE isn't running, let's kickstart that damn service to speed up the enrollment! " -foregroundcolor red
        Start-Service $Servicename -ErrorAction SilentlyContinue    
    }
}