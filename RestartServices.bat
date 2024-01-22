@echo off
setlocal enabledelayedexpansion

REM Function to log events
set "LogEvent="
for /f "delims=" %%A in ('wmic os get localdatetime ^| find "."') do set datetime=%%A
set "LogEvent=echo !datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2! !datetime:~8,2!:!datetime:~10,2!:!datetime:~12,2! - "

REM Array of service names
set "servicesToRestart=AarSvc_728f4 AdobeARMservice AJRouter"

REM Name of the network adapter
set "adapterName=Wi-Fi"  REM Replace with your actual adapter name

REM Check for Administrator Privileges
whoami /priv | find "SeShutdownPrivilege" >nul
if %errorlevel% neq 0 (
    %LogEvent% "This script requires administrative privileges. Please run as Administrator."
    exit /b 1
)

REM Stop and Start Services
for %%S in (%servicesToRestart%) do (
    net stop "%%S" 2>nul
    net start "%%S" 2>nul
)

REM Disable and Enable Network Adapter
netsh interface set interface name="%adapterName%" admin=disable
timeout /t 5 /nobreak >nul
netsh interface set interface name="%adapterName%" admin=enable

REM Log success
%LogEvent% "Network services and Wi-Fi adapter restarted successfully"

REM Display a message box using PowerShell
powershell -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Network services and Wi-Fi adapter restarted successfully.', 'Script Completed', 'OK', 'Information')}"

REM Provide a message indicating successful execution
echo Script execution completed successfully.

REM Prompt to confirm
set /p "confirmation=Do you want to proceed? (Y/N): "

if /i "%confirmation%" neq "Y" (
    %LogEvent% "Script execution aborted."
    exit /b 0
)
