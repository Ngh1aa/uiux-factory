$ErrorActionPreference = "Stop"

$FactoryRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$WorkspaceRoot = Resolve-Path (Join-Path $FactoryRoot "..")
$BoltRoot = Join-Path $WorkspaceRoot "bolt.diy"

Write-Host ""
Write-Host "UIUX FACTORY - DESIGN WORKBENCH" -ForegroundColor Cyan
Write-Host "Factory: $FactoryRoot"
Write-Host "Bolt:    $BoltRoot"
Write-Host ""

if (-not (Test-Path $BoltRoot)) {
  throw "bolt.diy sibling repo was not found at $BoltRoot"
}

$BridgeCommand = @"
cd '$FactoryRoot'
.\.venv\Scripts\Activate.ps1
python .\apps\bridge\server.py
"@

Start-Process powershell `
  -ArgumentList "-NoExit", "-Command", $BridgeCommand

Set-Location $BoltRoot

Write-Host "Starting bolt.diy..." -ForegroundColor Magenta
Write-Host "Open: http://localhost:5173/uiux" -ForegroundColor Green
Write-Host ""

pnpm run dev
