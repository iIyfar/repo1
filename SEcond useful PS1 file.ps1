<# 
    SecAuditToolkit.ps1 — Windows 10/11 PowerShell Toolkit
    Audience: Experienced techs doing authorized security auditing, IR triage, privacy, and cleanup.
    Safe focus: No exploitation, no evasion/persistence code, no bypasses. Privacy is reversible where possible.

    Usage:
      . .\SecAuditToolkit.ps1
      Show-Toolkit
      Get-Help <FunctionName> -Detailed

    Notes:
      - Some commands require elevation (Run PowerShell as Administrator).
      - Hiding is not security. Use on data you own and with permission.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

#region Helpers

function Write-Info { param([Parameter(Mandatory)][string]$Message) Write-Host "[i] $Message" -ForegroundColor Cyan }
function Write-Warn { param([Parameter(Mandatory)][string]$Message) Write-Host "[!] $Message" -ForegroundColor Yellow }
function Write-OK   { param([Parameter(Mandatory)][string]$Message) Write-Host "[OK] $Message" -ForegroundColor Green }
function Write-Err  { param([Parameter(Mandatory)][string]$Message) Write-Host "[X] $Message" -ForegroundColor Red }

function Confirm-Action {
    param([Parameter(Mandatory)][string]$Message,[switch]$Force)
    if ($Force) { return $true }
    $resp = Read-Host "$Message (y/n)"
    return $resp -match '^(y|yes)$'
}

function Test-IsAdministrator {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Require-Admin {
    if (-not (Test-IsAdministrator)) {
        throw "This action requires elevation. Please run PowerShell as Administrator."
    }
}

#endregion Helpers

#region System Info & Health

function Get-OSInfo {
    <#
      .SYNOPSIS Summarize OS details.
    #>
    Get-CimInstance Win32_OperatingSystem | Select-Object `
        @{n='ComputerName';e={$_.CSName}},
        @{n='OS';e={$_.Caption}},
        Version, BuildNumber, OSArchitecture,
        @{n='InstallDate';e={$_.InstallDate}},
        @{n='LastBoot';e={$_.LastBootUpTime}}, RegisteredUser
}

function Get-HardwareInfo {
    <#
      .SYNOPSIS CPU, RAM, disk, GPU summary.
    #>
    $cpu = Get-CimInstance Win32_Processor | Select-Object Name, MaxClockSpeed, NumberOfCores, NumberOfLogicalProcessors
    $ramBytes = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum
    $ramGB = [Math]::Round($ramBytes/1GB,2)
    $gpu = Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion,
        @{n='VRAM(GB)';e={[Math]::Round(($_.AdapterRAM/1GB),2)}},
        CurrentHorizontalResolution, CurrentVerticalResolution
    $disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID,
        @{n='Size(GB)';e={[Math]::Round($_.Size/1GB,2)}},
        @{n='Free(GB)';e={[Math]::Round($_.FreeSpace/1GB,2)}}, VolumeName, FileSystem
    [PSCustomObject]@{ CPU=$cpu; RAM_GB=$ramGB; GPU=$gpu; Disks=$disks }
}

function Get-TopProcesses {
    <#
      .SYNOPSIS Top processes by CPU or Memory.
    #>
    param([ValidateSet('CPU','Memory')][string]$By='CPU',[int]$Top=15)
    if ($By -eq 'CPU') { Get-Process | Sort-Object CPU -Descending | Select-Object -First $Top Name,Id,CPU,PM,StartTime -ErrorAction SilentlyContinue }
    else { Get-Process | Sort-Object PM -Descending | Select-Object -First $Top Name,Id,CPU,PM,StartTime -ErrorAction SilentlyContinue }
}

function Get-InstalledApps {
    <#
      .SYNOPSIS List installed programs (Registry-based).
    #>
    $paths = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    $items = foreach ($p in $paths) {
        if (Test-Path $p) {
            Get-ItemProperty $p -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName } |
            Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
        }
    }
    $items | Sort-Object DisplayName -Unique
}

function Run-SFC { sfc /scannow }
function Run-DISMRestore { Require-Admin; DISM /Online /Cleanup-Image /RestoreHealth }
function Get-BatteryReport {
    $out = Join-Path $env:TEMP 'battery-report.html'
    powercfg /batteryreport /output $out | Out-Null
    if (Test-Path $out) { Write-OK "Battery report: $out"; Start-Process $out } else { Write-Err "Failed to generate report." }
}

#endregion System Info & Health

#region Networking

function Show-IPConfig { ipconfig /all }
function Flush-DNS { ipconfig /flushdns }
function Renew-IP { Require-Admin; ipconfig /release; ipconfig /renew }

function List-OpenPorts {
    <#
      .SYNOPSIS Show listening TCP ports with owning process.
    #>
    $conns = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue
    $procMap = @{}
    foreach ($p in Get-Process) { $procMap[$p.Id] = $p.ProcessName }
    $conns | Select-Object LocalAddress, LocalPort, OwningProcess, @{n='ProcessName';e={$procMap[$_.OwningProcess]}} | Sort-Object LocalPort
}

function Test-NetworkPath { param([Parameter(Mandatory)][string]$Host,[int]$Count=4) Test-Connection -ComputerName $Host -Count $Count -ErrorAction SilentlyContinue }
function Test-HTTP {
    param([Parameter(Mandatory)][string]$Url)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try { $r = Invoke-WebRequest -Uri $Url -Method Head -UseBasicParsing -TimeoutSec 15; $sw.Stop(); [PSCustomObject]@{ Url=$Url; StatusCode=$r.StatusCode; TimeMs=$sw.ElapsedMilliseconds } }
    catch { $sw.Stop(); [PSCustomObject]@{ Url=$Url; StatusCode='Error'; TimeMs=$sw.ElapsedMilliseconds; Error=$_.Exception.Message } }
}

#endregion Networking

#region Security Audit & Hardening Snapshot

function Get-LocalAdmins {
    <#
      .SYNOPSIS List members of the local Administrators group.
    #>
    try {
        Get-LocalGroupMember -Group 'Administrators' | Select-Object Name, ObjectClass, PrincipalSource
    } catch {
        Write-Warn "Falling back to 'net localgroup administrators' (no object metadata)."
        (net localgroup administrators) 2>$null | Select-Object -Skip 6 | Where-Object {$_ -and $_ -notmatch 'The command completed successfully'} | ForEach-Object { $_.Trim() } |
            ForEach-Object { [PSCustomObject]@{ Name=$_; ObjectClass='Unknown'; PrincipalSource='Unknown' } }
    }
}

function Get-UserSessions {
    <#
      .SYNOPSIS Show interactive logon sessions (console/RDP).
    #>
    try { quser } catch { Write-Err "Failed to query sessions: $($_.Exception.Message)" }
}

function Get-SMBShareInfo {
    <#
      .SYNOPSIS List SMB shares and basic server configuration.
    #>
    $shares = try { Get-SmbShare -Special $false | Select-Object Name, Path, Description, EncryptData, FolderEnumerationMode } catch { @() }
    $cfg = try { Get-SmbServerConfiguration | Select-Object EnableSMB1Protocol,EnableSMB2Protocol,EncryptData,RejectUnencryptedAccess,EnableSecuritySignature,RequireSecuritySignature } catch { $null }
    [PSCustomObject]@{ Shares=$shares; ServerConfig=$cfg }
}

function Get-RDPConfig {
    <#
      .SYNOPSIS Summarize RDP enablement and NLA state.
    #>
    $deny = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -ErrorAction SilentlyContinue).fDenyTSConnections
    $nla  = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'UserAuthentication' -ErrorAction SilentlyContinue).UserAuthentication
    [PSCustomObject]@{
        RDPAcceptConnections = ($(if ($deny -eq 0) { 'Enabled' } else { 'Disabled' }))
        NetworkLevelAuth     = ($(if ($nla -eq 1) { 'Enabled' } else { 'Disabled/Unknown' }))
    }
}

function Get-FirewallProfiles {
    <#
      .SYNOPSIS Show Windows Firewall profile states.
    #>
    Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction, NotifyOnListen
}

function Get-DefenderStatus {
    <#
      .SYNOPSIS Windows Defender health and preferences snapshot.
    #>
    $status = try { Get-MpComputerStatus } catch { $null }
    $pref   = try { Get-MpPreference } catch { $null }
    if (-not $status) { Write-Warn "Defender status unavailable (third-party AV or module missing)."; return }
    [PSCustomObject]@{
        AMServiceEnabled = $status.AMServiceEnabled
        AntivirusEnabled = $status.AntivirusEnabled
        RealTimeProtectionEnabled = $status.RealTimeProtectionEnabled
        AntispywareEnabled = $status.AntispywareEnabled
        NISEnabled = $status.NISEnabled
        EngineVersion = $status.AMEngineVersion
        AVSignature   = $status.AntivirusSignatureVersion
        ASR_RulesConfigured = if ($pref) { $pref.AttackSurfaceReductionRules_Ids.Count } else { 0 }
        Exclusions = if ($pref) { [PSCustomObject]@{ Path=$pref.ExclusionPath; Process=$pref.ExclusionProcess; Extension=$pref.ExclusionExtension } } else { $null }
    }
}

function Get-ASRRules {
    <#
      .SYNOPSIS List Attack Surface Reduction (ASR) rules and actions.
      .NOTES Actions: 0=Off, 1=Block, 2=Audit, 6=Warn
    #>
    $pref = try { Get-MpPreference } catch { $null }
    if (-not $pref -or -not $pref.AttackSurfaceReductionRules_Ids) { Write-Warn "No ASR rules configured."; return }
    $map = @{}
    for ($i=0; $i -lt $pref.AttackSurfaceReductionRules_Ids.Count; $i++) {
        $id = $pref.AttackSurfaceReductionRules_Ids[$i]
        $act = $pref.AttackSurfaceReductionRules_Actions[$i]
        $map[$id] = switch ($act) { 0 {'Off'} 1 {'Block'} 2 {'Audit'} 6 {'Warn'} default { "Unknown($act)" } }
    }
    $map.GetEnumerator() | ForEach-Object { [PSCustomObject]@{ RuleId=$_.Key; Action=$_.Value } }
}

function Get-UACStatus {
    <#
      .SYNOPSIS Show UAC and secure desktop settings.
    #>
    $p = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    $o = Get-ItemProperty -Path $p -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        EnableLUA = $o.EnableLUA
        ConsentPromptBehaviorAdmin = $o.ConsentPromptBehaviorAdmin
        PromptOnSecureDesktop = $o.PromptOnSecureDesktop
    }
}

function Get-InstalledHotFixes { Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object HotFixID, Description, InstalledOn }

function Get-SecureBootStatus {
    <#
      .SYNOPSIS Check Secure Boot state (UEFI only).
    #>
    try { [PSCustomObject]@{ SecureBootEnabled = (Confirm-SecureBootUEFI) } }
    catch { Write-Warn "Secure Boot check not supported (legacy BIOS or permission)." }
}

function Get-DeviceGuardStatus {
    <#
      .SYNOPSIS Device Guard / Credential Guard configuration snapshot.
    #>
    $dg = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard -ErrorAction SilentlyContinue
    if (-not $dg) { Write-Warn "DeviceGuard WMI class not available."; return }
    [PSCustomObject]@{
        SecurityServicesConfigured = $dg.SecurityServicesConfigured
        SecurityServicesRunning    = $dg.SecurityServicesRunning
        VirtualizationBasedSecurityStatus = $dg.VirtualizationBasedSecurityStatus
        CodeIntegrityPolicyEnforcementStatus = $dg.CodeIntegrityPolicyEnforcementStatus
        UserModeCodeIntegrityPolicyEnforcementStatus = $dg.UserModeCodeIntegrityPolicyEnforcementStatus
    }
}

function Get-LsaProtection {
    <#
      .SYNOPSIS Check LSA protection (RunAsPPL).
    #>
    $v = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -ErrorAction SilentlyContinue)
    [PSCustomObject]@{
        RunAsPPL = $v.RunAsPPL
        LsaCfgFlags = $v.LsaCfgFlags
    }
}

function Get-ServicesAuto {
    <#
      .SYNOPSIS List auto-start services with paths.
    #>
    Get-CimInstance Win32_Service | Where-Object { $_.StartMode -like 'Auto*' } |
      Select-Object Name, DisplayName, State, StartMode, StartName, PathName
}

function Get-ScheduledTasks {
    <#
      .SYNOPSIS List scheduled tasks (user tasks emphasized).
    #>
    $tasks = Get-ScheduledTask
    foreach ($t in $tasks) {
        $info = $null
        try { $info = Get-ScheduledTaskInfo -TaskName $t.TaskName -TaskPath $t.TaskPath } catch {}
        [PSCustomObject]@{
            TaskName   = $t.TaskName
            TaskPath   = $t.TaskPath
            Author     = $t.Author
            State      = $t.State
            Triggers   = ($t.Triggers | ForEach-Object { $_.ToString() }) -join '; '
            Action     = (($t.Actions | ForEach-Object { $_.Execute + ' ' + $_.Arguments }) -join '; ').Trim()
            LastRun    = if ($info) { $info.LastRunTime } else { $null }
            NextRun    = if ($info) { $info.NextRunTime } else { $null }
        }
    } | Sort-Object TaskPath, TaskName
}

function Get-WMIEventSubscriptions {
    <#
      .SYNOPSIS List WMI permanent event subscriptions (common persistence location).
      .DESCRIPTION Useful for IR to spot suspicious consumers/bindings.
    #>
    $filters   = Get-CimInstance -Namespace root\subscription -ClassName __EventFilter -ErrorAction SilentlyContinue
    $consumers = @()
    $consumers += Get-CimInstance -Namespace root\subscription -ClassName CommandLineEventConsumer -ErrorAction SilentlyContinue
    $consumers += Get-CimInstance -Namespace root\subscription -ClassName ActiveScriptEventConsumer -ErrorAction SilentlyContinue
    $bindings  = Get-CimInstance -Namespace root\subscription -ClassName __FilterToConsumerBinding -ErrorAction SilentlyContinue

    [PSCustomObject]@{
        Filters   = $filters   | Select-Object Name, Query, CreatorSID, EventNamespace
        Consumers = $consumers | Select-Object Name, @{n='Type';e={$_.CimClass.CimClassName}}, *
        Bindings  = $bindings  | Select-Object Filter, Consumer
    }
}

function Get-ProcessInsight {
    <#
      .SYNOPSIS Enriched running process view (path, company, signature).
    #>
    $procs = Get-Process -ErrorAction SilentlyContinue
    foreach ($p in $procs) {
        $path = $null; $company=$null; $signed=$null; $signer=$null; $start=$null
        try { $path = $p.Path } catch {}
        if ($path -and (Test-Path $path)) {
            try { $company = (Get-Item $path).VersionInfo.CompanyName } catch {}
            try { $sig = Get-AuthenticodeSignature -FilePath $path; $signed = $sig.Status; $signer = $sig.SignerCertificate.Subject } catch {}
        }
        try { $start = $p.StartTime } catch {}
        [PSCustomObject]@{
            Name=$p.ProcessName; Id=$p.Id; CPU=$p.CPU; WS_MB=[math]::Round($p.WorkingSet64/1MB,1); Path=$path
            Company=$company; Signature=$signed; Signer=$signer; StartTime=$start
        }
    } | Sort-Object -Property WS_MB -Descending
}

function Get-UnsignedDrivers {
    <#
      .SYNOPSIS List unsigned PnP drivers.
    #>
    Get-CimInstance Win32_PnPSignedDriver | Where-Object { -not $_.IsSigned } | Select-Object DeviceName, DriverVersion, DriverProviderName, DriverDate, IsSigned
}

#endregion Security Audit & Hardening Snapshot

#region Logging & IR

function Find-Event {
    <#
      .SYNOPSIS Quick filter for event logs.
      .PARAMETER LogName Example: System, Application, Security
      .PARAMETER Id      Optional: event ID (or array)
      .PARAMETER Provider Optional: provider name
      .PARAMETER Since   Optional: hours back (default 24)
    #>
    param(
        [Parameter(Mandatory)][string]$LogName,
        [int[]]$Id,
        [string]$Provider,
        [int]$Since=24
    )
    $filter = @{ LogName=$LogName; StartTime=(Get-Date).AddHours(-$Since) }
    if ($Id) { $filter.Id = $Id }
    if ($Provider) { $filter.ProviderName = $Provider }
    Get-WinEvent -FilterHashtable $filter -ErrorAction SilentlyContinue |
      Select-Object TimeCreated, Id, ProviderName, LevelDisplayName, Message
}

function Export-EventLogs {
    <#
      .SYNOPSIS Export common logs to EVTX files in a folder.
    #>
    param([Parameter(Mandatory)][string]$OutputFolder)
    if (-not (Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder | Out-Null }
    $logs = 'System','Application','Security','Microsoft-Windows-Windows Defender/Operational'
    foreach ($l in $logs) {
        $out = Join-Path $OutputFolder ($l.Replace('/','_') + '.evtx')
        wevtutil epl "$l" "$out"
        Write-OK "Exported: $out"
    }
}

function Collect-IRBaseline {
    <#
      .SYNOPSIS Collect a quick IR baseline and save to JSON.
      .DESCRIPTION Includes OS, processes, open ports, autoruns, services, tasks, local admins, Defender, firewall.
    #>
    param([string]$OutputPath = $(Join-Path $env:USERPROFILE ("IR_Baseline_{0:yyyyMMdd_HHmmss}.json" -f (Get-Date))))
    $data = [ordered]@{}
    $data.OSInfo             = Get-OSInfo
    $data.Hardware           = Get-HardwareInfo
    $data.Processes          = Get-ProcessInsight
    $data.OpenPorts          = List-OpenPorts
    $data.StartupEntries     = (Get-StartupApps)
    $data.AutoServices       = Get-ServicesAuto
    $data.ScheduledTasks     = Get-ScheduledTasks
    $data.LocalAdmins        = Get-LocalAdmins
    $data.DefenderStatus     = Get-DefenderStatus
    $data.FirewallProfiles   = Get-FirewallProfiles
    $data.SMBShareInfo       = Get-SMBShareInfo
    $data.RDPConfig          = Get-RDPConfig
    $data.UnsignedDrivers    = Get-UnsignedDrivers
    $data.WMIEventSubscriptions = Get-WMIEventSubscriptions

    $json = $data | ConvertTo-Json -Depth 6
    Set-Content -Path $OutputPath -Value $json -Encoding UTF8
    Write-OK "Baseline saved: $OutputPath"
    return $OutputPath
}

#endregion Logging & IR

#region File & Folder Management

function Get-DiskUsage {
    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID,
        @{n='Size(GB)';e={[Math]::Round($_.Size/1GB,2)}},
        @{n='Free(GB)';e={[Math]::Round($_.FreeSpace/1GB,2)}},
        @{n='Used(GB)';e={[Math]::Round(($_.Size- $_.FreeSpace)/1GB,2)}},
        VolumeName, FileSystem
}

function Find-LargeFiles {
    param([Parameter(Mandatory)][string]$Path,[int]$Top=30,[int64]$MinSizeMB=0)
    $minBytes = $MinSizeMB * 1MB
    Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
      Where-Object { $_.Length -ge $minBytes } |
      Sort-Object Length -Descending |
      Select-Object -First $Top FullName, @{n='Size(GB)';e={[Math]::Round($_.Length/1GB,3)}}
}

function Find-OldFiles {
    param([Parameter(Mandatory)][string]$Path,[int]$OlderThanDays=180)
    Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
      Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$OlderThanDays) } |
      Select-Object FullName, Length, LastWriteTime
}

function Compare-Folders {
    param([Parameter(Mandatory)][string]$Left,[Parameter(Mandatory)][string]$Right)
    $l = Get-ChildItem -Path $Left -Recurse -File | ForEach-Object {
        [PSCustomObject]@{ Rel = $_.FullName.Substring($Left.TrimEnd('\').Length); Size=$_.Length }
    }
    $r = Get-ChildItem -Path $Right -Recurse -File | ForEach-Object {
        [PSCustomObject]@{ Rel = $_.FullName.Substring($Right.TrimEnd('\').Length); Size=$_.Length }
    }
    Compare-Object -ReferenceObject $l -DifferenceObject $r -Property Rel,Size -PassThru
}

function Sync-Folders {
    <#
      .SYNOPSIS Robocopy sync (safe default: copy, no deletions).
    #>
    param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Destination,[switch]$Mirror,[switch]$VerboseLog)
    if ($Mirror) { if (-not (Confirm-Action -Message "Mirror mode deletes files not present in source. Continue?" )) { return } }
    $args = @($Source, $Destination, '/R:2','/W:2','/NFL','/NDL','/NP','/XO')
    if ($VerboseLog) { $args = @($Source, $Destination, '/R:2','/W:2') }
    if ($Mirror) { $args += '/MIR' } else { $args += '/E' }
    robocopy @args | Out-Host
}

function Compress-ItemZip { param([Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)][string]$DestinationZip) Compress-Archive -Path $Path -DestinationPath $DestinationZip -Force }
function Extract-Zip { param([Parameter(Mandatory)][string]$Zip,[Parameter(Mandatory)][string]$Destination) Expand-Archive -Path $Zip -DestinationPath $Destination -Force }
function Calculate-Hash { param([Parameter(Mandatory)][string]$Path,[ValidateSet('MD5','SHA1','SHA256','SHA384','SHA512')][string]$Algorithm='SHA256') Get-FileHash -Path $Path -Algorithm $Algorithm }

function Search-TextInFiles {
    param([Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)][string]$Pattern,[switch]$CaseSensitive)
    $params = @{ Path=$Path; Pattern=$Pattern; Recurse=$true }
    if ($CaseSensitive) { $params['CaseSensitive'] = $true }
    Select-String @params | Select-Object Path, LineNumber, Line
}

function New-TempFolder {
    $folder = Join-Path $env:TEMP ("tmp_{0:yyyyMMdd_HHmmss}" -f (Get-Date))
    New-Item -ItemType Directory -Path $folder | Out-Null
    Write-OK "Created: $folder"
    return $folder
}

function Open-Path { param([Parameter(Mandatory)][string]$Path) if (Test-Path $Path) { Start-Process explorer.exe "`"$Path`"" } else { Write-Err "Not found: $Path" } }
function Restart-Explorer { Get-Process explorer -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue; Start-Process explorer.exe }
function Clear-TempFiles { param([switch]$Force) $temp = $env:TEMP; if (-not (Confirm-Action -Message "Delete contents of $temp ?" -Force:$Force)) { return }; Get-ChildItem $temp -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue; Write-OK "Temp cleared." }

#endregion File & Folder Management

#region Privacy: Hide / Unhide / Protect (EFS) / Rename Extension

function Hide-ItemSimple {
    <#
      .SYNOPSIS Hide file/folder via Hidden attribute. Optional: also System.
      .NOTES Hiding is not security and will not defeat admin or security tools.
    #>
    param([Parameter(Mandatory,ValueFromPipeline)][string[]]$Path,[switch]$AsSystem)
    process {
        foreach ($p in $Path) {
            if (-not (Test-Path $p)) { Write-Err "Not found: $p"; continue }
            $item = Get-Item $p -Force
            $item.Attributes = $item.Attributes -bor [IO.FileAttributes]::Hidden
            if ($AsSystem) { $item.Attributes = $item.Attributes -bor [IO.FileAttributes]::System }
            Write-OK "Hidden: $p"
        }
    }
}

function Unhide-ItemSimple {
    <#
      .SYNOPSIS Unhide by clearing Hidden/System attributes.
    #>
    param([Parameter(Mandatory,ValueFromPipeline)][string[]]$Path)
    process {
        foreach ($p in $Path) {
            if (-not (Test-Path $p -Force)) { Write-Err "Not found: $p"; continue }
            $item = Get-Item $p -Force
            $item.Attributes = $item.Attributes -band (-bnot [IO.FileAttributes]::Hidden)
            $item.Attributes = $item.Attributes -band (-bnot [IO.FileAttributes]::System)
            Write-OK "Unhidden: $p"
        }
    }
}

function New-HiddenFolder {
    <#
      .SYNOPSIS Create a folder and mark Hidden (optional System).
    #>
    param([Parameter(Mandatory)][string]$Path,[switch]$AsSystem)
    if (Test-Path $Path) { Write-Warn "Already exists: $Path" } else { New-Item -ItemType Directory -Path $Path | Out-Null }
    Hide-ItemSimple -Path $Path -AsSystem:$AsSystem | Out-Null
    return (Get-Item $Path -Force)
}

function Rename-ItemExtension {
    <#
      .SYNOPSIS Change file extension (cosmetic). Does not convert file format.
    #>
    param([Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)][string]$NewExtension)
    if (-not (Test-Path $Path -PathType Leaf)) { throw "File not found: $Path" }
    $new = [IO.Path]::ChangeExtension($Path, $NewExtension.TrimStart('.'))
    Rename-Item -Path $Path -NewName (Split-Path $new -Leaf)
    Write-OK "Renamed to: $new"
    return (Get-Item $new)
}

function Protect-FolderWithEFS {
    <#
      .SYNOPSIS Encrypt a folder using EFS (Encrypting File System).
      .NOTES Accessible by your user. Backup your EFS cert for recovery. Reversible with Unprotect-FolderWithEFS.
    #>
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path $Path)) { throw "Not found: $Path" }
    cipher /E /A "$Path" | Out-Null
    Write-OK "EFS encryption enabled: $Path"
}

function Unprotect-FolderWithEFS {
    <#
      .SYNOPSIS Decrypt a folder previously encrypted with EFS.
    #>
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path $Path -Force)) { throw "Not found: $Path" }
    cipher /D /A "$Path" | Out-Null
    Write-OK "EFS encryption removed: $Path"
}

#endregion Privacy

#region Deleting: Recycle Bin / Permanent / Free-space wipe

function Remove-ItemToRecycleBin {
    <#
      .SYNOPSIS Send files/folders to Recycle Bin (reversible).
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory,ValueFromPipeline)][string[]]$Path,[switch]$Force)
    begin {
        Add-Type -AssemblyName Microsoft.VisualBasic -ErrorAction SilentlyContinue | Out-Null
        $UI = [Microsoft.VisualBasic.FileIO.UIOption]::OnlyErrorDialogs
        $RB = [Microsoft.VisualBasic.FileIO.RecycleOption]::SendToRecycleBin
    }
    process {
        foreach ($p in $Path) {
            if (-not (Test-Path $p -Force)) { Write-Err "Not found: $p"; continue }
            if (-not (Confirm-Action -Message "Recycle: $p ?" -Force:$Force)) { continue }
            if ((Get-Item $p -Force).PSIsContainer) {
                [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($p, $UI, $RB)
            } else {
                [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($p, $UI, $RB)
            }
            Write-OK "Recycled: $p"
        }
    }
}

function Remove-ItemPermanent {
    <#
      .SYNOPSIS Permanently delete files/folders (irreversible).
    #>
    param([Parameter(Mandatory,ValueFromPipeline)][string[]]$Path)
    process {
        foreach ($p in $Path) {
            if (-not (Test-Path $p -Force)) { Write-Err "Not found: $p"; continue }
            $resp = Read-Host "PERMANENTLY delete: $p ? Type DELETE to confirm"
            if ($resp -ne 'DELETE') { Write-Warn "Skipped: $p"; continue }
            Remove-Item -LiteralPath $p -Force -Recurse -ErrorAction SilentlyContinue
            Write-OK "Deleted: $p"
        }
    }
}

function Clear-RecycleBinSafe { param([switch]$Force) if (-not (Confirm-Action -Message "Empty Recycle Bin for all drives?" -Force:$Force)) { return }; Clear-RecycleBin -Force -ErrorAction SilentlyContinue; Write-OK "Recycle Bin emptied." }

function Wipe-FreeSpace {
    <#
      .SYNOPSIS Wipe free space on a drive (cipher /w). Does not delete files.
      .NOTES Time-consuming. Requires Admin.
    #>
    param([Parameter(Mandatory)][ValidatePattern('^[A-Za-z]:$')][string]$DriveLetter)
    Require-Admin
    if (-not (Confirm-Action -Message "Wipe free space on $DriveLetter (time-consuming) ?" )) { return }
    cipher /w:$DriveLetter
}

#endregion Deleting

#region Startup / Autoruns

function Get-StartupApps {
    <#
      .SYNOPSIS Autoruns snapshot: registry Run keys and Startup folders.
    #>
    $paths = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run',
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run',
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce'
    )
    $startupFolders = @(
        "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp",
        "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup"
    )

    $reg = foreach ($p in $paths) {
        if (Test-Path $p) {
            Get-ItemProperty $p | ForEach-Object {
                $_.PSObject.Properties | Where-Object { $_.Name -notin 'PSPath','PSParentPath','PSChildName','PSDrive','PSProvider' } |
                    ForEach-Object { [PSCustomObject]@{ Source=$p; Name=$_.Name; Command=$_.Value } }
            }
        }
    }
    $files = foreach ($f in $startupFolders) {
        if (Test-Path $f) {
            Get-ChildItem $f -ErrorAction SilentlyContinue | Select-Object @{n='Source';e={$f}}, Name, FullName
        }
    }

    [PSCustomObject]@{ Registry = $reg; Folders = $files }
}

#endregion Startup / Autoruns

#region QoL Utilities

function Show-Toolkit {
    <#
      .SYNOPSIS List available toolkit functions by category.
    #>
    $byCat = [ordered]@{
        'System Info & Health' = @(
            'Get-OSInfo','Get-HardwareInfo','Get-TopProcesses',
            'Get-InstalledApps','Run-SFC','Run-DISMRestore','Get-BatteryReport'
        )
        'Networking' = @('Show-IPConfig','Flush-DNS','Renew-IP','List-OpenPorts','Test-NetworkPath','Test-HTTP')
        'Security Audit' = @(
            'Get-LocalAdmins','Get-UserSessions','Get-SMBShareInfo',
            'Get-RDPConfig','Get-FirewallProfiles','Get-DefenderStatus',
            'Get-ASRRules','Get-UACStatus','Get-InstalledHotFixes',
            'Get-SecureBootStatus','Get-DeviceGuardStatus','Get-LsaProtection',
            'Get-ServicesAuto','Get-ScheduledTasks','Get-WMIEventSubscriptions',
            'Get-ProcessInsight','Get-UnsignedDrivers'
        )
        'Logging & IR' = @('Find-Event','Export-EventLogs','Collect-IRBaseline')
        'Files & Folders' = @(
            'Get-DiskUsage','Find-LargeFiles','Find-OldFiles',
            'Compare-Folders','Sync-Folders','Compress-ItemZip',
            'Extract-Zip','Calculate-Hash','Search-TextInFiles',
            'New-TempFolder','Open-Path','Restart-Explorer','Clear-TempFiles'
        )
        'Privacy (Hide/Protect)' = @(
            'Hide-ItemSimple','Unhide-ItemSimple','New-HiddenFolder',
            'Rename-ItemExtension','Protect-FolderWithEFS','Unprotect-FolderWithEFS'
        )
        'Deleting' = @('Remove-ItemToRecycleBin','Remove-ItemPermanent','Clear-RecycleBinSafe','Wipe-FreeSpace')
    }

    Write-Host "`n=== SecAuditToolkit Commands ===`n" -ForegroundColor Green
    foreach ($k in $byCat.Keys) {
        Write-Host "• $k" -ForegroundColor Yellow
        $byCat[$k] | ForEach-Object { Write-Host "   - $_" -ForegroundColor Gray }
        Write-Host ""
    }
    Write-Host "Tip: Get-Help <FunctionName> -Detailed" -ForegroundColor Cyan
}

function Generate-Password {
    param([int]$Length=16,[switch]$NoSymbols)
    $lower='abcdefghijklmnopqrstuvwxyz'; $upper='ABCDEFGHIJKLMNOPQRSTUVWXYZ'; $digits='0123456789'; $symbols='!@#$%^&*()_-+=[]{}:;,.?'
    $chars = $lower + $upper + $digits + ($(if ($NoSymbols) { '' } else { $symbols }))
    -join (1..$Length | ForEach-Object { $chars[(Get-Random -Max $chars.Length)] })
}

function Show-Env { Get-ChildItem Env: | Sort-Object Name }

function Base64-Encode { param([Parameter(Mandatory)][string]$Text) [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Text)) }
function Base64-Decode { param([Parameter(Mandatory)][string]$Base64) [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Base64)) }

#endregion QoL Utilities

# Auto-show toolkit list when executed directly
if ($Host.Name -notlike '*ISE*' -and $MyInvocation.InvocationName -ne '.') {
    Show-Toolkit
}