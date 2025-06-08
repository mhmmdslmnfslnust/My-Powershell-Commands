$extensions = @("*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "*.scss", "*.html")
$sum = 0
foreach ($ext in $extensions) {
    $count = (Get-ChildItem -Path . -Filter $ext -Recurse -File | Where-Object { $_.FullName -notmatch "node_modules" } | ForEach-Object { (Get-Content $_.FullName -ErrorAction SilentlyContinue | Measure-Object -Line).Lines } | Measure-Object -Sum).Sum
    if ($count) {
        $sum += $count
        Write-Host "$ext : $count"
    }
}
Write-Host "Total lines: $sum"