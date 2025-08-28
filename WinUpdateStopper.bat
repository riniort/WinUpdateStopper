@echo off
title WinUpdateStopper (by Rindokuso)

:: -------- Admin check & auto-elevate --------
net session >nul 2>&1
if not %errorlevel%==0 (
  echo [!] This tool requires Administrator rights.
  echo     It will relaunch itself with elevation now...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

:: -------- Menu loop --------
:menu
cls
echo ================================
echo  Windows Update Control (W11)
echo  Service Enable/Disable
echo ================================
echo.
:: Show current state
sc query wuauserv | findstr /I "RUNNING STOPPED" >nul
if %errorlevel%==0 (
  for /f "tokens=1,3" %%a in ('sc query wuauserv ^| findstr /I "STATE"') do set "WU_STATE=%%b"
) else (
  set "WU_STATE=UNKNOWN"
)
echo Current Windows Update service state: %WU_STATE%
echo.
echo [0] Turn OFF Windows Update (disable service)
echo [1] Turn ON  Windows Update (enable and start)
echo [S] Open Services (services.msc) to check manually
echo [Q] Quit
echo.
set "choice="
set /p choice=Type 0 / 1 / S / Q then press Enter: 

if /I "%choice%"=="0" goto off
if /I "%choice%"=="1" goto on
if /I "%choice%"=="S" goto services
if /I "%choice%"=="Q" goto end

echo.
echo Invalid option. Try again.
timeout /t 1 >nul
goto menu

:off
echo.
echo Disabling Windows Update service...
net stop wuauserv >nul 2>&1
sc config wuauserv start= disabled >nul 2>&1
sc query wuauserv | findstr /I "STATE"
echo.
echo Done. Windows Update is now DISABLED (won't start next boot).
echo.
pause
goto menu

:on
echo.
echo Enabling Windows Update service (Manual) and starting it...
sc config wuauserv start= demand >nul 2>&1
net start wuauserv >nul 2>&1
sc query wuauserv | findstr /I "STATE"
echo.
echo Done. Windows Update is now ENABLED.
echo.
pause
goto menu

:services
echo.
echo Opening Services management console...
echo How to check or change manually:
echo   1) Find "Windows Update" in the list.
echo   2) Double-click it.
echo   3) "Startup type":
echo        - Disabled = OFF (blocks updates)
echo        - Manual/Automatic = ON
echo   4) Use the "Start"/"Stop" button to change running state.
echo.
start "" services.msc
pause
goto menu

:end
exit /b
