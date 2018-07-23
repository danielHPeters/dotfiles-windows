# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}


### Update Help for Modules
Write-Host "Updating Help..." -ForegroundColor "Yellow"
Update-Help -Force


### Package Providers
Write-Host "Installing Package Providers..." -ForegroundColor "Yellow"
Get-PackageProvider NuGet -Force | Out-Null
# Chocolatey Provider is not ready yet. Use normal Chocolatey
#Get-PackageProvider Chocolatey -Force
#Set-PackageSource -Name chocolatey -Trusted


### Install PowerShell Modules
Write-Host "Installing PowerShell Modules..." -ForegroundColor "Yellow"
Install-Module PSWindowsUpdate -Scope CurrentUser -Force


### Chocolatey
Write-Host "Installing Desktop Utilities..." -ForegroundColor "Yellow"
if ((which cinst) -eq $null) {
    iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    iex (new-object net.webclient).DownloadDtring('https://get.scoop.sh')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

# system and cli
scoop install pshazz
scoop install gcc
choco install curl                --limit-output
choco install wget                --limit-output
choco install nuget.commandline   --limit-output
choco install webpi               --limit-output
choco install ack                 --limit-output
choco install grep                --limit-output
choco install git.install         --limit-output -params '"/GitAndUnixToolsOnPath"'
choco install gpg4win             --limit-output
choco install nvm.portable        --limit-output
choco install ruby                --limit-output
choco install groovy              --limit-output
choco install kotlin              --limit-output
choco install gradle              --limit-output
choco install androidstudio       --limit-output
choco install zulu                --limit-output #Openjdk
choco install freepascal          --limit-output
choco install strawberryperl      --limit-output
choco install nodejs              --limit-output
choco install php                 --limit-output

# browsers
choco install googlechrome        --limit-output
choco install firefox             --limit-output
choco install opera               --limit-output
choco install vivaldi             --limit-output

# dev tools and frameworks
choco install vscode              --limit-output
choco install vim                 --limit-output
choco install winmerge            --limit-output
choco install grails              --limit-output
choco install vagrant             --limit-output
choco install scenebuilder9       --limit-output

# other programs
choco install vlc                 --limit-output
choco install foobar2000          --limit-output
choco install skype               --limit-output
choco install filezilla           --limit-output
choco install geogebra            --limit-output

Refresh-Environment

nvm on
nvm install --lts

gem pristine --all --env-shebang


### Windows Features
Write-Host "Installing Windows Features..." -ForegroundColor "Yellow"
# IIS Base Configuration
Enable-WindowsOptionalFeature -Online -All -FeatureName `
    "IIS-BasicAuthentication", `
    "IIS-DefaultDocument", `
    "IIS-DirectoryBrowsing", `
    "IIS-HttpCompressionDynamic", `
    "IIS-HttpCompressionStatic", `
    "IIS-HttpErrors", `
    "IIS-HttpLogging", `
    "IIS-ISAPIExtensions", `
    "IIS-ISAPIFilter", `
    "IIS-ManagementConsole", `
    "IIS-RequestFiltering", `
    "IIS-StaticContent", `
    "IIS-WebSockets", `
    "IIS-WindowsAuthentication" `
    -NoRestart | Out-Null

# ASP.NET Base Configuration
Enable-WindowsOptionalFeature -Online -All -FeatureName `
    "NetFx3", `
    "NetFx4-AdvSrvs", `
    "NetFx4Extended-ASPNET45", `
    "IIS-NetFxExtensibility", `
    "IIS-NetFxExtensibility45", `
    "IIS-ASPNET", `
    "IIS-ASPNET45" `
    -NoRestart | Out-Null

# Web Platform Installer for remaining Windows features
webpicmd /Install /AcceptEula /Products:"UrlRewrite2"
#webpicmd /Install /AcceptEula /Products:"NETFramework452"
webpicmd /Install /AcceptEula /Products:"Python279"

### Node Packages
Write-Host "Installing Node Packages..." -ForegroundColor "Yellow"
if (which npm) {
    npm install -g npm
    npm install -g gulp
    npm install -g mocha
    npm install -g chai
	npm install -g nodemon
	npm install -g @angular/cli
	npm install -g express-generator
	npm install -g typescript
    npm install -g coffeescript
    npm install -g create-react-native-app
}

### Janus for vim
Write-Host "Installing Janus..." -ForegroundColor "Yellow"
if ((which curl) -and (which vim) -and (which rake) -and (which bash)) {
    curl.exe -L https://bit.ly/janus-bootstrap | bash
}


### Visual Studio Plugins
if (which Install-VSExtension) {
    ### Visual Studio 2015
    # VsVim
    # Install-VSExtension https://visualstudiogallery.msdn.microsoft.com/59ca71b3-a4a3-46ca-8fe1-0e90e3f79329/file/6390/57/VsVim.vsix
    # Productivity Power Tools 2015
    # Install-VSExtension https://visualstudiogallery.msdn.microsoft.com/34ebc6a2-2777-421d-8914-e29c1dfa7f5d/file/169971/1/ProPowerTools.vsix

    ### Visual Studio 2013
    # VsVim
    # Install-VSExtension https://visualstudiogallery.msdn.microsoft.com/59ca71b3-a4a3-46ca-8fe1-0e90e3f79329/file/6390/57/VsVim.vsix
    # Productivity Power Tools 2013
    # Install-VSExtension https://visualstudiogallery.msdn.microsoft.com/dbcb8670-889e-4a54-a226-a48a15e4cace/file/117115/4/ProPowerTools.vsix
    # Web Essentials 2013
    # Install-VSExtension https://visualstudiogallery.msdn.microsoft.com/56633663-6799-41d7-9df7-0f2a504ca361/file/105627/47/WebEssentials2013.vsix
}
