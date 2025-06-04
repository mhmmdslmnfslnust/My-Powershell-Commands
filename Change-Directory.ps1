function cdx {
    $dirs = Get-ChildItem -Directory
    if ($dirs.Count -eq 0) {
        Write-Host "No subdirectories found."
        return
    }

    for ($i = 0; $i -lt $dirs.Count; $i++) {
        Write-Host "[$($i + 1)] $($dirs[$i].Name)"
    }

    $choice = Read-Host "Enter number"
    if ($choice -match '^\d+$' -and $choice -ge 1 -and $choice -le $dirs.Count) {
        Set-Location $dirs[$choice - 1].FullName
    } else {
        Write-Host "Invalid choice"
    }
}
