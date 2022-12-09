<#
.SYNOPSIS
    Detect if tzautoupdate service is set to Manual.

.DESCRIPTION
    For use as detection script in "Proactive Remediation" in Microsoft Intune.
    Detects if the Time Zone Service start typs is set to "Manual"
    Detection script, part of Proactive Remediatio to fix Time zone automatically.
    Full credit to Adam Gross (tw:@AdamGrossTX) and Ben Reader (tw:@powers_hell)

.NOTES
    
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

$ServiceName = 'tzautoupdate'
$Action = 'Manual'
$Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

If ($service.StartType -eq $Action) {
    Write-Host "$ServiceName is already configured correctly."
    Exit 0
}
else {
    Write-Warning "$ServiceName is not configured correctly."
    Exit 1
}