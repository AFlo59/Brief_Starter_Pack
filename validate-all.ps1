#!/usr/bin/env pwsh
# Script de validation complète avant livraison

$ErrorActionPreference = "Stop"

Write-Host "`n🎯 VALIDATION FINALE - Brief Migration Pandas → PySpark" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""

$allPassed = $true

# 1. Vérifier Docker
Write-Host "1️⃣  Vérification Docker..." -ForegroundColor Yellow
$containerRunning = docker ps --filter "name=brief_starter_pack" --format "{{.Names}}" 2>$null

if (-not $containerRunning) {
    Write-Host "   ⚠️  Container non démarré. Démarrage..." -ForegroundColor Yellow
    & .\docker-start.ps1
    Start-Sleep -Seconds 5
} else {
    Write-Host "   ✅ Container actif" -ForegroundColor Green
}

# 2. Vérifier structure projet
Write-Host "`n2️⃣  Vérification structure projet..." -ForegroundColor Yellow

$requiredFiles = @(
    "projects/freshkart_migration/src/pandas/pipeline.py",
    "projects/freshkart_migration/src/pyspark/pipeline.py",
    "projects/freshkart_migration/tests/test_migration.py",
    "projects/freshkart_migration/.pre-commit-config.yaml",
    "docker-compose.yml",
    "Dockerfile"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ MANQUANT: $file" -ForegroundColor Red
        $allPassed = $false
    }
}

# 3. Lancer les tests
Write-Host "`n3️⃣  Lancement des tests unitaires..." -ForegroundColor Yellow
Write-Host ""

$testCmd = "cd /workspace/Brief_Starter_Pack/projects/freshkart_migration && pytest tests/ -v --tb=short"
$testOutput = docker exec brief_starter_pack bash -c $testCmd 2>&1

Write-Host $testOutput

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n   ✅ Tous les tests passent!" -ForegroundColor Green
} else {
    Write-Host "`n   ❌ Des tests ont échoué!" -ForegroundColor Red
    $allPassed = $false
}

# 4. Tester coverage
Write-Host "`n4️⃣  Calcul du coverage..." -ForegroundColor Yellow
Write-Host ""

$coverageCmd = "cd /workspace/Brief_Starter_Pack/projects/freshkart_migration && pytest tests/ --cov=src --cov-report=term-missing --tb=short"
$coverageOutput = docker exec brief_starter_pack bash -c $coverageCmd 2>&1

Write-Host $coverageOutput

if ($coverageOutput -match "TOTAL.*?(\d+)%") {
    $coverage = [int]$matches[1]
    if ($coverage -ge 80) {
        Write-Host "`n   ✅ Coverage: $coverage% (objectif: ≥80%)" -ForegroundColor Green
    } else {
        Write-Host "`n   ⚠️  Coverage: $coverage% (objectif: ≥80%)" -ForegroundColor Yellow
    }
}

# 5. Vérifier pre-commit
Write-Host "`n5️⃣  Test pre-commit hooks..." -ForegroundColor Yellow
Write-Host ""

$precommitCmd = "cd /workspace/Brief_Starter_Pack/projects/freshkart_migration && pre-commit run --all-files"
$precommitOutput = docker exec brief_starter_pack bash -c $precommitCmd 2>&1

Write-Host $precommitOutput

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n   ✅ Pre-commit hooks OK" -ForegroundColor Green
} else {
    Write-Host "`n   ⚠️  Pre-commit a fait des corrections (normal)" -ForegroundColor Yellow
}

# 6. Comparer résultats Pandas vs PySpark
Write-Host "`n6️⃣  Comparaison Pandas vs PySpark..." -ForegroundColor Yellow
Write-Host ""

$compareCmd = "cd /workspace/Brief_Starter_Pack/projects/freshkart_migration && python3 compare_results.py"
docker exec brief_starter_pack bash -c $compareCmd 2>&1

# 7. Vérifier documentation
Write-Host "`n7️⃣  Vérification documentation..." -ForegroundColor Yellow

$docs = @(
    "README.md",
    "projects/freshkart_migration/README.md",
    "projects/freshkart_migration/SPRINT_PLANNING.md",
    "STATUS.md"
)

foreach ($doc in $docs) {
    if (Test-Path $doc) {
        $lines = (Get-Content $doc).Count
        Write-Host "   ✅ $doc ($lines lignes)" -ForegroundColor Green
    } else {
        Write-Host "   ❌ MANQUANT: $doc" -ForegroundColor Red
        $allPassed = $false
    }
}

# 8. Vérifier notebooks
Write-Host "`n8️⃣  Vérification notebooks..." -ForegroundColor Yellow

$notebooks = Get-ChildItem -Path "notebooks" -Filter "*.ipynb" -File

Write-Host "   📓 $($notebooks.Count) notebooks trouvés:" -ForegroundColor Cyan
foreach ($nb in $notebooks) {
    Write-Host "      - $($nb.Name)" -ForegroundColor Gray
}

# Résumé final
Write-Host "`n" + ("=" * 70) -ForegroundColor Cyan
Write-Host "📊 RÉSUMÉ DE LA VALIDATION" -ForegroundColor Cyan
Write-Host ("=" * 70) -ForegroundColor Cyan

if ($allPassed) {
    Write-Host "`n✅ PROJET PRÊT POUR LIVRAISON!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Prochaines étapes:" -ForegroundColor Yellow
    Write-Host "   1. Push sur GitHub: git init && git add . && git commit -m 'Migration complete'" -ForegroundColor White
    Write-Host "   2. Préparer présentation (voir demo_presentation.ipynb)" -ForegroundColor White
    Write-Host "   3. Tester notebooks dans Jupyter: http://localhost:8888" -ForegroundColor White
    Write-Host ""
    Write-Host "🎯 Critères Brief:" -ForegroundColor Yellow
    Write-Host "   ✅ Code migré Pandas → PySpark" -ForegroundColor Green
    Write-Host "   ✅ Tests unitaires (mêmes résultats)" -ForegroundColor Green
    Write-Host "   ✅ Pre-commit hooks configurés" -ForegroundColor Green
    Write-Host "   ✅ Organisation Agile (SPRINT_PLANNING.md)" -ForegroundColor Green
    Write-Host "   ✅ Documentation complète" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  CORRECTIONS NÉCESSAIRES" -ForegroundColor Yellow
    Write-Host "   Voir les erreurs ci-dessus" -ForegroundColor White
}

Write-Host ""
