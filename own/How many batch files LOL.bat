@echo off
setlocal EnableDelayedExpansion
title Ultimate Windows Power Tool Suite v2.0 - Professional Edition
color 0A
mode con: cols=120 lines=45

:: Check for Admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Attempting to restart with admin rights...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:INIT
set "VERSION=2.0"
set "AUTHOR=PowerSuite Pro"
set "TEMP_DIR=%TEMP%\PowerSuite"
set "LOG_DIR=%USERPROFILE%\PowerSuite_Logs"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
cd /d "%~dp0"

:MAIN_MENU
cls
call :BANNER
echo.
echo  ================================ MAIN MENU ================================
echo.
echo   [1]  Network Tools (50+)        [9]  Security Tools (45+)
echo   [2]  System Admin Tools (50+)   [10] Developer Tools (50+)
echo   [3]  Windows Tweaks (45+)       [11] Games & Entertainment (30+)
echo   [4]  System Information (40+)   [12] Internet Tools (45+)
echo   [5]  Performance Tools (45+)    [13] Advanced Utilities (50+)
echo   [6]  Privacy Tools (40+)        [14] Quick Actions (35+)
echo   [7]  Diagnostic Tools (45+)     [15] PowerShell Tools (40+)
echo   [8]  File Management (50+)      [16] Recovery & Repair (35+)
echo.
echo   [0] Exit
echo.
echo  ===========================================================================
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
if "%choice%"=="15" goto POWERSHELL_TOOLS
if "%choice%"=="16" goto RECOVERY_TOOLS
if "%choice%"=="0" goto EXIT_SCRIPT
goto MAIN_MENU

:BANNER
echo.
echo   ╔═══════════════════════════════════════════════════════════════════════════════════════╗
echo   ║   ██╗   ██╗██╗  ████████╗██╗███╗   ███╗ █████╗ ████████╗███████╗    ██████╗ ██████╗  ║
echo   ║   ██║   ██║██║  ╚══██╔══╝██║████╗ ████║██╔══██╗╚══██╔══╝██╔════╝    ██╔══██╗██╔══██╗ ║
echo   ║   ██║   ██║██║     ██║   ██║██╔████╔██║███████║   ██║   █████╗      ██████╔╝██████╔╝ ║
echo   ║   ██║   ██║██║     ██║   ██║██║╚██╔╝██║██╔══██║   ██║   ██╔══╝      ██╔═══╝ ██╔══██╗ ║
echo   ║   ╚██████╔╝███████╗██║   ██║██║ ╚═╝ ██║██║  ██║   ██║   ███████╗    ██║     ██║  ██║ ║
echo   ║    ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═╝     ╚═╝  ╚═╝ ║
echo   ║                         Windows Power Tool Suite v%VERSION% Professional                  ║
echo   ╚═══════════════════════════════════════════════════════════════════════════════════════╝
goto :EOF

:NETWORK_TOOLS
cls
call :BANNER
echo.
echo  ================================ NETWORK TOOLS ================================
echo.
echo   === SCANNING ===                   === CONFIGURATION ===              === ADVANCED ===
echo   [1]  Network Scanner               [18] IP Configuration              [35] Packet Sniffer
echo   [2]  Port Scanner                  [19] MAC Address Changer           [36] Network Mapper
echo   [3]  ARP Scanner                   [20] DNS Configuration             [37] Traffic Monitor
echo   [4]  Subnet Calculator             [21] DHCP Manager                  [38] Bandwidth Monitor
echo   [5]  Host Discovery                [22] Static IP Setup               [39] Network Logger
echo   [6]  Service Scanner               [23] Network Bridge                [40] Protocol Analyzer
echo   [7]  UDP Scanner                   [24] VLAN Configuration            [41] Route Tracer
echo                                                                         
echo   === WIFI/WIRELESS ===              === TESTING ===                    === SECURITY ===
echo   [8]  WiFi Scanner                  [25] Speed Test                    [42] Firewall Rules
echo   [9]  WiFi Password Viewer          [26] Ping Test                     [43] Port Forwarding
echo   [10] WiFi Hotspot Creator          [27] Latency Test                  [44] NAT Configuration
echo   [11] WiFi Signal Strength          [28] Packet Loss Test              [45] VPN Manager
echo   [12] WiFi Channel Analyzer         [29] MTU Test                      [46] SSL/TLS Checker
echo   [13] WiFi Profile Manager          [30] Bandwidth Test                [47] Network Isolation
echo                                                                         
echo   === UTILITIES ===                  === TROUBLESHOOTING ===            === MONITORING ===
echo   [14] Network Reset                 [31] Connection Troubleshooter     [48] Real-time Monitor
echo   [15] Network Share Manager         [32] DNS Troubleshooter            [49] Connection Logger
echo   [16] NetBIOS Tools                 [33] Winsock Reset                 [50] Network Statistics
echo   [17] Wake-on-LAN                   [34] Network Adapter Reset         
echo.
echo   [0] Back to Main Menu
echo.
set /p "nchoice=Select Option: "

if "%nchoice%"=="1" goto NET_SCANNER_ADV
if "%nchoice%"=="2" goto PORT_SCANNER_ADV
if "%nchoice%"=="3" goto ARP_SCANNER
if "%nchoice%"=="4" goto SUBNET_CALC
if "%nchoice%"=="5" goto HOST_DISCOVERY
if "%nchoice%"=="6" goto SERVICE_SCANNER
if "%nchoice%"=="7" goto UDP_SCANNER
if "%nchoice%"=="8" goto WIFI_SCANNER
if "%nchoice%"=="9" goto WIFI_PASSWORDS
if "%nchoice%"=="10" goto WIFI_HOTSPOT
if "%nchoice%"=="11" goto WIFI_SIGNAL
if "%nchoice%"=="12" goto WIFI_CHANNELS
if "%nchoice%"=="13" goto WIFI_PROFILES
if "%nchoice%"=="14" goto NET_RESET_ADV
if "%nchoice%"=="15" goto NET_SHARES
if "%nchoice%"=="16" goto NETBIOS_TOOLS
if "%nchoice%"=="17" goto WAKE_ON_LAN
if "%nchoice%"=="18" goto IP_CONFIG_ADV
if "%nchoice%"=="19" goto MAC_CHANGER
if "%nchoice%"=="20" goto DNS_CONFIG
if "%nchoice%"=="21" goto DHCP_MANAGER
if "%nchoice%"=="22" goto STATIC_IP
if "%nchoice%"=="23" goto NET_BRIDGE
if "%nchoice%"=="24" goto VLAN_CONFIG
if "%nchoice%"=="25" goto SPEED_TEST_ADV
if "%nchoice%"=="26" goto PING_TEST
if "%nchoice%"=="27" goto LATENCY_TEST
if "%nchoice%"=="28" goto PACKET_LOSS
if "%nchoice%"=="29" goto MTU_TEST
if "%nchoice%"=="30" goto BANDWIDTH_TEST
if "%nchoice%"=="31" goto CONN_TROUBLESHOOT
if "%nchoice%"=="32" goto DNS_TROUBLESHOOT
if "%nchoice%"=="33" goto WINSOCK_RESET
if "%nchoice%"=="34" goto ADAPTER_RESET
if "%nchoice%"=="35" goto PACKET_SNIFFER
if "%nchoice%"=="36" goto NETWORK_MAPPER
if "%nchoice%"=="37" goto TRAFFIC_MONITOR
if "%nchoice%"=="38" goto BANDWIDTH_MONITOR
if "%nchoice%"=="39" goto NETWORK_LOGGER
if "%nchoice%"=="40" goto PROTOCOL_ANALYZER
if "%nchoice%"=="41" goto ROUTE_TRACER
if "%nchoice%"=="42" goto FIREWALL_RULES
if "%nchoice%"=="43" goto PORT_FORWARD
if "%nchoice%"=="44" goto NAT_CONFIG
if "%nchoice%"=="45" goto VPN_MANAGER
if "%nchoice%"=="46" goto SSL_CHECKER
if "%nchoice%"=="47" goto NET_ISOLATION
if "%nchoice%"=="48" goto REALTIME_MONITOR
if "%nchoice%"=="49" goto CONN_LOGGER
if "%nchoice%"=="50" goto NET_STATS
if "%nchoice%"=="0" goto MAIN_MENU
goto NETWORK_TOOLS

:NET_SCANNER_ADV
cls
echo.
echo  ==================== ADVANCED NETWORK SCANNER ====================
echo.
echo Scanning network with multiple methods...
echo.
powershell -Command "& {
    $subnet = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike '*Loopback*'}).IPAddress.Split('.')[0..2] -join '.'
    Write-Host 'Scanning subnet: '$subnet'.0/24' -ForegroundColor Green
    Write-Host ''
    $ping = New-Object System.Net.NetworkInformation.Ping
    $results = @()
    1..254 | ForEach-Object {
        $ip = '$subnet.$_'
        $reply = $ping.Send($ip, 100)
        if ($reply.Status -eq 'Success') {
            try {
                $hostname = [System.Net.Dns]::GetHostEntry($ip).HostName
                $mac = (Get-NetNeighbor -IPAddress $ip -ErrorAction SilentlyContinue).LinkLayerAddress
            } catch {
                $hostname = 'Unknown'
                $mac = 'Unknown'
            }
            Write-Host '[ONLINE]' -ForegroundColor Green -NoNewline
            Write-Host ' '$ip' - '$hostname' - MAC: '$mac
            $results += [PSCustomObject]@{IP=$ip; Hostname=$hostname; MAC=$mac; ResponseTime=$reply.RoundtripTime}
        }
    }
    Write-Host ''
    Write-Host 'Scan complete. Found'$results.Count'active hosts.' -ForegroundColor Yellow
    $results | Format-Table -AutoSize
}"
pause
goto NETWORK_TOOLS

:PORT_SCANNER_ADV
cls
echo.
echo  ==================== ADVANCED PORT SCANNER ====================
echo.
set /p "target=Enter target IP/hostname: "
set /p "portrange=Enter port range (e.g., 1-1000) or 'common' for common ports: "
echo.
if /i "%portrange%"=="common" (
    set "ports=21,22,23,25,53,80,110,135,139,143,443,445,993,995,1723,3306,3389,5900,8080,8443"
) else (
    set "ports=%portrange%"
)
powershell -Command "& {
    Write-Host 'Scanning %target%...' -ForegroundColor Yellow
    Write-Host ''
    $ports = '%ports%'.Split(',')
    $openPorts = @()
    foreach ($port in $ports) {
        if ($port -like '*-*') {
            $range = $port.Split('-')
            $startPort = [int]$range[0]
            $endPort = [int]$range[1]
            $startPort..$endPort | ForEach-Object {
                $tcp = New-Object System.Net.Sockets.TcpClient
                try {
                    $tcp.ConnectAsync('%target%', $_).Wait(100) | Out-Null
                    if ($tcp.Connected) {
                        Write-Host '[OPEN]' -ForegroundColor Green -NoNewline
                        Write-Host ' Port '$_' - '$(switch($_){21{'FTP'};22{'SSH'};23{'Telnet'};25{'SMTP'};53{'DNS'};80{'HTTP'};110{'POP3'};135{'RPC'};139{'NetBIOS'};143{'IMAP'};443{'HTTPS'};445{'SMB'};993{'IMAPS'};995{'POP3S'};1723{'PPTP'};3306{'MySQL'};3389{'RDP'};5900{'VNC'};8080{'HTTP-Alt'};8443{'HTTPS-Alt'};default{'Unknown'}})
                        $openPorts += $_
                    }
                } catch {}
                finally { $tcp.Close() }
            }
        } else {
            $tcp = New-Object System.Net.Sockets.TcpClient
            try {
                $tcp.ConnectAsync('%target%', [int]$port).Wait(100) | Out-Null
                if ($tcp.Connected) {
                    Write-Host '[OPEN]' -ForegroundColor Green -NoNewline
                    Write-Host ' Port '$port
                    $openPorts += [int]$port
                }
            } catch {}
            finally { $tcp.Close() }
        }
    }
    Write-Host ''
    Write-Host 'Scan complete. Found'$openPorts.Count'open ports.' -ForegroundColor Yellow
}"
pause
goto NETWORK_TOOLS

:ARP_SCANNER
cls
echo.
echo  ==================== ARP SCANNER ====================
echo.
powershell -Command "& {
    Write-Host 'Current ARP Table:' -ForegroundColor Green
    Write-Host ''
    Get-NetNeighbor | Where-Object {$_.State -ne 'Permanent'} | Format-Table IPAddress, LinkLayerAddress, State, InterfaceAlias -AutoSize
    Write-Host ''
    Write-Host 'Sending ARP requests to discover hosts...' -ForegroundColor Yellow
    $subnet = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike '*Loopback*'}).IPAddress.Split('.')[0..2] -join '.'
    1..254 | ForEach-Object {
        $ip = '$subnet.$_'
        Start-Job -ScriptBlock {param($ip) Test-Connection -ComputerName $ip -Count 1 -Quiet} -ArgumentList $ip | Out-Null
    }
    Get-Job | Wait-Job | Remove-Job
    Start-Sleep -Seconds 2
    Write-Host ''
    Write-Host 'Updated ARP Table:' -ForegroundColor Green
    Get-NetNeighbor | Where-Object {$_.State -ne 'Permanent'} | Format-Table IPAddress, LinkLayerAddress, State, InterfaceAlias -AutoSize
}"
pause
goto NETWORK_TOOLS

:WIFI_PASSWORDS
cls
echo.
echo  ==================== WiFi PASSWORD VIEWER ====================
echo.
powershell -Command "& {
    $profiles = netsh wlan show profiles | Select-String '\:(.+)$' | ForEach-Object {$_.Matches.Groups[1].Value.Trim()}
    Write-Host 'Found'$profiles.Count'WiFi profiles:' -ForegroundColor Green
    Write-Host ''
    foreach ($profile in $profiles) {
        $details = netsh wlan show profile name=$profile key=clear
        $password = $details | Select-String 'Key Content\W+\:(.+)$' | ForEach-Object {$_.Matches.Groups[1].Value.Trim()}
        if ($password) {
            Write-Host 'SSID:' -ForegroundColor Yellow -NoNewline
            Write-Host ' '$profile
            Write-Host 'Password:' -ForegroundColor Yellow -NoNewline
            Write-Host ' '$password
            Write-Host '---'
        }
    }
}"
pause
goto NETWORK_TOOLS

:PACKET_SNIFFER
cls
echo.
echo  ==================== PACKET SNIFFER ====================
echo.
echo Starting packet capture (requires admin rights)...
echo.
powershell -Command "& {
    Write-Host 'Capturing packets for 10 seconds...' -ForegroundColor Yellow
    $startTime = Get-Date
    $packets = @()
    while ((Get-Date) -lt $startTime.AddSeconds(10)) {
        $connections = Get-NetTCPConnection | Where-Object {$_.State -eq 'Established'}
        foreach ($conn in $connections) {
            $process = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
            $packets += [PSCustomObject]@{
                Time = Get-Date -Format 'HH:mm:ss'
                LocalAddress = $conn.LocalAddress + ':' + $conn.LocalPort
                RemoteAddress = $conn.RemoteAddress + ':' + $conn.RemotePort
                Process = $process.Name
                State = $conn.State
            }
        }
        Start-Sleep -Milliseconds 500
    }
    $packets | Sort-Object Time -Descending | Select-Object -First 50 | Format-Table -AutoSize
}"
pause
goto NETWORK_TOOLS

:SYSADMIN_TOOLS
cls
call :BANNER
echo.
echo  ============================== SYSTEM ADMIN TOOLS ==============================
echo.
echo   === USER MANAGEMENT ===           === SERVICES ===                 === SYSTEM ===
echo   [1]  User Account Manager         [16] Service Manager             [31] System Restore
echo   [2]  Local Groups Manager         [17] Service Dependencies        [32] System Image
echo   [3]  User Privileges              [18] Service Startup Config     [33] Boot Configuration
echo   [4]  Password Policy              [19] Service Recovery Options   [34] System Files Check
echo   [5]  Account Lockout Policy       [20] Service Permissions        [35] Component Store
echo   [6]  User Profile Manager         [21] Service Monitor            [36] Windows Features
echo   [7]  Active Sessions              [22] Service Controller         [37] Optional Features
echo                                                                      
echo   === PROCESSES ===                 === REGISTRY ===                === POLICIES ===
echo   [8]  Process Manager              [23] Registry Editor            [38] Group Policy
echo   [9]  Process Tree                 [24] Registry Backup            [39] Security Policy
echo   [10] Process Priority             [25] Registry Search            [40] Audit Policy
echo   [11] Process Affinity             [26] Registry Monitor           [41] AppLocker
echo   [12] Process Permissions          [27] Registry Permissions       [42] User Rights
echo   [13] Process Monitor              [28] Registry Cleaner           [43] Password Policy
echo   [14] Process Dump                 [29] Registry Compare           
echo   [15] Process Injector             [30] Registry Export/Import     === ADVANCED ===
echo                                                                      [44] WMI Explorer
echo   === SCHEDULED TASKS ===           === EVENTS ===                  [45] COM+ Manager
echo   [46] Task Scheduler               [48] Event Viewer               [47] DCOM Config
echo   [47] Task Creator                 [49] Event Triggers             [50] MMC Console
echo.
echo   [0] Back to Main Menu
echo.
set /p "schoice=Select Option: "

if "%schoice%"=="1" goto USER_ACCOUNT_MGR
if "%schoice%"=="2" goto LOCAL_GROUPS_MGR
if "%schoice%"=="3" goto USER_PRIVILEGES
if "%schoice%"=="4" goto PASSWORD_POLICY
if "%schoice%"=="5" goto LOCKOUT_POLICY
if "%schoice%"=="6" goto PROFILE_MANAGER
if "%schoice%"=="7" goto ACTIVE_SESSIONS
if "%schoice%"=="8" goto PROCESS_MGR_ADV
if "%schoice%"=="9" goto PROCESS_TREE
if "%schoice%"=="10" goto PROCESS_PRIORITY
if "%schoice%"=="11" goto PROCESS_AFFINITY
if "%schoice%"=="12" goto PROCESS_PERMISSIONS
if "%schoice%"=="13" goto PROCESS_MONITOR
if "%schoice%"=="14" goto PROCESS_DUMP
if "%schoice%"=="15" goto PROCESS_INJECTOR
if "%schoice%"=="16" goto SERVICE_MGR_ADV
if "%schoice%"=="17" goto SERVICE_DEPENDENCIES
if "%schoice%"=="18" goto SERVICE_STARTUP
if "%schoice%"=="19" goto SERVICE_RECOVERY
if "%schoice%"=="20" goto SERVICE_PERMISSIONS
if "%schoice%"=="21" goto SERVICE_MONITOR
if "%schoice%"=="22" goto SERVICE_CONTROLLER
if "%schoice%"=="23" start regedit & goto SYSADMIN_TOOLS
if "%schoice%"=="24" goto REGISTRY_BACKUP
if "%schoice%"=="25" goto REGISTRY_SEARCH
if "%schoice%"=="26" goto REGISTRY_MONITOR
if "%schoice%"=="27" goto REGISTRY_PERMISSIONS
if "%schoice%"=="28" goto REGISTRY_CLEANER
if "%schoice%"=="29" goto REGISTRY_COMPARE
if "%schoice%"=="30" goto REGISTRY_EXPORT_IMPORT
if "%schoice%"=="31" goto SYSTEM_RESTORE_ADV
if "%schoice%"=="32" goto SYSTEM_IMAGE
if "%schoice%"=="33" goto BOOT_CONFIG
if "%schoice%"=="34" goto SFC_CHECK
if "%schoice%"=="35" goto COMPONENT_STORE
if "%schoice%"=="36" goto WINDOWS_FEATURES
if "%schoice%"=="37" goto OPTIONAL_FEATURES
if "%schoice%"=="38" start gpedit.msc & goto SYSADMIN_TOOLS
if "%schoice%"=="39" start secpol.msc & goto SYSADMIN_TOOLS
if "%schoice%"=="40" goto AUDIT_POLICY
if "%schoice%"=="41" goto APPLOCKER
if "%schoice%"=="42" goto USER_RIGHTS
if "%schoice%"=="43" goto PASS_POLICY_ADV
if "%schoice%"=="44" goto WMI_EXPLORER
if "%schoice%"=="45" start dcomcnfg & goto SYSADMIN_TOOLS
if "%schoice%"=="46" start taskschd.msc & goto SYSADMIN_TOOLS
if "%schoice%"=="47" goto TASK_CREATOR
if "%schoice%"=="48" start eventvwr.msc & goto SYSADMIN_TOOLS
if "%schoice%"=="49" goto EVENT_TRIGGERS
if "%schoice%"=="50" start mmc & goto SYSADMIN_TOOLS
if "%schoice%"=="0" goto MAIN_MENU
goto SYSADMIN_TOOLS

:USER_ACCOUNT_MGR
cls
echo.
echo  ==================== USER ACCOUNT MANAGER ====================
echo.
powershell -Command "& {
    Write-Host 'Local User Accounts:' -ForegroundColor Green
    Get-LocalUser | Format-Table Name, Enabled, PasswordRequired, PasswordExpires, LastLogon -AutoSize
    Write-Host ''
    Write-Host 'Options:' -ForegroundColor Yellow
    Write-Host '1. Create new user'
    Write-Host '2. Delete user'
    Write-Host '3. Enable/Disable user'
    Write-Host '4. Change password'
    Write-Host '5. Add to group'
    Write-Host '6. View user details'
    $choice = Read-Host 'Select option'
    switch ($choice) {
        '1' {
            $username = Read-Host 'Enter username'
            $password = Read-Host 'Enter password' -AsSecureString
            New-LocalUser -Name $username -Password $password -FullName $username
            Write-Host 'User created successfully' -ForegroundColor Green
        }
        '2' {
            $username = Read-Host 'Enter username to delete'
            Remove-LocalUser -Name $username
            Write-Host 'User deleted successfully' -ForegroundColor Green
        }
        '3' {
            $username = Read-Host 'Enter username'
            $action = Read-Host 'Enable (E) or Disable (D)?'
            if ($action -eq 'E') { Enable-LocalUser -Name $username }
            else { Disable-LocalUser -Name $username }
            Write-Host 'User status updated' -ForegroundColor Green
        }
        '4' {
            $username = Read-Host 'Enter username'
            $password = Read-Host 'Enter new password' -AsSecureString
            Set-LocalUser -Name $username -Password $password
            Write-Host 'Password changed successfully' -ForegroundColor Green
        }
        '5' {
            $username = Read-Host 'Enter username'
            $group = Read-Host 'Enter group name'
            Add-LocalGroupMember -Group $group -Member $username
            Write-Host 'User added to group' -ForegroundColor Green
        }
        '6' {
            $username = Read-Host 'Enter username'
            Get-LocalUser -Name $username | Format-List *
            Get-LocalGroup | Where-Object { (Get-LocalGroupMember $_ -ErrorAction SilentlyContinue).Name -like "*$username" } | ForEach-Object { Write-Host 'Member of:' $_.Name -ForegroundColor Yellow }
        }
    }
}"
pause
goto SYSADMIN_TOOLS

:PROCESS_MGR_ADV
cls
echo.
echo  ==================== ADVANCED PROCESS MANAGER ====================
echo.
powershell -Command "& {
    while ($true) {
        Clear-Host
        Write-Host 'PROCESS MANAGER - Real-time View' -ForegroundColor Green
        Write-Host '=================================' -ForegroundColor Green
        Write-Host ''
        $processes = Get-Process | Sort-Object CPU -Descending | Select-Object -First 20
        $processes | Format-Table @{L='PID';E={$_.Id}}, 
                                  @{L='Name';E={$_.ProcessName}}, 
                                  @{L='CPU(s)';E={[math]::Round($_.CPU,2)}}, 
                                  @{L='Memory(MB)';E={[math]::Round($_.WorkingSet64/1MB,2)}},
                                  @{L='Threads';E={$_.Threads.Count}},
                                  @{L='Handles';E={$_.HandleCount}} -AutoSize
        Write-Host ''
        Write-Host 'Options: K=Kill process, P=Set priority, A=Set affinity, D=Dump, Q=Quit' -ForegroundColor Yellow
        $key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        switch ($key.Character) {
            'k' {
                $pid = Read-Host 'Enter PID to kill'
                Stop-Process -Id $pid -Force
                Write-Host 'Process killed' -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
            'p' {
                $pid = Read-Host 'Enter PID'
                $priority = Read-Host 'Priority (Idle/BelowNormal/Normal/AboveNormal/High/RealTime)'
                (Get-Process -Id $pid).PriorityClass = $priority
                Write-Host 'Priority set' -ForegroundColor Green
                Start-Sleep -Seconds 2
            }
            'q' { break }
        }
        if ($key.Character -eq 'q') { break }
    }
}"
goto SYSADMIN_TOOLS

:SERVICE_MGR_ADV
cls
echo.
echo  ==================== ADVANCED SERVICE MANAGER ====================
echo.
powershell -Command "& {
    Write-Host 'Service Status Overview:' -ForegroundColor Green
    $services = Get-Service
    Write-Host 'Total:' $services.Count
    Write-Host 'Running:' ($services | Where-Object {$_.Status -eq 'Running'}).Count -ForegroundColor Green
    Write-Host 'Stopped:' ($services | Where-Object {$_.Status -eq 'Stopped'}).Count -ForegroundColor Red
    Write-Host ''
    Write-Host 'Critical Services Status:' -ForegroundColor Yellow
    'Spooler','Themes','AudioSrv','BITS','CryptSvc','Dhcp','Dnscache','EventLog','LanmanServer','LanmanWorkstation','PlugPlay','SamSs','Schedule','SENS','ShellHWDetection','Winmgmt','WinDefend' | ForEach-Object {
        $svc = Get-Service $_ -ErrorAction SilentlyContinue
        if ($svc) {
            $color = if ($svc.Status -eq 'Running') {'Green'} else {'Red'}
            Write-Host $svc.Name': '$svc.Status -ForegroundColor $color
        }
    }
    Write-Host ''
    Write-Host 'Options:' -ForegroundColor Yellow
    Write-Host '1. Start service'
    Write-Host '2. Stop service'
    Write-Host '3. Restart service'
    Write-Host '4. Change startup type'
    Write-Host '5. View service details'
    Write-Host '6. List all services'
    $choice = Read-Host 'Select option'
    switch ($choice) {
        '1' {
            $name = Read-Host 'Service name'
            Start-Service $name
            Write-Host 'Service started' -ForegroundColor Green
        }
        '2' {
            $name = Read-Host 'Service name'
            Stop-Service $name -Force
            Write-Host 'Service stopped' -ForegroundColor Red
        }
        '3' {
            $name = Read-Host 'Service name'
            Restart-Service $name
            Write-Host 'Service restarted' -ForegroundColor Green
        }
        '4' {
            $name = Read-Host 'Service name'
            $type = Read-Host 'Startup type (Automatic/Manual/Disabled)'
            Set-Service $name -StartupType $type
            Write-Host 'Startup type changed' -ForegroundColor Green
        }
        '5' {
            $name = Read-Host 'Service name'
            Get-Service $name | Format-List *
            Get-WmiObject Win32_Service | Where-Object {$_.Name -eq $name} | Format-List PathName, StartMode, StartName, Description
        }
        '6' {
            Get-Service | Sort-Object Status, Name | Format-Table Status, Name, DisplayName -AutoSize | Out-Host -Paging
        }
    }
}"
pause
goto SYSADMIN_TOOLS

:FILE_TOOLS
cls
call :BANNER
echo.
echo  ============================== FILE MANAGEMENT TOOLS ==============================
echo.
echo   === FILE OPERATIONS ===          === SEARCH & FIND ===           === COMPRESSION ===
echo   [1]  Advanced File Copy          [16] File Search                [31] ZIP Creator
echo   [2]  Secure Delete               [17] Duplicate Finder           [32] ZIP Extractor
echo   [3]  File Shredder               [18] Large File Finder          [33] 7z Operations
echo   [4]  Batch Rename                [19] Empty Folder Finder        [34] CAB Files
echo   [5]  File Splitter               [20] Recent Files               [35] Archive Manager
echo   [6]  File Merger                 [21] File Content Search        
echo   [7]  File Comparer               [22] Regex File Search          === ENCRYPTION ===
echo   [8]  File Monitor                                                [36] File Encryptor
echo                                    === ATTRIBUTES ===              [37] Folder Lock
echo   === PERMISSIONS ===              [23] Attribute Manager          [38] EFS Manager
echo   [9]  Permission Manager          [24] Hidden Files               [39] BitLocker
echo   [10] Ownership Changer           [25] System Files               [40] Secure Container
echo   [11] ACL Editor                  [26] Read-only Toggle           
echo   [12] Permission Backup           [27] Timestamp Editor           === SPECIAL ===
echo   [13] Permission Reset            [28] File Properties            [41] Symbolic Links
echo   [14] Inheritance Manager         [29] Extended Attributes        [42] Hard Links
echo   [15] Effective Permissions       [30] Alternate Streams          [43] Junction Points
echo                                                                    [44] Mount Points
echo   === RECOVERY ===                 === ANALYSIS ===                [45] Sparse Files
echo   [46] Deleted File Recovery       [48] Disk Usage Analyzer        [47] File Streams
echo   [47] Shadow Copy Explorer        [49] File Type Statistics       [50] NTFS Features
echo.
echo   [0] Back to Main Menu
echo.
set /p "fchoice=Select Option: "

if "%fchoice%"=="1" goto ADV_FILE_COPY
if "%fchoice%"=="2" goto SECURE_DELETE_ADV
if "%fchoice%"=="3" goto FILE_SHREDDER
if "%fchoice%"=="4" goto BATCH_RENAME_ADV
if "%fchoice%"=="5" goto FILE_SPLITTER
if "%fchoice%"=="6" goto FILE_MERGER
if "%fchoice%"=="7" goto FILE_COMPARER
if "%fchoice%"=="8" goto FILE_MONITOR
if "%fchoice%"=="9" goto PERMISSION_MGR
if "%fchoice%"=="10" goto OWNERSHIP_CHANGER
if "%fchoice%"=="11" goto ACL_EDITOR
if "%fchoice%"=="12" goto PERMISSION_BACKUP
if "%fchoice%"=="13" goto PERMISSION_RESET
if "%fchoice%"=="14" goto INHERITANCE_MGR
if "%fchoice%"=="15" goto EFFECTIVE_PERMS
if "%fchoice%"=="16" goto FILE_SEARCH_ADV
if "%fchoice%"=="17" goto DUPLICATE_FINDER
if "%fchoice%"=="18" goto LARGE_FILE_FINDER
if "%fchoice%"=="19" goto EMPTY_FOLDER_FINDER
if "%fchoice%"=="20" goto RECENT_FILES
if "%fchoice%"=="21" goto CONTENT_SEARCH
if "%fchoice%"=="22" goto REGEX_SEARCH
if "%fchoice%"=="23" goto ATTRIBUTE_MGR
if "%fchoice%"=="24" goto HIDDEN_FILES_ADV
if "%fchoice%"=="25" goto SYSTEM_FILES
if "%fchoice%"=="26" goto READONLY_TOGGLE
if "%fchoice%"=="27" goto TIMESTAMP_EDITOR
if "%fchoice%"=="28" goto FILE_PROPERTIES
if "%fchoice%"=="29" goto EXTENDED_ATTRS
if "%fchoice%"=="30" goto ALT_STREAMS
if "%fchoice%"=="31" goto ZIP_CREATOR
if "%fchoice%"=="32" goto ZIP_EXTRACTOR
if "%fchoice%"=="33" goto SEVEN_ZIP_OPS
if "%fchoice%"=="34" goto CAB_FILES
if "%fchoice%"=="35" goto ARCHIVE_MGR
if "%fchoice%"=="36" goto FILE_ENCRYPTOR_ADV
if "%fchoice%"=="37" goto FOLDER_LOCK
if "%fchoice%"=="38" goto EFS_MANAGER
if "%fchoice%"=="39" goto BITLOCKER_MGR
if "%fchoice%"=="40" goto SECURE_CONTAINER
if "%fchoice%"=="41" goto SYMBOLIC_LINKS
if "%fchoice%"=="42" goto HARD_LINKS
if "%fchoice%"=="43" goto JUNCTION_POINTS
if "%fchoice%"=="44" goto MOUNT_POINTS
if "%fchoice%"=="45" goto SPARSE_FILES
if "%fchoice%"=="46" goto DELETED_RECOVERY
if "%fchoice%"=="47" goto SHADOW_COPY
if "%fchoice%"=="48" goto DISK_USAGE
if "%fchoice%"=="49" goto FILE_STATISTICS
if "%fchoice%"=="50" goto NTFS_FEATURES
if "%fchoice%"=="0" goto MAIN_MENU
goto FILE_TOOLS

:FILE_SHREDDER
cls
echo.
echo  ==================== SECURE FILE SHREDDER ====================
echo.
powershell -Command "& {
    Write-Host 'SECURE FILE SHREDDER' -ForegroundColor Red
    Write-Host 'This will permanently delete files with multiple overwrites!' -ForegroundColor Yellow
    Write-Host ''
    $path = Read-Host 'Enter file/folder path to shred'
    if (Test-Path $path) {
        $passes = Read-Host 'Number of overwrite passes (1-35, recommended: 7)'
        Write-Host 'Shredding with'$passes'passes...' -ForegroundColor Red
        function Shred-File {
            param($file, $passes)
            $size = (Get-Item $file).Length
            for ($i = 1; $i -le $passes; $i++) {
                Write-Host 'Pass'$i'of'$passes': '$file
                $stream = [System.IO.File]::OpenWrite($file)
                $random = New-Object byte[] $size
                (New-Object Random).NextBytes($random)
                $stream.Write($random, 0, $size)
                $stream.Close()
            }
            Remove-Item $file -Force
        }
        if ((Get-Item $path).PSIsContainer) {
            Get-ChildItem $path -Recurse -File | ForEach-Object { Shred-File $_.FullName $passes }
            Remove-Item $path -Recurse -Force
        } else {
            Shred-File $path $passes
        }
        Write-Host 'Shredding complete!' -ForegroundColor Green
    } else {
        Write-Host 'Path not found!' -ForegroundColor Red
    }
}"
pause
goto FILE_TOOLS

:DUPLICATE_FINDER
cls
echo.
echo  ==================== DUPLICATE FILE FINDER ====================
echo.
powershell -Command "& {
    $path = Read-Host 'Enter directory path to scan'
    Write-Host 'Scanning for duplicates...' -ForegroundColor Yellow
    $files = Get-ChildItem -Path $path -Recurse -File | Select-Object FullName, Length, 
        @{Name='Hash';Expression={(Get-FileHash $_.FullName -Algorithm MD5).Hash}}
    $duplicates = $files | Group-Object Hash | Where-Object {$_.Count -gt 1}
    if ($duplicates) {
        Write-Host 'Found'$duplicates.Count'sets of duplicate files:' -ForegroundColor Red
        foreach ($group in $duplicates) {
            Write-Host ''
            Write-Host 'Duplicate Set (Hash:'$group.Name'):' -ForegroundColor Yellow
            $group.Group | ForEach-Object {
                Write-Host '  '$_.FullName' ('([math]::Round($_.Length/1MB,2))'MB)'
            }
            $totalWaste = ($group.Group[0].Length * ($group.Count - 1))
            Write-Host '  Wasted Space:'([math]::Round($totalWaste/1MB,2))'MB' -ForegroundColor Red
        }
    } else {
        Write-Host 'No duplicates found!' -ForegroundColor Green
    }
}"
pause
goto FILE_TOOLS

:SECURITY_TOOLS
cls
call :BANNER
echo.
echo  ============================== SECURITY TOOLS ==============================
echo.
echo   === PASSWORD & AUTH ===          === SCANNING ===                === FIREWALL ===
echo   [1]  Password Generator          [16] Malware Scanner            [31] Firewall Manager
echo   [2]  Password Strength Check     [17] Rootkit Scanner            [32] Firewall Rules
echo   [3]  Password Manager            [18] Port Scanner               [33] Port Blocker
echo   [4]  Two-Factor Auth             [19] Vulnerability Scanner      [34] IP Blocker
echo   [5]  Biometric Settings          [20] Security Audit             [35] Application Control
echo   [6]  Credential Manager          [21] File Integrity Check       
echo   [7]  Smart Card Manager          [22] Registry Scanner           === ENCRYPTION ===
echo                                                                    [36] File Encryption
echo   === ANTIVIRUS ===                === MONITORING ===              [37] Disk Encryption
echo   [8]  Windows Defender            [23] Process Monitor            [38] Email Encryption
echo   [9]  Defender Updates            [24] Network Monitor            [39] PGP Tools
echo   [10] Quarantine Manager          [25] File Monitor               [40] Certificate Manager
echo   [11] Exclusion Manager           [26] Registry Monitor           
echo   [12] Scan Scheduler              [27] Event Monitor              === PRIVACY ===
echo   [13] Threat History              [28] USB Monitor                [41] Privacy Cleaner
echo   [14] Real-time Protection        [29] Keylogger Detector         [42] Metadata Remover
echo   [15] Cloud Protection            [30] Camera/Mic Monitor         [43] Anonymizer
echo                                                                    [44] VPN Manager
echo   === ADVANCED ===                                                 [45] Proxy Manager
echo   [46] Security Policy Editor
echo   [47] UAC Configuration
echo   [48] AppLocker
echo   [49] BitLocker
echo   [50] Secure Boot
echo.
echo   [0] Back to Main Menu
echo.
set /p "sechoice=Select Option: "

if "%sechoice%"=="1" goto PASS_GEN_ADV
if "%sechoice%"=="2" goto PASS_STRENGTH
if "%sechoice%"=="3" goto PASS_MANAGER
if "%sechoice%"=="4" goto TWO_FACTOR
if "%sechoice%"=="5" goto BIOMETRIC
if "%sechoice%"=="6" goto CREDENTIAL_MGR
if "%sechoice%"=="7" goto SMARTCARD_MGR
if "%sechoice%"=="8" goto DEFENDER_MGR
if "%sechoice%"=="9" goto DEFENDER_UPDATE
if "%sechoice%"=="10" goto QUARANTINE_MGR
if "%sechoice%"=="11" goto EXCLUSION_MGR
if "%sechoice%"=="12" goto SCAN_SCHEDULER
if "%sechoice%"=="13" goto THREAT_HISTORY
if "%sechoice%"=="14" goto REALTIME_PROTECTION
if "%sechoice%"=="15" goto CLOUD_PROTECTION
if "%sechoice%"=="16" goto MALWARE_SCANNER
if "%sechoice%"=="17" goto ROOTKIT_SCANNER
if "%sechoice%"=="18" goto PORT_SCANNER_SEC
if "%sechoice%"=="19" goto VULN_SCANNER
if "%sechoice%"=="20" goto SECURITY_AUDIT
if "%sechoice%"=="21" goto FILE_INTEGRITY
if "%sechoice%"=="22" goto REGISTRY_SCANNER
if "%sechoice%"=="23" goto PROCESS_MONITOR_SEC
if "%sechoice%"=="24" goto NETWORK_MONITOR_SEC
if "%sechoice%"=="25" goto FILE_MONITOR_SEC
if "%sechoice%"=="26" goto REGISTRY_MONITOR_SEC
if "%sechoice%"=="27" goto EVENT_MONITOR
if "%sechoice%"=="28" goto USB_MONITOR
if "%sechoice%"=="29" goto KEYLOGGER_DETECT
if "%sechoice%"=="30" goto CAMERA_MIC_MONITOR
if "%sechoice%"=="31" goto FIREWALL_MGR_ADV
if "%sechoice%"=="32" goto FIREWALL_RULES_ADV
if "%sechoice%"=="33" goto PORT_BLOCKER
if "%sechoice%"=="34" goto IP_BLOCKER
if "%sechoice%"=="35" goto APP_CONTROL
if "%sechoice%"=="36" goto FILE_ENCRYPTION_ADV
if "%sechoice%"=="37" goto DISK_ENCRYPTION
if "%sechoice%"=="38" goto EMAIL_ENCRYPTION
if "%sechoice%"=="39" goto PGP_TOOLS
if "%sechoice%"=="40" goto CERT_MANAGER
if "%sechoice%"=="41" goto PRIVACY_CLEANER
if "%sechoice%"=="42" goto METADATA_REMOVER
if "%sechoice%"=="43" goto ANONYMIZER
if "%sechoice%"=="44" goto VPN_MANAGER_ADV
if "%sechoice%"=="45" goto PROXY_MANAGER
if "%sechoice%"=="46" goto SEC_POLICY_EDITOR
if "%sechoice%"=="47" goto UAC_CONFIG
if "%sechoice%"=="48" goto APPLOCKER_ADV
if "%sechoice%"=="49" goto BITLOCKER_ADV
if "%sechoice%"=="50" goto SECURE_BOOT
if "%sechoice%"=="0" goto MAIN_MENU
goto SECURITY_TOOLS

:PASS_GEN_ADV
cls
echo.
echo  ==================== ADVANCED PASSWORD GENERATOR ====================
echo.
powershell -Command "& {
    Write-Host 'Advanced Password Generator' -ForegroundColor Green
    Write-Host ''
    $length = Read-Host 'Password length (8-128)'
    Write-Host 'Include: (Y/N for each)'
    $upper = Read-Host 'Uppercase letters?'
    $lower = Read-Host 'Lowercase letters?'
    $numbers = Read-Host 'Numbers?'
    $symbols = Read-Host 'Symbols?'
    $exclude = Read-Host 'Exclude ambiguous characters (0,O,l,1)?'
    
    $chars = ''
    if ($upper -eq 'Y') { $chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' }
    if ($lower -eq 'Y') { $chars += 'abcdefghijklmnopqrstuvwxyz' }
    if ($numbers -eq 'Y') { $chars += '0123456789' }
    if ($symbols -eq 'Y') { $chars += '!@#$%^&*()_+-=[]{}|;:,.<>?' }
    if ($exclude -eq 'Y') { $chars = $chars -replace '[0Ol1]','' }
    
    Write-Host ''
    Write-Host 'Generated Passwords:' -ForegroundColor Yellow
    1..5 | ForEach-Object {
        $password = -join (1..$length | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
        Write-Host $password
        if ($_ -eq 1) { $password | Set-Clipboard; Write-Host '(First password copied to clipboard)' -ForegroundColor Gray }
    }
    
    Write-Host ''
    Write-Host 'Password Strength Analysis:' -ForegroundColor Cyan
    $entropy = [math]::Log2([math]::Pow($chars.Length, $length))
    Write-Host 'Character Set Size:'$chars.Length
    Write-Host 'Entropy:'([math]::Round($entropy, 2))'bits'
    Write-Host 'Strength: ' -NoNewline
    if ($entropy -lt 30) { Write-Host 'Very Weak' -ForegroundColor Red }
    elseif ($entropy -lt 50) { Write-Host 'Weak' -ForegroundColor Yellow }
    elseif ($entropy -lt 70) { Write-Host 'Fair' -ForegroundColor Yellow }
    elseif ($entropy -lt 90) { Write-Host 'Strong' -ForegroundColor Green }
    else { Write-Host 'Very Strong' -ForegroundColor Green }
}"
pause
goto SECURITY_TOOLS

:MALWARE_SCANNER
cls
echo.
echo  ==================== MALWARE SCANNER ====================
echo.
powershell -Command "& {
    Write-Host 'Malware Scanner' -ForegroundColor Red
    Write-Host 'Performing quick security scan...' -ForegroundColor Yellow
    Write-Host ''
    
    # Check for suspicious processes
    Write-Host 'Checking for suspicious processes...' -ForegroundColor Cyan
    $suspiciousProcesses = @('powershell','cmd','wscript','cscript','mshta','rundll32') 
    Get-Process | Where-Object { $suspiciousProcesses -contains $_.Name } | ForEach-Object {
        if ($_.Path -notlike '*\Windows\System32\*' -and $_.Path -notlike '*\Windows\SysWOW64\*') {
            Write-Host '[WARNING] Suspicious process:'$_.Name'at'$_.Path -ForegroundColor Red
        }
    }
    
    # Check for suspicious services
    Write-Host ''
    Write-Host 'Checking for suspicious services...' -ForegroundColor Cyan
    Get-Service | Where-Object { $_.Status -eq 'Running' -and $_.ServiceName -match '^[a-z]{8,10}$' } | ForEach-Object {
        Write-Host '[WARNING] Suspicious service:'$_.ServiceName -ForegroundColor Yellow
    }
    
    # Check for suspicious scheduled tasks
    Write-Host ''
    Write-Host 'Checking for suspicious scheduled tasks...' -ForegroundColor Cyan
    Get-ScheduledTask | Where-Object { $_.State -eq 'Ready' -and $_.Author -eq '' } | ForEach-Object {
        Write-Host '[WARNING] Suspicious task:'$_.TaskName -ForegroundColor Yellow
    }
    
    # Check for suspicious network connections
    Write-Host ''
    Write-Host 'Checking for suspicious network connections...' -ForegroundColor Cyan
    Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' -and $_.RemotePort -in @(4444,5555,6666,7777,8888,9999) } | ForEach-Object {
        Write-Host '[WARNING] Suspicious connection to'$_.RemoteAddress':'$_.RemotePort -ForegroundColor Red
    }
    
    # Windows Defender quick scan
    Write-Host ''
    Write-Host 'Starting Windows Defender quick scan...' -ForegroundColor Green
    Start-MpScan -ScanType QuickScan
    
    Write-Host ''
    Write-Host 'Scan complete!' -ForegroundColor Green
}"
pause
goto SECURITY_TOOLS

:DEV_TOOLS
cls
call :BANNER
echo.
echo  ============================== DEVELOPER TOOLS ==============================
echo.
echo   === ENVIRONMENT ===              === VERSION CONTROL ===         === BUILD TOOLS ===
echo   [1]  Environment Variables       [16] Git Configuration          [31] MSBuild Helper
echo   [2]  PATH Manager                [17] Git Repository Init        [32] Make Helper
echo   [3]  SDK Manager                 [18] Git Commit Helper          [33] Compiler Detector
echo   [4]  Runtime Versions            [19] Git Branch Manager         [34] Build Automation
echo   [5]  Package Managers            [20] Git Log Viewer             [35] CI/CD Pipeline
echo   [6]  Virtual Environments        [21] Git Diff Tool              
echo   [7]  Container Manager           [22] SVN Helper                 === DEBUGGING ===
echo                                                                    [36] Debug Mode Toggle
echo   === WEB DEVELOPMENT ===          === DATABASE ===                [37] Symbol Server
echo   [8]  Local Server                [23] SQL Server Manager         [38] Crash Dump Analysis
echo   [9]  Port Manager                [24] MySQL Manager              [39] Memory Dump
echo   [10] SSL Certificate Gen         [25] SQLite Browser             [40] Process Debugger
echo   [11] API Tester                  [26] MongoDB Helper             
echo   [12] REST Client                 [27] Redis Manager              === CODE TOOLS ===
echo   [13] WebSocket Tester            [28] Database Backup            [41] Code Formatter
echo   [14] HTTP Server                 [29] Query Optimizer            [42] Syntax Checker
echo   [15] Proxy Server                [30] Connection Pooling         [43] Linter
echo                                                                    [44] Code Generator
echo   === TESTING ===                  === DOCUMENTATION ===           [45] Template Manager
echo   [46] Unit Test Runner            [48] API Doc Generator          
echo   [47] Integration Tester          [49] Markdown Viewer            === MISC ===
echo                                    [50] Comment Generator          [51] License Manager
echo.
echo   [0] Back to Main Menu
echo.
set /p "dchoice=Select Option: "

if "%dchoice%"=="1" goto ENV_VARS_ADV
if "%dchoice%"=="2" goto PATH_MGR_ADV
if "%dchoice%"=="3" goto SDK_MANAGER
if "%dchoice%"=="4" goto RUNTIME_VERSIONS
if "%dchoice%"=="5" goto PACKAGE_MANAGERS
if "%dchoice%"=="6" goto VIRTUAL_ENV
if "%dchoice%"=="7" goto CONTAINER_MGR
if "%dchoice%"=="8" goto LOCAL_SERVER
if "%dchoice%"=="9" goto PORT_MGR_DEV
if "%dchoice%"=="10" goto SSL_CERT_GEN
if "%dchoice%"=="11" goto API_TESTER
if "%dchoice%"=="12" goto REST_CLIENT
if "%dchoice%"=="13" goto WEBSOCKET_TEST
if "%dchoice%"=="14" goto HTTP_SERVER
if "%dchoice%"=="15" goto PROXY_SERVER
if "%dchoice%"=="16" goto GIT_CONFIG
if "%dchoice%"=="17" goto GIT_INIT
if "%dchoice%"=="18" goto GIT_COMMIT
if "%dchoice%"=="19" goto GIT_BRANCH
if "%dchoice%"=="20" goto GIT_LOG
if "%dchoice%"=="21" goto GIT_DIFF
if "%dchoice%"=="22" goto SVN_HELPER
if "%dchoice%"=="23" goto SQL_SERVER_MGR
if "%dchoice%"=="24" goto MYSQL_MGR
if "%dchoice%"=="25" goto SQLITE_BROWSER
if "%dchoice%"=="26" goto MONGODB_HELPER
if "%dchoice%"=="27" goto REDIS_MGR
if "%dchoice%"=="28" goto DB_BACKUP
if "%dchoice%"=="29" goto QUERY_OPTIMIZER
if "%dchoice%"=="30" goto CONN_POOLING
if "%dchoice%"=="31" goto MSBUILD_HELPER
if "%dchoice%"=="32" goto MAKE_HELPER
if "%dchoice%"=="33" goto COMPILER_DETECT
if "%dchoice%"=="34" goto BUILD_AUTO
if "%dchoice%"=="35" goto CI_CD_PIPELINE
if "%dchoice%"=="36" goto DEBUG_MODE_TOGGLE
if "%dchoice%"=="37" goto SYMBOL_SERVER
if "%dchoice%"=="38" goto CRASH_DUMP
if "%dchoice%"=="39" goto MEMORY_DUMP_DEV
if "%dchoice%"=="40" goto PROCESS_DEBUGGER
if "%dchoice%"=="41" goto CODE_FORMATTER
if "%dchoice%"=="42" goto SYNTAX_CHECKER
if "%dchoice%"=="43" goto LINTER
if "%dchoice%"=="44" goto CODE_GENERATOR
if "%dchoice%"=="45" goto TEMPLATE_MGR
if "%dchoice%"=="46" goto UNIT_TEST
if "%dchoice%"=="47" goto INTEGRATION_TEST
if "%dchoice%"=="48" goto API_DOC_GEN
if "%dchoice%"=="49" goto MARKDOWN_VIEWER
if "%dchoice%"=="50" goto COMMENT_GEN
if "%dchoice%"=="51" goto LICENSE_MGR
if "%dchoice%"=="0" goto MAIN_MENU
goto DEV_TOOLS

:LOCAL_SERVER
cls
echo.
echo  ==================== LOCAL DEVELOPMENT SERVER ====================
echo.
powershell -Command "& {
    Write-Host 'Local Development Server' -ForegroundColor Green
    Write-Host ''
    $port = Read-Host 'Enter port number (default: 8080)'
    if (-not $port) { $port = '8080' }
    $path = Read-Host 'Enter root directory (default: current)'
    if (-not $path) { $path = Get-Location }
    
    Write-Host ''
    Write-Host 'Starting HTTP server on port'$port'...' -ForegroundColor Yellow
    Write-Host 'Root directory:'$path
    Write-Host 'URL: http://localhost:'$port -ForegroundColor Cyan
    Write-Host ''
    Write-Host 'Press Ctrl+C to stop the server' -ForegroundColor Gray
    
    $http = [System.Net.HttpListener]::new()
    $http.Prefixes.Add('http://localhost:' + $port + '/')
    $http.Start()
    
    try {
        while ($http.IsListening) {
            $context = $http.GetContext()
            $request = $context.Request
            $response = $context.Response
            
            Write-Host ('{0} {1}' -f $request.HttpMethod, $request.Url.LocalPath) -ForegroundColor Green
            
            $file = Join-Path $path $request.Url.LocalPath.TrimStart('/')
            if ((Get-Item $file -ErrorAction SilentlyContinue).PSIsContainer) {
                $file = Join-Path $file 'index.html'
            }
            
            if (Test-Path $file) {
                $buffer = [System.IO.File]::ReadAllBytes($file)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            } else {
                $response.StatusCode = 404
                $buffer = [System.Text.Encoding]::UTF8.GetBytes('404 Not Found')
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            }
            $response.Close()
        }
    } finally {
        $http.Stop()
    }
}"
goto DEV_TOOLS

:API_TESTER
cls
echo.
echo  ==================== API TESTER ====================
echo.
powershell -Command "& {
    Write-Host 'REST API Tester' -ForegroundColor Green
    Write-Host ''
    $url = Read-Host 'Enter API URL'
    $method = Read-Host 'HTTP Method (GET/POST/PUT/DELETE)'
    $headers = @{}
    
    Write-Host 'Add headers (press Enter with empty name to skip):' -ForegroundColor Yellow
    while ($true) {
        $headerName = Read-Host 'Header name'
        if (-not $headerName) { break }
        $headerValue = Read-Host 'Header value'
        $headers[$headerName] = $headerValue
    }
    
    $body = $null
    if ($method -ne 'GET') {
        $body = Read-Host 'Request body (JSON)'
    }
    
    Write-Host ''
    Write-Host 'Sending request...' -ForegroundColor Yellow
    
    try {
        $params = @{
            Uri = $url
            Method = $method
            Headers = $headers
        }
        if ($body) { $params['Body'] = $body }
        
        $response = Invoke-RestMethod @params -Verbose
        
        Write-Host ''
        Write-Host 'Response:' -ForegroundColor Green
        $response | ConvertTo-Json -Depth 10
    } catch {
        Write-Host 'Error:'$_.Exception.Message -ForegroundColor Red
        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            Write-Host 'Response:'$reader.ReadToEnd()
        }
    }
}"
pause
goto DEV_TOOLS

:GAMES
cls
call :BANNER
echo.
echo  ============================== GAMES & ENTERTAINMENT ==============================
echo.
echo   === CLASSIC GAMES ===            === PUZZLE GAMES ===           === ACTION GAMES ===
echo   [1]  Number Guessing             [11] Sudoku Solver             [21] Snake Game
echo   [2]  Rock Paper Scissors         [12] Word Scramble             [22] Space Invaders (ASCII)
echo   [3]  Tic-Tac-Toe                 [13] Anagram Game              [23] Asteroids (ASCII)
echo   [4]  Hangman                     [14] Crossword Helper          [24] Racing Game
echo   [5]  Blackjack                   [15] Logic Puzzles             [25] Shooting Gallery
echo   [6]  Dice Games                  [16] Math Puzzles              
echo   [7]  Card Games                  [17] Memory Game               === UTILITIES ===
echo   [8]  Coin Flip                   [18] Pattern Matching          [26] Dice Roller
echo   [9]  Lottery Simulator           [19] Maze Generator            [27] Card Shuffler
echo   [10] Slot Machine                [20] Tower of Hanoi            [28] Random Generator
echo                                                                   [29] ASCII Art Gallery
echo                                                                   [30] Text Adventure Engine
echo.
echo   [0] Back to Main Menu
echo.
set /p "gchoice=Select Option: "

if "%gchoice%"=="1" goto NUMBER_GUESS_ADV
if "%gchoice%"=="2" goto RPS_ADV
if "%gchoice%"=="3" goto TIC_TAC_TOE
if "%gchoice%"=="4" goto HANGMAN
if "%gchoice%"=="5" goto BLACKJACK
if "%gchoice%"=="6" goto DICE_GAMES
if "%gchoice%"=="7" goto CARD_GAMES
if "%gchoice%"=="8" goto COIN_FLIP
if "%gchoice%"=="9" goto LOTTERY_SIM
if "%gchoice%"=="10" goto SLOT_MACHINE
if "%gchoice%"=="11" goto SUDOKU_SOLVER
if "%gchoice%"=="12" goto WORD_SCRAMBLE
if "%gchoice%"=="13" goto ANAGRAM_GAME
if "%gchoice%"=="14" goto CROSSWORD_HELPER
if "%gchoice%"=="15" goto LOGIC_PUZZLES
if "%gchoice%"=="16" goto MATH_PUZZLES
if "%gchoice%"=="17" goto MEMORY_GAME_ADV
if "%gchoice%"=="18" goto PATTERN_MATCH
if "%gchoice%"=="19" goto MAZE_GEN
if "%gchoice%"=="20" goto TOWER_HANOI
if "%gchoice%"=="21" goto SNAKE_ADV
if "%gchoice%"=="22" goto SPACE_INVADERS
if "%gchoice%"=="23" goto ASTEROIDS
if "%gchoice%"=="24" goto RACING_GAME
if "%gchoice%"=="25" goto SHOOTING_GALLERY
if "%gchoice%"=="26" goto DICE_ROLLER
if "%gchoice%"=="27" goto CARD_SHUFFLER
if "%gchoice%"=="28" goto RANDOM_GEN
if "%gchoice%"=="29" goto ASCII_ART
if "%gchoice%"=="30" goto TEXT_ADVENTURE
if "%gchoice%"=="0" goto MAIN_MENU
goto GAMES

:TIC_TAC_TOE
cls
echo.
echo  ==================== TIC-TAC-TOE ====================
echo.
powershell -Command "& {
    $board = @('1','2','3','4','5','6','7','8','9')
    $player = 'X'
    $computer = 'O'
    
    function Show-Board {
        Write-Host ''
        Write-Host ' '$board[0]' | '$board[1]' | '$board[2]
        Write-Host '-----------'
        Write-Host ' '$board[3]' | '$board[4]' | '$board[5]
        Write-Host '-----------'
        Write-Host ' '$board[6]' | '$board[7]' | '$board[8]
        Write-Host ''
    }
    
    function Check-Winner {
        $lines = @(
            @(0,1,2), @(3,4,5), @(6,7,8),
            @(0,3,6), @(1,4,7), @(2,5,8),
            @(0,4,8), @(2,4,6)
        )
        foreach ($line in $lines) {
            if ($board[$line[0]] -eq $board[$line[1]] -and $board[$line[1]] -eq $board[$line[2]]) {
                return $board[$line[0]]
            }
        }
        if ($board -notcontains '1' -and $board -notcontains '2' -and $board -notcontains '3' -and
            $board -notcontains '4' -and $board -notcontains '5' -and $board -notcontains '6' -and
            $board -notcontains '7' -and $board -notcontains '8' -and $board -notcontains '9') {
            return 'Tie'
        }
        return $null
    }
    
    Write-Host 'TIC-TAC-TOE' -ForegroundColor Green
    Write-Host 'You are X, Computer is O' -ForegroundColor Yellow
    
    while ($true) {
        Show-Board
        $move = Read-Host 'Your move (1-9)'
        if ($board[$move-1] -ne 'X' -and $board[$move-1] -ne 'O') {
            $board[$move-1] = $player
        } else {
            Write-Host 'Invalid move!' -ForegroundColor Red
            continue
        }
        
        $winner = Check-Winner
        if ($winner) {
            Show-Board
            if ($winner -eq 'Tie') { Write-Host 'It''s a tie!' -ForegroundColor Yellow }
            elseif ($winner -eq $player) { Write-Host 'You win!' -ForegroundColor Green }
            else { Write-Host 'Computer wins!' -ForegroundColor Red }
            break
        }
        
        # Computer move (simple AI)
        $available = @()
        for ($i = 0; $i -lt 9; $i++) {
            if ($board[$i] -ne 'X' -and $board[$i] -ne 'O') { $available += $i }
        }
        if ($available.Count -gt 0) {
            $compMove = $available | Get-Random
            $board[$compMove] = $computer
            Write-Host 'Computer chose:'($compMove+1) -ForegroundColor Cyan
        }
        
        $winner = Check-Winner
        if ($winner) {
            Show-Board
            if ($winner -eq 'Tie') { Write-Host 'It''s a tie!' -ForegroundColor Yellow }
            elseif ($winner -eq $player) { Write-Host 'You win!' -ForegroundColor Green }
            else { Write-Host 'Computer wins!' -ForegroundColor Red }
            break
        }
    }
}"
pause
goto GAMES

:POWERSHELL_TOOLS
cls
call :BANNER
echo.
echo  ============================== POWERSHELL TOOLS ==============================
echo.
echo   === SCRIPTING ===                === MODULES ===                === REMOTING ===
echo   [1]  Script Generator            [15] Module Manager            [29] Remote Session
echo   [2]  Script Analyzer             [16] Module Installer          [30] Remote Commands
echo   [3]  Script Debugger             [17] Module Builder            [31] Remote File Transfer
echo   [4]  Script Converter            [18] Module Repository         [32] Remote Registry
echo   [5]  Script Obfuscator           [19] Module Documentation      [33] Remote WMI
echo   [6]  Script Signer               [20] Module Testing            
echo   [7]  Script Profiler                                            === AUTOMATION ===
echo                                    === SYSTEM ===                 [34] Task Automation
echo   === CMDLETS ===                  [21] System Information        [35] Event Automation
echo   [8]  Cmdlet Explorer             [22] Performance Counters      [36] File Watcher
echo   [9]  Cmdlet Help                 [23] Event Logs                [37] Schedule Jobs
echo   [10] Cmdlet Builder              [24] Service Control           [38] Workflow Engine
echo   [11] Cmdlet Tester               [25] Process Control           
echo   [12] Pipeline Builder            [26] Registry Access           === ADVANCED ===
echo   [13] Object Explorer             [27] WMI Queries               [39] DSC Configuration
echo   [14] Type Accelerators           [28] COM Objects               [40] Class Builder
echo.
echo   [0] Back to Main Menu
echo.
set /p "pschoice=Select Option: "

if "%pschoice%"=="1" goto PS_SCRIPT_GEN
if "%pschoice%"=="2" goto PS_ANALYZER
if "%pschoice%"=="3" goto PS_DEBUGGER
if "%pschoice%"=="4" goto PS_CONVERTER
if "%pschoice%"=="5" goto PS_OBFUSCATOR
if "%pschoice%"=="6" goto PS_SIGNER
if "%pschoice%"=="7" goto PS_PROFILER
if "%pschoice%"=="8" goto PS_CMDLET_EXPLORER
if "%pschoice%"=="9" goto PS_HELP
if "%pschoice%"=="10" goto PS_CMDLET_BUILDER
if "%pschoice%"=="11" goto PS_CMDLET_TESTER
if "%pschoice%"=="12" goto PS_PIPELINE
if "%pschoice%"=="13" goto PS_OBJECT_EXPLORER
if "%pschoice%"=="14" goto PS_TYPE_ACCEL
if "%pschoice%"=="15" goto PS_MODULE_MGR
if "%pschoice%"=="16" goto PS_MODULE_INSTALL
if "%pschoice%"=="17" goto PS_MODULE_BUILDER
if "%pschoice%"=="18" goto PS_MODULE_REPO
if "%pschoice%"=="19" goto PS_MODULE_DOC
if "%pschoice%"=="20" goto PS_MODULE_TEST
if "%pschoice%"=="21" goto PS_SYSINFO
if "%pschoice%"=="22" goto PS_PERF_COUNTERS
if "%pschoice%"=="23" goto PS_EVENT_LOGS
if "%pschoice%"=="24" goto PS_SERVICE_CTRL
if "%pschoice%"=="25" goto PS_PROCESS_CTRL
if "%pschoice%"=="26" goto PS_REGISTRY
if "%pschoice%"=="27" goto PS_WMI
if "%pschoice%"=="28" goto PS_COM
if "%pschoice%"=="29" goto PS_REMOTE_SESSION
if "%pschoice%"=="30" goto PS_REMOTE_CMD
if "%pschoice%"=="31" goto PS_REMOTE_FILE
if "%pschoice%"=="32" goto PS_REMOTE_REG
if "%pschoice%"=="33" goto PS_REMOTE_WMI
if "%pschoice%"=="34" goto PS_TASK_AUTO
if "%pschoice%"=="35" goto PS_EVENT_AUTO
if "%pschoice%"=="36" goto PS_FILE_WATCHER
if "%pschoice%"=="37" goto PS_SCHEDULE
if "%pschoice%"=="38" goto PS_WORKFLOW
if "%pschoice%"=="39" goto PS_DSC
if "%pschoice%"=="40" goto PS_CLASS_BUILDER
if "%pschoice%"=="0" goto MAIN_MENU
goto POWERSHELL_TOOLS

:PS_SCRIPT_GEN
cls
echo.
echo  ==================== POWERSHELL SCRIPT GENERATOR ====================
echo.
powershell -Command "& {
    Write-Host 'PowerShell Script Generator' -ForegroundColor Green
    Write-Host ''
    Write-Host 'Select script type:' -ForegroundColor Yellow
    Write-Host '1. System Information Collector'
    Write-Host '2. File Backup Script'
    Write-Host '3. Network Monitor'
    Write-Host '4. Service Monitor'
    Write-Host '5. Log Parser'
    Write-Host '6. User Management'
    Write-Host '7. Registry Backup'
    Write-Host '8. Performance Monitor'
    
    $choice = Read-Host 'Select option'
    $scriptName = Read-Host 'Enter script name (without .ps1)'
    
    $script = @'
# Generated PowerShell Script
# Created: $(Get-Date)
# Type: 
'@
    
    switch ($choice) {
        '1' {
            $script += @'

# System Information Collector
$info = @{}
$info['ComputerName'] = $env:COMPUTERNAME
$info['OS'] = Get-WmiObject Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber
$info['CPU'] = Get-WmiObject Win32_Processor | Select-Object Name, MaxClockSpeed, NumberOfCores
$info['Memory'] = Get-WmiObject Win32_PhysicalMemory | Measure-Object Capacity -Sum
$info['Disks'] = Get-WmiObject Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace
$info['Network'] = Get-NetAdapter | Select-Object Name, Status, LinkSpeed
$info | ConvertTo-Json | Out-File 'SystemInfo.json'
Write-Host 'System information saved to SystemInfo.json'
'@
        }
        '2' {
            $script += @'

# File Backup Script
param(
    [string]$SourcePath = 'C:\Users\$env:USERNAME\Documents',
    [string]$DestPath = 'D:\Backup'
)

$date = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupPath = Join-Path $DestPath "Backup_$date"
New-Item -ItemType Directory -Path $backupPath -Force

Get-ChildItem $SourcePath -Recurse | ForEach-Object {
    $destFile = $_.FullName.Replace($SourcePath, $backupPath)
    Copy-Item $_.FullName -Destination $destFile -Force
    Write-Progress -Activity 'Backing up files' -Status $_.Name
}
Write-Host "Backup completed to $backupPath"
'@
        }
        '3' {
            $script += @'

# Network Monitor Script
while ($true) {
    Clear-Host
    Write-Host 'Network Monitor' -ForegroundColor Green
    Write-Host '===============' -ForegroundColor Green
    
    # Show network adapters
    Get-NetAdapter | Format-Table Name, Status, LinkSpeed, MacAddress
    
    # Show network connections
    Get-NetTCPConnection | Where-Object State -eq 'Established' | 
        Format-Table LocalAddress, LocalPort, RemoteAddress, RemotePort, State
    
    # Show network statistics
    Get-NetAdapterStatistics | Format-Table Name, ReceivedBytes, SentBytes
    
    Start-Sleep -Seconds 5
}
'@
        }
    }
    
    $script | Out-File "$scriptName.ps1" -Encoding UTF8
    Write-Host "Script generated: $scriptName.ps1" -ForegroundColor Green
}"
pause
goto POWERSHELL_TOOLS

:INTERNET_TOOLS
cls
call :BANNER
echo.
echo  ============================== INTERNET TOOLS ==============================
echo.
echo   === BROWSERS ===                 === DOWNLOADS ===              === NETWORKING ===
echo   [1]  Browser Cache Clear         [16] Download Manager          [31] DNS Changer
echo   [2]  Cookie Manager              [17] YouTube Downloader        [32] Proxy Manager
echo   [3]  History Cleaner             [18] Website Downloader        [33] VPN Client
echo   [4]  Bookmark Manager            [19] FTP Client                [34] TOR Configuration
echo   [5]  Password Manager            [20] Torrent Info              [35] IP Changer
echo   [6]  Extension Manager           [21] Direct Downloader         
echo   [7]  User Agent Switcher         [22] Resume Download           === WEB TOOLS ===
echo   [8]  Browser Reset                                              [36] Website Checker
echo                                    === COMMUNICATION ===          [37] SEO Analyzer
echo   === PRIVACY ===                  [23] Email Client              [38] Link Validator
echo   [9]  Tracking Blocker            [24] IRC Client                [39] Sitemap Generator
echo   [10] Ad Blocker Config           [25] Instant Messenger         [40] RSS Reader
echo   [11] Privacy Mode                [26] Video Conference          [41] Web Scraper
echo   [12] Fingerprint Spoofer         [27] VoIP Tools                [42] API Client
echo   [13] WebRTC Disable              [28] Chat Logger               [43] Webhook Tester
echo   [14] Canvas Blocker              [29] Message Encryption        [44] SSL Checker
echo   [15] Location Spoofer            [30] Secure Tunnel             [45] Domain Tools
echo.
echo   [0] Back to Main Menu
echo.
set /p "ichoice=Select Option: "

if "%ichoice%"=="1" goto BROWSER_CACHE_CLEAR
if "%ichoice%"=="2" goto COOKIE_MANAGER
if "%ichoice%"=="3" goto HISTORY_CLEANER
if "%ichoice%"=="4" goto BOOKMARK_MANAGER
if "%ichoice%"=="5" goto PASSWORD_MGR_BROWSER
if "%ichoice%"=="6" goto EXTENSION_MGR
if "%ichoice%"=="7" goto UA_SWITCHER_ADV
if "%ichoice%"=="8" goto BROWSER_RESET
if "%ichoice%"=="9" goto TRACKING_BLOCKER
if "%ichoice%"=="10" goto AD_BLOCKER
if "%ichoice%"=="11" goto PRIVACY_MODE
if "%ichoice%"=="12" goto FINGERPRINT_SPOOF
if "%ichoice%"=="13" goto WEBRTC_DISABLE
if "%ichoice%"=="14" goto CANVAS_BLOCKER
if "%ichoice%"=="15" goto LOCATION_SPOOFER
if "%ichoice%"=="16" goto DOWNLOAD_MGR_ADV
if "%ichoice%"=="17" goto YOUTUBE_DL
if "%ichoice%"=="18" goto WEBSITE_DL
if "%ichoice%"=="19" goto FTP_CLIENT
if "%ichoice%"=="20" goto TORRENT_INFO
if "%ichoice%"=="21" goto DIRECT_DL
if "%ichoice%"=="22" goto RESUME_DL
if "%ichoice%"=="23" goto EMAIL_CLIENT
if "%ichoice%"=="24" goto IRC_CLIENT
if "%ichoice%"=="25" goto IM_CLIENT
if "%ichoice%"=="26" goto VIDEO_CONF
if "%ichoice%"=="27" goto VOIP_TOOLS
if "%ichoice%"=="28" goto CHAT_LOGGER
if "%ichoice%"=="29" goto MSG_ENCRYPTION
if "%ichoice%"=="30" goto SECURE_TUNNEL
if "%ichoice%"=="31" goto DNS_CHANGER_ADV
if "%ichoice%"=="32" goto PROXY_MGR_ADV
if "%ichoice%"=="33" goto VPN_CLIENT
if "%ichoice%"=="34" goto TOR_CONFIG
if "%ichoice%"=="35" goto IP_CHANGER
if "%ichoice%"=="36" goto WEBSITE_CHECKER
if "%ichoice%"=="37" goto SEO_ANALYZER
if "%ichoice%"=="38" goto LINK_VALIDATOR
if "%ichoice%"=="39" goto SITEMAP_GEN
if "%ichoice%"=="40" goto RSS_READER
if "%ichoice%"=="41" goto WEB_SCRAPER_ADV
if "%ichoice%"=="42" goto API_CLIENT
if "%ichoice%"=="43" goto WEBHOOK_TEST
if "%ichoice%"=="44" goto SSL_CHECKER_ADV
if "%ichoice%"=="45" goto DOMAIN_TOOLS
if "%ichoice%"=="0" goto MAIN_MENU
goto INTERNET_TOOLS

:UA_SWITCHER_ADV
cls
echo.
echo  ==================== ADVANCED USER AGENT SWITCHER ====================
echo.
powershell -Command "& {
    Write-Host 'User Agent Configuration Tool' -ForegroundColor Green
    Write-Host ''
    
    $userAgents = @{
        '1' = @{Name='Chrome Windows Latest'; UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'}
        '2' = @{Name='Firefox Windows Latest'; UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0'}
        '3' = @{Name='Edge Latest'; UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0'}
        '4' = @{Name='Safari macOS'; UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 14_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15'}
        '5' = @{Name='Chrome Android'; UA='Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'}
        '6' = @{Name='iPhone Safari'; UA='Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1'}
        '7' = @{Name='iPad Safari'; UA='Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1'}
        '8' = @{Name='Googlebot'; UA='Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'}
        '9' = @{Name='Bingbot'; UA='Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)'}
        '10' = @{Name='Custom'; UA=''}
    }
    
    Write-Host 'Select User Agent:' -ForegroundColor Yellow
    $userAgents.GetEnumerator() | Sort-Object Name | ForEach-Object {
        Write-Host "$($_.Key). $($_.Value.Name)"
    }
    
    $choice = Read-Host 'Select option'
    
    if ($choice -eq '10') {
        $customUA = Read-Host 'Enter custom User Agent string'
        $userAgents['10'].UA = $customUA
    }
    
    $selectedUA = $userAgents[$choice].UA
    
    # Set for Internet Explorer/Edge
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name 'User Agent' -Value $selectedUA
    
    # Create a test request
    Write-Host ''
    Write-Host 'Testing User Agent...' -ForegroundColor Cyan
    $response = Invoke-WebRequest -Uri 'http://httpbin.org/user-agent' -UserAgent $selectedUA
    Write-Host 'Current User Agent:' -ForegroundColor Green
    Write-Host ($response.Content | ConvertFrom-Json).'user-agent'
    
    Write-Host ''
    Write-Host 'User Agent configured successfully!' -ForegroundColor Green
}"
pause
goto INTERNET_TOOLS

:WEB_SCRAPER_ADV
cls
echo.
echo  ==================== ADVANCED WEB SCRAPER ====================
echo.
powershell -Command "& {
    Write-Host 'Advanced Web Scraper' -ForegroundColor Green
    Write-Host ''
    
    $url = Read-Host 'Enter URL to scrape'
    Write-Host ''
    Write-Host 'Scraping options:' -ForegroundColor Yellow
    Write-Host '1. Extract all links'
    Write-Host '2. Extract all images'
    Write-Host '3. Extract all text'
    Write-Host '4. Extract specific elements (CSS selector)'
    Write-Host '5. Extract meta tags'
    Write-Host '6. Extract forms'
    Write-Host '7. Full page download'
    
    $option = Read-Host 'Select option'
    
    try {
        $response = Invoke-WebRequest -Uri $url
        $html = $response.Content
        
        switch ($option) {
            '1' {
                Write-Host 'Links found:' -ForegroundColor Green
                $response.Links | ForEach-Object {
                    Write-Host $_.href
                }
            }
            '2' {
                Write-Host 'Images found:' -ForegroundColor Green
                $response.Images | ForEach-Object {
                    Write-Host $_.src
                }
            }
            '3' {
                Write-Host 'Text content:' -ForegroundColor Green
                $text = $html -replace '<[^>]+>','' -replace '&nbsp;',' ' -replace '&amp;','&'
                Write-Host $text
            }
            '4' {
                $selector = Read-Host 'Enter CSS selector'
                # Note: Full CSS selector support would require HtmlAgilityPack
                Write-Host 'Note: Full CSS selector support requires additional libraries' -ForegroundColor Yellow
            }
            '5' {
                Write-Host 'Meta tags:' -ForegroundColor Green
                $html | Select-String '<meta[^>]*>' -AllMatches | ForEach-Object {
                    $_.Matches | ForEach-Object {
                        Write-Host $_.Value
                    }
                }
            }
            '6' {
                Write-Host 'Forms found:' -ForegroundColor Green
                $response.Forms | ForEach-Object {
                    Write-Host 'Action:'$_.Action
                    Write-Host 'Method:'$_.Method
                    Write-Host 'Fields:'$_.Fields.Keys -join ', '
                    Write-Host '---'
                }
            }
            '7' {
                $filename = 'scraped_' + ([System.Uri]$url).Host + '.html'
                $html | Out-File $filename -Encoding UTF8
                Write-Host "Page saved to $filename" -ForegroundColor Green
            }
        }
    } catch {
        Write-Host 'Error:'$_.Exception.Message -ForegroundColor Red
    }
}"
pause
goto INTERNET_TOOLS

:RECOVERY_TOOLS
cls
call :BANNER
echo.
echo  ============================== RECOVERY & REPAIR TOOLS ==============================
echo.
echo   === SYSTEM RECOVERY ===          === FILE RECOVERY ===          === BOOT REPAIR ===
echo   [1]  System Restore Point        [13] Deleted File Recovery     [25] Boot Manager Repair
echo   [2]  Create Restore Point        [14] Partition Recovery        [26] BCD Rebuild
echo   [3]  Recovery Environment        [15] Photo Recovery            [27] MBR Fix
echo   [4]  Reset This PC               [16] Document Recovery         [28] Boot Sector Repair
echo   [5]  System Image Backup         [17] Email Recovery            [29] UEFI/BIOS Reset
echo   [6]  System Image Restore        [18] Browser Data Recovery     [30] Safe Mode Config
echo                                                                   
echo   === REPAIR TOOLS ===             === DATA RECOVERY ===          === ADVANCED ===
echo   [7]  SFC Scan                    [19] RAID Recovery             [31] Registry Recovery
echo   [8]  DISM Repair                 [20] Database Recovery         [32] Driver Rollback
echo   [9]  Check Disk                  [21] Encrypted File Recovery   [33] Windows Update Fix
echo   [10] Component Store Cleanup     [22] Shadow Copy Recovery      [34] Network Reset
echo   [11] Windows Update Reset        [23] Backup Recovery           [35] Permission Reset
echo   [12] Driver Repair               [24] Cloud Backup Recovery     
echo.
echo   [0] Back to Main Menu
echo.
set /p "rchoice=Select Option: "

if "%rchoice%"=="1" goto SYSTEM_RESTORE_POINT
if "%rchoice%"=="2" goto CREATE_RESTORE_POINT
if "%rchoice%"=="3" goto RECOVERY_ENV
if "%rchoice%"=="4" goto RESET_PC
if "%rchoice%"=="5" goto SYSTEM_IMAGE_BACKUP
if "%rchoice%"=="6" goto SYSTEM_IMAGE_RESTORE
if "%rchoice%"=="7" goto SFC_SCAN
if "%rchoice%"=="8" goto DISM_REPAIR
if "%rchoice%"=="9" goto CHECK_DISK
if "%rchoice%"=="10" goto COMPONENT_CLEANUP
if "%rchoice%"=="11" goto UPDATE_RESET
if "%rchoice%"=="12" goto DRIVER_REPAIR
if "%rchoice%"=="13" goto FILE_RECOVERY
if "%rchoice%"=="14" goto PARTITION_RECOVERY
if "%rchoice%"=="15" goto PHOTO_RECOVERY
if "%rchoice%"=="16" goto DOCUMENT_RECOVERY
if "%rchoice%"=="17" goto EMAIL_RECOVERY
if "%rchoice%"=="18" goto BROWSER_RECOVERY
if "%rchoice%"=="19" goto RAID_RECOVERY
if "%rchoice%"=="20" goto DATABASE_RECOVERY
if "%rchoice%"=="21" goto ENCRYPTED_RECOVERY
if "%rchoice%"=="22" goto SHADOW_RECOVERY
if "%rchoice%"=="23" goto BACKUP_RECOVERY
if "%rchoice%"=="24" goto CLOUD_RECOVERY
if "%rchoice%"=="25" goto BOOT_MGR_REPAIR
if "%rchoice%"=="26" goto BCD_REBUILD
if "%rchoice%"=="27" goto MBR_FIX
if "%rchoice%"=="28" goto BOOT_SECTOR_REPAIR
if "%rchoice%"=="29" goto UEFI_RESET
if "%rchoice%"=="30" goto SAFE_MODE_CONFIG
if "%rchoice%"=="31" goto REGISTRY_RECOVERY
if "%rchoice%"=="32" goto DRIVER_ROLLBACK
if "%rchoice%"=="33" goto UPDATE_FIX
if "%rchoice%"=="34" goto NETWORK_RESET_FULL
if "%rchoice%"=="35" goto PERMISSION_RESET_FULL
if "%rchoice%"=="0" goto MAIN_MENU
goto RECOVERY_TOOLS

:SFC_SCAN
cls
echo.
echo  ==================== SYSTEM FILE CHECKER ====================
echo.
echo Running comprehensive system file check...
echo.
echo [1/4] Running SFC scan...
sfc /scannow
echo.
echo [2/4] Verifying system files...
sfc /verifyonly
echo.
echo [3/4] Running DISM to check health...
DISM /Online /Cleanup-Image /CheckHealth
echo.
echo [4/4] Scanning for corruption...
DISM /Online /Cleanup-Image /ScanHealth
echo.
echo System file check complete!
echo.
pause
goto RECOVERY_TOOLS

:EXIT_SCRIPT
cls
echo.
echo  ========================================
echo.
echo   Thank you for using Ultimate Windows
echo   Power Tool Suite v2.0 Professional
echo.
echo   Created with Windows native commands
echo   and PowerShell integration
echo.
echo  ========================================
echo.
timeout /t 3 /nobreak >nul
exit /b