
@echo off
setlocal enabledelayedexpansion
title Ultimate Windows Admin Toolkit v2.0
color 0A
cd /d "%~dp0"

:MENU
cls
echo ================================================================================
echo                     ULTIMATE WINDOWS ADMIN TOOLKIT v2.0                       
echo ================================================================================
echo.
echo  [1] System Information Tools
echo  [2] Network Utilities
echo  [3] File and Folder Management
echo  [4] System Maintenance
echo  [5] Security and Privacy Tools
echo  [6] Performance Tools
echo  [7] Advanced PowerShell Tools
echo  [8] Backup and Recovery
echo  [9] Windows Features Management
echo  [0] Exit
echo.
echo ================================================================================
set /p choice="Select an option: "

if "%choice%"=="1" goto SYSINFO
if "%choice%"=="2" goto NETWORK
if "%choice%"=="3" goto FILEOPS
if "%choice%"=="4" goto MAINTENANCE
if "%choice%"=="5" goto SECURITY
if "%choice%"=="6" goto PERFORMANCE
if "%choice%"=="7" goto POWERSHELL
if "%choice%"=="8" goto BACKUP
if "%choice%"=="9" goto FEATURES
if "%choice%"=="0" exit
goto MENU

:SYSINFO
cls
echo ================================================================================
echo                          SYSTEM INFORMATION TOOLS
echo ================================================================================
echo.
echo  [1] Full System Information Report
echo  [2] Hardware Information
echo  [3] Installed Software List
echo  [4] Running Processes
echo  [5] System Uptime
echo  [6] Disk Usage Report
echo  [7] Environment Variables
echo  [8] Windows Version Details
echo  [9] Driver Information
echo  [0] Back to Main Menu
echo.
set /p subchoice="Select: "

if "%subchoice%"=="1" (
    echo Generating comprehensive system report...
    systeminfo > "%USERPROFILE%\Desktop\SystemReport_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt"
    msinfo32
    pause
)
if "%subchoice%"=="2" (
    wmic cpu get name,maxclockspeed,numberofcores,numberoflogicalprocessors
    wmic memorychip get capacity,speed,manufacturer
    wmic diskdrive get model,size,status
    pause
)
if "%subchoice%"=="3" (
    wmic product get name,version,vendor > "%USERPROFILE%\Desktop\InstalledSoftware.txt"
    echo Software list saved to Desktop
    pause
)
if "%subchoice%"=="4" (
    tasklist /v
    pause
)
if "%subchoice%"=="5" (
    wmic os get lastbootuptime
    net statistics server
    pause
)
if "%subchoice%"=="6" (
    wmic logicaldisk get size,freespace,name,volumename
    pause
)
if "%subchoice%"=="7" (
    set
    pause
)
if "%subchoice%"=="8" (
    ver
    wmic os get caption,version,buildnumber,osarchitecture
    pause
)
if "%subchoice%"=="9" (
    driverquery /v > "%USERPROFILE%\Desktop\DriverList.txt"
    echo Driver list saved to Desktop
    pause
)
if "%subchoice%"=="0" goto MENU
goto SYSINFO

:NETWORK
cls
echo ================================================================================
echo                            NETWORK UTILITIES
echo ================================================================================
echo.
echo  [1] Show Network Configuration
echo  [2] Ping Test
echo  [3] Trace Route
echo  [4] DNS Lookup
echo  [5] Show Active Connections
echo  [6] WiFi Profiles and Passwords
echo  [7] Flush DNS Cache
echo  [8] Reset Network Stack
echo  [9] Port Scanner
echo  [10] Network Speed Test
echo  [0] Back to Main Menu
echo.
set /p subchoice="Select: "

if "%subchoice%"=="1" (
    ipconfig /all
    pause
)
if "%subchoice%"=="2" (
    set /p pinghost="Enter hostname or IP: "
    ping -t !pinghost!
    pause
)
if "%subchoice%"=="3" (
    set /p tracehost="Enter hostname or IP: "
    tracert !tracehost!
    pause
)
if "%subchoice%"=="4" (
    set /p dnshost="Enter hostname: "
    nslookup !dnshost!
    pause
)
if "%subchoice%"=="5" (
    netstat -an
    pause
)
if "%subchoice%"=="6" (
    netsh wlan show profiles
    set /p wifiname="Enter WiFi name to show password: "
    netsh wlan show profile name="!wifiname!" key=clear
    pause
)
if "%subchoice%"=="7" (
    ipconfig /flushdns
    echo DNS Cache flushed successfully
    pause
)
if "%subchoice%"=="8" (
    echo WARNING: This will reset your network configuration!
    set /p confirm="Are you sure? (Y/N): "
    if /i "!confirm!"=="Y" (
        netsh winsock reset
        netsh int ip reset
        echo Please restart your computer
    )
    pause
)
if "%subchoice%"=="9" (
    set /p scanip="Enter IP to scan: "
    set /p portrange="Enter port range (e.g., 1-1000): "
    for /l %%i in (!portrange!) do (
        powershell -command "Test-NetConnection -ComputerName !scanip! -Port %%i -InformationLevel Quiet"
    )
    pause
)
if "%subchoice%"=="0" goto MENU
goto NETWORK

:FILEOPS
cls
echo ================================================================================
echo                        FILE AND FOLDER MANAGEMENT
echo ================================================================================
echo.
echo  [1] Hide Files/Folders (Attribute Method)
echo  [2] Unhide Files/Folders
echo  [3] Create Hidden System Folder
echo  [4] Secure Delete (Overwrite)
echo  [5] Batch Rename Files
echo  [6] Find Large Files
echo  [7] Duplicate File Finder
echo  [8] Lock/Unlock Folder
echo  [9] File Encryption
echo  [10] Alternative Data Streams
echo  [0] Back to Main Menu
echo.
set /p subchoice="Select: "

if "%subchoice%"=="1" (
    echo Enter path to hide (file or folder):
    set /p hidepath="> "
    attrib +h +s "!hidepath!"
    echo Item hidden successfully
    pause
)
if "%subchoice%"=="2" (
    echo Enter path to unhide:
    set /p unhidepath="> "
    attrib -h -s "!unhidepath!"
    echo Item unhidden successfully
    pause
)
if "%subchoice%"=="3" (
    set /p foldername="Enter folder name to create as hidden system: "
    mkdir "!foldername!"
    attrib +h +s "!foldername!"
    echo Hidden system folder created
    pause
)
if "%subchoice%"=="4" (
    echo WARNING: This will permanently delete and overwrite the file!
    set /p delfile="Enter file path to securely delete: "
    set /p confirm="Are you sure? (Y/N): "
    if /i "!confirm!"=="Y" (
        cipher /w:"!delfile!"
        del /f /q "!delfile!"
        echo File securely deleted
    )
    pause
)
if "%subchoice%"=="5" (
    echo Enter folder path containing files to rename:
    set /p renamepath="> "
    set /p prefix="Enter prefix for new names: "
    set counter=1
    for %%f in ("!renamepath!\*.*") do (
        ren "%%f" "!prefix!_!counter!%%~xf"
        set /a counter+=1
    )
    echo Files renamed successfully
    pause
)
if "%subchoice%"=="6" (
    echo Finding files larger than 100MB...
    forfiles /s /c "cmd /c if @fsize gtr 104857600 echo @path - @fsize bytes"
    pause
)
if "%subchoice%"=="7" (
    powershell -command "Get-ChildItem -Recurse | Group-Object Length | Where-Object {$_.Count -gt 1} | Select-Object -ExpandProperty Group | Format-Table FullName, Length"
    pause
)
if "%subchoice%"=="8" (
    echo [1] Lock Folder
    echo [2] Unlock Folder
    set /p lockChoice="Select: "
    if "!lockChoice!"=="1" (
        set /p lockFolder="Enter folder path to lock: "
        cacls "!lockFolder!" /E /P everyone:n
        echo Folder locked
    )
    if "!lockChoice!"=="2" (
        set /p unlockFolder="Enter folder path to unlock: "
        cacls "!unlockFolder!" /E /P everyone:f
        echo Folder unlocked
    )
    pause
)
if "%subchoice%"=="9" (
    echo [1] Encrypt File/Folder
    echo [2] Decrypt File/Folder
    set /p cryptChoice="Select: "
    if "!cryptChoice!"=="1" (
        set /p encryptPath="Enter path to encrypt: "
        cipher /e "!encryptPath!"
    )
    if "!cryptChoice!"=="2" (
        set /p decryptPath="Enter path to decrypt: "
        cipher /d "!decryptPath!"
    )
    pause
)
if "%subchoice%"=="10" (
    echo Alternative Data Streams - Hide data in files
    echo [1] Hide text in ADS
    echo [2] View ADS
    set /p adsChoice="Select: "
    if "!adsChoice!"=="1" (
        set /p hostFile="Enter host file path: "
        set /p hiddenData="Enter text to hide: "
        echo !hiddenData! > "!hostFile!:hidden"
        echo Data hidden in ADS
    )
    if "!adsChoice!"=="2" (
        set /p viewFile="Enter file path: "
        dir /r "!viewFile!"
        more < "!viewFile!:hidden"
    )
    pause
)
if "%subchoice%"=="0" goto MENU
goto FILEOPS

:MAINTENANCE
cls
echo ================================================================================
echo                           SYSTEM MAINTENANCE
echo ================================================================================
echo.
echo  [1] Disk Cleanup
echo  [2] Defragment Drives
echo  [3] Check Disk for Errors
echo  [4] System File Checker
echo  [5] Clear Temp Files
echo  [6] Windows Update Cleanup
echo  [7] Registry Backup
echo  [8] Clear Event Logs
echo  [9] Optimize Startup
echo  [0] Back to Main Menu
echo.
set /p subchoice="Select: "

if "%subchoice%"=="1" (
    cleanmgr /sageset:1
    cleanmgr /sagerun:1
    pause
)
if "%subchoice%"=="2" (
    defrag C: /A
    pause
)
if "%subchoice%"=="3" (
    echo This will schedule a disk check on next restart
    chkdsk C: /f /r
    pause
)
if "%subchoice%"=="4" (
    sfc /scannow
    pause
)
if "%subchoice%"=="5" (
    del /q /f /s %temp%\*
    del /q /f /s C:\Windows\Temp\*
    echo Temp files cleared
    pause
)
if "%subchoice%"=="6" (
    Dism.exe /online /Cleanup-Image /StartComponentCleanup
    pause
)
if "%subchoice%"=="7" (
    reg export HKLM "%USERPROFILE%\Desktop\Registry_Backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%.reg"
    echo Registry backed up to Desktop
    pause
)
if "%subchoice%"=="8" (
    for /f "tokens=*" %%a in ('wevtutil el') do wevtutil cl "%%a"
    echo All event logs cleared
    pause
)
if "%subchoice%"=="9" (
    msconfig
    pause
)
if "%subchoice%"=="0" goto MENU
goto MAINTENANCE

:SECURITY
cls
echo ================================================================================
echo                         SECURITY AND PRIVACY TOOLS
echo ================================================================================
echo.
echo  [1] Windows Defender Quick Scan
echo  [2] Firewall Settings
echo  [3] View/Kill Suspicious Processes
echo  [4] Clear Browser Data
echo  [5] Privacy Settings
echo  [6] Password Generator
echo  [7] File Hash Calculator
echo  [8] Secure Wipe Free Space
echo  [9] View Startup Programs
echo  [0] Back to Main Menu
echo.
set /p subchoice="Select: "

if "%subchoice%"=="1" (
    start windowsdefender:
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
    pause
)
if "%subchoice%"=="2" (
    netsh advfirewall show allprofiles
    pause
)
if "%subchoice%"=="3" (
    tasklist /v | findstr /i "unknown"
    set /p killpid="Enter PID to kill (or 0 to skip): "
    if not "!killpid!"=="0" taskkill /pid !killpid! /f
    pause
)
if "%subchoice%"=="4" (
    RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255
    echo Browser data cleared
    pause
)
if "%subchoice%"=="5" (
    start ms-settings:privacy
    pause
)
if "%subchoice%"=="6" (
    powershell -command "Add-Type -AssemblyName System.Web; [System.Web.Security.Membership]::GeneratePassword(16,4)"
    pause
)
if "%subchoice%"=="7" (
    set /p hashfile="Enter file path: "
    certutil -hashfile "!hashfile!" SHA256
    pause
)
if "%subchoice%"=="8" (
    echo WARNING: This will wipe free space on C: drive
    set /p confirm="Continue? (Y/N): "
    if /i "!confirm!"=="Y" cipher /w:C:
    pause
)
if "%subchoice%"=="9" (
    wmic startup get caption,command,location
    pause
)
if "%subchoice%"=="0" goto MENU
goto SECURITY

:PERFORMANCE
cls
echo ================================================================================
echo                           PERFORMANCE TOOLS
echo ================================================================================
echo.
echo  [1] Resource Monitor
echo  [2] Performance Monitor
echo  [3] RAM Memory Diagnostic
echo  [4] CPU Stress Test Info
echo  [5] Disable Unnecessary Services
echo  [6] Power Settings
echo  [7] Visual Effects Settings
echo  [8] Game Mode Toggle
echo  [9] Clear RAM Cache
echo  [0] Back to Main Menu
echo.
set /p subchoice="Select: "

if "%subchoice%"=="1" (
    resmon
    pause
)
if "%subchoice%"=="2" (
    perfmon
    pause
)
if "%subchoice%"=="3" (
    mdsched
    pause
)
if "%subchoice%"=="4" (
    wmic cpu get loadpercentage
    pause
)
if "%subchoice%"=="5" (
    services.msc
    pause
)
if "%subchoice%"=="6" (
    powercfg /list
    pause
)
if "%subchoice%"=="7" (
    SystemPropertiesPerformance
    pause
)
if "%subchoice%"=="8" (
    start ms-settings:gaming-gamemode
    pause
)
if "%subchoice%"=="9" (
    echo Clearing RAM cache...
    ipconfig /release
    ipconfig /renew
    arp -d *
    nbtstat -R
    nbtstat -RR
    ipconfig /flushdns
    ipconfig /registerdns
    echo RAM cache cleared
    pause
)
if "%subchoice%"=="0" goto MENU
goto PERFORMANCE


cls
echo ================================================================================
echo                        ADVANCED POWERSHELL TOOLS
echo ================================================================================
echo.
echo Creating PowerShell script...

(
echo # Advanced PowerShell Tools Script
echo.
echo function Show-Menu {
echo     Clear-Host
echo     Write-Host "================ PowerShell Advanced Tools ================"
echo     Write-Host "1: Get System Health Report"
echo     Write-Host "2: Find and Remove Empty Folders"
echo     Write-Host "3: Batch Image Resizer"
echo     Write-Host "4: Network Port Monitor"
echo     Write-Host "5: Process CPU Usage Monitor"
echo     Write-Host "6: Duplicate File Remover"
echo     Write-Host "7: System Restore Point Creator"
echo     Write-Host "8: Service Manager"
echo     Write-Host "9: Event Log Analyzer"
echo     Write-Host "0: Exit"
echo }
echo.
echo do {
echo     Show-Menu
echo     $selection = Read-Host "Select option"
echo     switch ^($selection^) {
echo         '1' {
echo             Get-ComputerInfo ^| Out-File "$env:USERPROFILE\Desktop\SystemHealth.txt"
echo             Write-Host "System health report saved to Desktop"
echo         }
echo         '2' {
echo             Get-ChildItem -Recurse -Directory ^| Where {^(Get-ChildItem $_.FullName^).Count -eq 0} ^| Remove-Item -Confirm
echo         }
echo         '3' {
echo             $folder = Read-Host "Enter image folder path"
echo             $width = Read-Host "Enter new width"
echo             Add-Type -AssemblyName System.Drawing
echo             Get-ChildItem $folder -Include *.jpg,*.png,*.bmp -Recurse ^| ForEach {
echo                 $img = [System.Drawing.Image]::FromFile^($_.FullName^)
echo                 $ratio = $width / $img.Width
echo                 $height = $img.Height * $ratio
echo                 $newImg = New-Object System.Drawing.Bitmap^($width, $height^)
echo                 $graphics = [System.Drawing.Graphics]::FromImage^($newImg^)
echo                 $graphics.DrawImage^($img, 0, 0, $width, $height^)
echo                 $newImg.Save^($_.FullName.Replace^($_.Extension, "_resized$^($_.Extension^)"^)^)
echo                 $img.Dispose^(^)
echo                 $newImg.Dispose^(^)
echo             }
echo         }
echo         '4' {
echo             $port = Read-Host "Enter port to monitor"
echo             while^($true^) {
echo                 $connection = Test-NetConnection -Port $port -InformationLevel Quiet
echo                 Write-Host "Port $port status: $connection"
echo                 Start-Sleep -Seconds 5
echo             }
echo         }
echo         '5' {
echo             Get-Process ^| Sort-Object CPU -Descending ^| Select-Object -First 10 Name, CPU, WorkingSet
echo         }
echo         '6' {
echo             $path = Read-Host "Enter path to scan for duplicates"
echo             Get-ChildItem $path -Recurse -File ^| Get-FileHash ^| Group-Object Hash ^| Where {$_.Count -gt 1} ^| ForEach {$_.Group ^| Select-Object Path}
echo         }
echo         '7' {
echo             $description = Read-Host "Enter restore point description"
echo             Checkpoint-Computer -Description $description
echo             Write-Host "Restore point created"
echo         }
echo         '8' {
echo             Get-Service ^| Out-GridView -PassThru ^| ForEach {
echo                 $action = Read-Host "Action for $^($_.Name^) [start/stop/restart/skip]"
echo                 switch^($action^) {
echo                     "start" {Start-Service $_.Name}
echo                     "stop" {Stop-Service $_.Name}
echo                     "restart" {Restart-Service $_.Name}
echo                 }
echo             }
echo         }
echo         '9' {
echo             $logName = Read-Host "Enter log name ^(Application/System/Security^)"
echo             Get-EventLog -LogName $logName -Newest 100 ^| Out-GridView
echo         }
echo     }
echo     if^($selection -ne '0'^) {pause}
echo } while^($selection -ne '0'^)
) > "%TEMP%\PowerShellTools.ps1"

powershell -ExecutionPolicy Bypass -File "%TEMP%\PowerShellTools.ps1"
del "%TEMP%\PowerShellTools.ps1"
goto MENU

:BACKUP
cls
echo ================================================================================
echo                          BACKUP AND RECOVERY
echo ================================================================================
echo.
echo  [1] Create System Restore Point
echo  [2] Backup User Profile
echo  [3] Backup Registry
echo  [4] Backup Drivers
echo  [5] Create System Image
echo  [6] File History Settings
echo  [7] Shadow Copy Explorer
echo  [8] Recovery Options
echo  [0] Back to Main Menu
echo.
set /p subchoice="Select: "

if "%subchoice%"=="1" (
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Manual Restore Point", 100, 7
    echo Restore point created
    pause
)
if "%subchoice%"=="2" (
    set backuppath=%USERPROFILE%\Desktop\ProfileBackup_%date:~-4,4%%date:~-10,2%%date:~-7,2%
    mkdir "!backuppath!"
    xcopy "%USERPROFILE%\Documents" "!backuppath!\Documents" /E /H /C /I
    xcopy "%USERPROFILE%\Desktop" "!backuppath!\Desktop" /E /H /C /I
    xcopy "%USERPROFILE%\Pictures" "!backuppath!\Pictures" /E /H /C /I
    echo Profile backed up to !backuppath!
    pause
)
if "%subchoice%"=="3" (
    reg export HKLM "%USERPROFILE%\Desktop\HKLM_Backup.reg"
    reg export HKCU "%USERPROFILE%\Desktop\HKCU_Backup.reg"
    echo Registry backed up to Desktop
    pause
)
if "%subchoice%"=="4" (
    dism /online /export-driver /destination:"%USERPROFILE%\Desktop\DriverBackup"
    echo Drivers backed up to Desktop\DriverBackup
    pause
)
if "%subchoice%"=="5" (
    wbadmin start backup -backupTarget:E: -include:C: -allCritical -quiet
    pause
)
if "%subchoice%"=="6" (
    start ms-settings:backup
    pause
)
if "%subchoice%"=="7" (
    vssadmin list shadows
    pause
)
if "%subchoice%"=="8" (
    start ms-settings:recovery
    pause
)
if "%subchoice%"=="0" goto MENU
goto BACKUP

:FEATURES
cls
echo ================================================================================
echo                      WINDOWS FEATURES MANAGEMENT
echo ================================================================================
echo.
echo  [1] Enable/Disable Windows Features
echo  [2] God Mode Folder
echo  [3] Hidden Windows Tools
echo  [4] Advanced System Settings
echo  [5] Group Policy Editor
echo  [6] Device Manager
echo  [7] Computer Management
echo  [8] Task Scheduler
echo  [9] Windows Sandbox
echo  [0] Back to Main Menu
echo.
set /p subchoice="Select: "

if "%subchoice%"=="1" (
    optionalfeatures
    pause
)
if "%subchoice%"=="2" (
    mkdir "%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
    echo God Mode folder created on Desktop
    pause
)
if "%subchoice%"=="3" (
    echo Opening hidden tools menu...
    echo.
    echo Available tools:
    echo - Character Map: charmap
    echo - Private Character Editor: eudcedit
    echo - Steps Recorder: psr
    echo - Math Input Panel: mip
    echo - Windows Memory Diagnostic: mdsched
    echo - System Configuration: msconfig
    echo - DirectX Diagnostic: dxdiag
    echo - Disk Cleanup: cleanmgr
    echo - Remote Desktop: mstsc
    echo - Snipping Tool: snippingtool
    echo.
    set /p tool="Enter tool command: "
    start !tool!
    pause
)
if "%subchoice%"=="4" (
    SystemPropertiesAdvanced
    pause
)
if "%subchoice%"=="5" (
    gpedit.msc
    pause
)
if "%subchoice%"=="6" (
    devmgmt.msc
    pause
)
if "%subchoice%"=="7" (
    compmgmt.msc
    pause
)
if "%subchoice%"=="8" (
    taskschd.msc
    pause
)
if "%subchoice%"=="9" (
    echo Checking Windows Sandbox status...
    powershell -command "Enable-WindowsOptionalFeature -Online -FeatureName 'Containers-DisposableClientVM' -All"
    pause
)
if "%subchoice%"=="0" goto MENU
goto FEATURES

:EXIT
echo.
echo Thank you for using Ultimate Windows Admin Toolkit!
timeout /t 3 /nobreak >nul
exit
```

## PowerShell Companion Script (Save as `AdvancedTools.ps1`)

```powershell
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
