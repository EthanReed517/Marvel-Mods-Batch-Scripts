@echo off
REM chcp 65001 >nul

REM -----------------------------------------------------------------------------

REM Settings:
REM What to do? (b = backup, r = restore, v = reset to vanilla, u = MUA, x = XML2, a = all settings, s = saves, c = controller settings, d = resolution+display, combinations required)
set o=buas
REM Game names for registry and user settings
set u=Marvel Ultimate Alliance
set x=X-Men Legends 2
REM Registry Keys
set k=HKEY_CURRENT_USER\Software\Activision\
set a=
set c=Controls
set d=Settings\Display
REM Saves location
set s=%USERPROFILE%\Documents\Activision\

REM -----------------------------------------------------------------------------

REM these are automatic settings, don't edit them:
if not defined o EXIT
set dircmd=/b /ad

if [%o%] NEQ [%o:u=%] call :BaR %u%
if [%o%] NEQ [%o:x=%] call :BaR %x%
goto eof

:BaR
set sv=%s%%*\Save
set df=%s%%*\
set kg=%k%%*\
for /f "tokens=1-4 delims=- " %%g in ("%*") do set mx=%%g& set um=%%h& set al=%%i& set to=%%j
set gs=%mx:~,1%%um:~,1%%al:~,1%%to%
echo %*
echo.
if [%o%] NEQ [%o:v=%] goto reset
if [%o%] EQU [%o:b=%] goto restoreBKP

:askname
set /p bpn=Please enter a backup profile name (existing profiles will be replaced): || set bpn=
if "%bpn%"=="" CLS & echo Please enter a name & goto askname
if /i "%bpn%"=="Save" CLS & echo Save can't be used & goto askname
if /i "%bpn%"=="Screenshots" CLS & echo Screenshots can't be used & goto askname

call :BoR B

if [%o%] NEQ [%o:r=%] goto restore
EXIT /b


:BoR [B or R] to set backup or restore
if not exist "%df%%bpn%" mkdir "%df%%bpn%"
for %%r in (a c d) do call :reg %%r %1
for %%s in (save dat) do call :save %%s %1
EXIT /b


:reg
call set p=%%o:%1=%%
if [%o%] EQU [%p%] EXIT /b
call set p=%%%1%%
set fn=
if defined p set fn=%p:*\=%
set rfn="%df%%bpn%\%fn%Backup%gs%.reg"
set rk="%kg%%p%"
goto reg%2
:regB
regedit /e %rfn% %rk%
EXIT /b
:regR
if %1==d call :Resolution
if exist %rfn% %rfn% & copy %rfn% "%sv%"
EXIT /b
:regV
reg delete %rk%
EXIT /b

:save
if [%o%] EQU [%o:s=%] EXIT /b
goto save%2
EXIT /b
:saveB
copy "%sv%\*.%1" "%df%%bpn%"
if %1==dat cd /d "%df%%bpn%" & start .
EXIT /b
:saveR
del "%sv%\*.%1"
copy "%df%%bpn%\*.%1" "%sv%"
EXIT /b
:saveV
del /p "%sv%\*.%1"
EXIT /b


:restoreBKP
if [%o%] EQU [%o:r=%] EXIT
choice /m "Do you want to create a backup profile first"
if not errorlevel 2 goto askname

:restore
REM removed saved profile %bpn%, because it's problematic when it includes delimiters
set fd=dir "%df%" ^| findstr /veil "Screenshots Save"
CLS
echo %*
echo.
setlocal enabledelayedexpansion
for /f "delims=" %%f in ('%fd:|=^|%') do (
 set /a i+=1
 if !i! LEQ 9 (
  echo !i!. %%f
  set p[!i!]=%%f
  set ch=!ch!!i!
  set /a m+=1
 )
)
set /a m+=1
echo 0. More
echo.
choice /c %ch%0 /m "Choose a profile to restore"
if errorlevel %m% (call :askP) else set bpn=!p[%errorlevel%]!

del /q "%sv%\*"
call :BoR R

EXIT /b

:askP
CLS
%fd%
echo.
set /p bpn=Enter or paste a profile from above: 
for /f "delims=" %%p in ('%fd:|=^|% ^| find /i "%bpn%"') do set "bpn=%%p" & EXIT /b
echo Profile not found.
set n=-1
:switchP
call :sP %n%
CLS
%fd%
echo.
echo Chosen profile: %bpn%
echo.
choice /c SA /m "Press 'A' to accept and continue with this profile, press 'S' to switch"
if errorlevel 2 EXIT /b
goto switchP
:sP
set /a n+=1
set z=skip=%n% 
if %n% EQU %i% set n=0
if %n% EQU 0 set z=
for /f "%z%delims=" %%p in ('%fd:|=^|%') do set "bpn=%%p" & EXIT /b
EXIT /b

:reset
call :BoR V
CLS
if [%o%] NEQ [%o:r=%] goto restoreBKP
if [%o%] NEQ [%o:b=%] goto askname
EXIT


:Resolution
set vrMUA=1920x1080 1680x1050 1280x1024 1280x720 1024x768
set vrXML2=1920x1080 1680x1050 1600x900 1440x900 1440x576 1440x480 1400x1050 1366x768 1360x768 1280x1024
call set validRes=%%vr%gs%%%
set invalidResMUA=640x480 800x600
for %%c in (%validRes%) do set /a ch+=1
:switcher
set /a x+=1
call :findInString validRes %x% resolution
if %x% GEQ %ch% set x=0
CLS
ECHO.
ECHO %resolution%
ECHO.
CHOICE /C AS /M "Press 'A' to accept this resolution, press 'S' to switch"
IF ERRORLEVEL 2 goto switcher

if exist %rfn% goto regPS
(call :regRes)>%rfn%
EXIT /b

:regRes
echo Windows Registry Editor Version 5.00
echo.
echo [%rk%]
echo "Resolution"="%resolution%"
goto BaR

:regPS
PowerShell "(Get-Content -Path %rfn:"='%) -replace '.Resolution.=.*', '\"Resolution\"=\"%resolution%\"' | Set-Content -Path %rfn:"='%"
EXIT /b

:findInString var token outVar
if "%~3" == "" (set outVar=%~1) else set outVar=%~3
call set "search=%%%~1%%"
for /f "tokens=%2" %%s in ("%search%") do set %outVar%=%%s
EXIT /b
