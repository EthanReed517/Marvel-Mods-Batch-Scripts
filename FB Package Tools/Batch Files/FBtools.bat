@echo off

REM -----------------------------------------------------------------------------

REM Settings:

REM What operation should be made? (=extractFB; =buildFB; =buildCFG; =updateCFG; =buildFBnew; =ask; =detect)
set operation=detect
REM Allow all file formats, when dragging&dropping files? (=true; =false)
set allowfext=false
REM Include subfolders (recursive mode)? (yes =true; no =false)
set recursive=false

REM Extract options
REM Use subfolders? (=true; =false)
set subfolder=true
REM Delete PKG files? (=true; =false; =ask)
set deletepkg=false
REM Copy build batch? (=true; =false)
set copybuild=true

REM -----------------------------------------------------------------------------

REM these are automatic settings, don't edit them:
if "%operation%" == "ask" call :opswitcher
set inext=.fb, .cfg, .pkg
if ""=="%temp%" set "temp=%~dp0"
REM Set this to operation line number
set l=8

call :start%operation%
if %allowfext%==true set inext=.*


if not "%~1"=="" goto Args
set "f=%~dp0"
set "fullpath=%f:~0,-1%"
call :isfolder
GOTO End

:Args
if ""=="%args%" call :convCCL args
for %%p in (%args%) do (
 set fullpath=%%~p
 2>nul pushd "%%~p" && call :isfolder || call :isfiles
)
GOTO End

:isfolder
cd /d "%fullpath:"=%"
call :rec%recursive%
for /f "delims=" %%i in ('dir %inext:.=*.% 2^>nul') do (
 set "fullpath=%dp%%%~i"
 call :isfiles
)
EXIT /b
:rectrue
set dircmd=/b /a-d /s
set dp=
EXIT /b
:recfalse
set dircmd=/b /a-d
set "dp=%fullpath%\"
EXIT /b

:isfiles
set "fullpath=%fullpath:"=%"
call :filesetup
if not "%inext%"==".*" echo %xtnsonly%|findstr /eil "%inext:,=%" >nul || EXIT /b
goto %operation%

:convCCL
set "i=%cmdcmdline:"=""%"
set "i=%i:*"" =%"
set "i=%i:~0,-2%"
if ""=="%i%" EXIT /b
:fixQ
if ""=="%i%" call set "i=%%%1%%"
set "i=%i:^=^^%"
set "i=%i:&=^&%"
set "i=%i: =^ ^ %"
set i=%i:""="%
set "i=%i:"=""Q%"
set "i=%i:  ="S"S%"
set "i=%i:^ ^ = %"
set "i=%i:""="%"
set "i=%i:"Q=%"
set %1="%i:"S"S=" "%"
set i=
EXIT /b

:filesetup
for %%i in ("%fullpath%") do (
 set pathonly=%%~dpi
 set pathname=%%~dpni
 set nameonly=%%~ni
 set namextns=%%~nxi
 set xtnsonly=%%~xi
)
set recallcd=
set fixcurrd=
if defined f EXIT /b
if "%pathonly%" == "%~dp0" EXIT /b
set recallcd=cd /d "%cd%"
set fixcurrd=cd /d "%pathonly%"
EXIT /b


:askop
CLS
ECHO.
ECHO %operationtext%
ECHO.
CHOICE /C AS /M "Press 'A' to accept and continue with this process, press 'S' to switch"
IF ERRORLEVEL 2 GOTO opswitcher
IF ERRORLEVEL 1 EXIT /b
:opswitcher
if ""=="%o%" set o=0
call :OPS%o%
set o=%errorlevel%
goto askop
:OPS0
set operation=extractFB
set operationtext=Extract FB packages.
EXIT /b 1
:OPS1
set operation=buildFB
set operationtext=Build/create FB packages from CFG files.
EXIT /b 2
:OPS2
set operation=buildFBnew
set operationtext=Build/create FB packages from CFG files, and ask to add new files.
EXIT /b 3
:OPS3
set operation=buildCFG
set operationtext=Create a CFG from a PKG (decompiled PKGB file with any file extension).
EXIT /b 4
:OPS4
set operation=updateCFG
set operationtext=Update a CFG file (input file) with all new files. CFG can be empty.
EXIT /b 0

:startextractFB
call :checkToolsE fbExtractor
set inext=.fb
EXIT /b
:startbuildFBnew
:startbuildFB
REM create the enter.vbs script. This will automatically hit enter when compiling
set "enter_script=%temp%\enter.vbs"
if not exist "%enter_script%" (
 echo Set WshShell = WScript.CreateObject^("WScript.Shell"^)
 echo WshShell.SendKeys "{ENTER}"
)>"%enter_script%"
call :checkToolsE fbBuilder
:startupdateCFG
set inext=.cfg
EXIT /b
:startbuildCFG
call :checkToolsE cfgBuilder
set inext=.xml, .txt, .pkg
EXIT /b
:startdetect
call :checkTools fb && EXIT /b
call :checkToolsE fbExtractor
call :checkToolsE fbBuilder
EXIT /b
:startRFFB
call :checkToolsE fb
EXIT /b 

:detect
if "%fullpath%"=="%~dp0cfgBuilder_info.cfg" EXIT /b
if /i "%xtnsonly%"==".fb" goto extractFB
if /i "%xtnsonly%"==".json" goto RFFB
if /i "%xtnsonly%"==".cfg" goto buildFB
call :checkToolsE cfgBuilder
if /i "%xtnsonly%"==".pkg" goto buildCFG
call :opswitcher
goto %operation%
EXIT /b

:RFFB
if /i "%xtnsonly%"==".fb" goto RFFBD
set ext=.fb
if /i "%pathname:~-3%"==".fb" set ext=
%fb% "%fullpath%" "%pathname%%ext%" || goto Errors
EXIT /b
:RFFBD
%fb% -d "%fullpath%" "%pathname%.xml" || goto Errors
EXIT /b

:extractFB
if defined fb goto RFFBD
if %deletepkg%==ask choice /m "Do you want to create PKG files" & if errorlevel 2 (set deletepkg=true) else set deletepkg=false
%fbExtractor% "%fullpath%"
if %deletepkg%==true del "%fullpath%.pkg" /f /q
if %subfolder%==false EXIT /b
mkdir "%pathname%"
for %%f in (actors, automaps, conversations, data, dialogs, effects, hud, maps, models, motionpaths, movies, packages, scripts, shaders, skybox, sounds, subtitles, textures, ui) do @move "%pathonly%%%f" "%pathname%" & rmdir /s /q "%pathonly%%%f"
REM for /f %%f in ('dir /b "%pathonly%"') do echo %%~xf|findstr /vile ".fb .bat .exe .cfg" && move /y "%pathonly%%%~f" "%pathname%"
move /y "%pathonly%__combined.igb" "%pathname%\"
move /y "%pathonly%%namextns%.pkg" "%pathname%\"
move /y "%pathonly%%namextns%.cfg" "%pathname%\"
del "%pathonly%on"
del "%pathonly%off"
if %copybuild%==false EXIT /b
(
 echo @echo off
 echo set operation=buildFBnew
 more +%l% "%~f0"
)>"%pathname%\buildFB.bat"
if exist "%~dp0fbBuilder.exe" ( copy /y "%~dp0fbBuilder.exe" "%pathname%"
) else for /f "delims=" %%a in ('where fbBuilder 2^>nul') do copy /y "%%~fa" "%pathname%"
EXIT /b

:buildFBnew
choice /m "Did you add new files, in addition to the ones that extracted from '%nameonly%'"
if not errorlevel 2 call :updateCFG
:buildFB
if defined fb goto RFFB
%fixcurrd%
wscript "%enter_script%"
echo %namextns% | %fbBuilder%
move /y "%fullpath%.fb" "%pathname%"
%recallcd%
EXIT /b

:updateCFG
set dircmd=/b
for /f %%a in ('dir /ad /b "%pathonly%"') do for /f "delims=" %%i in ('dir /a-d /b /s "%%~a"') do set "fi=%%~dpni" & call :writeNewFiles %%~xi %%~ni
(for /f "usebackq tokens=1-3" %%b in ("%fullpath%") do if exist "%pathonly%%%b" echo %%b %%c %%d)>"%temp%\%nameonly%.tmp"
move /y "%temp%\%nameonly%.tmp" "%fullpath%"
EXIT /b
:writeNewFiles
call set "fi=%%fi:%pathonly%=%%"
set "fe=%fi:\=/%%1"
find /i "%fe%" "%fullpath%" >nul && EXIT /b
for /f "tokens=1,2 delims=\" %%d in ("%fi%") do if "%%d"=="data" (set dir=%%e) else set dir=%%d
set r=xml eng fre ger ita spa rus pol
set e=%1
echo %1|findstr /ile ".%r: = .% .%r: =b .%b" >nul && set e=.xmlb
call :%dir%%e% %2 && goto toCFG
if /i "%e%"==".xmlb" set format=xml_resident & goto toCFG
call :checkCBI
for /f "usebackq tokens=1 skip=2" %%c in (`find "%e:.=%" "%cfgpath%cfgBuilder_info.cfg"`) do set "format=%%c" & goto toCFG
:toCFG
echo %fe% %fe% %format%>>"%fullpath%"
EXIT /b
:actors.igb
for /f "delims=0123456789" %%i in ("%1") do set "format=actoranimdb" & EXIT /b
set format=actorskin
EXIT /b 0
:textures.igb
set format=texture
EXIT /b 0
:conversations.xmlb
:npcstat.xmlb
:weapons.xmlb
:entities.xmlb
set format=xml
EXIT /b 0
:talents.xmlb
set format=xml_talents
EXIT /b 0
:powerstyles.xmlb
:fightstyles.xmlb
set format=fightstyle
EXIT /b 0
:effects.xmlb
set format=effect
EXIT /b 0
:maps.xmlb
set format=zonexml
EXIT /b 0
:motionpaths.igb
set format=motionpath
EXIT /b 0
:shared_powerups.xmlb
set format=%dir%
EXIT /b 0
REM cfgBuilder_info makes them shared_powerups
REM :common_ents.xml
REM :item_ents.xmlb
REM :shared_nodes.xmlb
REM :shared_nodes_combat.xmlb
REM :aipatterns.xml

:buildCFG
call :checkCBI
cd /d "%cfgpath%"
move /y "%fullpath%" "%cd%\%namextns%"
%cfgBuilder% %namextns%
move "%cd%\%namextns%" "%fullpath%"
move /y "%cd%\%namextns%.cfg" "%pathname%.cfg"
%recallcd%
EXIT /b
:checkCBI
if exist "%~dp0cfgBuilder_info.cfg" set "cfgpath=%~dp0" & EXIT /b
call :checkToolsE cfgBuilder
for %%c in (%cfgBuilder%) do if exist "%%~dpccfgBuilder_info.cfg" set "cfgpath=%%~dpc" & EXIT /b
echo cfgBuilder_info.cfg not found.
goto Errors


:checkTools program
if exist "%~dp0%1.exe" set %1="%~dp0%1.exe"
if not defined %1 for /f "delims=" %%a in ('where %1 2^>nul') do set %1=%1
if defined %1 EXIT /b 0
if /i [%1]==[FB] goto checkFB
EXIT /b 1
:checkFB
if defined %1 EXIT /b 0
REM No .exe standalone existing, currently.
REM if exist "%~dp0json2xmlb.exe" set %1="%~dp0json2xmlb.exe" & EXIT /b 0
:checkPython
for /f "delims=" %%a in ('where py 2^>nul') do (
 for /f "delims=" %%b in ('where zsnd 2^>nul') do goto setRF
 for /f "delims=" %%c in ('pip --version 2^>nul') do goto instRF
)
EXIT /b 1
echo Python is not correctly installed. Check the Readme.
goto Errors
:instRF
pip install --ignore-installed raven-formats || EXIT /b
:setRF
set fb=fb
EXIT /b 0
:checkToolsE program
call :checkTools %1 && EXIT /b
echo "%1.exe" not found.
goto Errors


:Errors
echo.
echo There was an error in the process. Check the error description.
pause
:End
EXIT