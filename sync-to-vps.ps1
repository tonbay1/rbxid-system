# Auto Sync to VPS Script
param(
    [string]$VpsIP = "103.58.149.243",
    [string]$VpsUser = "Administrator",
    [string]$VpsPath = "C:\rbxid-system"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Auto Sync to VPS ($VpsIP)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to copy files using RoboCopy
function Sync-Files {
    Write-Host "[INFO] Syncing files to VPS..." -ForegroundColor Yellow
    
    # Using RoboCopy for efficient file sync
    $source = Get-Location
    $destination = "\\$VpsIP\C$\rbxid-system"
    
    try {
        # Create network drive mapping
        Write-Host "[INFO] Mapping network drive..." -ForegroundColor Yellow
        net use Z: "\\$VpsIP\C$" /persistent:no
        
        # Sync files
        robocopy "$source" "Z:\rbxid-system" /MIR /XD .git node_modules /XF *.log *.tmp
        
        Write-Host "[SUCCESS] Files synced successfully!" -ForegroundColor Green
        
        # Disconnect network drive
        net use Z: /delete /y
        
    } catch {
        Write-Host "[ERROR] Failed to sync files: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    
    return $true
}

# Function to restart server on VPS
function Restart-VpsServer {
    Write-Host "[INFO] Restarting server on VPS..." -ForegroundColor Yellow
    
    try {
        # Kill existing node processes
        Invoke-Command -ComputerName $VpsIP -ScriptBlock {
            Get-Process -Name "node" -ErrorAction SilentlyContinue | Stop-Process -Force
        }
        
        Start-Sleep -Seconds 2
        
        # Start new server process
        Invoke-Command -ComputerName $VpsIP -ScriptBlock {
            Set-Location "C:\rbxid-system\server"
            Start-Process -FilePath "node" -ArgumentList "rbxid-server.js" -WindowStyle Hidden
        }
        
        Write-Host "[SUCCESS] Server restarted!" -ForegroundColor Green
        return $true
        
    } catch {
        Write-Host "[ERROR] Failed to restart server: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Main execution
Write-Host "[INFO] Starting auto-sync process..." -ForegroundColor Yellow

if (Sync-Files) {
    if (Restart-VpsServer) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "    DEPLOY COMPLETED SUCCESSFULLY!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "Server URL: http://rbxid.com:3010" -ForegroundColor Cyan
        Write-Host "Health Check: http://rbxid.com:3010/health" -ForegroundColor Cyan
    }
} else {
    Write-Host "[ERROR] Deploy failed!" -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
