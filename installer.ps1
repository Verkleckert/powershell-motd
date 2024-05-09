$settingsPath = ".\settings.json"
$filePath = $PROFILE

$defaultSettings = @{
    "1" = @{type = "newline"}
    "2" = @{type = "header"; name = "default"}
    "3" = @{type = "newline"}
    "4" = @{type = "newline"}
    "5" = @{type = "system-info"; name = "default"}
    "6" = @{type = "newline"}
    "7" = @{type = "newline"}
    "8" = @{type = "drive-info"; name = "default"}
    "9" = @{type = "newline"}
}

# Ensure settings file exists before proceeding
if (-Not (Test-Path $settingsPath)) {
    $defaultSettings | ConvertTo-Json -Depth 5 | Set-Content $settingsPath
}

# Load settings from the file
$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

function saveSettings {
    $settings | ConvertTo-Json -Depth 5 | Set-Content $settingsPath
}

function addNewItem {
    # TODO Check if at least one value in settings
    $position = Read-Host "Enter the position where to insert the new item"

    if (-not ($position -match '^\d+$')) {
        Write-Host "Invalid position."
        pause
        return
    }

    $type = Read-Host "Enter the type of the new item (newline, header, system-info, drive-info)"
    
    if (-not(@('newline', 'header', 'system-info', 'drive-info') -contains $type)) {
        Write-Host "Invalid type."
        pause
        return
    } 
    
    if ($type -ne 'newline') {
        $scriptFiles = Get-ChildItem -Path ".\components\$type" -Filter "*.ps1"
        
        Clear-Host
        
        foreach ($file in $scriptFiles) {
            Write-Host "[$($file.BaseName)]"
            Write-Host ""
            $preview = Get-Content ($PSScriptRoot + "\components\$type\" + $file.name) -Raw
            Invoke-Expression $preview
            Write-Host ""
        }
        $name = Read-Host "Enter the name of the new item"

        if (-not ($scriptFiles.BaseName -contains $name)) {
            Write-Host "Invalid name."
            pause
            return
        }
    }
    if ($position -match '^\d+$' -and $settings.PSObject.Properties.Name -contains $position) {
        $newSettings = @{}
        $incremented = $false
        foreach ($key in $settings.PSObject.Properties.Name | Sort-Object { [int]$_ }) {
            if ([int]$key -ge [int]$position -and -not $incremented) {
                $newKey = [string]([int]$key + 1)
                $newSettings[$newKey] = $settings.$key
            } elseif ($incremented) {
                $newKey = [string]([int]$key + 1)
                $newSettings[$newKey] = $settings.$key
            } else {
                $newSettings[$key] = $settings.$key
            }
            if ($key -eq $position) {
                $incremented = $true
                if ($type -ne 'newline') {
                    $newSettings[$position] = @{type = $type; name = $name}
                } else {
                    $newSettings[$position] = @{type = "newline"}
                }
            }
        }
        $settings = $newSettings
        saveSettings
    } else {
        Write-Host "Invalid position or position does not exist."
    }
}

function removeItem {
    $position = Read-Host "Enter the position of the item to remove"
    if ($position -match '^\d+$' -and $settings.PSObject.Properties.Name -contains $position) {
        $newSettings = @{}
        foreach ($key in $settings.PSObject.Properties.Name | Sort-Object { [int]$_ }) {
            if ([int]$key -lt [int]$position) {
                $newSettings[$key] = $settings.$key
            } elseif ([int]$key -gt [int]$position) {
                $newKey = [string]([int]$key - 1)
                $newSettings[$newKey] = $settings.$key
            }
        }
        $settings = $newSettings
        saveSettings
    } else {
        Write-Host "Invalid position or position does not exist."
    }
}

function build {
    $motd = ""
    $orderedKeys = $settings.PSObject.Properties.Name | Sort-Object { [int]$_ }
    foreach ($key in $orderedKeys) {
        $item = $settings.$key
        switch ($item.type) {
            'newline' {
                $motd += "Write-Host ''`n" 
            }
            'header' {
                $motd += Get-Content ($PSScriptRoot + "\components\header\" + $item.name + ".ps1") -Raw
                $motd += "`n" 
            }
            'system-info' {
                $motd += Get-Content ($PSScriptRoot + "\components\system-info\" + $item.name + ".ps1") -Raw
                $motd += "`n" 
            }
            'drive-info' {
                $motd += Get-Content ($PSScriptRoot + "\components\drive-info\" + $item.name + ".ps1") -Raw
                $motd += "`n" 
            }
        }
    }
    return $motd
    
}

function preview {
    $motd = build
    Invoke-Expression $motd
    pause
}

function apply {
    $motd = build
    
    $lines = Get-Content $filePath
    
    $startIndex = $null
    $endIndex = $null
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '# MOTD START') { $startIndex = $i }
        if ($lines[$i] -match '# MOTD END') { $endIndex = $i }
    }
    
    if ($startIndex -ne $null -and $endIndex -ne $null -and $endIndex -gt $startIndex) {
        # Reconstruct the $lines array by concatenating parts before, between, and after the content
        $before = $lines[0..$startIndex]
        $after = $lines[($endIndex + 1)..($lines.Count - 1)]
        $lines = $before + $motd + $after
    } elseif ($startIndex -eq $null -or $endIndex -eq $null) {
        $lines += '# MOTD START'
        $lines += $motd
        $lines += '# MOTD END'
    }
    
    $lines | Set-Content $filePath
    
    Write-Host "Changes applied successfully."
    
    pause
}

function Main {
    # Load settings from the file
    do {
        $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
        Clear-Host
        Write-Host "================ MOTD ================"
        $orderedKeys = $settings.PSObject.Properties.Name | Sort-Object { [int]$_ }
        foreach ($key in $orderedKeys) {
            $item = $settings.$key
            Write-Host "$($key): " -NoNewline
            switch ($item.type) {
                'newline' { Write-Host "" }
                'header' { Write-Host "Header: $($item.name)" }
                'system-info' { Write-Host "System Info: $($item.name)" }
                'drive-info' { Write-Host "Drive Info: $($item.name)" }
            }
        }
        Write-Host "======================================="
        Write-Host "Enter 'Q' to quit"
        Write-Host "Enter 'A' to apply changes"
        Write-Host "Enter 'P' for a preview"
        Write-Host "Enter '+' to add a new item"
        Write-Host "Enter '-' to remove an item"
        Write-Host "======================================="
        
        $userInput = Read-Host "Enter your choice"
        switch ($userInput) {
            'Q' { break }
            'A' { apply }
            'P' { preview }
            '+' { addNewItem }
            '-' { removeItem }
            default { Write-Host "Invalid input, please try again." }
        }
    } while ($userInput -ne 'Q')
}

Main
