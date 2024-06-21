# Define a function to compute the SHA512 hash of a file
Function Get-SHA512Hash($file) {
    $computedHash = Get-FileHash -Path $file -Algorithm SHA512
    return $computedHash
}

# Define a function to remove the existing baseline file if present
Function Remove-ExistingBaseline() {
    $baselineFile = ".\baseline_record.txt"
    if (Test-Path -Path $baselineFile) {
        Remove-Item -Path $baselineFile
    }
}

# User interaction for script options
Write-Host "Select an option:"
Write-Host "1) Create a new file hash baseline"
Write-Host "2) Start file integrity monitoring with the existing baseline"
$userChoice = Read-Host -Prompt "Enter '1' or '2' to proceed"
Write-Host ""

# Option 1: Create a new baseline
if ($userChoice -eq "1") {
    Remove-ExistingBaseline

    # Retrieve all files and calculate their hashes
    $targetFiles = Get-ChildItem -Path .\TargetFiles
    foreach ($file in $targetFiles) {
        $fileHash = Get-SHA512Hash $file.FullName
        "$($fileHash.Path)|$($fileHash.Hash)" | Out-File -FilePath .\baseline_record.txt -Append
    }
}

# Option 2: Monitor file integrity
elseif ($userChoice -eq "2") {
    $hashesDictionary = @{}

    # Load the baseline and populate the dictionary
    $baselineData = Get-Content -Path .\baseline_record.txt
    foreach ($entry in $baselineData) {
        $path, $hash = $entry.Split("|")
        $hashesDictionary[$path] = $hash
    }

    # Continuous monitoring loop
    while ($true) {
        Start-Sleep -Seconds 1
        $currentFiles = Get-ChildItem -Path .\TargetFiles

        foreach ($file in $currentFiles) {
            $currentHash = Get-SHA512Hash $file.FullName

            if (-not $hashesDictionary.ContainsKey($currentHash.Path)) {
                Write-Host "New file detected: $($currentHash.Path)" -ForegroundColor Cyan
            } elseif ($hashesDictionary[$currentHash.Path] -ne $currentHash.Hash) {
                Write-Host "File modified: $($currentHash.Path)" -ForegroundColor Magenta
            }
        }

        # Check for deleted files
        foreach ($originalPath in $hashesDictionary.Keys) {
            if (-not (Test-Path -Path $originalPath)) {
                Write-Host "File deleted: $originalPath" -ForegroundColor Red
            }
        }
    }
}
