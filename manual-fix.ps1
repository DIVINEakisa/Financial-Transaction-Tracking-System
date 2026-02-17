# Manual Fix for Transaction Servlet
# This will copy the source to ensure it compiles fresh

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " FTTS - Manual Rebuild Fix" -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if VS Code Java extension is available
$vscodeTasks = Test-Path ".vscode\tasks.json"

if ($vscodeTasks) {
    Write-Host "VS Code detected! Please do the following:" -ForegroundColor Yellow
    Write-Host "1. Press Ctrl+Shift+P" -ForegroundColor White
    Write-Host "2. Type: Java: Clean Java Language Server Workspace" -ForegroundColor White
    Write-Host "3. Click 'Restart and delete'" -ForegroundColor White
    Write-Host "4. Wait for rebuild to complete" -ForegroundColor White
    Write-Host "5. Then run this in terminal: mvn tomcat7:run" -ForegroundColor White
} else {
    Write-Host "Please do ONE of the following:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "OPTION 1 - VS Code:" -ForegroundColor Green
    Write-Host "  1. Open Command Palette (Ctrl+Shift+P)" -ForegroundColor White
    Write-Host "  2. Type: Java: Clean Java Language Server Workspace" -ForegroundColor White
    Write-Host "  3. Select 'Restart and delete'" -ForegroundColor White
    Write-Host ""
    Write-Host "OPTION 2 - IntelliJ IDEA:" -ForegroundColor Green
    Write-Host "  1. Build menu -> Rebuild Project" -ForegroundColor White
    Write-Host "  2. Run menu -> Stop (if running)" -ForegroundColor White
    Write-Host "  3. Run menu -> Run" -ForegroundColor White
    Write-Host ""
    Write-Host "OPTION 3 - Eclipse:" -ForegroundColor Green
    Write-Host "  1. Right-click project -> Clean..." -ForegroundColor White
    Write-Host "  2. Right-click project -> Build Project" -ForegroundColor White
    Write-Host "  3. Right-click project -> Run As -> Run on Server" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "After rebuilding, access: http://localhost:8080/ftts/transactions.jsp" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

pause
