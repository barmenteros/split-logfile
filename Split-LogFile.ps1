<#
.SYNOPSIS
  Split a large text file into numbered chunks, naming outputs after the source file.

.DESCRIPTION
  Streams the input file to avoid high memory use.
  Creates an output folder named "<BaseName>_Chunks" beside the input file.
  Writes chunk files named "<BaseName>_0000.txt", "<BaseName>_0001.txt", …

.PARAMETER InputFilePath
  Full path to the source .txt file.

.PARAMETER LinesPerChunk
  Lines per chunk file (default: 1000).

.EXAMPLE
  .\Split-LogFile.ps1 `
    -InputFilePath 'C:\Users\barme\OneDrive\Downloads\20250624_EA_log_file.txt' `
    -LinesPerChunk 2000
#>
param(
    [Parameter(Mandatory)]
    [string]$InputFilePath,

    [int]$LinesPerChunk = 1000
)

# — Prepare names and paths ————————————————————————————————————————————
if (-not (Test-Path $InputFilePath)) {
    Write-Error "Input file not found: $InputFilePath"
    exit 1
}

$baseName        = [System.IO.Path]::GetFileNameWithoutExtension($InputFilePath)
$parentDir       = Split-Path -Path $InputFilePath -Parent
$OutputDirectory = Join-Path $parentDir ("${baseName}_Chunks")

if (-not (Test-Path $OutputDirectory)) {
    New-Item -Path $OutputDirectory -ItemType Directory | Out-Null
}

# — Streaming reader/writer loop ————————————————————————————————————
$reader     = [System.IO.File]::OpenText($InputFilePath)
$chunkIndex = 0

try {
    while (-not $reader.EndOfStream) {
        $buffer = New-Object System.Collections.Generic.List[string]
        for ($i = 0; $i -lt $LinesPerChunk -and -not $reader.EndOfStream; $i++) {
            $buffer.Add($reader.ReadLine())
        }

        # New filename: "<BaseName>_0000.txt", "<BaseName>_0001.txt", …
        $outFileName = "{0}_{1:D4}.txt" -f $baseName, $chunkIndex
        $outFile     = Join-Path $OutputDirectory $outFileName

        [System.IO.File]::WriteAllLines($outFile, $buffer)

        Write-Host ("Wrote {0} lines → {1}" -f $buffer.Count, $outFile)
        $chunkIndex++
    }
}
finally {
    $reader.Close()
}