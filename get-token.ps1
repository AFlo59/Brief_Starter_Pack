#!/usr/bin/env pwsh
# Wrapper pour get-token.sh

& bash scripts/get-token.sh

if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
