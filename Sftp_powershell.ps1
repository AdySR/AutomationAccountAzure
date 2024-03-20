$port = "22"
$Password = "k8CUT/G1oWzm+7l6Yz/NL0Zaq0t67ral"
$User = "dnaadydfsa.redoakcvs"
$hostName = "dnaadydfsa.blob.core.windows.net"
$SftpPath = '/landing_zone/'
 
#blob storage related variables
# $container = "cvs"
# $blobFilePath = "cvs/landingzone"
 
#get connection setup
$account = Connect-AzAccount -Identity -Confirm:$false | Out-Null
write-output $account
 
    try {
        $accKey = (Get-AzStorageAccountKey -ResourceGroupName "CentricDnATraining" -Name "dnaadydfsa")[0].Value
        $context_storageAcct = New-AzStorageContext -StorageAccountName "dnaadydfsa" -StorageAccountKey $accKey
        write-output $context_storageAcct
    }
    catch {
        $errors += [PSCustomObject]@{Item = "azcontext"; Error = $_.Exception }
        write-output "error get AZcontext"
    }
 
#sftp setup
$secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($User, $secpasswd)
 
write-output "====== Starting SFTP Session on $($hostName)"
$ssh = New-SFTPSession -ComputerName $hostName -Credential $Credentials -Port $port -Force -Verbose
write-output "   +++ SFTP Session started on $($hostName)"
 
#get files from sftp
$listOfFiles = Get-SFTPChildItem -SessionId $ssh.SessionId -Path $SftpPath
write-output $listOfFiles

# $filteredFiles = @($listOfFiles | Where-Object { $_.Attributes.Size -gt 0 })
 
# foreach ($file in $filteredFiles) {
 
#     try {
         
#         $blobPath = $($blobFilePath + "/" + $file.Name)
#         $localFolderBase = [System.Io.Path]::GetFileNameWithoutExtension($file.Name)
#         $localFolder = $($env:temp + "\" + $localFolderBase)
#         $fileToCopy = $($localFolder + "\" + $file.Name)
 
#         #create new folder to hold the downloaded file
#         New-Item -Path $localFolder -ItemType Directory -Force -Confirm:$false | Out-Null
 
#         #download file to local storage
#         Get-SFTPFile -SessionId $ssh.SessionId -RemoteFile $file.FullName -LocalPath $localFolder
         
#         #move file to container
#         Set-AzStorageBlobContent -File $fileToCopy -Container $container -Blob $blobPath -StandardBlobTier Cool -Context $context_storageAcct.Context -Force -Confirm:$false
 
#         #check if file was saved to the container
#         $blob = Get-AzStorageBlob -Blob $blobPath -Container $container -Context $context_storageAcct.Context -ErrorAction Ignore
#         if ($blob)
#         {
#             Write-output "Blob can be removed from SFTP"
#             Remove-SFTPItem -SessionId $ssh.SessionId -path  $file.FullName -Force
#         }
#     }
#     catch {
#         write-output $_.Exception
#     }
# }
 
# #terminate the SFTP session
# Remove-SFTPSession -SessionId $ssh.SessionID
