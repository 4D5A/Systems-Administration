$Filename = "Installed Software Report_$($env:COMPUTERNAME)_$(Get-Date -Format ddMMyyyy).txt"
New-Item -Path "$Filename"
Add-Content -Path "$Filename" -Value "Installed Software"
Add-Content -Path "$Filename" -Value "Report created from $env:COMPUTERNAME"
Add-Content -Path "$Filename" -Value "Report created on $(Get-Date -Format ddMMyyyy_HHmmss)"
Remove-Item variable:Content
$Content = @()
If ([System.Environment]::Is64BitOperatingSystem -eq $True) {
    $InstalledSoftwarePerMachine32BitArray = Get-ChildItem "HKLM:SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    ForEach($InstalledSoftwarePerMachine32Bit in $InstalledSoftwarePerMachine32BitArray) {
        $DisplayName = $InstalledSoftwarePerMachine32Bit.GetValue('DisplayName')
        $DisplayVersion = $InstalledSoftwarePerMachine32Bit.GetValue('DisplayVersion')
        $InstallRange = "Per Machine"
        $SoftwareArchitecture = "32 Bit"
        $InstalledAsUser = ""
        If ($null -ne ($DisplayName)) {
            $Content += [pscustomobject]@{DisplayName = $DisplayName; DisplayVersion = $DisplayVersion; SoftwareArchitecture = $SoftwareArchitecture; InstallRange = $InstallRange; InstalledAsUser = $InstalledAsUser}
        }
    }
    $InstalledSoftwarePerMachine64BitArray = Get-ChildItem "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    ForEach($InstalledSoftwarePerMachine64Bit in $InstalledSoftwarePerMachine64BitArray) {
        $DisplayName = $InstalledSoftwarePerMachine64Bit.GetValue('DisplayName')
        $DisplayVersion = $InstalledSoftwarePerMachine64Bit.GetValue('DisplayVersion')
        $InstallRange = "Per Machine"
        $SoftwareArchitecture = "64 Bit"
        $InstalledAsUser = ""
        If ($null -ne ($DisplayName)) {
            $Content += [pscustomobject]@{DisplayName = $DisplayName; DisplayVersion = $DisplayVersion; SoftwareArchitecture = $SoftwareArchitecture; InstallRange = $InstallRange; InstalledAsUser = $InstalledAsUser}
        }
    }
    $InstalledSoftwarePerUser64BitArray = Get-ChildItem "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    ForEach($InstalledSoftwarePerUser64Bit in $InstalledSoftwarePerUser64BitArray) {
        $DisplayName = $InstalledSoftwarePerUser64Bit.GetValue('DisplayName')
        $DisplayVersion = $InstalledSoftwarePerUser64Bit.GetValue('DisplayVersion')
        $InstallRange = "Per User"
        $SoftwareArchitecture = "64 Bit"
        $InstalledAsUser = "$env:USERNAME"
        If ($null -ne ($DisplayName)) {
            $Content += [pscustomobject]@{DisplayName = $DisplayName; DisplayVersion = $DisplayVersion; SoftwareArchitecture = $SoftwareArchitecture; InstallRange = $InstallRange; InstalledAsUser = $InstalledAsUser}
        }
    }
}
If ([System.Environment]::Is64BitOperatingSystem -eq $False) {
    $InstalledSoftwarePerMachine32BitArray = Get-ChildItem "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    ForEach($InstalledSoftwarePerMachine32Bit in $InstalledSoftwarePerMachine32BitArray) {
        $DisplayName = $InstalledSoftwarePerMachine32Bit.GetValue('DisplayName')
        $DisplayVersion = $InstalledSoftwarePerMachine32Bit.GetValue('DisplayVersion')
        $InstallRange = "Per Machine"
        $SoftwareArchitecture = "32 Bit"
        $InstalledAsUser = ""
        If ($null -ne ($DisplayName)) {
            $Content += [pscustomobject]@{DisplayName = $DisplayName; DisplayVersion = $DisplayVersion; SoftwareArchitecture = $SoftwareArchitecture; InstallRange = $InstallRange; InstalledAsUser = $InstalledAsUser}
        }
    }
    $InstalledSoftwarePerMachine32BitArray = Get-ChildItem "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    ForEach($InstalledSoftwarePerMachine32Bit in $InstalledSoftwarePerMachine32BitArray) {
        $DisplayName = $InstalledSoftwarePerMachine32Bit.GetValue('DisplayName')
        $DisplayVersion = $InstalledSoftwarePerMachine32Bit.GetValue('DisplayVersion')
        $InstallRange = "Per User"
        $SoftwareArchitecture = "32 Bit"
        $InstalledAsUser = "$env:USERNAME"
        If ($null -ne ($DisplayName)) {
            $Content += [pscustomobject]@{DisplayName = $DisplayName; DisplayVersion = $DisplayVersion; SoftwareArchitecture = $SoftwareArchitecture; InstallRange = $InstallRange; InstalledAsUser = $InstalledAsUser}
        }
    }
}
Add-Content -Path "$Filename" -Value ($Content | Sort-Object -Property @{Expression = "SoftwareArchicture"; Descending = $True}, @{Expression = "DisplayName"; Descending = $False} | Format-Table | Out-String -Width 300)