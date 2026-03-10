function Start-IntuneSync {
    $tasks = Get-ScheduledTask |
    Where-Object {
        $_.TaskPath -like "\Microsoft\Windows\EnterpriseMgmt\*" -and
        $_.TaskName -eq "PushLaunch"
    }

    if (-not $tasks) {
        Write-Error "PushLaunch task not found. Device may not be MDM-enrolled or tasks are missing."
    }

    foreach ($t in $tasks) {
        Start-ScheduledTask -TaskName $t.TaskName -TaskPath $t.TaskPath
        Write-Host "Started $($t.TaskPath)$($t.TaskName)"
    }
} 