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
   $gitstatus = Write-VcsStatus
   Write-Host '[' -NoNewline -ForegroundColor gray
   Write-Host "$ENV:USERNAME@" -NoNewline -ForegroundColor Yellow
   Write-Host "$ENV:COMPUTERNAME".ToLower() -NoNewline -ForegroundColor Yellow
   Write-Host ']' -NoNewline -ForegroundColor gray
   Write-Host '-[' -NoNewline -ForegroundColor gray
   write-host (shorten-path (Get-Location).Path) -NoNewline -ForegroundColor white
   Write-Host ']' -ForegroundColor gray -NoNewline
   Write-Host $gitstatus
   Write-Host '%' -NoNewline
   return ' '
}

# Shell functions

function cddash {
    if ($args[0] -eq '-') {
        $pwd = $OLDPWD;
    } else {
        $pwd = $args[0];
    }
    $tmp = Get-Location;

    if ($pwd) {
        Set-Location $pwd;
    }
    Set-Variable -Name OLDPWD -Value $tmp -Scope global;
}

# Customized Alias

Set-Alias -Name gep -Value Get-ExecutionPolicy
Set-Alias -Name sep -Value Set-ExecutionPolicy
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name for	-Value ForEach-Object
Set-Alias -Name .. -Value cd..