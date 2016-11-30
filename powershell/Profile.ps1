# Importing Modules #

Import-Module posh-git

#Prompt Function

function shorten-path([string] $path) {
  $loc = $path.Replace($HOME, '~')
  # remove prefix for UNC paths
  $loc = $loc -replace '^[^:]+::', ''
  # make path shorter like tabs in Vim,
    # handle paths starting with \\ and . correctly
  return ($loc -replace '\\(\.?)([^\\]{3})[^\\]*(?=\\)','\$1$2')
}

function prompt {
   write-host 'PowerShell' -n -f yellow
   write-host '-[' -n -f gray
   write-host (shorten-path (pwd).Path) -n -f white
   Write-VcsStatus
   $global:LASTEXITCODE = $realLASTEXITCODE
   write-host ']' -n -f gray
   write-host ' %' -n
   # Update-HostWindowTitle
   return ' '
}

# Customized Alias

Set-Alias gep Get-ExecutionPolicy
Set-Alias sep Set-ExecutionPolicy
Set-Alias more more.com
Set-Alias for ForEach-Object
