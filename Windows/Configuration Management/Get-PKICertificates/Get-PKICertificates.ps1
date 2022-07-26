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

#MIT License

#Copyright (c) 2022 4D5A

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

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
        [String]$BulkDelete,
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

If(-Not(($DeleteCertificate) -Or ($BulkDelete) -Or ($DeleteBySubject) -Or ($AddCertificate))) {
    $CertificateStore = New-Object System.Security.Cryptography.x509Certificates.x509Store $PhysicalStore,$SystemStore
    $CertificateStore.Open('ReadOnly')
    Get-ChildItem cert:\$SystemStore\$PhysicalStore
} ElseIf (-Not($BulkDelete)) {
    $CertificateStore = New-Object System.Security.Cryptography.x509Certificates.x509Store $PhysicalStore,$SystemStore
    $CertificateStore.Open('ReadWrite')
}

If ($DeleteCertificate) {
    $CertificatesforDeletion = @(Get-ChildItem cert:\$SystemStore\$PhysicalStore | Where-Object {$_.Thumbprint -eq "$DeleteCertificate"})
    Foreach($DeleteCertificate in $CertificatesforDeletion) {
        $CertificateStore.Remove($CertificatesforDeletion)
    }
    $CertificateStore.close()
}

If($BulkDelete) {
    $Certificates = Import-Csv -Path $BulkDelete -Header Thumbprint,SystemStore,PhysicalStore
    Foreach($Certificate in $Certificates) {
        $Thumbprint = $Certificate.Thumbprint
        $SystemStore = $Certificate.SystemStore
        $PhysicalStore = $Certificate.PhysicalStore
        $CertificateStore = New-Object System.Security.Cryptography.x509Certificates.x509Store $PhysicalStore,$SystemStore
        $CertificateStore.Open('ReadWrite')
        $CertificatesforDeletion = Get-ChildItem cert:\$SystemStore\$PhysicalStore | Where-Object {$_.Thumbprint -eq "$Thumbprint"}
        If($CertificatesforDeletion) {
            $CertificateStore.Remove($CertificatesforDeletion)
        }
        $CertificateStore.close()
        $null = $CertificateStore
        $null = $Certificate
        $null = $Thumbprint
        $null = $SystemStore
        $null = $PhysicalStore
        $null = $CertificatesforDeletion
        $null = $DeleteCertificate
    }
    Get-ChildItem cert:\$SystemStore\$PhysicalStore
}

If ($DeleteBySubject) {
    $CertificatesforDeletion = @(Get-ChildItem cert:\$SystemStore\$PhysicalStore | Where-Object {$_.Subject -like "*$DeleteBySubject*"})
    $CertificatesforDeletion
    $DeleteBySubjectAnswer = Read-Host "CAUTION: This will delete all certificates that include a Subject that is '-like *$DeleteBySubject*'. Please read https://technet.microsoft.com/en-us/library/hh847759.aspx for additional information on how PowerShell processes information compared with the -like operator. Do you want to delete these resulting certificates? (Yes/No)"
    If($DeleteBySubjectAnswer -like "Yes") {
        ForEach($DeleteCertificate in $CertificatesforDeletion) {
            $CertificateStore.Remove($DeleteCertificate)
        }
    }
    $CertificateStore.close()
}    

If ($AddCertificate) {
    $CertificateStore.Add($AddCertificate)
    $CertificateStore.close()
}

$null = $SystemStore
$null = $PhysicalStore
$null = $DeleteCertificate
$null = $BulkDelete
$null = $DeleteBySubject
$null = $AddCertificate
$null = $CertificateStore
$null = $CertificatesforDeletion
$null = $StoredCertificate
$null = $Certificates
$null = $Certificate
$null = $Thumbprint