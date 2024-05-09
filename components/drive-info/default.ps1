function Show-DriveInfo() {
    $drives = Get-PSDrive -PSProvider FileSystem
    # $consoleWidth = [console]::WindowWidth
    foreach($drive in $drives){
        if($null -ne $drive.Used -And $drive.Name -ne "D"){
            $total = $drive.Used + $drive.Free
            $usedPercent = [math]::Round(($drive.Used / $total) * 100)
            $freePercent = 100 - $usedPercent
            
            $barColor = "Green"
            $percentColor = "Green"
            if ($usedPercent -gt 80) {
                $barColor = "Red"
                $percentColor = "Red"
            }
            
            $progressbar = "$([char]0xEE04)" * [math]::floor($usedPercent / 5) + "$([char]0xEE04)" + "$([char]0xEE01)" * [math]::floor($freePercent / 5)
            
            # Zentrierung des Texts auf 80 Zeichen Breite
            # $line = "{0} [{1}] {2}%" -f ($drive.Name + ":"), $progressbar, $usedPercent
            # $paddedLine = $line.PadLeft(($line.Length + 80) / 2)
            
            Write-Host ("      " + $drive.Name + ":") -NoNewline -ForegroundColor Gray
            Write-Host " $([char]0xEE03)" -NoNewline -ForegroundColor $barColor
            Write-Host $progressbar -NoNewline -ForegroundColor $barColor
            Write-Host "$([char]0xEE02)" -NoNewline -ForegroundColor $barColor
            Write-Host (" " + $usedPercent + "%") -NoNewline -ForegroundColor $percentColor
            Write-Host " ...." -NoNewline -ForegroundColor Gray
            Write-Host (" " + [math]::Round($drive.Used/(1024*1024*1024), 1) + " GB") -NoNewline -ForegroundColor $percentColor
            Write-Host " /" -NoNewline -ForegroundColor Gray
            Write-Host (" " + [math]::Round($total/(1024*1024*1024), 1) + " GB") -ForegroundColor White
        }
    }
}