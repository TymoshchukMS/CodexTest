@echo off
rem Create WorkData folder if it does not exist
if not exist "C:\WorkData" (
    mkdir "C:\WorkData"
    echo Created C:\WorkData
)

rem Grant Everyone full control
icacls "C:\WorkData" /grant Everyone:(F) /T /C >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Permissions set for Everyone.
) else (
    echo Failed to set permissions.
)

rem Share folder as WorkData
net share WorkData=C:\WorkData /grant:Everyone,FULL >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Share WorkData created.
) else (
    echo Failed to create share.
)

rem Map drive W: to the local share
net use W: \\%COMPUTERNAME%\WorkData >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Drive W: mapped to \\%COMPUTERNAME%\WorkData.
) else (
    echo Failed to map drive W:.
)

rem Get local IPv4 address (first non-loopback)
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /c:"IPv4"') do (
    for /f "delims= " %%B in ("%%A") do set LOCAL_IP=%%B& goto ip_found
)
:ip_found
if defined LOCAL_IP (
    rem Save IP to shared location on drive L:
    set IP_FILE="L:\00 Storages\ip_master.txt"
    echo %LOCAL_IP% > %IP_FILE%
    if %ERRORLEVEL% EQU 0 (
        echo IP address %LOCAL_IP% written to %IP_FILE%.
    ) else (
        echo Failed to write IP address to %IP_FILE%.
    )
) else (
    echo Could not determine local IP address.
)

pause
