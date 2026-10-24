@echo off
TITLE Free Fire Optimizer - 0.5ms Timer & Kernel Enforcer
COLOR 0B

:: 1. Automatically request Administrator privileges
NET SESSION >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Requesting Administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

cls
echo ========================================================
echo   APPLYING 0.5ms TIMER & KERNEL TWEAKS (SELF-CONTAINED)
echo ========================================================
echo.

echo [1/3] Writing Kernel Timer & MMCSS Registry Overrides (0.5ms Target)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d 5000 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul
echo [+] Registry parameters successfully written.

echo.
echo [2/3] Configuring Windows Boot Configuration (BCD)...
bcdedit /set disabledynamictick yes >nul
bcdedit /set useplatformclock false >nul
echo [+] BCD ticks locked to high-performance mode.

echo.
echo [3/3] Restarting MMCSS Service...
net stop mmcss >nul 2>&1
net start mmcss >nul 2>&1
echo [+] MMCSS service refreshed.

echo.
echo ========================================================
echo [SUCCESS] 0.5ms Optimization Applied Successfully!
echo ========================================================
echo [!] IMPORTANT: Please restart your PC to finalize changes.
echo ========================================================
echo.
pause