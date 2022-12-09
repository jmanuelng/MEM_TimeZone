<#
.SYNOPSIS
    Set timezone automatically.

.DESCRIPTION
    For use as remediation script in "Proactive Remediation" in Microsoft Intune.
    Fix Time zone automatically configured using location services when Autopilot has been setup to hide Privacy Settings.
    Full credit to Adam Gross (tw:@AdamGrossTX) and Ben Reader (tw:@powers_hell)

.NOTES
    
    Full credit to Adam Gross (tw:@AdamGrossTX) and Ben Reader (tw:@powers_hell), I didn't change a line.
    Soruce: https://github.com/IntuneTraining/TimezoneTurnOn

    You'll need this script (or similar) If you've setup Autopilot to skip privacy page.
    This script should be coupled with a Configuration Policy to enable Location Services in device. 
                System > Allow Location: Force Locatin On

    Read Micheal Niehaus's blog: https://oofhours.com/2020/08/11/time-time-time-and-location-services/
    Watch the following Intune Training's YT video: https://www.youtube.com/watch?v=49c1tVdzwVQ
    The original script: https://github.com/IntuneTraining/TimezoneTurnOn

    To allow granular control by app to user create a Configuration Profile to Privacy/LetAppsAccessGazeInput_UserInControlOfTheseApps
                Privacy > Let apps access location: Force Allow
                Privacy > Let apps access location User in control of these apps: <apps list, one app per line>
    MS Docs: https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-privacy#privacy-letappsaccesslocation


#>

#region Settings
$ServiceName = 'tzautoupdate'
$Action = 'Manual'
#endregion
#region Functions
Function Manage-Services {
    Param
    (
        [string]$ServiceName,
        [ValidateSet("Start", "Stop", "Restart", "Disable", "Auto", "Manual")]
        [string]$Action
    )

    try {
        Start-Transcript -Path "C:\Windows\Temp\$($ServiceName)_Management.Log" -Force -ErrorAction SilentlyContinue
        Get-Date
        $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        $service
        if ($service) {
            Switch ($Action) {
                "Start" { Start-Service -Name $ServiceName; Break; }
                "Stop" { Stop-Service -Name $ServiceName; Break; }
                "Restart" { Restart-Service -Name $ServiceName; Break; }
                "Disable" { Set-Service -Name $ServiceName -StartupType Disabled -Status Stopped; Break; }
                "Auto" { Set-Service -Name $ServiceName -StartupType Automatic -Status Running; Break; }
                "Manual" { Set-Service -Name $ServiceName -StartupType Manual -Status Running; Break; }
            }
            Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        }
        Stop-Transcript -ErrorAction SilentlyContinue
    }
    catch {
        throw $_
    }
}
#endregion

#region Process
try {
    Write-Host "Fixing TimeZone service statup type to MANUAL."
    Manage-Services -ServiceName $ServiceName -Action $Action
    Exit 0
}
catch {
    Write-Error $_.Exception.Message
}
#endregion