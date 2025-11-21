#!/usr/bin/env pwsh
# Script PowerShell pour lancer les tests du projet de migration

Write-Host "🧪 Tests FreshKart Migration" -ForegroundColor Cyan
Write-Host "============================`n" -ForegroundColor Cyan

# Vérifier que Docker est running
$containerRunning = docker ps --filter "name=brief_starter_pack" --format "{{.Names}}" 2>$null

if (-not $containerRunning) {
    Write-Host "❌ Container Docker non démarré!" -ForegroundColor Red
    Write-Host "   Lancez: .\docker-start.sh`n" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Container Docker actif`n" -ForegroundColor Green

# Options
$RunCoverage = $false
$Verbose = $false

# Parser les arguments
foreach ($arg in $args) {
    if ($arg -eq "--coverage" -or $arg -eq "-c") {
        $RunCoverage = $true
    }
    if ($arg -eq "--verbose" -or $arg -eq "-v") {
        $Verbose = $true
    }
    if ($arg -eq "--help" -or $arg -eq "-h") {
        Write-Host "Usage: .\run-tests.ps1 [options]`n" -ForegroundColor White
        Write-Host "Options:" -ForegroundColor White
        Write-Host "  --coverage, -c    Lancer avec coverage" -ForegroundColor Gray
        Write-Host "  --verbose, -v     Mode verbeux" -ForegroundColor Gray
        Write-Host "  --help, -h        Afficher cette aide`n" -ForegroundColor Gray
        exit 0
    }
}

# Construire la commande
$testCmd = "cd /workspace/Brief_Starter_Pack/projects/freshkart_migration && pytest tests/"

if ($Verbose) {
    $testCmd += " -v"
}

if ($RunCoverage) {
    Write-Host "📊 Lancement des tests avec coverage...`n" -ForegroundColor Yellow
    $testCmd += " --cov=src --cov-report=html --cov-report=term"
} else {
    Write-Host "🚀 Lancement des tests...`n" -ForegroundColor Yellow
}

# Lancer les tests
docker exec -it brief_starter_pack bash -c $testCmd

$exitCode = $LASTEXITCODE

# Résultat
Write-Host "`n============================`n" -ForegroundColor Cyan

if ($exitCode -eq 0) {
    Write-Host "✅ Tous les tests sont passés!" -ForegroundColor Green

    if ($RunCoverage) {
        Write-Host "`n📊 Rapport coverage généré dans htmlcov/index.html" -ForegroundColor Cyan
    }
} else {
    Write-Host "❌ Des tests ont échoué!" -ForegroundColor Red
    exit $exitCode
}
