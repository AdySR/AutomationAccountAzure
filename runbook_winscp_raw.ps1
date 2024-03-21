# Import required modules
Import-Module Az.Accounts
Import-Module Az.Storage
Import-Module WinSCP

# Variables
$SftpServer = "sftp.example.com"
$SftpUsername = "your_username"
$SftpPassword = "your_password"
$RemotePath = "/remote/directory/path"
$LocalPath = "C:\Local\Directory\Path"
$AzureStorageAccountName = "your_storage_account_name"
$AzureStorageContainerName = "your_container_name"
$StorageContext = New-AzStorageContext -StorageAccountName $AzureStorageAccountName -StorageAccountKey "your_storage_account_key"

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
