function Show-SystemInfo() {
    $net = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
    $net = $net | Select-Object -First 1
    $net = $net | Select-Object -Property @{Name="MAC"; Expression={$_.MACAddress}}, @{Name="IP"; Expression={$_.IPAddress[0]}}
    
    Write-Host "    MAC-Address ........................ " -NoNewline -ForegroundColor Gray
    Write-Host $net.MAC -ForegroundColor White
    Write-Host "    IP-Address ......................... " -NoNewline -ForegroundColor Gray
    Write-Host  $net.IP -ForegroundColor White
}