# Script: Windows-Setup.ps1
# Purpose: Automated setup for new Windows instances
# Author: Juan Manuel Rey @jreypo
# Last Updated: 2025-06-06
# Description: Installs essential tools, configures WSL2, Docker, VS Code extensions, and Azure CLI with logging and idempotency.

#Requires -RunAsAdministrator
param(
    [switch]$SkipWSL = $false,
    [switch]$SkipDocker = $false,
    [switch]$SkipVSCodeExtensions = $false,
    [switch]$NoPrompt = $false
)

$LogFile = "$PSScriptRoot\Windows-Setup.log"
function Log {
    param([string]$Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    "$timestamp $Message" | Tee-Object -FilePath $LogFile -Append
}

Log "--- Windows-Setup.ps1 started ---"

# Define the list of applications to install
$applications = @(
    "Microsoft.VisualStudioCode",
    "Mozilla.Firefox",
    "7zip.7zip",
    "Microsoft.Git",
    "Microsoft.PowerToys",
    "Python.Python.3.13",
    "SourceFoundry.HackFonts",
    "PuTTY.PuTTY",
    "Microsoft.Edit",
    "Microsoft.Windbg",
    "Microsoft.Sysinternals",
    "WinSCP.WinSCP",
    "9PGCV4V3BK4W", # DevToys
    "Postman.Postman",
    "httpie.httpie",
    "GitHub.cli",
    "Microsoft.Bicep"
)

# Function to check if an app is already installed via winget
function Is-AppInstalled {
    param([string]$AppId)
    $result = winget list --id $AppId 2>$null
    return ($result -match $AppId)
}

# Function to install applications using winget
function Install-Applications {
    foreach ($app in $applications) {
        if (Is-AppInstalled $app) {
            Log "$app already installed. Skipping."
        } else {
            try {
                Log "Installing $app..."
                winget install --id $app --exact --silent
                Log "$app installed successfully."
            } catch {
                Write-Error "Failed to install $app. Error: $_"
                Log "Failed to install $app. Error: $_"
            }
        }
    }
}


# Install WSL2
function Install-WSL {
    if (Get-Command wsl -ErrorAction SilentlyContinue) {
        Log "WSL already installed. Skipping."
        return
    }
    try {
        Write-Host "Installing WSL2..."
        wsl --install
        Write-Host "WSL2 installed successfully."
        Log "WSL2 installed successfully."
    } catch {
        Write-Host "Failed to install WSL2. Error: $_"
        Log "Failed to install WSL2. Error: $_"
    }
}

# insttall VS Code extensions
function Install-VSCodeExtensions {
    $extensions = @(
        "ms-python.python",
        "ms-azuretools.azure-dev",
        "ms-azuretools.vscode-docker",
        "ms-azuretools.vscode-azurefunctions",
        "ms-azuretools.vscode-azurestorage",
        "ms-azuretools.vscode-bicep",
        "ms-azuretools.vscode-ansible",
        "ms-azuretools.vscode-kubernetes-tools",
        "ms-azuretools.vscode-azureappservice",
        "ms-azuretools.vscode-virtual-machines",
        "ms-azuretools.vscode-azurestaticwebapps",
        "ms-azuretools.vscode-azurecontainerapps",
        "ms-azuretools.vscode-azure-github-copilot",
        "ms-azuretools.azure-dev",
        "ms-azuretools.vscode-azureresourcegroups",
        "ms-vscode-remote.vscode-remote-extensionpack",
        "ms-windows-ai-studio.windows-ai-studio",
        "ms-toolsai.jupyter",
        "ms-toolsai.jupyter-keymap",
        "ms-toolsai.jupyter-renderers",
        "ms-vscode.azure-repos",
        "ms-vscode.azure-pipelines",
        "ms-vscode.cpptools",
        "ms-vscode.csharp",
        "ms-dotnettools.csharp",
        "teamsdevapp.vscode-ai-foundry",
        "ms-vscode.powershell",
        "github.github-vscode-theme",
        "github.vscode-pull-request-github",
        "github.copilot-chat",
        "github.copilot",
        "hashicorp.terraform",
        "hashicorp.hcl",
        "redhat.vscode-yaml"
    )
    $installed = code --list-extensions
    foreach ($ext in $extensions) {
        if ($installed -contains $ext) {
            Log "VS Code extension $ext already installed. Skipping."
        } else {
            try {
                Log "Installing VS Code extension: $ext..."
                code --install-extension $ext
                Log "$ext installed successfully."
            } catch {
                Write-Error "Failed to install VS Code extension $ext. Error: $_"
                Log "Failed to install VS Code extension $ext. Error: $_"
            }
        }
    }
}

# Main script execution

# Check if winget is available
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Log "winget is available. Starting installation..."
    Install-Applications
} else {
    Write-Error "winget is not available. Please install it first."
    Log "winget is not available. Please install it first."
    Write-Host "You can download the latest version of winget from https://aka.ms/getwinget"
    exit 1
}

# Check if VS Code is available and install extensions if not skipped
if (-not $SkipVSCodeExtensions) {
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Log "Visual Studio Code is available. Installing extensions..."
        Install-VSCodeExtensions
    } else {
        Write-Error "Visual Studio Code is not available. Please install it first."
        Log "Visual Studio Code is not available. Please install it first."
        Write-Host "You can download the latest version of Visual Studio Code from https://code.visualstudio.com/"
    }
}

# Enable WSL and Virtual Machine Platform features
if (-not $SkipWSL) {
    try {
        Log "Enabling WSL and Virtual Machine Platform features..."
        dism.exe /Online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All /NoRestart
        dism.exe /Online /Enable-Feature /FeatureName:VirtualMachinePlatform /All /NoRestart
        Log "WSL and Virtual Machine Platform features enabled successfully."
    } catch {
        Write-Error "Failed to enable WSL and Virtual Machine Platform features. Error: $_"
        Log "Failed to enable WSL and Virtual Machine Platform features. Error: $_"
    }
    # Install WSL2
    if (Get-Command wsl -ErrorAction SilentlyContinue) {
        Log "WSL is available. Proceeding with installation..."
        Install-WSL
        Log "WSL installation completed. Please restart your computer to finalize the setup."
    } else {
        Write-Error "WSL is not available. Please install it first."
        Log "WSL is not available. Please install it first."
        Write-Host "You can enable WSL by running 'wsl --install' in an elevated PowerShell prompt."
    }
    # Set WSL2 as the default version
    try {
        Log "Setting WSL2 as the default version..."
        wsl --set-default-version 2
        Log "WSL2 set as the default version successfully."
    } catch {
        Write-Error "Failed to set WSL2 as the default version. Error: $_"
        Log "Failed to set WSL2 as the default version. Error: $_"
    }
}

# Docker Desktop installation (idempotent, prompt only if not -SkipDocker or -NoPrompt)
if ($PSBoundParameters.ContainsKey('SkipDocker')) {
    if ($SkipDocker) {
        Log "Skipping Docker Desktop installation as per script parameter."
    } else {
        if (Is-AppInstalled 'Docker.DockerDesktop') {
            Log "Docker Desktop already installed. Skipping."
        } else {
            Log "Installing Docker Desktop as per script parameter."
            try {
                Log "Installing Docker Desktop..."
                winget install --id Docker.DockerDesktop --exact --silent
                Log "Docker Desktop installed successfully."
            } catch {
                Write-Error "Failed to install Docker Desktop. Error: $_"
                Log "Failed to install Docker Desktop. Error: $_"
            }
        }
    }
} elseif (-not $NoPrompt) {
    do {
        $dockerChoice = Read-Host "Do you want to install Docker Desktop? (Y/N)"
    } until ($dockerChoice -match '^[YyNn]$')
    $SkipDocker = $dockerChoice -match '^[Nn]$'
    if ($SkipDocker) {
        Log "Skipping Docker Desktop installation as per user choice."
    } else {
        if (Is-AppInstalled 'Docker.DockerDesktop') {
            Log "Docker Desktop already installed. Skipping."
        } else {
            Log "User opted to install Docker Desktop."
            try {
                Log "Installing Docker Desktop..."
                winget install --id Docker.DockerDesktop --exact --silent
                Log "Docker Desktop installed successfully."
            } catch {
                Write-Error "Failed to install Docker Desktop. Error: $_"
                Log "Failed to install Docker Desktop. Error: $_"
            }
        }
    }
}

# Install Azure CLI (idempotent)
if (Is-AppInstalled 'Microsoft.AzureCLI') {
    Log "Azure CLI already installed. Skipping."
} else {
    try {
        Log "Installing Azure CLI..."
        winget install --id Microsoft.AzureCLI --exact --silent
        Log "Azure CLI installed successfully."
    } catch {
        Write-Error "Failed to install Azure CLI. Error: $_"
        Log "Failed to install Azure CLI. Error: $_"
    }
}

Log "--- Windows-Setup.ps1 completed ---"
Write-Host "\nSetup complete. Please review $LogFile for details."
if (-not $SkipWSL) {
    Write-Host "If you enabled or installed WSL, please restart your computer to finalize the setup."
}
