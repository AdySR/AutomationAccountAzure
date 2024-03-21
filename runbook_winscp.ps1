
# Import required modules
Import-Module Az.Accounts
Import-Module Az.Storage
Import-Module WinSCP

$port = "22"
$Password = "k8CUT/G1oWzm+7l6Yz/NL0Zaq0t67ral"
$User = "dnaadydfsa.redoakcvs"
$hostName = "dnaadydfsa.blob.core.windows.net"
$SftpPath = '/landing_zone/'
 
#blob storage related variables
$container = "cvsprocess"
$blobFilePath = "raw_files/"
 


# Variables
$SftpServer =  "dnaadydfsa.blob.core.windows.net"
$SftpUsername = "dnaadydfsa.redoakcvs"
$SftpPassword = "k8CUT/G1oWzm+7l6Yz/NL0Zaq0t67ral"
$RemotePath = '/landing_zone/'

$LocalPath = "C:\Local\Directory\Path"
$AzureStorageAccountName = "dnaadydfsa"
$AzureStorageContainerName = "cvs"
$StorageContext = New-AzStorageContext -StorageAccountName $AzureStorageAccountName -StorageAccountKey "uyVzSUvq/TJafthIcrOELH67NRQrlU4kiuvPbapf0zYoJYK1+lyvzbqu92dK4aqA+DRM/RDwWbEl+ASti1ZhUg=="

# Set up SFTP session
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = $SftpServer
    UserName = $SftpUsername
    Password = $SftpPassword
}

$session = New-Object WinSCP.Session

try {
    # Connect to SFTP
    $session.Open($sessionOptions)
    
    # Get list of files in remote directory
    $files = $session.EnumerateRemoteFiles($RemotePath)

    foreach ($fileInfo in $files) {
        # Download each file
        $localFilePath = Join-Path -Path $LocalPath -ChildPath $fileInfo.Name
        $session.GetFiles(($RemotePath + "/" + $fileInfo.Name), $localFilePath).Check()
        
        # Upload file to Azure Storage
        Set-AzStorageBlobContent -File $localFilePath -Container $AzureStorageContainerName -Blob $fileInfo.Name -Context $StorageContext -Force
    }
} finally {
    # Disconnect SFTP session
    $session.Dispose()
}
