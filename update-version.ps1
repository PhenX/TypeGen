param(
    [Parameter(Mandatory = $true)]
    [string]$Version
)

function Abort([string]$msg) {
    Write-Error $msg
    exit 1
}

if ($Version -notmatch '^\d+\.\d+\.\d+$') {
    Abort "Version must be major.minor.build (example: 6.0.4). You passed '$Version'."
}

$InformationalVersion = $Version
$AssemblyVersion      = "$Version.0"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$RelativeFiles = @(
    "nuget\TypeGen.nuspec",
    "nuget-dotnetcli\dotnet-typegen.nuspec",
    "src\TypeGen\TypeGen.Cli\AssemblyInfo.cs",
    "src\TypeGen\TypeGen.Core\AssemblyInfo.cs"
)

# Resolve absolute paths
$Files = foreach ($rel in $RelativeFiles) {
    if ([System.IO.Path]::IsPathRooted($rel)) {
        if (Test-Path $rel) { (Resolve-Path $rel).Path }
    } else {
        $abs = Join-Path $ScriptDir $rel
        if (Test-Path $abs) { (Resolve-Path $abs).Path }
    }
}

function Backup-File($Path) {
    $stamp = (Get-Date).ToString("yyyyMMddHHmmss")
    $bak = "$Path.$stamp.bak"
    Copy-Item -Path $Path -Destination $bak -Force
    Write-Host "Backup created: $bak"
}

function Update-Nuspec($Path, $NewVersion) {
    if (-not (Test-Path $Path)) {
        Write-Host "WARN: nuspec not found, skipping: $Path"
        return
    }

    try {
        # Read raw bytes and decode using BOM-aware reader
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        # Let .NET detect BOM by using StreamReader with detectEncodingFromByteOrderMarks = $true
        $ms = New-Object System.IO.MemoryStream(,$bytes)
        $sr = New-Object System.IO.StreamReader($ms, $true)
        $raw = $sr.ReadToEnd()
        $sr.Close()
        $ms.Close()

        # Trim leading whitespace and any garbage before first '<'
        $firstLt = $raw.IndexOf('<')
        if ($firstLt -gt 0) {
            $raw = $raw.Substring($firstLt)
        }

        # Remove leading BOM char if present (U+FEFF)
        if ($raw.Length -gt 0 -and $raw[0] -eq [char]0xFEFF) {
            $raw = $raw.Substring(1)
        }

        # Load cleaned XML string into XmlDocument
        $xml = New-Object System.Xml.XmlDocument
        $xml.PreserveWhitespace = $true
        $xml.LoadXml($raw)

        # Namespace support
        $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
        if ($xml.DocumentElement -and $xml.DocumentElement.NamespaceURI) {
            $ns.AddNamespace("d", $xml.DocumentElement.NamespaceURI)
        }

        # Find <version>
        $node = $xml.SelectSingleNode("/package/metadata/version", $ns)
        if ($node -eq $null -and $ns.HasNamespace("d")) {
            $node = $xml.SelectSingleNode("/d:package/d:metadata/d:version", $ns)
        }
        if ($node -eq $null) { $node = $xml.SelectSingleNode("//metadata/version", $ns) }
        if ($node -eq $null) { $node = $xml.SelectSingleNode("//version", $ns) }

        if ($node -eq $null) {
            Write-Warning "No <version> element found in $Path; skipping."
            return
        }

        $old = $node.InnerText
        $node.InnerText = $NewVersion

        # Write formatted XML (UTF8 without BOM)
        $settings = New-Object System.Xml.XmlWriterSettings
        $settings.Indent = $true
        $settings.IndentChars = "  "
        $settings.NewLineChars = "`r`n"
        $settings.NewLineHandling = "Replace"
        $settings.OmitXmlDeclaration = $false
        $settings.Encoding = New-Object System.Text.UTF8Encoding($false)

        $writer = [System.Xml.XmlWriter]::Create($Path, $settings)
        try { $xml.Save($writer) } finally { $writer.Close() }

        Write-Host "Updated nuspec: $Path (version: $old -> $NewVersion)"
    }
    catch {
        Write-Error ("Failed to update nuspec {0}: {1}" -f $Path, $($_.ToString()))
    }
}


function Update-AssemblyInfo($Path, $AsmVer, $FileVer, $InfoVer) {
    try {
        $content = Get-Content -Path $Path -Raw
        $orig = $content

        $rules = @(
            @{ P = 'AssemblyVersion';              V = $AsmVer }
            @{ P = 'AssemblyFileVersion';          V = $FileVer }
            @{ P = 'AssemblyInformationalVersion'; V = $InfoVer }
        )

        foreach ($r in $rules) {
            $pattern = "(?m)^\s*\[assembly:\s*(?:System\.Reflection\.)?{0}\s*\(\s*""[^""]*""\s*\)\s*\]\s*$" -f $r.P
            $replacement = '[assembly: {0}("{1}")]' -f $r.P, $r.V

            if ($content -match $pattern) {
                $content = [regex]::Replace($content, $pattern, $replacement)
            } else {
                $content = $content.TrimEnd() + "`r`n$replacement`r`n"
            }
        }

        if ($content -ne $orig) {
            Set-Content -Path $Path -Value $content -Encoding UTF8
            Write-Host "Updated AssemblyInfo: $Path"
        } else {
            Write-Host "No changes: $Path"
        }
    }
    catch {
        Write-Error ("Failed to update AssemblyInfo {0}: {1}" -f $Path, $_)
    }
}

# Main loop
foreach ($file in $Files) {
    Backup-File $file
    switch ([System.IO.Path]::GetExtension($file).ToLowerInvariant()) {
        ".nuspec" { Update-Nuspec $file $InformationalVersion }
        ".cs"     { Update-AssemblyInfo $file $AssemblyVersion $AssemblyVersion $InformationalVersion }
    }
}

Write-Host "Done. Updated to version $Version."
exit 0
