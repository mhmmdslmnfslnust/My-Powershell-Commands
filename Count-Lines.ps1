function count-lines {
    <#
    .SYNOPSIS
        Counts the number of lines in code files.
    .DESCRIPTION
        Counts the total number of lines in web development files within the current directory and its subdirectories.
        Excludes 'node_modules' folders from the count.
    .EXAMPLE
        count-lines
    .NOTES
        Supported file types: JS, JSX, TS, TSX, CSS, SCSS, HTML
    #>

    $extensions = @("*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "*.scss", "*.html")
    $sum = 0
    $results = @{
    }
    
    Write-Host "`n📊 CODE LINE COUNTER 📊" -ForegroundColor Cyan
    Write-Host "-------------------------`n"
    
    foreach ($ext in $extensions) {
        $files = Get-ChildItem -Path . -Filter $ext -Recurse -File | 
                 Where-Object { $_.FullName -notmatch "node_modules" }
        
        if ($files) {
            $count = ($files | ForEach-Object { 
                (Get-Content $_.FullName -ErrorAction SilentlyContinue | Measure-Object -Line).Lines 
            } | Measure-Object -Sum).Sum
            
            if ($count) {
                $sum += $count
                $results[$ext] = $count
                
                # Choose color based on extension type
                $color = switch -Wildcard ($ext) {
                    "*.js*" { "Yellow" }
                    "*.ts*" { "Blue" }
                    "*.css" { "Magenta" }
                    "*.scss" { "DarkMagenta" }
                    "*.html" { "Green" }
                    default { "White" }
                }
                
                Write-Host "$($ext.PadRight(6)) : " -NoNewline
                Write-Host "$($count.ToString('N0').PadLeft(10))" -ForegroundColor $color
            }
        }
    }
    
    Write-Host "`nTOTAL   : " -NoNewline
    Write-Host "$($sum.ToString('N0').PadLeft(10))" -ForegroundColor Cyan
    Write-Host ""
}