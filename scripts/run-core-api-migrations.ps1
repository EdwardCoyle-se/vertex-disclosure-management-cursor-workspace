# =====================================================
# Run Core API Database Migrations
# ESG-13441: Manual Publish Workflow
# =====================================================

param(
    [switch]$Clean = $false,
    [string]$Environment = "local"
)

Write-Host "=== Core API Database Migrations ===" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"
$coreApiPath = "DotNet_Angular\vertex-disclosure-management-api\service\SE.Sustainability.Vertex.DisclosureManagement.API"

try {
    # Step 1: Stop running Core API processes
    Write-Host "Step 1: Checking for running Core API processes..." -ForegroundColor Yellow
    $processes = Get-Process | Where-Object { $_.ProcessName -like "*DisclosureManagement.API*" }
    
    if ($processes) {
        Write-Host "Found $($processes.Count) running process(es). Stopping..." -ForegroundColor Yellow
        $processes | ForEach-Object {
            Write-Host "  Stopping process $($_.Id) ($($_.ProcessName))" -ForegroundColor Gray
            Stop-Process -Id $_.Id -Force
        }
        Start-Sleep -Seconds 2
        Write-Host "[OK] Processes stopped" -ForegroundColor Green
    } else {
        Write-Host "[OK] No running processes found" -ForegroundColor Green
    }
    Write-Host ""

    # Step 2: Navigate to Core API directory
    Write-Host "Step 2: Navigating to Core API directory..." -ForegroundColor Yellow
    if (-not (Test-Path $coreApiPath)) {
        throw "Core API path not found: $coreApiPath"
    }
    Push-Location $coreApiPath
    Write-Host "[OK] Current directory: $(Get-Location)" -ForegroundColor Green
    Write-Host ""

    # Step 3: Clean build (optional)
    if ($Clean) {
        Write-Host "Step 3: Cleaning solution..." -ForegroundColor Yellow
        dotnet clean --configuration Debug
        if ($LASTEXITCODE -ne 0) {
            throw "Clean failed with exit code $LASTEXITCODE"
        }
        Write-Host "[OK] Solution cleaned" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host "Step 3: Skipping clean (use -Clean to enable)" -ForegroundColor Gray
        Write-Host ""
    }

    # Step 4: Restore NuGet packages
    Write-Host "Step 4: Restoring NuGet packages..." -ForegroundColor Yellow
    dotnet restore
    if ($LASTEXITCODE -ne 0) {
        throw "Restore failed with exit code $LASTEXITCODE"
    }
    Write-Host "[OK] NuGet packages restored" -ForegroundColor Green
    Write-Host ""

    # Step 5: Build the solution
    Write-Host "Step 5: Building solution..." -ForegroundColor Yellow
    dotnet build --configuration Debug --no-restore
    if ($LASTEXITCODE -ne 0) {
        throw "Build failed with exit code $LASTEXITCODE"
    }
    Write-Host "[OK] Build succeeded" -ForegroundColor Green
    Write-Host ""

    # Step 6: Run migrations
    Write-Host "Step 6: Running database migrations..." -ForegroundColor Yellow
    Write-Host "Environment: $Environment" -ForegroundColor Gray
    Write-Host ""
    Write-Host "--- Migration Output ---" -ForegroundColor Cyan
    
    $env:APP_ENV = $Environment
    $env:ASPNETCORE_ENVIRONMENT = $Environment
    
    dotnet run --no-build -- run-migrations
    
    if ($LASTEXITCODE -ne 0) {
        throw "Migration failed with exit code $LASTEXITCODE"
    }
    Write-Host "--- End Migration Output ---" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[OK] Migrations completed successfully" -ForegroundColor Green
    Write-Host ""

    # Step 7: Success message
    Write-Host "=== Migration Complete ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Run the diagnostic script to verify columns exist:" -ForegroundColor Gray
    Write-Host "     .\scripts\run-database-diagnostic.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "  2. Start the Core API and test:" -ForegroundColor Gray
    Write-Host "     cd $coreApiPath" -ForegroundColor White
    Write-Host "     dotnet run" -ForegroundColor White
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "=== Migration Failed ===" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Check if SQL Server is running" -ForegroundColor Gray
    Write-Host "  2. Verify connection string in appsettings.local.json" -ForegroundColor Gray
    Write-Host "  3. Check if database exists: sqldb-disclosure-managment-non" -ForegroundColor Gray
    Write-Host "  4. Review migration script for errors" -ForegroundColor Gray
    Write-Host ""
    exit 1
} finally {
    Pop-Location
}


