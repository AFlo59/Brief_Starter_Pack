#!/usr/bin/env pwsh
#
# Script PowerShell wrapper pour nettoyer l'environnement Docker
# Appelle le script bash scripts/docker-clean.sh via WSL
#

Write-Host "Nettoyage de l'environnement Docker..." -ForegroundColor Yellow
Write-Host ""

# Verifier que WSL est disponible
try {
    wsl --list --quiet | Out-Null
} catch {
    Write-Host "ERREUR: WSL n'est pas disponible" -ForegroundColor Red
    Write-Host "Installez WSL: https://aka.ms/wsl" -ForegroundColor Yellow
    exit 1
}

# Convertir le chemin Windows en chemin WSL
$scriptPath = $PSScriptRoot
$wslPath = $scriptPath -replace '\\', '/' -replace 'C:', '/mnt/c'

# Executer le script bash dans WSL
Write-Host "Execution du script de nettoyage..." -ForegroundColor Cyan
Write-Host ""

$bashCmd = "cd '$wslPath' ; chmod +x scripts/docker-clean.sh ; ./scripts/docker-clean.sh"
wsl bash -c $bashCmd

$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    Write-Host ""
    Write-Host "Nettoyage termine avec succes !" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "Erreur lors du nettoyage (code: $exitCode)" -ForegroundColor Red
    exit $exitCode
}
