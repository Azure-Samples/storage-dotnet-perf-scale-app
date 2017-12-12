---
services: storage
platforms: dotnet
author: georgewallace
---

# Azure Storage Performance and Scalability Test

This is an <a href="http://azure.microsoft.com/en-us/services/storage/">Azure storage</a> demo that creates a DS14v2 virtual machine with 50 1GB random files that are uploaded and downloaded to a storage account to showcase scalability and performance when using the Azure storage SDK.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fgeorgewallace%2Fstorage-dotnet-perf-scale-app%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

1. Click Deploy button to deploy the sample to a Windows VM on Azure
2. Once deployment is completed, connect to the VM via RDP using the administrator account you defined. You will have 50 files each 1GB on the D: drive as sample data.
3. Navigate to the sample application in D:\git\storage-dotnet-perf-scale-app
`cd d:\git\storage-dotnet-perf-scale-app`
4. Run the application to upload the files to Azure Storage from the folder
`dotnet run`
5. By default the download and delete capabilities are commented out.  To run them uncomment the `// DownloadFilesAsync().GetAwaiter().GetResult();` and `// DeleteExistingContainersAsync().GetAwaiter().GetResult();` lines for in the Main method.
6. Re-build the application by running `dotnet build`.
7. Re-run the application by running `dotnet run`

When done with the sample, remember to delete the VM and resource group to ensure you do not continue to get charged.
