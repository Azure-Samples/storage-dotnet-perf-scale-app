#------------------------------------------------------------------------------
#MIT License

#Copyright(c) 2017 Microsoft Corporation. All rights reserved.

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
#------------------------------------------------------------------------------

Start-Transcript
## Install .NET Core 2.0
Invoke-WebRequest "https://dot.net/v1/dotnet-install.ps1" -OutFile "./dotnet-install.ps1" 
./dotnet-install.ps1 -Channel 2.0 -InstallDir c:\dotnet

# Install Posh-Git
Write-host "Installing Posh-Git"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -force

# Install chocolately to be able to install git
Invoke-WebRequest 'https://chocolatey.org/install.ps1' -OutFile "./choco-install.ps1"
./choco-install.ps1

# Install Git with choco
choco install git -y

# clone the sample repo
New-Item -ItemType Directory -Path D:\git -Force
Set-Location D:\git
Write-host "cloning repo"
& 'C:\Program Files\git\cmd\git.exe' clone https://github.com/azure-samples/storage-dotnet-perf-scale-app

write-host "Changing directory to $((Get-Item -Path ".\" -Verbose).FullName)"
Set-Location D:\git\storage-dotnet-perf-scale-app

# Restore NuGet packages and build applocation
Write-host "restoring nuget packages"
c:\dotnet\dotnet.exe restore
c:\dotnet\dotnet.exe build

# Set the path for dotnet.
$OldPath=(Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path

$dotnetpath = "c:\dotnet"
IF(Test-Path -Path $dotnetpath)
{
$NewPath=$OldPath+';'+$dotnetpath
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $NewPath
}

# Configure the environment variable to store the connection string in.
if($args)
{
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name storageconnectionstring -Value "DefaultEndpointsProtocol=http;AccountName=$($args[0]);AccountKey=$($args[1]);EndpointSuffix=core.windows.net";
}

# Create 50 1GB files to be used for the sample
New-Item -ItemType Directory D:\git\storage-dotnet-perf-scale-app\upload
Set-Location D:\git\storage-dotnet-perf-scale-app\upload
Write-host "Creating files"
for($i=0; $i -lt 50; $i++)
{
$out = new-object byte[] 1073741824; 
(new-object Random).NextBytes($out); 
[IO.File]::WriteAllBytes("D:\git\storage-dotnet-perf-scale-app\upload\$([guid]::NewGuid().ToString()).txt", $out)
}

Stop-Transcript

