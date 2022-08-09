$BitLockerProtectedVolumes =  Get-BitLockerVolume | Where-Object {($_.VolumeStatus -ne "FullyDecrypted") -AND ($_.KeyProtector -like "RecoveryPassword")}
Foreach ($BitLockerProtectedVolume in $BitLockerProtectedVolumes) {
$BitLockerKeyProtector = $BitLockerProtectedVolume.KeyProtector | Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"}
Write-Output $BitLockerKeyProtector
}