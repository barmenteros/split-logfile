# split-logfile

A lightweight PowerShell utility to split large text files into fixed‑size, numbered chunks.

## Features
- Streams input to minimize memory usage
- Configurable lines per chunk
- Output folder and file names derived from source file name
- Zero dependencies beyond PowerShell 5+

## Installation
```bash
# Clone the repo
git clone https://github.com/barmenteros/split-logfile.git
cd split-logfile
````

## Usage

```powershell
.\Split-LogFile.ps1 -InputFilePath 'C:\path\to\large.txt' -LinesPerChunk 10000
```

### Parameters

* `-InputFilePath` (string, **required**): Full path to the `.txt` file.
* `-LinesPerChunk` (int): Number of lines per chunk. Default: `1000`.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is licensed under the MIT License; see [LICENSE](LICENSE) for details.
