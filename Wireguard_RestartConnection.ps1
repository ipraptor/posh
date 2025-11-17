#==========================================
# Restart WireGuard Tunnel Service (No GUI)
# The script manages the tunnel via the Windows system service.
# Anton Palamarchuk (info@expice.ru) 25-11-17v1
#==========================================

# --- Check for Administrator Rights and Relaunch ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relaunch the script with elevated privileges
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`""
    Exit
}

# --- TUNNEL CONFIGURATION ---
# !!! REPLACE WITH YOUR EXACT TUNNEL NAME !!!
$TunnelName = "YOURTUNNELNAME" 
$ServiceName = "WireGuardTunnel$" + $TunnelName
# -------------------------

Write-Host "--- Starting WireGuard Tunnel: '$TunnelName' ---" -ForegroundColor Cyan

# 1. Service existence check
if (-not (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Service '$ServiceName' not found. Check the tunnel name." -ForegroundColor Red
    Exit
}

# 2. Stop the service (to ensure a clean start)
Write-Host "Attempting to stop the service..."
try {
    Stop-Service -Name $ServiceName -Force -ErrorAction Stop
    Write-Host "Service stopped." -ForegroundColor DarkYellow
    Start-Sleep -Seconds 2
}
catch {
    # Ignore error if the service is already stopped
    Write-Host "Service was already inactive. Continuing..." -ForegroundColor Yellow
}

# 3. Start the service and the tunnel
Write-Host "Starting service and tunnel..."
try {
    Start-Service -Name $ServiceName -ErrorAction Stop
    Write-Host "Service '$ServiceName' started. Waiting 10 seconds for Handshake..." -ForegroundColor Green
    Start-Sleep -Seconds 10
    
    # 4. Status Check
    $Status = Get-Service -Name $ServiceName
    if ($Status.Status -eq "Running") {
        Write-Host "=======================================" -ForegroundColor Green
        Write-Host "SUCCESS: Tunnel '$TunnelName' is active (Running)." -ForegroundColor Green
        Write-Host "=======================================" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Service started but status is not confirmed." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "CRITICAL ERROR: Failed to start the service. Check WireGuard logs." -ForegroundColor Red
}

Write-Host "--- Operation completed. ---"
