function Get-Schedule1 {
    param (
        [string]$EnrollmentId
    )

    Write-Host "Almost finished, checking if the EnterpriseMgmt task is running to start the sync!" -ForegroundColor Yellow

    # Define the full task path
    $taskPath = "\Microsoft\Windows\EnterpriseMgmt\$EnrollmentId*"

    # Retrieve the specific scheduled task
    $task = Get-ScheduledTask | 
    Where-Object { $_.TaskName -eq 'Schedule #1 created by enrollment client' -and $_.TaskPath -like $taskPath }

    if ($null -eq $task) {
        Write-Host "Enrollment task doesn't exist for Enrollment ID $EnrollmentId" -ForegroundColor Red
        return
    }

    # Check the state of the specific task
    $taskState = $task.State

    if ($taskState -eq 'Running') {
        Write-Host "`n"
        Write-Host "Enrollment task is running! It looks like I fixed your sync issues. I guess you owe me a beer now!" -ForegroundColor Green
            
        if (-not $Unattended) {
            $Form.ShowDialog()
        }
    }
    elseif ($taskState -eq 'Ready') {
        Write-Host "Enrollment task is ready!!!" -ForegroundColor Green
    }
    else {
        Write-Host "Enrollment task is in an unexpected state: $taskState" -ForegroundColor Yellow
    }
}