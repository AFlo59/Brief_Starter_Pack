#!/usr/bin/env pwsh
# Wrapper pour docker-start.sh

Write-Host "🚀 Démarrage des services Docker..." -ForegroundColor Cyan
Write-Host ""

& bash scripts/docker-start.sh

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Erreur lors du démarrage!" -ForegroundColor Red
    exit $LASTEXITCODE
}
