
# Get the full path of the "schemas" and "data" folders
$schemasPath = Join-Path -Path (Get-Location) -ChildPath "schemas"
$dataPath = Join-Path -Path (Get-Location) -ChildPath "data"

# Ensure the "data" folder exists
if (-not (Test-Path $dataPath)) {
    New-Item -ItemType Directory -Path $dataPath | Out-Null
}

# Check if the "schemas" folder exists
if (Test-Path $schemasPath) {
    # Get all XML files, sorted by numeric prefix
    $files = Get-ChildItem -Path $schemasPath -Filter "*.xml" | Sort-Object { [int]($_.Name -replace '^(\d+)_.*$', '$1') }

    foreach ($file in $files) {
        # Construct the zip file name in the "data" folder
        $zipFile = Join-Path -Path $dataPath -ChildPath ([System.IO.Path]::ChangeExtension($file.Name, ".zip"))

        # Execute the command and capture errors
        $command = "pac data export -sf `"$($file.FullName)`" -df `"$zipFile`" -o -v"

        Write-Host "Executing: $command"
        try {
            Invoke-Expression $command
        }
        catch {
            Write-Host "Error processing $($file.Name): $_"
        }
    }
}
else {
    Write-Host "The 'schemas' folder does not exist in the current directory."
}
