$subscription = "Pay-As-You-Go"
Connect-AzAccount -Identity

Set-AzContext -Subscription $subscription

#Wrap authentication in retry logic 
$logonAttempt = 0
while(!($connectionResult) -And ($logonAttempt -le 5))
{
$LogonAttempt++
$connectionResult =   Connect-AzAccount -Identity
Start-Sleep -Seconds 1
}
 
#Setting Context to correct subscription
Write-Output "test1"

Set-AzContext -Subscription $subscription




Import-Module Az
$azStorageAccountName = "defaultadlsgen2num1" # Name of your storage account 
$azStorageAccountKey = "++wbZ0/YMmhQ9z/o3Fkd2B+==" # Access key for your storage account
$azContainerName = "sftpshared" # Container name to list your blobs
$azResourceGroupName = "default-rg" # Resource group name where storage account lives

$connectionContext = (Get-AzStorageAccount -ResourceGroupName $azResourceGroupName -AccountName $azStorageAccountName).Context
# Get a list of containers in a storage account
Get-AzStorageContainer -Name $azContainerName -Context $connectionContext | Select Name
# Get a list of blobs in a container 
Get-AzStorageBlob -Container $azContainerName -Context $connectionContext | Select Name
