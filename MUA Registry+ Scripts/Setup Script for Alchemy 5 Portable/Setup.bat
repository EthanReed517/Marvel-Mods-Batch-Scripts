@echo off

echo "%~dp0" | find ";" >nul && goto ErrorPath

set envkey="HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment"
if defined IG_ROOT set "OldDLL=%IG_ROOT:"=%\DLL"
if defined OldDLL set "OldDLL=%OldDLL:\\=\%"
set "NewDLL=%~dp0DLL"

if "%NewDLL%" == "%OldDLL%" (
 choice /m "An identical installation was found. Do you want to unregister Alchemy from this system"
 if ERRORLEVEL 2 Exit 0
 goto Uninstall
)
if defined IG_ROOT (
 choice /m "Alchemy found. Do you want to unregister Alchemy from this system (press N to update the setup instead)"
 if not ERRORLEVEL 2 goto Uninstall
)

:Install
setx IG_ROOT /m "%~dp0
if ERRORLEVEL 1 goto Error
echo "%PATH:"=%" | find /i "%OldDLL%" >nul && call :RemPathVar
call :GetPathVar
echo "%OldPath:"=%" | find /i "%NewDLL%" >nul || call :AddPathVar
choice /c FIN /m "Associate .IGB files with Finalizer (F), Insight Viewer (I) or don't associate/change (N)"
if ERRORLEVEL 3 Exit 0
if ERRORLEVEL 2 ( set "igApp=insight\DX9\insight" ) else ( set "igApp=Finalizer\sgFinalizer" )
FTYPE igb_auto_file="%~dp0ArtistPack\%igApp%.exe" "%%1"
ASSOC .IGB=igb_auto_file
Exit 0

:Uninstall
setx IG_ROOT "" /m
if ERRORLEVEL 1 goto Error
echo "%PATH:"=%" | find /i "%OldDLL%" >nul && call :RemPathVar
REG delete %envkey% /f /v IG_ROOT
FTYPE igb_auto_file=
ASSOC .IGB=
pause
Exit 0

REM [User] is something like "S-1-5-21-xxxxxxxxxx-xxxxxxxxx-xxxxxxxxxx-1001"
REM [HKCU] is either HKEY_USERS\[User] or HKEY_CURRENT_USER   (User key)
REM [HKCR] is [HKCU]\SOFTWARE\Classes, [HKCU]_Classes, or HKEY_CLASSES_ROOT
REM [CS] is HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001 (etc.) or HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet
REM [CV] is [HKCU]\SOFTWARE\Microsoft\Windows\CurrentVersion
REM Partial user key: [CS]\Services\bam\State\UserSettings\[User]

REM File assiociation is not properly removed. To do so, you would have to edit registry directly, which is not so secure in this case.
REM [HKCR]\igb_auto_file                       should be removed with FTYPE
REM (not found in latest test: [HKCR]\.igb)    should be removed with ASSOC
REM (not found in latest test: [HKCR]\SgFinalizer.Document)
REM    (plus: [HKCR]\Applications\insight.exe) > open with
REM    (plus: [HKCR]\Applications\sgFinalizer.exe) > open with
REM [CV]\ApplicationAssociationToasts
REM       igb_auto_file_.igb
REM       (not found in latest test: Applications\insight.exe_.igb and/or Applications\sgFinalizer.exe_.igb)
REM [CV]\Explorer\FileExts\.igb

REM There are multiple other registry entries for Alchemy and Finalizer after registering file association and using the app.
REM [HKCU]\SOFTWARE\Alchemy Finalizer
REM [HKCR]\Local Settings\Software\Microsoft\Windows\Shell\MuiCache
REM       all Alchemy apps are listed here
REM [CV]\Explorer\FeatureUsage\AppSwitched
REM       installer and viewer/finalizer are listed here
REM [CV]\Explorer\FeatureUsage\ShowJumpView
REM       installer and viewer/finalizer are listed here
REM [HKCU]\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\
REM       Compatibility Assistant\Store & Layers: viewer/finalizer comp. settings
REM Code example: REG delete "HKEY_CURRENT_USER\SOFTWARE\Alchemy Finalizer" /f

:AddPathVar
set "NewPath=%OldPath:"=%;%NewDLL%;"
goto RegPathVar
REM Powershell takes way too long, but no prompt
REM when remove not set, when add do set "NDTA= + '%NewDLL%'"
PowerShell "$op = [System.Environment]::GetEnvironmentVariable('PATH', 'machine') -split ';' | ? {$_}; $op | %% {if ($_[1] -ne ':') {EXIT 1}}; $cp = $op | ? {$_ -notmatch ('^' + [regex]::Escape('%NewDLL%') + '\\?') -or $_ -notmatch ('^' + [regex]::Escape('%OldDLL%') + '\\?') }; [System.Environment]::SetEnvironmentVariable('PATH', ($cp%NDTA% -join ';') + ';', 'machine'); $cp | %% {if ($_ -match 'Alchemy.*DLL') {EXIT 2}}; EXIT 0"
if %errorlevel%==2 call :Warnng
if %errorlevel%==1 EXIT

:RemPathVar
set "Equal=%OldDLL%#" & call :fixEqual
set "r=;%ne:~1,-1%"
call :GetPathVar
set "Equal=%OldPath:"=%#" & set "ne=" & call :fixEqual
set "OldPath=%ne:~1,-1%"
call set "NewPath=%%OldPath:%r%=%%"
set "NewPath=%NewPath:?==%"
call :RegPathVar
echo "%NewPath%" | findstr /irc:"Alchemy.*DLL" >nul && call :Warnng
Exit /b
:fixEqual
for /F "tokens=1* delims==" %%a in ("%Equal%") do set "Equal=%%b" & set "ne=%ne%?%%a"
if defined Equal goto fixEqual
Exit /b

:RegPathVar
REG add %envkey% /f /v Path /t REG_SZ /d "%NewPath:;;=;%"
if ERRORLEVEL 1 goto Error
Exit /b

:GetPathVar
for /f "skip=2 tokens=1,2*" %%n in ('REG query %envkey% /v "Path" 2^>nul') do if /i "%%n" == "Path" set "OldPath=%%p"
Exit /b

:Warnng
echo.
echo  An old Alchemy path still exists in the Path variable.
echo  Please remove or update it manually:
echo   Control Panel ^> System ^> Advanced system settings (near bottom) ^> Environment Variables.
echo   Select the "Path" variable (System and/or User) and click on "Edit".
pause
Exit /b

:ErrorPath
echo ERROR: A ^"^;^" was found in the path.
echo Please rename the files and^/or folders,
echo or move Alchemy to a different location, and try again.
echo Unfotunately, the variables to register are malfunctioning with a ^"^;^".
pause
Exit

:Error
endlocal
echo Please run the Setup with administrator rights.
pause