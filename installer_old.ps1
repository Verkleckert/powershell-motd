$settingsPath = ".\settings_old.json"

$defaultSettings = @{
    header = "default"
    header_enabled = $true
    drive_info = "default"
    drive_info_enabled = $true
    system_info = "default"
    system_info_enabled = $true
    order = @(1, 2, 3)
}

# Order
#
# 1 = Header
# 2 = Drive Info
# 3 = System Info

$indexes = @{
    1 = "Header"
    2 = "Drive Info"
    3 = "System Info"
}

if (-Not (Test-Path $settingsPath)) {
    $defaultSettings | ConvertTo-Json -Depth 5 | Set-Content $settingsPath
}

$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

function saveSettings {
    $settings | ConvertTo-Json -Depth 5 | Set-Content $settingsPath
}


function Show-MainMenu {
    $header_color = if ($settings.header_enabled -eq $true ) { 'Green' } else { 'Red' }
    $drive_info_color = if ($settings.drive_info_enabled -eq $true ) { 'Green' } else { 'Red' }
    $system_info_color = if ($settings.system_info_enabled -eq $true ) { 'Green' } else { 'Red' }
    
    Clear-Host
    Write-Host "============== Main Menu =============="
    Write-Host "1: " -NoNewline
    Write-Host "Header" -ForegroundColor $header_color
    Write-Host "2: " -NoNewline
    Write-Host "Drive info" -ForegroundColor $drive_info_color
    Write-Host "3: " -NoNewline
    Write-Host "System info" -ForegroundColor $system_info_color
    Write-Host "10: Change order"
    Write-Host "11: Apply changes"
    Write-Host "Q: Quit"
    Write-Host "======================================="
}

function ShowAll-Headers {
    $scriptFiles = Get-ChildItem -Path ".\components_old\header" -Filter "*.ps1"
    
    Clear-Host
    
    foreach ($file in $scriptFiles) {
        . $file.FullName
        
        if (Test-Path function:\Show-Header) {
            Write-Host $file.BaseName
            Write-Host ""
            Show-Header
            Write-Host ""
        } else {
            Write-Host "Function 'Show-Header' not found in file: $($file.Name)"
        }
        
        Remove-Item function:\Show-Header -ErrorAction SilentlyContinue
    }
}

function ShowAll-SystemInfo {
    $scriptFiles = Get-ChildItem -Path ".\components_old\sys-info" -Filter "*.ps1"
    
    Clear-Host
    
    foreach ($file in $scriptFiles) {
        . $file.FullName
        
        if (Test-Path function:\Show-SystemInfo) {
            Write-Host $file.BaseName
            Write-Host ""
            Show-SystemInfo
            Write-Host ""
        } else {
            Write-Host "Function 'Show-SystemInfo' not found in file: $($file.Name)"
        }
        
        Remove-Item function:\Show-SystemInfo -ErrorAction SilentlyContinue
    }
}

function ShowAll-DriveInfos {
    $scriptFiles = Get-ChildItem -Path ".\components_old\drive-info" -Filter "*.ps1"
    
    Clear-Host
    
    foreach ($file in $scriptFiles) {
        . $file.FullName
        
        if (Test-Path function:\Show-DriveInfo) {
            Write-Host $file.BaseName
            Write-Host ""
            Show-DriveInfo
            Write-Host ""
        } else {
            Write-Host "Function 'Show-DriveInfo' not found in file: $($file.Name)"
        }
        
        Remove-Item function:\Show-DriveInfo -ErrorAction SilentlyContinue
    }
}

function Show-HeaderMenu {
    do {
        $header_color = if ($settings.header_enabled -eq $true ) { 'Green' } else { 'Red' }
        $header_status = if ($settings.header_enabled -eq $true ) { 'Disable' } else { 'Enable' }
        
        Clear-Host
        Write-Host "============= Header Menu ============="
        Write-Host "1: Change header theme"
        Write-Host "2: " -NoNewline
        Write-Host "$header_status header" -ForegroundColor $header_color
        Write-Host "B: Back"
        Write-Host "======================================="
        
        $input = Read-Host "Choose an option"
        switch ($input) {
            '1' {
                ShowAll-Headers
                $input = Read-Host "Choose an option"
                $fullPath = Join-Path -Path ".\components_old\header" -ChildPath "$input.ps1"
                if (Test-Path $fullPath) {
                    $settings.header = $input
                    saveSettings
                } else {
                    Write-Host "Theme '$input' not found" -ForegroundColor Red
                    pause
                }
            }
            '2' {
                $settings.header_enabled = -not $settings.header_enabled
                saveSettings
            }
            'B' {
                break
            }
            default {
                Write-Host "Invalid input, please try again."
                pause
            }
        }
    }
    while ($input -ne 'B')
}

function Show-DriveInfoMenu {
    do {
        $drive_info_color = if ($settings.drive_info_enabled -eq $true ) { 'Green' } else { 'Red' }
        $drive_info_status = if ($settings.drive_info_enabled -eq $true ) { 'Disable' } else { 'Enable' }
        
        Clear-Host
        Write-Host "=========== Drive Info Menu ==========="
        Write-Host "1: Change drive info theme"
        Write-Host "2: " -NoNewline
        Write-Host "$drive_info_status drive info" -ForegroundColor $drive_info_color
        Write-Host "B: Back"
        Write-Host "======================================="
        
        $input = Read-Host "Choose an option"
        switch ($input) {
            '1' {
                ShowAll-DriveInfos
                $input = Read-Host "Choose an option"
                $fullPath = Join-Path -Path ".\components_old\drive-info" -ChildPath "$input.ps1"
                if (Test-Path $fullPath) {
                    $settings.drive_info = $input
                    saveSettings
                } else {
                    Write-Host "Theme '$input' not found" -ForegroundColor Red
                    pause
                }
            }
            '2' {
                $settings.drive_info_enabled = -not $settings.drive_info_enabled
                saveSettings
            }
            'B' {
                break
            }
            default {
                Write-Host "Invalid input, please try again."
                pause
            }
        }
    }
    while ($input -ne 'B')
}

function Show-SystemInfoMenu {
    do {
        $system_info_color = if ($settings.system_info_enabled -eq $true ) { 'Green' } else { 'Red' }
        $system_info_status = if ($settings.system_info_enabled -eq $true ) { 'Disable' } else { 'Enable' }
        
        Clear-Host
        Write-Host "========== System Info Menu ===========" # FIXME one longer on the right than on the left
        Write-Host "1: Change system info theme"
        Write-Host "2: " -NoNewline
        Write-Host "$system_info_status system info" -ForegroundColor $system_info_color
        Write-Host "B: Back"
        Write-Host "======================================="
        
        $input = Read-Host "Choose an option"
        switch ($input) {
            '1' {
                ShowAll-SystemInfo
                $input = Read-Host "Choose an option"
                $fullPath = Join-Path -Path ".\components_old\sys-info" -ChildPath "$input.ps1"
                if (Test-Path $fullPath) {
                    $settings.system_info = $input
                    saveSettings
                } else {
                    Write-Host "Theme '$input' not found" -ForegroundColor Red
                    pause
                }
            }
            '2' {
                $settings.system_info_enabled = -not $settings.system_info_enabled
                saveSettings
            }
            'B' {
                break
            }
            default {
                Write-Host "Invalid input, please try again."
                pause
            }
        }
    }
    while ($input -ne 'B')
}

function Show-ChangeOrderMenu {
    do {
        Clear-Host
        Write-Host "============= Header Menu ============="
        Write-Host "Available components:"
        $sortedKeys = $indexes.Keys | Sort-Object
        foreach ($index in $sortedKeys) {
            Write-Host "$($index): $($indexes[$index])"
        }
        Write-Host "======================================="
        Write-Host "Current Order:"
        foreach ($index in $settings.order) {
            Write-Host "$($index): $($indexes[$index])"
        }
        Write-Host "======================================="
        Write-Host "Enter a new space separated order"
        Write-Host "(e.g. '1 2 3') or 'B' to go back"
        Write-Host "You need to provide all even if they"
        Write-Host "are disabled. WIP"
        Write-Host "======================================="
        $input = Read-Host "Enter new order"
        if ($input -ne 'B') {
            $newOrder = $input -split ' ' | ForEach-Object { [int]$_ }
            $indexSet = $indexes.Keys | Sort-Object
            
            # Check if all elements in newOrder are valid indexes
            $allValidIndexes = $newOrder -match ($indexSet -join "|")
            
            # Check for no duplicates by comparing counts after removing duplicates
            $uniqueOrder = $newOrder | Sort-Object -Unique
            $hasNoDuplicates = $uniqueOrder.Count -eq $newOrder.Count
            
            # Check that all indexes are present by comparing the sorted and unique lists
            $allIndexesPresent = ($uniqueOrder -join ',') -eq ($indexSet -join ',')
            
            if ($allValidIndexes -and $hasNoDuplicates -and $allIndexesPresent) {
                $settings.order = $newOrder
                saveSettings
            }
        }
    }
    while ($input -ne 'B')
}




function ApplyChanges {
    $filePath = $PROFILE
    $newContent = @('Write-Host ""')
    foreach ($index in $settings.order) {
        switch ($index) {
            1 {
                if ($settings.header_enabled -eq $true) {
                    $newContent += @(Get-Content ($PSScriptRoot + "\components_old\header\" + $settings.header + ".ps1"))
                    $newContent += @("Show-Header")
                    $newContent += @('Write-Host ""')
                }
            }
            2 {
                if ($settings.drive_info_enabled -eq $true) {
                    $newContent += @(Get-Content ($PSScriptRoot + "\components_old\drive-info\" + $settings.drive_info + ".ps1"))
                    $newContent += @("Show-DriveInfo")
                    $newContent += @('Write-Host ""')
                }
            }
            3 {
                if ($settings.system_info_enabled -eq $true) {
                    $newContent += @(Get-Content ($PSScriptRoot + "\components_old\sys-info\" + $settings.system_info + ".ps1"))
                    $newContent += @("Show-SystemInfo")
                    $newContent += @('Write-Host ""')
                }
            }
        }
    }
    
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
        $lines = $before + $newContent + $after
    } elseif ($startIndex -eq $null -or $endIndex -eq $null) {
        $lines += '# MOTD START'
        $lines += $newContent
        $lines += '# MOTD END'
    }
    
    $lines | Set-Content $filePath
}



function Main {
    do {
        Show-MainMenu
        $input = Read-Host "Choose an option"
        switch ($input) {
            '1' {
                Show-HeaderMenu
            }
            '2' {
                Show-DriveInfoMenu
            }
            '3' {
                Show-SystemInfoMenu
            }
            '10' {
                Show-ChangeOrderMenu
            }
            '11' {
                ApplyChanges
                Write-Host "Changes applied"
                pause
            }
            'Q' {
                Write-Host "Exiting..."
                break
            }
            default {
                Write-Host "Invalid input, please try again."
                pause
            }
        }
    }
    while ($input -ne 'Q')
}

Main