# from azure.storage.blob import BlobService

def copy_azure_files(self):

        blob_service = BlobService(account_name='dnaadydfsa', account_key='uyVzSUvq/TJafthIcrOELH67NRQrlU4kiuvPbapf0zYoJYK1+lyvzbqu92dK4aqA+DRM/RDwWbEl+ASti1ZhUg==')
        blob_name = 'file (9).txt'
        copy_from_container = 'cvsprocess'
        copy_to_container = 'cvsprocess'

        blob_url = blob_service.make_blob_url(copy_from_container, blob_name)
        # blob_url:https://demostorage.blob.core.windows.net/image-container/pretty.jpg

        blob_service.copy_blob(copy_to_container, blob_name, blob_url)

        #for move the file use this line
        blob_service.delete_blob(copy_from_container, blob_name)



# copy_azure_files()




from azure.storage.blob import BlobServiceClient

# Azure
# Get this from Settings/Access keys in your Storage account on Azure portal
account_name = "dnaadydfsa"
connection_string = "DefaultEndpointsProtocol=https;AccountName=dnaadydfsa;AccountKey=uyVzSUvq/TJafthIcrOELH67NRQrlU4kiuvPbapf0zYoJYK1+lyvzbqu92dK4aqA+DRM/RDwWbEl+ASti1ZhUg==;EndpointSuffix=core.windows.net"


# Source
source_container_name = "cvsprocess"
source_file_path = "raw_files/file (8).txt"
blob_service_client = BlobServiceClient.from_connection_string(connection_string)
source_blob = (f"https://{account_name}.blob.core.windows.net/{source_container_name}/{source_file_path}")

# Target
target_container_name = "cvsprocess"
target_file_path = "processed_files/file (8).txt"
copied_blob = blob_service_client.get_blob_client(target_container_name, target_file_path)
copied_blob.start_copy_from_url(source_blob)

# If you would like to delete the source file
# remove_blob = blob_service_client.get_blob_client(source_container_name, source_file_path)
# remove_blob.delete_blob()


# azure_remote_path = "sftplanding/cah"
# azure_sftp_host = "dnaadydfsa.blob.core.windows.net"
# azure_sftp_username = "ady"
# azure_sftp_password = "RYJQ3BdmuxChMdNynaUiSxWDaBJPh2wx"

# local_download_path = "/path/to/local/directory"

# # Call the function to download files
# download_files_from_sftp(azure_sftp_host, azure_sftp_username, azure_sftp_password, azure_remote_path, local_download_path)





# $sourceResourceGroup = "CentricDnATraining"
# $sourceStorageAccountName = "dnaadydfsa"
# $sourceContainerName = "cvsprocess"
# $sourceFolder = "raw_files"

# $destinationResourceGroup = "CentricDnATraining"
# $destinationStorageAccountName = "dnaadydfsa"
# $destinationContainerName = "cvsprocess"
# $destinationFolder = "processed_files"
