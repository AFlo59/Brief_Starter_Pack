#!/usr/bin/env pwsh
#
# Script pour executer pre-commit dans l'environnement WSL
#

Write-Host "Execution de pre-commit dans l'environnement virtuel WSL..." -ForegroundColor Cyan
Write-Host ""

$projectPath = "/mnt/c/Users/red59/Documents/Brief_Starter_Pack/projects/freshkart_migration"

$cmd = @"
cd $projectPath && source ../../venv/bin/activate && pre-commit run --all-files
"@

wsl bash -c $cmd

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Pre-commit passe avec succes !" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "Pre-commit a detecte des problemes (code: $LASTEXITCODE)" -ForegroundColor Yellow
    Write-Host "Les fichiers ont ete automatiquement corriges." -ForegroundColor Yellow
    Write-Host "Relancez le script pour verifier." -ForegroundColor Yellow
}
