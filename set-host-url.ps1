# SharpCell — replace the placeholder hosting URL in manifest.xml
# Usage from PowerShell, inside the dist/ folder:
#   .\set-host-url.ps1 -Url "https://csava.github.io/sharpcell/"
#
# The URL must end with a trailing slash. After running, manifest.xml is
# ready to sideload into Excel.

param(
  [Parameter(Mandatory = $true)]
  [string]$Url
)

if (-not $Url.EndsWith("/")) {
  $Url = $Url + "/"
}

$manifest = Join-Path $PSScriptRoot "manifest.xml"
if (-not (Test-Path $manifest)) {
  Write-Error "manifest.xml not found next to this script."
  exit 1
}

$placeholder = "https://YOUR-GH-USERNAME.github.io/sharpcell/"
$content = Get-Content $manifest -Raw

if (-not $content.Contains($placeholder)) {
  Write-Host "Manifest already points at a custom URL. Nothing to do." -ForegroundColor Yellow
  exit 0
}

$content = $content.Replace($placeholder, $Url)
Set-Content -Path $manifest -Value $content -Encoding UTF8

Write-Host "manifest.xml updated to use $Url" -ForegroundColor Green
Write-Host ""
Write-Host "Next: in Excel, Insert > Add-ins > Upload My Add-in > pick this manifest.xml"
