# DO NOT CHANGE THIS FILE
# This file is managed in the Build repo and it auto-updates itself
#

[CmdletBinding()]
Param
(
    [parameter(mandatory=$false, ValueFromRemainingArguments=$true)]$Arguments
)

if(Test-Path .build) {
    pushd .build
    git pull --ff-only -q
    popd
}
else {
    git clone git@github.com:energyhelpline/build.git .build -q

    ## update gitignore
    if (!(Test-Path .\.gitignore)) {
        New-Item -Path .\.gitignore -ItemType File
    }

    if (!(Select-String -Pattern ".build/" -Path ".\.gitignore" -SimpleMatch)){
        Add-Content -Path ".\.gitignore" -Value "
#EHL build system
.build/"

        Write-Host ***** .gitignore updated to ignore .build folder - please commit this change
    }
}

## check to see if this file is updated - if so update and re-run
$thisFile = Get-FileHash .\build.ps1 -Algorithm SHA1
$latestFile = Get-FileHash .\.build\template.build.ps1 -Algorithm SHA1

if ($thisFile.Hash -ne $latestFile.Hash) {
    Copy-Item -Path .build\template.build.ps1 -Destination .\build.ps1
    Write-Host ***** build.ps1 file updated -  please commit this file
    Invoke-Expression ".\build.ps1 $Arguments"
    exit
}

## create build.cake file in root
if(!(Test-Path .\build.cake)) {
    Copy-Item -Path .build\template.build.cake -Destination .\build.cake
    Write-Host ***** build.cake file created -  please update and commit this file
}
else {
    ## call cakebuild.ps1
    pushd .\.build
    Invoke-Expression ".\cakebuild.ps1 $Arguments"
    popd
}