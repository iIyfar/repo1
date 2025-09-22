# Advanced PowerShell Tools Companion Script
# Run with: powershell -ExecutionPolicy Bypass -File AdvancedTools.ps1

# Requires Admin privileges for some functions
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "Some features require Administrator privileges. Consider running as Administrator." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
}

# Main Menu Function
function Show-MainMenu {
    Clear-Host
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║          ADVANCED POWERSHELL SYSTEM TOOLS v2.0              ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[1] Advanced File Operations" -ForegroundColor Green
    Write-Host "[2] System Optimization" -ForegroundColor Green
    Write-Host "[3] Security Tools" -ForegroundColor Green
    Write-Host "[4] Network Analysis" -ForegroundColor Green
    Write-Host "[5] Process Management" -ForegroundColor Green
    Write-Host "[6] Disk Operations" -ForegroundColor Green
    Write-Host "[7] Registry Tools" -ForegroundColor Green
    Write-Host "[8] Scheduled Tasks" -ForegroundColor Green
    Write-Host "[9] System Information Export" -ForegroundColor Green
    Write-Host "[0] Exit" -ForegroundColor Red
    Write-Host ""
}

# File Operations Functions
function Advanced-FileOperations {
    Clear-Host
    Write-Host "=== Advanced File Operations ===" -ForegroundColor Yellow
    Write-Host "1. Find files by content"
    Write-Host "2. Bulk file operations"
    Write-Host "3. File attribute manager"
    Write-Host "4. Secure file shredder"
    Write-Host "5. Hidden file revealer"
    
    $choice = Read-Host "Select option"
    
    switch ($choice) {
        "1" {
            $searchPath = Read-Host "Enter search path"
            $searchString = Read-Host "Enter search string"
            Get-ChildItem -Path $searchPath -Recurse -File | 
                Select-String -Pattern $searchString | 
                Select-Object Path, LineNumber, Line | 
                Format-Table -AutoSize
        }
        "2" {
            $sourcePath = Read-Host "Enter source path"
            $operation = Read-Host "Operation (copy/move/delete)"
            $filter = Read-Host "File filter (e.g., *.txt)"
            
            $files = Get-ChildItem -Path $sourcePath -Filter $filter -Recurse
            
            switch ($operation) {
                "copy" {
                    $destPath = Read-Host "Enter destination path"
                    $files | Copy-Item -Destination $destPath -Force
                }
                "move" {
                    $destPath = Read-Host "Enter destination path"
                    $files | Move-Item -Destination $destPath -Force
                }
                "delete" {
                    $confirm = Read-Host "Confirm deletion? (YES to confirm)"
                    if ($confirm -eq "YES") {
                        $files | Remove-Item -Force
                    }
                }
            }
        }
        "3" {
            $filePath = Read-Host "Enter file/folder path"
            $item = Get-Item $filePath -Force
            
            Write-Host "Current Attributes: $($item.Attributes)"
            Write-Host "Options: Hidden, System, ReadOnly, Archive"
            $setAttribute = Read-Host "Enter attribute to toggle"
            
            if ($item.Attributes -band [System.IO.FileAttributes]::$setAttribute) {
                $item.Attributes = $item.Attributes -bxor [System.IO.FileAttributes]::$setAttribute
                Write-Host "Removed $setAttribute attribute"
            } else {
                $item.Attributes = $item.Attributes -bor [System.IO.FileAttributes]::$setAttribute
                Write-Host "Added $setAttribute attribute"
            }
        }
        "4" {
            $filePath = Read-Host "Enter file path to shred"
            if (Test-Path $filePath) {
                $bytes = Get-Item $filePath | Select-Object -ExpandProperty Length
                $random = New-Object byte[] $bytes
                $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create()
                
                1..3 | ForEach-Object {
                    $rng.GetBytes($random)
                    [System.IO.File]::WriteAllBytes($filePath, $random)
                    Write-Host "Pass $_ complete"
                }
                
                Remove-Item $filePath -Force
                Write-Host "File shredded and deleted"
            }
        }
        "5" {
            $path = Read-Host "Enter path to scan"
            Get-ChildItem -Path $path -Force -Recurse | 
                Where-Object { $_.Attributes -band [System.IO.FileAttributes]::Hidden } |
                Select-Object FullName, Attributes, Length |
                Format-Table -AutoSize
        }
    }
    
    Read-Host "Press Enter to continue"
}

# System Optimization Functions
function System-Optimization {
    Clear-Host
    Write-Host "=== System Optimization ===" -ForegroundColor Yellow
    
    # Clean temp files
    Write-Host "Cleaning temporary files..." -ForegroundColor Green
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    # Clear recycle bin
    Write-Host "Emptying Recycle Bin..." -ForegroundColor Green
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    
    # Optimize drives
    Write-Host "Optimizing drives..." -ForegroundColor Green
    Get-Volume | Where-Object { $_.DriveLetter } | ForEach-Object {
        Optimize-Volume -DriveLetter $_.DriveLetter -Defrag -Verbose
    }
    
    # Clear DNS cache
    Clear-DnsClientCache
    
    # Reset Windows Search
    Write-Host "Resetting Windows Search..." -ForegroundColor Green
    Stop-Service WSearch
    Remove-Item "$env:ProgramData\Microsoft\Search\Data\Applications\Windows\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service WSearch
    
    Write-Host "Optimization complete!" -ForegroundColor Green
    Read-Host "Press Enter to continue"
}

# Security Tools
function Security-Tools {
    Clear-Host
    Write-Host "=== Security Tools ===" -ForegroundColor Yellow
    Write-Host "1. Generate secure passwords"
    Write-Host "2. File integrity checker"
    Write-Host "3. Port security scanner"
    Write-Host "4. Process security analyzer"
    Write-Host "5. Firewall rule manager"
    
    $choice = Read-Host "Select option"
    
    switch ($choice) {
        "1" {
            Add-Type -AssemblyName System.Web
            $length = Read-Host "Password length (default 16)"
            if (-not $length) { $length = 16 }
            $password = [System.Web.Security.Membership]::GeneratePassword($length, 4)
            Write-Host "Generated Password: $password" -ForegroundColor Green
            $password | Set-Clipboard
            Write-Host "Password copied to clipboard" -ForegroundColor Yellow
        }
        "2" {
            $filePath = Read-Host "Enter file path"
            $hash = Get-FileHash -Path $filePath -Algorithm SHA256
            Write-Host "SHA256: $($hash.Hash)" -ForegroundColor Green
            
            $saveHash = Read-Host "Save hash for future comparison? (Y/N)"
            if ($saveHash -eq "Y") {
                $hash | Export-Csv -Path "$filePath.hash" -NoTypeInformation
                Write-Host "Hash saved to $filePath.hash"
            }
        }
        "3" {
            $target = Read-Host "Enter target IP/hostname"
            $startPort = Read-Host "Start port"
            $endPort = Read-Host "End port"
            
            $startPort..$endPort | ForEach-Object {
                $port = $_
                $tcp = New-Object System.Net.Sockets.TcpClient
                try {
                    $tcp.Connect($target, $port)
                    Write-Host "Port $port : OPEN" -ForegroundColor Red
                    $tcp.Close()
                } catch {
                    Write-Host "Port $port : CLOSED" -ForegroundColor Green
                }
            }
        }
        "4" {
            Get-Process | ForEach-Object {
                $proc = $_
                try {
                    $path = $proc.Path
                    if ($path) {
                        $sig = Get-AuthenticodeSignature $path
                        if ($sig.Status -ne "Valid") {
                            Write-Host "$($proc.Name) - UNSIGNED" -ForegroundColor Yellow
                        }
                    }
                } catch {}
            }
        }
        "5" {
            Get-NetFirewallRule | 
                Select-Object DisplayName, Direction, Action, Enabled |
                Out-GridView -Title "Firewall Rules" -PassThru
        }
    }
    
    Read-Host "Press Enter to continue"
}

# Main execution loop
do {
    Show-MainMenu
    $selection = Read-Host "Enter your choice"
    
    switch ($selection) {
        "1" { Advanced-FileOperations }
        "2" { System-Optimization }
        "3" { Security-Tools }
        "4" {
            # Network Analysis
            Get-NetTCPConnection | 
                Where-Object { $_.State -eq "Established" } |
                Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State |
                Format-Table -AutoSize
            Read-Host "Press Enter to continue"
        }
        "5" {
            # Process Management
            Get-Process | 
                Sort-Object CPU -Descending |
                Select-Object -First 20 Name, CPU, WorkingSet, Id |
                Format-Table -AutoSize
            
            $killProcess = Read-Host "Enter process ID to terminate (or Enter to skip)"
            if ($killProcess) {
                Stop-Process -Id $killProcess -Force
                Write-Host "Process terminated" -ForegroundColor Green
            }
            Read-Host "Press Enter to continue"
        }
        "6" {
            # Disk Operations
            Get-Volume | Format-Table -AutoSize
            Get-PhysicalDisk | Format-Table -AutoSize
            Get-Disk | Format-Table -AutoSize
            Read-Host "Press Enter to continue"
        }
        "7" {
            # Registry Tools
            Write-Host "Registry Backup..." -ForegroundColor Yellow
            $date = Get-Date -Format "yyyyMMdd_HHmmss"
            reg export HKLM "$env:USERPROFILE\Desktop\HKLM_$date.reg"
            reg export HKCU "$env:USERPROFILE\Desktop\HKCU_$date.reg"
            Write-Host "Registry backed up to Desktop" -ForegroundColor Green
            Read-Host "Press Enter to continue"
        }
        "8" {
            # Scheduled Tasks
            Get-ScheduledTask | 
                Where-Object { $_.State -ne "Disabled" } |
                Select-Object TaskName, State, TaskPath |
                Out-GridView -Title "Active Scheduled Tasks"
            Read-Host "Press Enter to continue"
        }
        "9" {
            # System Information Export
            $exportPath = "$env:USERPROFILE\Desktop\SystemInfo_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
            
            $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>System Information Report</title>
    <style>
        body { font-family: Arial, sans-serif; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        h2 { color: #333; }
    </style>
</head>
<body>
    <h1>System Information Report</h1>
    <h2>Computer Info</h2>
    $(Get-ComputerInfo | ConvertTo-Html -Fragment)
    <h2>Disk Usage</h2>
    $(Get-Volume | ConvertTo-Html -Fragment)
    <h2>Network Configuration</h2>
    $(Get-NetIPConfiguration | ConvertTo-Html -Fragment)
    <h2>Installed Software</h2>
    $(Get-Package | Select-Object Name, Version | ConvertTo-Html -Fragment)
</body>
</html>
"@
            
            $html | Out-File $exportPath
            Write-Host "System information exported to $exportPath" -ForegroundColor Green
            Read-Host "Press Enter to continue"
        }
    }
} while ($selection -ne "0")

Write-Host "Thank you for using Advanced PowerShell Tools!" -ForegroundColor Cyan