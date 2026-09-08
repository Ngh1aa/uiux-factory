$ErrorActionPreference = "Stop"

$FactoryRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$WorkspaceRoot = Resolve-Path (Join-Path $FactoryRoot "..")
$BoltRoot = Join-Path $WorkspaceRoot "bolt.diy"
$PnpmVersion = "9.14.4"

Write-Host ""
Write-Host "UIUX FACTORY - DESIGN WORKBENCH" -ForegroundColor Cyan
Write-Host "Factory: $FactoryRoot"
Write-Host "Bolt:    $BoltRoot"
Write-Host ""

if (-not (Test-Path $BoltRoot)) {
  throw "bolt.diy sibling repo was not found at $BoltRoot"
}

if (-not (Test-Path (Join-Path $FactoryRoot ".venv\Scripts\python.exe"))) {
  throw "Python virtual environment was not found at uiux-factory\.venv"
}

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  throw "Node.js is required but was not found in PATH."
}

if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
  throw "npx is required but was not found in PATH. Reinstall Node.js with npm included."
}

$NodeVersion = node --version
Write-Host "Node: $NodeVersion"
Write-Host "pnpm: using npx pnpm@$PnpmVersion (no global install required)" -ForegroundColor DarkGray
Write-Host ""

$BridgeCommand = @"
cd '$FactoryRoot'
.\.venv\Scripts\Activate.ps1
python .\apps\bridge\server.py
"@

Start-Process powershell `
  -ArgumentList "-NoExit", "-Command", $BridgeCommand

Set-Location $BoltRoot

if (-not (Test-Path (Join-Path $BoltRoot "node_modules"))) {
  Write-Host "Installing bolt.diy dependencies with pnpm@$PnpmVersion..." -ForegroundColor Yellow
  & npx --yes "pnpm@$PnpmVersion" install

  if ($LASTEXITCODE -ne 0) {
    throw "bolt.diy dependency installation failed with exit code $LASTEXITCODE"
  }
}

Write-Host "Starting bolt.diy..." -ForegroundColor Magenta
Write-Host "Open: http://localhost:5173/uiux" -ForegroundColor Green
Write-Host ""

& npx --yes "pnpm@$PnpmVersion" run dev

if ($LASTEXITCODE -ne 0) {
  throw "bolt.diy dev server exited with code $LASTEXITCODE"
}
