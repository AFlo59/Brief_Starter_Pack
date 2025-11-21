#!/usr/bin/env pwsh
# Wrapper pour docker-build.sh

Write-Host "🐳 Construction de l'image Docker..." -ForegroundColor Cyan
Write-Host ""

& bash scripts/docker-build.sh

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Erreur lors de la construction!" -ForegroundColor Red
    exit $LASTEXITCODE
}
