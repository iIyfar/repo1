@echo off
:: ###################################################################
:: # Creates a custom URL protocol for a specified application.      #
:: ###################################################################
:: # Author: SHΔDØW WRATH                                            #
:: # Version: 1.0                                                    #
:: ###################################################################

:: --- Check for administrative privileges ---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "%~s0", "runas", "", "" > "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: --- User Input ---
set /p protocolName="Enter the name for your URL protocol (e.g., 'myapp'): "
set /p appPath="Enter the full path to the application's executable (e.g., 'C:\path\to\your\app.exe'): "

:: --- Input Validation ---
if not defined protocolName (
    echo Protocol name cannot be empty. Script aborted.
    pause
    exit
)

if not exist "%appPath%" (
    echo The specified application path does not exist. Script aborted.
    pause
    exit
)

:: --- Create Registry Keys ---
reg add "HKEY_CLASSES_ROOT\%protocolName%" /v "" /t REG_SZ /d "URL:%protocolName% Protocol" /f
reg add "HKEY_CLASSES_ROOT\%protocolName%" /v "URL Protocol" /t REG_SZ /d "" /f
reg add "HKEY_CLASSES_ROOT\%protocolName%\shell\open\command" /v "" /t REG_SZ /d "\"%appPath%\" \"%1\"" /f

echo.
echo Successfully created URL protocol '%protocolName%' for '%appPath%'.
pause