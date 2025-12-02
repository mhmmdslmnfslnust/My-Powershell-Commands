function count-lines {
    <#
    .SYNOPSIS
        Count lines in meaningful development files.
    .DESCRIPTION
        Recursively counts lines of source, config, UI, and template files
        relevant to real-world development. Excludes build folders.
    .EXAMPLE
        count-lines
    .NOTES
        Supports a wide range of programming languages and file types.
        Excludes: node_modules, dist, build, out, .git
    #>

    $extensions = @(
        # Web
        "*.js", "*.jsx", "*.ts", "*.tsx",
        "*.css", "*.scss", "*.html",
        "*.vue", "*.svelte",

        # Backend / General purpose
        "*.py", "*.java", "*.kt",
        "*.c", "*.h", "*.cpp", "*.hpp",
        "*.cs", "*.go", "*.rs",
        "*.php", "*.rb",

        # Desktop / Mobile UI
        "*.fxml", "*.xml", "*.swift", "*.dart",

        # Config / Infra / Build
        "*.json", "*.yaml", "*.yml",
        "*.toml", "*.env", "*.ini", "*.config",
        "*.gradle", "*.kts",
        "*.md", "*.txt",

        # Templates
        "*.ejs", "*.pug", "*.hbs", "*.twig", "*.njk"
    )

    $excluded = @(
        "node_modules", "dist", "build", "out", ".git"
    )

    $sum = 0
    $results = @{

    }

    Write-Host "`n📊 CODE LINE COUNTER 📊" -ForegroundColor Cyan
    Write-Host "-------------------------`n"

    foreach ($ext in $extensions) {
        $files = Get-ChildItem -Path . -Filter $ext -Recurse -File |
            Where-Object {
                $parts = $_.FullName.ToLower().Split([IO.Path]::DirectorySeparatorChar)
                -not ($parts | Where-Object { $excluded -contains $_ })
            }

        if ($files) {
            $count = ($files | ForEach-Object {
                (Get-Content $_.FullName -ErrorAction SilentlyContinue |
                Measure-Object -Line).Lines
            } | Measure-Object -Sum).Sum

            if ($count) {
                $sum += $count
                $results[$ext] = $count

                Write-Host "$($ext.PadRight(10)) : " -NoNewline
                Write-Host "$($count.ToString('N0').PadLeft(12))" -ForegroundColor Green
            }
        }
    }

    Write-Host "`nTOTAL       : " -NoNewline
    Write-Host "$($sum.ToString('N0').PadLeft(12))" -ForegroundColor Cyan
    Write-Host ""
}