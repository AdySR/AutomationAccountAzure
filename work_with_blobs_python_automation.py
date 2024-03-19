print('hello')
# from azure.storage.blob import BlobServiceClient
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient


# import os, random
# from azure.identity import AzureCliCredential
# from azure.mgmt.resource import ResourceManagementClient
# from azure.mgmt.storage import StorageManagementClient
# credential = AzureCliCredential()

# subscription_id = "4cc4444c-ad82-4f77-a7de-4e1177a07a92"
# resource_client = ResourceManagementClient(credential, subscription_id)
# RESOURCE_GROUP_NAME = "CentricDnATraining"
# LOCATION = "East US"

# import requests



connection_string = "DefaultEndpointsProtocol=https;AccountName=dnaadydfsa;AccountKey=__=="
blob_service_client = BlobServiceClient.from_connection_string(connection_string)

container_client=blob_service_client.get_container_client('default')

# blobs = container_client.list_blobs( )
# for blob in blobs:
#     print(blob.name)




print("moving files . .")

def move_file(source_container_name, source_blob_name, destination_container_name, destination_blob_name, connection_string):
    
    blob_service_client = BlobServiceClient.from_connection_string(connection_string)

    source_blob_client = blob_service_client.get_blob_client(container=source_container_name, blob=source_blob_name)
    destination_blob_client = blob_service_client.get_blob_client(container=destination_container_name, blob=destination_blob_name)

    print("Start the copy process")
    destination_blob_client.start_copy_from_url(source_blob_client.url)

    print("Delete the source blob after copy")
    source_blob_client.delete_blob()



source_container = "default"
source_blob = "sftp_shared_cah/qq.txt"
destination_container = "default"
destination_blob = "processed_cah/qq.txt"

move_file(source_container, source_blob, destination_container, destination_blob, connection_string)

# adf_webhook_url = "https://ed908413-571b-4fb0-881b-36da2dae71cc.webhook.eus.azure-automation.net/webhooks?token=KKZdObypKN1mWlHus8nQK7x3XTMSXVdI9XmLKVpCS6U%3d"
# headers = {"Content-Type": "application/json"}
# body = {"status": status}


# response = requests.post(adf_webhook_url, json=body, headers=headers)

# if response.status_code == 200:
#     print("ADF webhook status updated successfully.")
# else:
#     print(f"Failed to update ADF webhook status. Status code: {response.status_code}, Response: {response.text}")


    

# import logging
# import azure.functions as func
# from azure.storage.blob import BlobServiceClient
# import zipfile
# import os

# blob_service_client = BlobServiceClient.from_connection_string(connect_str)
# dir_path = r'<PATH_OF_EXTRACTED_FILES>'

# def main(myblob: func.InputStream):
#     logging.info(f"Python blob trigger function processed blob \n"
#                  f"Name: {myblob.name}\n"
#                  f"Blob Size: {myblob.length} bytes")

#     container_client = blob_service_client.get_container_client("<INPUT_BLOB_CONTAINER>")
#     blob_client = container_client.get_blob_client("<ZIP_FILE_NAME>")

#     // Downloading Zip to local system
#     with open("sample1.zip", "wb") as my_blob:
#         download_stream = blob_client.download_blob()
#         my_blob.write(download_stream.readall())
        
#     // Extracting Zip Folder to path
#     with zipfile.ZipFile("sample1.zip", 'r') as zip_ref:
#         zip_ref.extractall(dir_path)
        
#     // Reading and uploading Files to Storage account
#     fileList = os.listdir(dir_path)
#     for filename in fileList:
#         container_client_upload = blob_service_client.get_container_client("<OUTPUT_BLOB_CONTAINER>")
#         blob_client_upload = container_client_upload.get_blob_client(filename)

#         f = open(dir_path+'\\'+filename, 'r')
#         byt = f.read()
#         blob_client_upload.upload_blob(byt, blob_type="BlockBlob")
