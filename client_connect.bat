@echo off
setlocal
rem Location of IP file created on the server
set IP_FILE="L:\00 Storages\ip_master.txt"
if not exist %IP_FILE% (
    echo IP file not found: %IP_FILE%
    pause
    exit /b 1
)
for /f "usebackq delims=" %%A in (%IP_FILE%) do set MASTER_IP=%%A
if not defined MASTER_IP (
    echo Failed to read IP from %IP_FILE%
    pause
    exit /b 1
)

rem Map drive W: to the server share
net use W: \\%MASTER_IP%\WorkData /persistent:yes >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Drive W: mapped to \\%MASTER_IP%\WorkData.
) else (
    echo Failed to map drive W:.
)

pause
