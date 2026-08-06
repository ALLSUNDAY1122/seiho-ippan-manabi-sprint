$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$indexPath = Join-Path $projectRoot 'index.html'

if (-not (Test-Path -LiteralPath $indexPath -PathType Leaf)) {
    throw "index.html is missing: $indexPath"
}

$html = Get-Content -LiteralPath $indexPath -Raw -Encoding utf8
$required = @('<!DOCTYPE html', '<html', '<script', '</html>')
foreach ($marker in $required) {
    if (-not $html.Contains($marker)) {
        throw "Required HTML marker is missing: $marker"
    }
}

$externalCount = ([regex]::Matches($html, 'https?://|//cdn|cdnjs|unpkg')).Count
if ($externalCount -gt 0) {
    throw "External URL or CDN references found: $externalCount"
}

if (-not $html.Contains('seiho_ippan_manabi_sprint_v1')) {
    throw 'Expected localStorage key is missing'
}

$bytes = [Text.Encoding]::UTF8.GetByteCount($html)
Write-Output "PASS: $indexPath ($bytes bytes)"
