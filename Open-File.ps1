function openf {
    $files = Get-ChildItem -File
    if ($files.Count -eq 0) {
        Write-Host "No files found."
        return
    }

    for ($i = 0; $i -lt $files.Count; $i++) {
        Write-Host "[$($i + 1)] $($files[$i].Name)"
    }

    $choice = Read-Host "Enter number"
    if ($choice -match '^\d+$' -and $choice -ge 1 -and $choice -le $files.Count) {
        Start-Process $files[$choice - 1].FullName
    } else {
        Write-Host "Invalid choice"
    }
}
