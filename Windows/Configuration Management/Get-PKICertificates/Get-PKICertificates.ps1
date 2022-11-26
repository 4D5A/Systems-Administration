<#
    .Synopsis
        Removes or adds a certificate.
    
    .Description
        Removes or adds a certificate in the location specified when the command is run.

    .Notes
        N/A
        
    .Example
        This example deletes a certificate by thumbprint.
        
        Get-PKICertificates -DeleteCertificate XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        
    .Example
        This example deletes a certificate by subject. CAUTION: This will delete all certificates that are like www.example.com. Please read https://technet.microsoft.com/en-us/library/hh847759.aspx for additional information on how PowerShell processes information compared with the -like operator.
        
        Get-PKICertificates -DeleteBySubject www.example.com
    
    .Example
        This example adds a certificate.
        
        Get-PKICertificates -AddCertificate "C:\folder\folder\certificate.cer"
        
    .Example
        This example replaces a cerficate using the subject to delete the certificate. CAUTION: This will delete all certificates that are like www.example.com. Please read https://technet.microsoft.com/en-us/library/hh847759.aspx for additional information on how PowerShell processes information compared with the -like operator.
        
        Get-PKICertificates -DeleteBySubject www.example.com -AddCertificate "C:\folder\folder\certificate.cer"
#>
    
Param(
    [parameter(Mandatory=$False)]
        [ValidateSet("CurrentUser","LocalMachine")]
        [String]$SystemStore,
    [parameter(Mandatory=$False)]
        [ValidateSet("AddressBook","AuthRoot","CertificateAuthority","Disallowed","My","Root","TrustedPeople","TrustedPublisher")]
        [String]$PhysicalStore,
    [parameter(Mandatory=$False)]
        [String]$DeleteCertificate,
    [parameter(Mandatory=$False)]
        [String]$DeleteBySubject,
    [parameter(Mandatory=$False)]
        [String]$AddCertificate
)

If(-Not($SystemStore)) {
    $SystemStore = "CurrentUser"
}

If(-Not($PhysicalStore)) {
    $PhysicalStore = "My"
}

If(-Not(($DeleteCertificate) -Or ($DeleteBySubject) -Or ($AddCertificate))) {
    $CertificateStore = New-Object System.Security.Cryptography.x509Certificates.x509Store $PhysicalStore,$SystemStore
    $CertificateStore.Open('ReadOnly')
    Get-ChildItem cert:\$SystemStore\$PhysicalStore
} Else {
    $CertificateStore = New-Object System.Security.Cryptography.x509Certificates.x509Store $PhysicalStore,$SystemStore
    $CertificateStore.Open('ReadWrite')
}

If ($DeleteCertificate) {
    $StoredCertificates = @(Get-ChildItem cert:\$SystemStore\$PhysicalStore | Where-Object { $_.Thumbprint -eq "$DeleteCertificate" })
    Foreach($Certificates in $StoredCertificates) {
        $CertificateStore.Remove($Certificates)
    }
}

If ($DeleteBySubject) {
    $StoredCertificates = @(Get-ChildItem cert:\$SystemStore\$PhysicalStore | Where-Object { $_.Subject -like "*$DeleteBySubject*" })
    ForEach($Certificates in $StoredCertificates) {
        $CertificateStore.Remove($Certificates)
    }
}    

If ($AddCertificate) {
    $CertificateStore.add($AddCertificate)
}

$CertificateStore.close()