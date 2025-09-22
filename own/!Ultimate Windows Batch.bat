@echo off
setlocal EnableDelayedExpansion
title Ultimate Windows Power Tool Suite v1.0
color 0A
mode con: cols=100 lines=40

:INIT
set "VERSION=1.0"
set "AUTHOR=PowerSuite"
set "TEMP_DIR=%TEMP%\PowerSuite"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
cd /d "%~dp0"

:MAIN_MENU
cls
call :BANNER
echo.
echo  ==================== MAIN MENU ====================
echo.
echo   [1] Network Tools           [8] File Management Tools
echo   [2] System Admin Tools      [9] Security Tools
echo   [3] Windows Tweaks          [10] Developer Tools
echo   [4] System Information      [11] Mini Games
echo   [5] Performance Tools       [12] Internet Tools
echo   [6] Privacy Tools           [13] Advanced Utilities
echo   [7] Diagnostic Tools        [14] Quick Actions
echo.
echo   [0] Exit
echo.
echo  ===================================================
echo.
set /p "choice=Select Option: "

if "%choice%"=="1" goto NETWORK_TOOLS
if "%choice%"=="2" goto SYSADMIN_TOOLS
if "%choice%"=="3" goto WINDOWS_TWEAKS
if "%choice%"=="4" goto SYSTEM_INFO
if "%choice%"=="5" goto PERFORMANCE_TOOLS
if "%choice%"=="6" goto PRIVACY_TOOLS
if "%choice%"=="7" goto DIAGNOSTIC_TOOLS
if "%choice%"=="8" goto FILE_TOOLS
if "%choice%"=="9" goto SECURITY_TOOLS
if "%choice%"=="10" goto DEV_TOOLS
if "%choice%"=="11" goto GAMES
if "%choice%"=="12" goto INTERNET_TOOLS
if "%choice%"=="13" goto ADVANCED_UTILS
if "%choice%"=="14" goto QUICK_ACTIONS
if "%choice%"=="0" goto EXIT_SCRIPT
goto MAIN_MENU

:BANNER
echo.
echo   ╔═══════════════════════════════════════════════════════════════════╗
echo   ║   ██╗   ██╗██╗  ████████╗██╗███╗   ███╗ █████╗ ████████╗███████╗ ║
echo   ║   ██║   ██║██║  ╚══██╔══╝██║████╗ ████║██╔══██╗╚══██╔══╝██╔════╝ ║
echo   ║   ██║   ██║██║     ██║   ██║██╔████╔██║███████║   ██║   █████╗   ║
echo   ║   ██║   ██║██║     ██║   ██║██║╚██╔╝██║██╔══██║   ██║   ██╔══╝   ║
echo   ║   ╚██████╔╝███████╗██║   ██║██║ ╚═╝ ██║██║  ██║   ██║   ███████╗ ║
echo   ║    ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝ ║
echo   ║                    Windows Power Tool Suite v%VERSION%                 ║
echo   ╚═══════════════════════════════════════════════════════════════════╝
goto :EOF

:NETWORK_TOOLS
cls
call :BANNER
echo.
echo  ==================== NETWORK TOOLS ====================
echo.
echo   [1] Network Scanner         [6] DNS Tools
echo   [2] Port Scanner            [7] MAC Address Tools
echo   [3] Speed Test              [8] Network Reset
echo   [4] WiFi Manager            [9] Proxy Configuration
echo   [5] Network Monitor         [10] Advanced IP Config
echo.
echo   [0] Back to Main Menu
echo.
set /p "nchoice=Select Option: "

if "%nchoice%"=="1" goto NET_SCANNER
if "%nchoice%"=="2" goto PORT_SCANNER
if "%nchoice%"=="3" goto SPEED_TEST
if "%nchoice%"=="4" goto WIFI_MANAGER
if "%nchoice%"=="5" goto NET_MONITOR
if "%nchoice%"=="6" goto DNS_TOOLS
if "%nchoice%"=="7" goto MAC_TOOLS
if "%nchoice%"=="8" goto NET_RESET
if "%nchoice%"=="9" goto PROXY_CONFIG
if "%nchoice%"=="10" goto ADV_IP_CONFIG
if "%nchoice%"=="0" goto MAIN_MENU
goto NETWORK_TOOLS

:NET_SCANNER
cls
echo.
echo  ==================== NETWORK SCANNER ====================
echo.
echo Scanning local network...
echo.
for /l %%i in (1,1,254) do (
    set "ip=192.168.1.%%i"
    ping -n 1 -w 100 !ip! >nul 2>&1
    if !errorlevel!==0 (
        echo [ONLINE] !ip!
        for /f "tokens=2" %%a in ('arp -a !ip! ^| findstr !ip!') do echo    MAC: %%a
    )
)
echo.
pause
goto NETWORK_TOOLS

:PORT_SCANNER
cls
echo.
echo  ==================== PORT SCANNER ====================
echo.
set /p "target=Enter target IP/hostname: "
echo.
echo Scanning common ports on %target%...
echo.
for %%p in (21 22 23 25 53 80 110 443 445 3306 3389 8080) do (
    powershell -Command "$tcp = New-Object System.Net.Sockets.TcpClient; try { $tcp.Connect('%target%', %%p); Write-Host '[OPEN] Port %%p'; $tcp.Close() } catch { }" 2>nul
)
echo.
pause
goto NETWORK_TOOLS

:WIFI_MANAGER
cls
echo.
echo  ==================== WiFi MANAGER ====================
echo.
echo   [1] Show WiFi Profiles
echo   [2] Show Saved Passwords
echo   [3] Connect to Network
echo   [4] Disconnect WiFi
echo   [5] Export WiFi Profile
echo.
set /p "wchoice=Select: "

if "%wchoice%"=="1" (
    netsh wlan show profiles
) else if "%wchoice%"=="2" (
    echo.
    set /p "profile=Enter WiFi profile name: "
    netsh wlan show profile "!profile!" key=clear | findstr /C:"Key Content"
) else if "%wchoice%"=="3" (
    set /p "ssid=Enter SSID: "
    netsh wlan connect name="!ssid!"
) else if "%wchoice%"=="4" (
    netsh wlan disconnect
) else if "%wchoice%"=="5" (
    set /p "profile=Enter profile to export: "
    netsh wlan export profile name="!profile!" folder="%cd%"
)
echo.
pause
goto NETWORK_TOOLS

:SYSADMIN_TOOLS
cls
call :BANNER
echo.
echo  ==================== SYSADMIN TOOLS ====================
echo.
echo   [1] User Management         [6] Service Manager
echo   [2] Process Manager         [7] Registry Tools
echo   [3] Task Scheduler          [8] Event Log Viewer
echo   [4] System Restore          [9] Driver Manager
echo   [5] Group Policy Editor     [10] Remote Desktop Config
echo.
echo   [0] Back to Main Menu
echo.
set /p "schoice=Select Option: "

if "%schoice%"=="1" goto USER_MGMT
if "%schoice%"=="2" goto PROCESS_MGR
if "%schoice%"=="3" goto TASK_SCHED
if "%schoice%"=="4" goto SYS_RESTORE
if "%schoice%"=="5" start gpedit.msc & goto SYSADMIN_TOOLS
if "%schoice%"=="6" goto SERVICE_MGR
if "%schoice%"=="7" goto REG_TOOLS
if "%schoice%"=="8" start eventvwr.msc & goto SYSADMIN_TOOLS
if "%schoice%"=="9" goto DRIVER_MGR
if "%schoice%"=="10" goto RDP_CONFIG
if "%schoice%"=="0" goto MAIN_MENU
goto SYSADMIN_TOOLS

:PROCESS_MGR
cls
echo.
echo  ==================== PROCESS MANAGER ====================
echo.
echo   [1] List All Processes
echo   [2] Kill Process by Name
echo   [3] Kill Process by PID
echo   [4] Process Tree
echo   [5] Top CPU Consumers
echo.
set /p "pchoice=Select: "

if "%pchoice%"=="1" (
    tasklist /v
) else if "%pchoice%"=="2" (
    set /p "pname=Enter process name: "
    taskkill /f /im "!pname!"
) else if "%pchoice%"=="3" (
    set /p "pid=Enter PID: "
    taskkill /f /pid !pid!
) else if "%pchoice%"=="4" (
    wmic process get Caption,ProcessId,ParentProcessId /format:table
) else if "%pchoice%"=="5" (
    wmic process get Caption,ProcessId,WorkingSetSize /format:table | sort /r
)
echo.
pause
goto SYSADMIN_TOOLS

:WINDOWS_TWEAKS
cls
call :BANNER
echo.
echo  ==================== WINDOWS TWEAKS ====================
echo.
echo   [1] Disable Telemetry       [6] Context Menu Editor
echo   [2] Optimize Startup        [7] Visual Effects
echo   [3] Privacy Settings        [8] Power Options
echo   [4] Windows Update Control  [9] System Sounds
echo   [5] Defender Settings       [10] Advanced Settings
echo.
echo   [0] Back to Main Menu
echo.
set /p "tchoice=Select Option: "

if "%tchoice%"=="1" goto DISABLE_TELEMETRY
if "%tchoice%"=="2" goto OPTIMIZE_STARTUP
if "%tchoice%"=="3" goto PRIVACY_SETTINGS
if "%tchoice%"=="4" goto UPDATE_CONTROL
if "%tchoice%"=="5" goto DEFENDER_SETTINGS
if "%tchoice%"=="6" goto CONTEXT_MENU
if "%tchoice%"=="7" goto VISUAL_EFFECTS
if "%tchoice%"=="8" start powercfg.cpl & goto WINDOWS_TWEAKS
if "%tchoice%"=="9" start mmsys.cpl & goto WINDOWS_TWEAKS
if "%tchoice%"=="10" goto ADV_SETTINGS
if "%tchoice%"=="0" goto MAIN_MENU
goto WINDOWS_TWEAKS

:DISABLE_TELEMETRY
cls
echo.
echo  ==================== DISABLE TELEMETRY ====================
echo.
echo Disabling Windows telemetry services...
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start=disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start=disabled >nul 2>&1
echo.
echo Creating registry entries to block telemetry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
echo.
echo Telemetry disabled successfully!
pause
goto WINDOWS_TWEAKS

:FILE_TOOLS
cls
call :BANNER
echo.
echo  ==================== FILE MANAGEMENT TOOLS ====================
echo.
echo   [1] File Hider/Unhider      [6] Duplicate Finder
echo   [2] Secure Delete           [7] File Encryptor
echo   [3] Batch Rename            [8] Permission Manager
echo   [4] Directory Tree          [9] Symbolic Link Creator
echo   [5] Large File Finder       [10] File Attributes
echo.
echo   [0] Back to Main Menu
echo.
set /p "fchoice=Select Option: "

if "%fchoice%"=="1" goto FILE_HIDER
if "%fchoice%"=="2" goto SECURE_DELETE
if "%fchoice%"=="3" goto BATCH_RENAME
if "%fchoice%"=="4" goto DIR_TREE
if "%fchoice%"=="5" goto LARGE_FILES
if "%fchoice%"=="6" goto DUP_FINDER
if "%fchoice%"=="7" goto FILE_ENCRYPT
if "%fchoice%"=="8" goto PERM_MGR
if "%fchoice%"=="9" goto SYMLINK
if "%fchoice%"=="10" goto FILE_ATTR
if "%fchoice%"=="0" goto MAIN_MENU
goto FILE_TOOLS

:FILE_HIDER
cls
echo.
echo  ==================== FILE HIDER/UNHIDER ====================
echo.
echo   [1] Hide File/Folder
echo   [2] Unhide File/Folder
echo   [3] Show Hidden Files
echo   [4] Super Hide (System + Hidden)
echo.
set /p "hchoice=Select: "

if "%hchoice%"=="1" (
    set /p "filepath=Enter file/folder path: "
    attrib +h "!filepath!"
    echo File/folder hidden!
) else if "%hchoice%"=="2" (
    set /p "filepath=Enter file/folder path: "
    attrib -h "!filepath!"
    echo File/folder unhidden!
) else if "%hchoice%"=="3" (
    dir /ah
) else if "%hchoice%"=="4" (
    set /p "filepath=Enter file/folder path: "
    attrib +s +h "!filepath!"
    echo File/folder super hidden!
)
echo.
pause
goto FILE_TOOLS

:SECURITY_TOOLS
cls
call :BANNER
echo.
echo  ==================== SECURITY TOOLS ====================
echo.
echo   [1] Password Generator      [6] Firewall Manager
echo   [2] File Integrity Check    [7] Anti-Malware Scan
echo   [3] System Audit            [8] Security Policy
echo   [4] Encryption Tools        [9] Port Blocker
echo   [5] Account Security        [10] Security Report
echo.
echo   [0] Back to Main Menu
echo.
set /p "sechoice=Select Option: "

if "%sechoice%"=="1" goto PASS_GEN
if "%sechoice%"=="2" goto FILE_INTEGRITY
if "%sechoice%"=="3" goto SYS_AUDIT
if "%sechoice%"=="4" goto ENCRYPT_TOOLS
if "%sechoice%"=="5" goto ACC_SECURITY
if "%sechoice%"=="6" goto FIREWALL_MGR
if "%sechoice%"=="7" goto MALWARE_SCAN
if "%sechoice%"=="8" start secpol.msc & goto SECURITY_TOOLS
if "%sechoice%"=="9" goto PORT_BLOCK
if "%sechoice%"=="10" goto SEC_REPORT
if "%sechoice%"=="0" goto MAIN_MENU
goto SECURITY_TOOLS

:PASS_GEN
cls
echo.
echo  ==================== PASSWORD GENERATOR ====================
echo.
set /p "length=Enter password length (8-32): "
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%%^&*()"
set "password="
for /l %%i in (1,1,%length%) do (
    set /a "rand=!random! %% 72"
    for %%j in (!rand!) do set "password=!password!!chars:~%%j,1!"
)
echo.
echo Generated Password: !password!
echo.
echo Password copied to clipboard!
echo !password! | clip
pause
goto SECURITY_TOOLS

:GAMES
cls
call :BANNER
echo.
echo  ==================== MINI GAMES ====================
echo.
echo   [1] Number Guessing Game    [4] Math Challenge
echo   [2] Rock Paper Scissors     [5] Memory Game
echo   [3] Dice Roller             [6] ASCII Snake (Simple)
echo.
echo   [0] Back to Main Menu
echo.
set /p "gchoice=Select Game: "

if "%gchoice%"=="1" goto GUESS_GAME
if "%gchoice%"=="2" goto RPS_GAME
if "%gchoice%"=="3" goto DICE_GAME
if "%gchoice%"=="4" goto MATH_GAME
if "%gchoice%"=="5" goto MEMORY_GAME
if "%gchoice%"=="6" goto SNAKE_GAME
if "%gchoice%"=="0" goto MAIN_MENU
goto GAMES

:GUESS_GAME
cls
echo.
echo  ==================== NUMBER GUESSING GAME ====================
echo.
set /a "target=!random! %% 100 + 1"
set "attempts=0"
echo I'm thinking of a number between 1 and 100!
echo.

:GUESS_LOOP
set /a "attempts+=1"
set /p "guess=Your guess: "
if !guess! lss !target! (
    echo Too low! Try again.
    goto GUESS_LOOP
) else if !guess! gtr !target! (
    echo Too high! Try again.
    goto GUESS_LOOP
) else (
    echo.
    echo Correct! The number was !target!
    echo You got it in !attempts! attempts!
)
echo.
pause
goto GAMES

:RPS_GAME
cls
echo.
echo  ==================== ROCK PAPER SCISSORS ====================
echo.
echo   [1] Rock
echo   [2] Paper
echo   [3] Scissors
echo.
set /p "player=Your choice (1-3): "
set /a "computer=!random! %% 3 + 1"

set "pchoice=Unknown"
set "cchoice=Unknown"
if %player%==1 set "pchoice=Rock"
if %player%==2 set "pchoice=Paper"
if %player%==3 set "pchoice=Scissors"
if %computer%==1 set "cchoice=Rock"
if %computer%==2 set "cchoice=Paper"
if %computer%==3 set "cchoice=Scissors"

echo.
echo You chose: !pchoice!
echo Computer chose: !cchoice!
echo.

if %player%==%computer% (
    echo It's a tie!
) else if %player%==1 if %computer%==3 (
    echo You win! Rock beats Scissors!
) else if %player%==2 if %computer%==1 (
    echo You win! Paper beats Rock!
) else if %player%==3 if %computer%==2 (
    echo You win! Scissors beats Paper!
) else (
    echo Computer wins!
)
echo.
pause
goto GAMES

:INTERNET_TOOLS
cls
call :BANNER
echo.
echo  ==================== INTERNET TOOLS ====================
echo.
echo   [1] User Agent Switcher     [6] Download Manager
echo   [2] IP Configuration        [7] Web Scraper
echo   [3] Proxy Switcher          [8] URL Shortener Check
echo   [4] DNS Changer             [9] Website Status Check
echo   [5] Browser Cache Clear     [10] Network Speed Optimizer
echo.
echo   [0] Back to Main Menu
echo.
set /p "ichoice=Select Option: "

if "%ichoice%"=="1" goto UA_SWITCHER
if "%ichoice%"=="2" goto IP_CONFIG
if "%ichoice%"=="3" goto PROXY_SWITCH
if "%ichoice%"=="4" goto DNS_CHANGE
if "%ichoice%"=="5" goto CACHE_CLEAR
if "%ichoice%"=="6" goto DOWNLOAD_MGR
if "%ichoice%"=="7" goto WEB_SCRAPER
if "%ichoice%"=="8" goto URL_CHECK
if "%ichoice%"=="9" goto SITE_STATUS
if "%ichoice%"=="10" goto NET_OPTIMIZE
if "%ichoice%"=="0" goto MAIN_MENU
goto INTERNET_TOOLS

:UA_SWITCHER
cls
echo.
echo  ==================== USER AGENT CONFIGURATION ====================
echo.
echo Common User Agents:
echo.
echo [1] Chrome Windows: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36
echo [2] Firefox Windows: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
echo [3] Edge: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Edge/91.0.864.59
echo [4] Safari Mac: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15
echo [5] Mobile Chrome: Mozilla/5.0 (Linux; Android 11; SM-G991B) AppleWebKit/537.36
echo.
echo Registry keys for IE/Edge user agent stored at:
echo HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\5.0\User Agent
echo.
set /p "uachoice=Select UA preset (1-5): "
echo.
echo Setting selected user agent for Internet Explorer/Edge...
if "%uachoice%"=="1" reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "User Agent" /t REG_SZ /d "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" /f >nul
if "%uachoice%"=="2" reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "User Agent" /t REG_SZ /d "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101" /f >nul
echo User Agent configured!
pause
goto INTERNET_TOOLS

:PROXY_SWITCH
cls
echo.
echo  ==================== PROXY CONFIGURATION ====================
echo.
echo   [1] Enable Proxy
echo   [2] Disable Proxy
echo   [3] View Current Proxy
echo   [4] Set Custom Proxy
echo.
set /p "proxychoice=Select: "

if "%proxychoice%"=="1" (
    set /p "proxyaddr=Enter proxy address (IP:PORT): "
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "!proxyaddr!" /f >nul
    echo Proxy enabled: !proxyaddr!
) else if "%proxychoice%"=="2" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
    echo Proxy disabled!
) else if "%proxychoice%"=="3" (
    reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer
    reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable
)
echo.
pause
goto INTERNET_TOOLS

:DEV_TOOLS
cls
call :BANNER
echo.
echo  ==================== DEVELOPER TOOLS ====================
echo.
echo   [1] Environment Variables   [6] Git Helper
echo   [2] Path Manager            [7] Code Templates
echo   [3] Port Forwarding         [8] Build Tools
echo   [4] localhost Manager       [9] Debug Mode Toggle
echo   [5] API Tester              [10] Dev Environment Setup
echo.
echo   [0] Back to Main Menu
echo.
set /p "dchoice=Select Option: "

if "%dchoice%"=="1" goto ENV_VARS
if "%dchoice%"=="2" goto PATH_MGR
if "%dchoice%"=="3" goto PORT_FWD
if "%dchoice%"=="4" goto LOCALHOST_MGR
if "%dchoice%"=="5" goto API_TEST
if "%dchoice%"=="6" goto GIT_HELPER
if "%dchoice%"=="7" goto CODE_TEMPLATES
if "%dchoice%"=="8" goto BUILD_TOOLS
if "%dchoice%"=="9" goto DEBUG_MODE
if "%dchoice%"=="10" goto DEV_SETUP
if "%dchoice%"=="0" goto MAIN_MENU
goto DEV_TOOLS

:ENV_VARS
cls
echo.
echo  ==================== ENVIRONMENT VARIABLES ====================
echo.
echo   [1] List All Variables
echo   [2] Set New Variable
echo   [3] Delete Variable
echo   [4] Edit PATH
echo.
set /p "echoice=Select: "

if "%echoice%"=="1" (
    set
) else if "%echoice%"=="2" (
    set /p "varname=Variable name: "
    set /p "varvalue=Variable value: "
    setx !varname! "!varvalue!"
    echo Variable set!
) else if "%echoice%"=="3" (
    set /p "varname=Variable to delete: "
    setx !varname! ""
    echo Variable deleted!
) else if "%echoice%"=="4" (
    echo Current PATH:
    echo %PATH%
    echo.
    set /p "newpath=Add to PATH: "
    setx PATH "%PATH%;!newpath!"
)
echo.
pause
goto DEV_TOOLS

:ADVANCED_UTILS
cls
call :BANNER
echo.
echo  ==================== ADVANCED UTILITIES ====================
echo.
echo   [1] System File Checker     [6] Memory Diagnostic
echo   [2] Disk Cleanup            [7] Component Store Cleanup
echo   [3] Registry Backup         [8] System Image Backup
echo   [4] Boot Configuration      [9] Hyper-V Manager
echo   [5] Windows Features        [10] Advanced Recovery
echo.
echo   [0] Back to Main Menu
echo.
set /p "auchoice=Select Option: "

if "%auchoice%"=="1" (
    echo Running System File Checker...
    sfc /scannow
) else if "%auchoice%"=="2" (
    cleanmgr /sageset:1
    cleanmgr /sagerun:1
) else if "%auchoice%"=="3" goto REG_BACKUP
else if "%auchoice%"=="4" (
    bcdedit
    pause
) else if "%auchoice%"=="5" (
    optionalfeatures
) else if "%auchoice%"=="6" (
    mdsched
) else if "%auchoice%"=="7" (
    Dism /Online /Cleanup-Image /StartComponentCleanup
) else if "%auchoice%"=="8" (
    wbadmin start backup -backupTarget:E: -include:C: -quiet
) else if "%auchoice%"=="9" (
    virtmgmt.msc
) else if "%auchoice%"=="10" goto ADV_RECOVERY
else if "%auchoice%"=="0" goto MAIN_MENU

pause
goto ADVANCED_UTILS

:REG_BACKUP
cls
echo.
echo  ==================== REGISTRY BACKUP ====================
echo.
set "backupdir=%USERPROFILE%\Desktop\RegBackup_%date:~-4,4%%date:~-10,2%%date:~-7,2%"
mkdir "%backupdir%" 2>nul
echo Backing up registry to %backupdir%...
echo.
reg export HKLM "%backupdir%\HKLM.reg" /y
reg export HKCU "%backupdir%\HKCU.reg" /y
reg export HKCR "%backupdir%\HKCR.reg" /y
reg export HKU "%backupdir%\HKU.reg" /y
reg export HKCC "%backupdir%\HKCC.reg" /y
echo.
echo Registry backup complete!
pause
goto ADVANCED_UTILS

:QUICK_ACTIONS
cls
call :BANNER
echo.
echo  ==================== QUICK ACTIONS ====================
echo.
echo   [1] Restart Explorer        [6] Clear DNS Cache
echo   [2] Empty Recycle Bin       [7] Reset Network
echo   [3] Lock Computer           [8] System Info
echo   [4] Shutdown Timer          [9] Resource Monitor
echo   [5] Clear Temp Files        [10] God Mode Folder
echo.
echo   [0] Back to Main Menu
echo.
set /p "qchoice=Select Option: "

if "%qchoice%"=="1" (
    taskkill /f /im explorer.exe && start explorer.exe
) else if "%qchoice%"=="2" (
    rd /s /q %systemdrive%\$Recycle.bin
) else if "%qchoice%"=="3" (
    rundll32.exe user32.dll,LockWorkStation
) else if "%qchoice%"=="4" (
    set /p "seconds=Shutdown in seconds: "
    shutdown /s /t !seconds!
) else if "%qchoice%"=="5" (
    del /q /f /s %temp%\* 2>nul
    echo Temp files cleared!
) else if "%qchoice%"=="6" (
    ipconfig /flushdns
) else if "%qchoice%"=="7" (
    netsh winsock reset
    netsh int ip reset
) else if "%qchoice%"=="8" (
    systeminfo | more
) else if "%qchoice%"=="9" (
    resmon
) else if "%qchoice%"=="10" (
    mkdir "%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" 2>nul
    echo God Mode folder created on Desktop!
)
echo.
pause
goto MAIN_MENU

:PERFORMANCE_TOOLS
cls
call :BANNER
echo.
echo  ==================== PERFORMANCE TOOLS ====================
echo.
echo   [1] RAM Optimizer           [6] Startup Manager
echo   [2] CPU Monitor             [7] Service Optimizer
echo   [3] Disk Defragmenter       [8] Visual Effects Off
echo   [4] Clear Page File         [9] Gaming Mode
echo   [5] Disable Animations      [10] Performance Report
echo.
echo   [0] Back to Main Menu
echo.
set /p "pchoice=Select Option: "

if "%pchoice%"=="1" (
    echo Clearing working sets...
    wmic process where "ProcessId>4" call SetWorkingSetSize 0 0 >nul 2>&1
    echo RAM optimized!
) else if "%pchoice%"=="2" (
    wmic cpu get loadpercentage /value
) else if "%pchoice%"=="3" (
    defrag C: /A
) else if "%pchoice%"=="4" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f
) else if "%pchoice%"=="5" (
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
) else if "%pchoice%"=="10" (
    perfmon /report
)
echo.
pause
goto PERFORMANCE_TOOLS

:PRIVACY_TOOLS
cls
call :BANNER
echo.
echo  ==================== PRIVACY TOOLS ====================
echo.
echo   [1] Clear Browser Data      [6] Disable Cortana
echo   [2] Clear Recent Files      [7] Camera/Mic Control
echo   [3] Clear Run History       [8] Location Services
echo   [4] Privacy Dashboard       [9] App Permissions
echo   [5] Activity History        [10] Advertising ID Reset
echo.
echo   [0] Back to Main Menu
echo.
set /p "prchoice=Select Option: "

if "%prchoice%"=="1" (
    RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255
    echo Browser data cleared!
) else if "%prchoice%"=="2" (
    del /f /q "%APPDATA%\Microsoft\Windows\Recent\*"
    echo Recent files cleared!
) else if "%prchoice%"=="3" (
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f 2>nul
    echo Run history cleared!
) else if "%prchoice%"=="6" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
    echo Cortana disabled!
)
echo.
pause
goto PRIVACY_TOOLS

:DIAGNOSTIC_TOOLS
cls
call :BANNER
echo.
echo  ==================== DIAGNOSTIC TOOLS ====================
echo.
echo   [1] System Health Check     [6] Network Diagnostics
echo   [2] Hardware Info           [7] Driver Issues
echo   [3] Memory Test             [8] Disk Health
echo   [4] Temperature Monitor     [9] Event Log Analysis
echo   [5] BSOD Analysis           [10] Performance Monitor
echo.
echo   [0] Back to Main Menu
echo.
set /p "dgchoice=Select Option: "

if "%dgchoice%"=="1" (
    echo Running system health check...
    DISM /Online /Cleanup-Image /CheckHealth
    DISM /Online /Cleanup-Image /ScanHealth
) else if "%dgchoice%"=="2" (
    wmic computersystem get model,name,manufacturer,systemtype
    wmic cpu get name,numberofcores,maxclockspeed
    wmic memorychip get capacity,speed,manufacturer
) else if "%dgchoice%"=="3" (
    mdsched
) else if "%dgchoice%"=="8" (
    wmic diskdrive get status,model,size
)
echo.
pause
goto DIAGNOSTIC_TOOLS

:SYSTEM_INFO
cls
call :BANNER
echo.
echo  ==================== SYSTEM INFORMATION ====================
echo.
echo Computer Name: %COMPUTERNAME%
echo User Name: %USERNAME%
echo.
echo OS Information:
wmic os get Caption,Version,BuildNumber,OSArchitecture /value | findstr /v "^$"
echo.
echo Hardware Information:
wmic cpu get Name,NumberOfCores,MaxClockSpeed /value | findstr /v "^$"
echo.
echo Memory Information:
wmic computersystem get TotalPhysicalMemory /value | findstr /v "^$"
echo.
echo Disk Information:
wmic logicaldisk get size,freespace,caption /value | findstr /v "^$"
echo.
echo Network Adapters:
wmic nic where "NetEnabled=true" get Name,MACAddress /value | findstr /v "^$"
echo.
pause
goto MAIN_MENU

:EXIT_SCRIPT
cls
echo.
echo  ==================== GOODBYE ====================
echo.
echo   Thank you for using Ultimate Windows Power Tool Suite!
echo.
echo   Created with Windows native commands only
echo   No external dependencies required
echo.
timeout /t 3 /nobreak >nul
exit /b

REM =============== Additional Helper Functions ===============

:SPEED_TEST
cls
echo.
echo  ==================== NETWORK SPEED TEST ====================
echo.
echo Testing download speed...
echo.
powershell -Command "$start = Get-Date; Invoke-WebRequest -Uri 'http://speedtest.tele2.net/1MB.zip' -OutFile '%temp%\speedtest.tmp' -UseBasicParsing; $end = Get-Date; $time = ($end - $start).TotalSeconds; $speed = (1 / $time) * 8; Remove-Item '%temp%\speedtest.tmp'; Write-Host \"Download Speed: $([math]::Round($speed, 2)) Mbps\""
echo.
echo Testing ping to common servers...
ping -n 4 8.8.8.8
echo.
pause
goto NETWORK_TOOLS

:NET_MONITOR
cls
echo.
echo  ==================== NETWORK MONITOR ====================
echo.
echo Press Ctrl+C to stop monitoring
echo.
:MONITOR_LOOP
netstat -e
timeout /t 2 /nobreak >nul
cls
goto MONITOR_LOOP

:DNS_TOOLS
cls
echo.
echo  ==================== DNS TOOLS ====================
echo.
echo   [1] Flush DNS Cache
echo   [2] Display DNS Cache
echo   [3] Set Google DNS
echo   [4] Set Cloudflare DNS
echo   [5] Reset to Default DNS
echo.
set /p "dnschoice=Select: "

if "%dnschoice%"=="1" (
    ipconfig /flushdns
    echo DNS cache flushed!
) else if "%dnschoice%"=="2" (
    ipconfig /displaydns | more
) else if "%dnschoice%"=="3" (
    netsh interface ip set dns "Wi-Fi" static 8.8.8.8
    netsh interface ip add dns "Wi-Fi" 8.8.4.4 index=2
    echo Google DNS set!
) else if "%dnschoice%"=="4" (
    netsh interface ip set dns "Wi-Fi" static 1.1.1.1
    netsh interface ip add dns "Wi-Fi" 1.0.0.1 index=2
    echo Cloudflare DNS set!
) else if "%dnschoice%"=="5" (
    netsh interface ip set dns "Wi-Fi" dhcp
    echo DNS reset to default!
)
echo.
pause
goto NETWORK_TOOLS

:MEMORY_GAME
cls
echo.
echo  ==================== MEMORY GAME ====================
echo.
echo Remember the sequence!
echo.
set "sequence="
for /l %%i in (1,1,5) do (
    set /a "num=!random! %% 10"
    set "sequence=!sequence!!num!"
)
echo Sequence: !sequence!
timeout /t 3 /nobreak >nul
cls
echo.
echo  ==================== MEMORY GAME ====================
echo.
set /p "answer=Enter the sequence: "
if "!answer!"=="!sequence!" (
    echo Correct! Well done!
) else (
    echo Wrong! The sequence was: !sequence!
)
echo.
pause
goto GAMES

:SNAKE_GAME
cls
echo.
echo  ==================== ASCII SNAKE ====================
echo.
echo Use W,A,S,D to move, Q to quit
echo.
set "snake=O"
set "x=10"
set "y=5"

:SNAKE_LOOP
cls
for /l %%i in (1,1,20) do echo.
for /l %%i in (1,1,!y!) do echo.
for /l %%i in (1,1,!x!) do set "spaces=!spaces! "
echo !spaces!!snake!
set "spaces="
choice /c wasdq /n /t 1 /d s >nul
if %errorlevel%==1 set /a "y-=1"
if %errorlevel%==2 set /a "x-=1"
if %errorlevel%==3 set /a "y+=1"
if %errorlevel%==4 set /a "x+=1"
if %errorlevel%==5 goto GAMES
if !x! lss 0 set "x=0"
if !y! lss 0 set "y=0"
if !x! gtr 70 set "x=70"
if !y! gtr 20 set "y=20"
goto SNAKE_LOOP

:NET_RESET
cls
echo.
echo  ==================== NETWORK RESET ====================
echo.
echo This will reset all network settings. Continue? (Y/N)
set /p "confirm="
if /i "%confirm%"=="Y" (
    netsh winsock reset
    netsh int ip reset
    netsh advfirewall reset
    ipconfig /release
    ipconfig /renew
    ipconfig /flushdns
    echo Network reset complete! Please restart your computer.
)
pause
goto NETWORK_TOOLS

REM End of script