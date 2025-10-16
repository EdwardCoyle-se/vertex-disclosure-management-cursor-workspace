# =====================================================
# Run Database Diagnostic Script
# ESG-13441: Manual Publish Workflow
# Checks if migration columns exist in the database
# =====================================================

param(
    [string]$Server = "127.0.0.1,1433",
    [string]$Database = "sqldb-disclosure-managment-non",
    [string]$Username = "sa",
    [string]$Password = "1.LOCAL_PASS#"
)

Write-Host "=== Database Schema Diagnostic ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Connection Details:" -ForegroundColor Yellow
Write-Host "  Server:   $Server" -ForegroundColor Gray
Write-Host "  Database: $Database" -ForegroundColor Gray
Write-Host "  Username: $Username" -ForegroundColor Gray
Write-Host ""

$ErrorActionPreference = "Stop"
$scriptPath = "scripts\diagnose-database-schema.sql"

try {
    # Check if SQL script exists
    if (-not (Test-Path $scriptPath)) {
        throw "Diagnostic SQL script not found: $scriptPath"
    }
    Write-Host "[OK] Diagnostic script found: $scriptPath" -ForegroundColor Green
    Write-Host ""

    # Check if sqlcmd is available
    $sqlcmdPath = Get-Command sqlcmd -ErrorAction SilentlyContinue
    if (-not $sqlcmdPath) {
        Write-Host "[ERROR] sqlcmd not found in PATH" -ForegroundColor Red
        Write-Host ""
        Write-Host "Alternative: Run the SQL script manually in SQL Server Management Studio (SSMS)" -ForegroundColor Yellow
        Write-Host "Script location: $(Get-Item $scriptPath | Select-Object -ExpandProperty FullName)" -ForegroundColor White
        Write-Host ""
        Write-Host "Or install sqlcmd:" -ForegroundColor Yellow
        Write-Host "  https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility" -ForegroundColor Gray
        exit 1
    }
    Write-Host "[OK] sqlcmd found: $($sqlcmdPath.Source)" -ForegroundColor Green
    Write-Host ""

    # Run the diagnostic script
    Write-Host "Running diagnostic script..." -ForegroundColor Yellow
    Write-Host "--- Diagnostic Output ---" -ForegroundColor Cyan
    Write-Host ""
    
    $connectionString = "Server=$Server;Database=$Database;User Id=$Username;Password=$Password;TrustServerCertificate=True;"
    
    sqlcmd -S $Server -d $Database -U $Username -P $Password -i $scriptPath -C
    
    if ($LASTEXITCODE -ne 0) {
        throw "Diagnostic script failed with exit code $LASTEXITCODE"
    }
    
    Write-Host ""
    Write-Host "--- End Diagnostic Output ---" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[OK] Diagnostic completed successfully" -ForegroundColor Green
    Write-Host ""

    # Provide guidance based on common scenarios
    Write-Host "=== Next Steps ===" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "If columns are MISSING:" -ForegroundColor Yellow
    Write-Host "  1. Run the migration script:" -ForegroundColor Gray
    Write-Host "     .\scripts\run-core-api-migrations.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "If columns EXIST but error persists:" -ForegroundColor Yellow
    Write-Host "  1. Verify Core API is connecting to the correct database" -ForegroundColor Gray
    Write-Host "  2. Check appsettings.local.json connection string" -ForegroundColor Gray
    Write-Host "  3. Restart Core API to pick up schema changes" -ForegroundColor Gray
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "=== Diagnostic Failed ===" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Manual Alternative:" -ForegroundColor Yellow
    Write-Host "  1. Open SQL Server Management Studio (SSMS)" -ForegroundColor Gray
    Write-Host "  2. Connect to: $Server" -ForegroundColor Gray
    Write-Host "  3. Open script: $(Get-Item $scriptPath | Select-Object -ExpandProperty FullName)" -ForegroundColor Gray
    Write-Host "  4. Execute against database: $Database" -ForegroundColor Gray
    Write-Host ""
    exit 1
}


