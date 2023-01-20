@echo off
for %%p in (%*) do EXIT

REM -----------------------------------------------------------------------------

REM Settings:

REM What operation should be made? (create language template =decLanguage; build translation =compLanguage; patch =patchEXE; patch MUA's resolution =resolution; choose each time =ask)
set operation=ask
REM Path to MUA, or a MUA MO2 mod folder? (detect: "MUApath=")
set "MUApath="
REM Path to Game.exe (when using a mod folder)?
set "GamePath="
REM Language? (must be a valid 3 letter language, eg. =rus)
REM valid languages are defined in build.ini
set language=

REM Translation Helper Settings:
REM Copy assets from specified folder? (yes, use from MUApath =true; no, use from Translation Helper =false)
set assetssrc=false
REM Path to a mod folder for engb file updates (eg. OCP)? (ask: "OCPpath=")
set "OCPpath="
REM Set the decompile/convert format: (JSON =json; true XML =xml; NBA2kStuff's XML =lxml)
set decformat=json
REM Rename the decompiled extension to below? (enter the extension, eg.: =txt; don't rename: customext=)
set customext=
REM Delete decompiled files? (yes =true; no =false)
set deletedec=false

REM EXE Patcher Settings:
REM What should be patched? (language =lang; Human Torch effect =fxHT; Ghost Rider effect =fxGR)
set patch-OP=lang
REM effect location? (must be a valid 2 digit menulocation, eg. =02)
set fxmenloc=24

REM Resolution Patcher Settings:
REM Define default Resolution:
set resolution=1920x1080
REM Game (XML2 or MUA):
set GameCode=MUA

REM -----------------------------------------------------------------------------

REM these are automatic settings, don't edit them:
set rf=xml eng fre ger ita pol rus spa pkg boy chr nav %language%
call :start%operation%
if ""=="%temp%" set "temp=%~dp0"
set "tem=%temp%\%operation%.tmp"
set "rfo=%temp%\RFoutput.log"
set "xco=%temp%\XCoutput.log"
set "erl=%~dp0error.log"
set MUA=Marvel Ultimate Alliance
set XML2=X-Men Legends 2
call set Game=%%%GameCode%%%
del "%erl%" "%xco%" "%rfo%" "%tem%"
CLS
goto %operation%

:ask
CHOICE /C CDFPR /M "[D]ecompile English, [C]ompile to %language%b (build translation), [F]ake Translation, [P]atch Game.exe, Patch [R]esolution"
IF ERRORLEVEL 5 GOTO resolution
IF ERRORLEVEL 4 SET operation=patchEXE& GOTO patchEXE
IF ERRORLEVEL 3 GOTO fakeTranslation
call :xml
IF ERRORLEVEL 2 GOTO decLanguage
set decformat=json
IF ERRORLEVEL 1 GOTO compLanguage
EXIT /b

:startcompLanguage
set decformat=json
:startdecLanguage
:xml
if not defined decformat call :cFormat
set xm=xmlb&if "%decformat%" == "lxml" set xm=xmlb-compile
call :checkTools %xm% && EXIT /b
echo %xm% not found. Check the Readme.
goto Errors

:cFormat
CLS
ECHO (J) JSON format with Raven-Formats by nikita488
ECHO (L) Legacy format with xmlb-compile by NBA2kStuff
ECHO (X) True XML format with Raven-Formats by nikita488
ECHO.
CHOICE /C JXL /M "Which format do you want to use"
IF ERRORLEVEL 1 SET decformat=json
IF ERRORLEVEL 2 SET decformat=xml
IF ERRORLEVEL 3 SET decformat=lxml& SET customext=txt
EXIT /b

:definePath
if "%MUApath%"=="" call :readOHS
if "%MUApath%"=="" set /p MUApath=No installation path defined. Please paste or type the path here: 
call :checkPath || set MUApath=.
if "%MUApath%"=="" set MUApath=.
set "MUApath=%MUApath:\\=\%"
if not exist "%MUApath%\data" echo WARNING: "%MUApath%\data" does not exist. Please create this folder, before running OHS. & pause
if not defined GamePath set "GamePath=%MUApath%\Game.exe"
EXIT /b
:readOHS
if exist herostat.cfg call :readOldHS && EXIT /b
if exist %GameCode%\config.ini
for /f "tokens=1* delims=:, " %%o in ('type %GameCode%\config.ini ^| find """gameInstallPath"": "') do for %%m in (%%p) do set MUApath=%%~m
:checkPath
if exist "%MUApath%\data\herostat.engb" EXIT /b 0
EXIT /b 1
:readOldHS
set /p dp=<herostat.cfg
set "MUApath=%dp:~,-8%"
goto checkPath

:fakeTranslation
call :getAssets
for /r "MUA_%lang%_Translation\" %%l in (*.itab, *.engb) do ren "%%~l" "%%~nl.%language%b"
goto activateLanguage

:decLanguage
call :getAssets
CLS
echo Decompiling . . .
for /r "MUA_%lang%_Translation\" %%i in (*.itab, *.engb) do (
 set "fullpath=%%~fi"
 call :filesetup
 call :RUNxmlb .%decformat% "" -d
)

:activateLanguage
call :checkAssets build.ini || goto IGCT
(PowerShell "$b = gc '%fullpath%'; $b[14] = 'AllowedTextLanguages = eng,%language%'; $b[18] = 'DefaultTextLanguage = %language%'; $b")>"%fullpath%"

:IGCT
call :checkAssets igct.bnx || goto patchEXE
if /i %language% NEQ eng ren "%fullpath%" igct%language%.bnx
if "%inl%" == "ita" goto End

:patchEXE
if "%language%"=="" call :askLanguage
call :check%operation% || call :checkAssets Game.exe || echo Game.exe not found || goto Errors
if "%patch-OP%"=="lang" call :hexEdit 3997B8 %language%
if "%patch-OP%"=="fxHT" call :hexEdit 3CC67B %fxmenloc%
if "%patch-OP%"=="fxGR" call :hexEdit 3CC687 %fxmenloc%
goto End
:checkpatchEXE
call :definePath
if exist "%GamePath%" EXIT /b 0
EXIT /b 1
:hexEdit startOffset string
(call :hexEditScript %1 "%~2")>"%tem%.ps1"
Powershell -executionpolicy remotesigned -File "%tem%.ps1"
del "%tem%.ps1"
CLS
ECHO Game.exe updated.
EXIT /b
:hexEditScript
echo $bytes  = [System.IO.File]::ReadAllBytes("%GamePath%");
echo $s = "%~2";
echo $s = $s.ToCharArray();
echo $o = 0;
echo $offset = 0x%1;
echo Foreach ($char in $s) {
echo     $c = [System.String]::Format("{0:X}", [System.Convert]::ToUInt32($char));
echo     $bytes[$offset+$o] = "0x" + $c;
echo     $o++
echo };
echo [System.IO.File]::WriteAllBytes("%GamePath%", $bytes)
EXIT /b

:getAssets
if "%language%"=="" call :askLanguage
set inl=eng
set lang=%language:ita=Italian%
set lang=%language:fre=French%
set lang=%language:ger=German%
set lang=%language:spa=Spanish%
set lang=%language:pol=Polish%
set lang=%language:rus=Russian%
if "%lang:~3%"=="" set lang=Custom
if %language%==ita set inl=ita
set "src=%inl% translation"
if %assetssrc%==true call :definePath & set "src=%MUApath%\*.%inl%b"
xcopy "%src%" "MUA_%lang%_Translation" /s /d /i /exclude:exclude_leftover.txt
if "%OCPpath%"=="" set /p "OCPpath=Enter/paste a mod folder (eg. OCP) to update the .engb files (press enter to skip): " || EXIT /b
xcopy "%OCPpath%\*.engb" "MUA_%lang%_Translation" /s /d /i
for /r "MUA_%lang%_Translation\" %%i in (*.itab) do if exist "%%~dpni.engb" del "%%i"
EXIT /b
:copyAllAssets
call :definePath
robocopy "%MUApath% " "MUA_%lang%_Translation" *.engb /s
EXIT /b

:checkAssets
set "fullpath=%~dp0MUA_%lang%_Translation\%~1"
if "%~1"=="Game.exe" set "GamePath=%fullpath%"
if not exist "%fullpath%" if exist "%MUApath%\%~1" ( copy "%MUApath%\%~1" "%fullpath%"
) else EXIT /b 1
EXIT /b 0

:askLanguage
CLS
ECHO (I) Italian
ECHO (F) French
ECHO (G) German
ECHO (S) Spanish
ECHO (P) Polish
ECHO (R) Russian
ECHO (O) Other
ECHO.
CHOICE /C IFGSPRO /M "Which language do you want to translate"
IF ERRORLEVEL 7 goto custLanguage
IF ERRORLEVEL 1 SET language=ita
IF ERRORLEVEL 2 SET language=fre
IF ERRORLEVEL 3 SET language=ger
IF ERRORLEVEL 4 SET language=spa
IF ERRORLEVEL 5 SET language=pol
IF ERRORLEVEL 6 SET language=rus
EXIT /b

:custLanguage
echo.
set /p language=Specify a language code (must be three letters and lowercase, eg. ptb): 
if "%language:~2%" NEQ "" if "%language:~3%"=="" EXIT /b
echo Invalid input
goto custLanguage

:compLanguage
for /d %%f in (MUA_*_Translation) do call :compiler %%~nf
goto End

:compiler
set lang=%*
set "lang=%lang:~4,-12%"
set ext=%lang:Italian=itab%
set ext=%lang:French=freb%
set ext=%lang:German=gerb%
set ext=%lang:Spanish=spab%
set ext=%lang:Polish=polb%
set ext=%lang:Russian=rusb%
CLS
CHOICE /C LE /M "Do you want to use .engb [E] or .%ext% [L] extensions for the %lang% translation"
IF ERRORLEVEL 2 SET ext=engb
set extALL=%ext%
set operation=compile
CLS
echo Compiling . . .
for /r "%*\" %%i in (*.txt, *.xml, *.json) do (
 set fullpath=%%~fi
 call :filesetup
 call :compile
)
set delx=*.txt, *.xml, *.json, *.bak
if %ext% NEQ engb set delx=%delx%, *.engb
CHOICE /M "Do you want to delete all %delx% files for the %lang% translation"
IF ERRORLEVEL 2 EXIT /b
for /r "%*\" %%r in (%delx%) do del /q "%%~fr"
for /r "%*\" %%d in (.) do rd /q "%%~d"
EXIT /b

:resolution
set vrMUA=1024x768 1280x720 1280x1024 1680x1050 1920x1080
set vrXML2=1920x1080 1680x1050 1600x900 1440x900 1440x576 1440x480 1400x1050 1366x768 1360x768 1280x1024
call set validRes=%%vr%GameCode%%%
set invalidResMUA1=640x480 800x600
for %%c in (%validRes%) do set /a c+=1
:switcher
set /a x+=1
call :findInString validRes %x% resolution
if %x% GEQ %c% set x=0
CLS
ECHO.
ECHO %resolution%
ECHO.
CHOICE /C AS /M "Press 'A' to accept the resolution, press 'S' to switch"
IF ERRORLEVEL 2 goto switcher

set rfn=MUA_resolution
set key=HKEY_CURRENT_USER\SOFTWARE\Activision\%Game%\Settings\Display
set property="Resolution"="%resolution%"

:writeRegistry
call :writeRegFile > "%tem%.reg"
"%tem%.reg"
del "%tem%.reg"
goto End

:writeRegFile
echo Windows Registry Editor Version 5.00
echo [%key%]
echo %property%
echo.
EXIT /b

:convert
set XC=%deletedec%
call :checkVersion && goto convertRF
if %decformat%==lxml EXIT /b 0
call :checkExist json
if ""=="%conv%" call :checkConv
%conv% "%fullpath%" 2>"%rfo%"
for /f %%e in ("%rfo%") do if %%~ze GTR 0 call :writerror RF & EXIT /b 1
if %XC%==true del "%fullpath%"
set "fullpath=%pathname%.json"
call :filesetup
set XC=true
set version=json
:convertRF
call :fixExt %version%
if "%operation%"=="compile" EXIT /b 0
if "%decformat%"=="%version%" EXIT /b 0
set "d=%pathname%.%dex%" & call :numberedBKP d
set decformat=xml& call :xml & set decformat=%decformat%
call :RUNxmlb .temp && if %XC%==true del "%fullpath%"
call :xml
set "fullpath=%pathname%.temp"
call :RUNxmlb .%dex% "" -d
del "%fullpath%"
set "fullpath=%d%"
EXIT /b 0
:checkVersion
set /p version=<"%fullpath%"
set "version=%version%"
if "%version:~0,1%" == "<" ( set version=xml
) else if "%version:~0,1%" == "{" ( set version=json
) else EXIT /b 1
EXIT /b 0
:fixExt
if /i "%xtnsonly%" == ".%1" EXIT /b
call :checkExist %1
move /y "%fullpath%" "%pathname%.%1" >nul
set "fullpath=%pathname%.%1"
EXIT /b

:compile
call :convert || EXIT /b
call :setup
call :RUNxmlb .%extension% && if %XC%==true del "%fullpath%"
EXIT /b 0

:decompile
call :RUNxmlb .%dex% "" -d %xtnsonly% || EXIT /b
move /y "%fullpath%.%dex%" "%fullpath%.%customext%" >nul
EXIT /b

:edit
call :decompile
notepad "%fullpath%.%customext%"
move /y "%fullpath%.%customext%" "%fullpath%.%dex%" >nul
call :RUNxmlb %xtnsonly% .%dex% && if %deletedec%==true del "%fullpath%.%dex%" "%fullpath%.bak"
EXIT /b 0

:setup
for %%e in (%rf: =b %b) do if /i ".%%e"=="%nameonly:~-5%" set "extension=%%e" & set "pathname=%pathname:~,-5%" & EXIT /b
if defined extALL set "extension=%extALL%" & EXIT /b
call :Formats
if %x% GTR 1 (
 choice /m "Do you want to compile all remaining input files to %extension%"
 if not ERRORLEVEL 2 set extALL=%extension%
)
EXIT /b
:FDform
ECHO 1. xmlb (default without display text)
ECHO 2. engb (default with English display text)
ECHO 3. pkgb (for files in packages folder only)
ECHO 4. boyb (for map buoys in maps folder only)
ECHO 5. chrb (for map character lists in maps folder only)
ECHO 6. navb (for map navigation files in maps folder only)
ECHO 7. Other Languages
EXIT /b
:FDlang
ECHO 1. freb (for all files with French display text)
ECHO 2. gerb (for all files with German display text)
ECHO 3. itab (for all files with Italian display text)
ECHO 4. polb (for all files with Polish display text)
ECHO 5. rusb (for all files with Russian display text)
ECHO 6. spab (for all files with Spanish display text)
ECHO 7. engb (default with English display text)
EXIT /b
:FD
CLS
CALL :FD%1
ECHO.
CHOICE /C 1234567 /M "Press the number for the format which you want to compile '%nameonly%' into:"
EXIT /b
:Formats
CALL :FD form
IF ERRORLEVEL 1 SET extension=xmlb
IF ERRORLEVEL 2 SET extension=engb
IF ERRORLEVEL 3 SET extension=pkgb
IF ERRORLEVEL 4 SET extension=boyb
IF ERRORLEVEL 5 SET extension=chrb
IF ERRORLEVEL 6 SET extension=navb
IF %ERRORLEVEL% LSS 7 EXIT /b 0
:Languages
CALL :FD lang
IF ERRORLEVEL 1 SET extension=freb
IF ERRORLEVEL 2 SET extension=gerb
IF ERRORLEVEL 3 SET extension=itab
IF ERRORLEVEL 4 SET extension=polb
IF ERRORLEVEL 5 SET extension=rusb
IF ERRORLEVEL 6 SET extension=spab
IF ERRORLEVEL 7 SET extension=engb
EXIT /b 0

:RUNxmlb
%xmlb% %~3 "%fullpath%%~2" "%pathname%%~4%~1" 2>"%rfo%" 1>"%xco%"
if %errorlevel% GTR 0 call :writerror & EXIT /b 1
if "%decformat%%~3" == "lxml-d" move /y "%xco%" "%pathname%%~4%~1"
EXIT /b 0

:writerror
set errfile=
for /f "skip=2 delims=" %%e in ('find /i "error" "%rfo%" 2^>nul') do set "msg=%%e" & call :writeMsg>>"%erl%"
if "%1" == "RF" EXIT /b
for /f "delims=" %%e in ('type "%xco%"') do set "msg=%%e" & call :writeMsg>>"%erl%"
EXIT /b
:writeMsg
if ""=="%errfile%" echo "%fullpath%"
set "errfile=%nameonly%"
echo  %msg:&=^&%
EXIT /b


:filesetup
for %%i in ("%fullpath%") do (
 set pathonly=%%~dpi
 set pathname=%%~dpni
 set nameonly=%%~ni
 set namextns=%%~nxi
 set xtnsonly=%%~xi
)
EXIT /b

:findInString var token outVar
if "%~3" == "" (set outVar=%~1) else set outVar=%~3
call set "search=%%%~1%%"
for /f "tokens=%2" %%s in ("%search%") do set %outVar%=%%s
EXIT /b

:checkTools program
if exist "%~dp0%1.exe" set %1="%~dp0%1.exe"
if not defined %1 for /f "delims=" %%a in ('where %1 2^>nul') do set %1=%1
echo %1 | find /i "XMLB" >nul && goto check%decformat%
if defined %1 EXIT /b 0
EXIT /b 1
:checklxml
if not defined %1 EXIT /b 1
call set "xmlb=%%%1%% -s"
set dex=%customext%
EXIT /b 0
:checkxml
:checkjson
set dex=%decformat%
if defined %1 EXIT /b 0
if exist "%~dp0json2xmlb.exe" set %1="%~dp0json2xmlb.exe" & EXIT /b 0
:checkPython
for /f "delims=" %%a in ('where py 2^>nul') do (
 for /f "delims=" %%b in ('where zsnd 2^>nul') do goto setRF
 PATH | find "Programs\Python\Python" >nul && goto instRF
)
echo Python is not correctly installed. Check the Readme.
goto Errors
:instRF
pip install --ignore-installed raven-formats
:setRF
set xmlb=xmlb
set Zsnd=Zsnd
EXIT /b 0
:checkConv
call :checkTools py
if exist "%~dp0xml2json.exe" set conv="%~dp0xml2json.exe"
if defined py if exist "%~dp0converter.py" set conv=py "%~dp0converter.py"
if not defined conv echo Converter not found. Check the Readme.>>"%erl%"
EXIT /b

:checkExist extension
set "numBKP=%pathname%.%1" 
:numberedBKP filename as var numBKP
if not exist "%numBKP%" EXIT /b 0
for /l %%n in (0,1,999) do if not exist "%numBKP%.%%n.bak" copy "%numBKP%" "%numBKP%.%%n.bak" & EXIT /b 0
EXIT /b


:End
call :%operation%Post
CLS
if not exist "%erl%" goto cleanup
:Errors
echo.
echo There was an error in the process. Check the error description.
if exist "%erl%" (
 echo.
 type "%erl%"
)
pause
:cleanup
del "%xco%" "%rfo%" "%tem%"
EXIT


:: OCP mods (include):
\conversations\act1\atlantis\atlantis1\1_atlantis1_042.engb
\conversations\act1\atlantis\atlantis5\1_atlantis5_030.engb
\conversations\act1\heli\heli1\1_heli1_010.engb
\conversations\act1\heli\heli2\1_heli2_010.engb
\conversations\act1\heli\heli2\1_heli2_020a.engb
\conversations\act1\heli\heli3\1_heli3_026.engb
\conversations\act2\murder\murder1\2_murder2_010.engb
\conversations\act2\murder\murder2\2_murder2_030.engb
\conversations\act2\murder\murder2\2_murder2_050.engb
1_heli3_030_dlc.engb
1_heli4_022_dlc.engb
1_omega3_092_dlc.engb
2_mephisto1_012_dlc.engb
2_mephisto2_211_dlc.engb
2_mephisto3_030m.engb
2_mephisto3_050m.engb
2_mephisto3_053m.engb
2_mephisto3_055m.engb
2_mephisto3_060m.engb
2_mephisto4_020_dlc.engb
2_mephisto4_022m.engb
2_mephisto4_029.engb
2_murder2_012.engb
2_murder2_014.engb
2_murder2_014_dlc.engb
2_murder2_070m.engb
2_murder2_072_dlc.engb
2_murder2_072_nc_dlc.engb
2_murder3_012_dlc.engb
2_murder3_032_dlc.engb
2_murder5_012_dlc.engb
2_strange1_060m.engb
2_strange1_260m.engb
3_niffleheim2_042_dlc.engb
3_valhalla1_036.engb
3_valhalla1_040m.engb
4_shiar2_072_dlc.engb
4_shiar5_052_dlc.engb
5_doom2_036_dlc.engb
5_doom3_050_dlc.engb
5_doom5_114_dlc.engb
 \conversations\sim\captainmarvel\
epilogue.engb
intro.engb
villain.engb
 \conversations\sim\hawkeye\
epilogue.engb
intro.engb
villain.engb
 \conversations\sim\hulk\
epilogue.engb
intro.engb
 \conversations\sim\moonknight\
epilogue.engb
intro.engb
villain.engb
 \conversations\sim\ronin\
epilogue.engb
intro.engb
villain.engb
 \conversations\sim\silversurfer\
epilogue.engb
intro.engb
villain.engb
 \conversations\sim\vvblackwidow\
epilogue.engb
intro.engb
villain.engb
 \data\powerstyles\
ps_beast.engb
ps_bishop.engb
ps_blackwidow.engb
ps_cable.engb
ps_cannonball.engb
ps_captainmarvel.engb
ps_colossus.engb
ps_cyclops.engb
ps_darkphoenix.engb
ps_doomdlc.engb
ps_frost.engb
ps_gambit.engb
ps_hawkeye.engb
ps_hulk.engb
ps_jubilee.engb
ps_juggernaut.engb
ps_magma.engb
ps_magneto.engb
ps_moonknight.engb
ps_nightcrawlerdlc.engb
ps_phoenix.engb
ps_professorx.engb
ps_psylocke.engb
ps_pyro_hero.engb
ps_rogue.engb
ps_ronin.engb
ps_sabretooth.engb
ps_scarletwitch.engb
ps_sunfire.engb
ps_toad.engb
ps_venom.engb
ps_xman.engb
 \data\talents\
beast.engb
bishop.engb
blackwidowv.engb
cable.engb
cannonball.engb
captainmarvel.engb
colossus.engb
cyclops.engb
darkphoenix.engb
doomdlc.engb
emma_frost_hero.engb
gambit.engb
hawkeye.engb
hulk.engb
jubilee.engb
juggernaut_hero.engb
magma.engb
magneto.engb
moonknight.engb
nightcrawlerdlc.engb
phoenix.engb
professorx.engb
psylocke_hero.engb
pyro_hero.engb
rogue.engb
ronin.engb
sabretooth.engb
scarletwitch.engb
sunfire.engb
toad_hero.engb
venom.engb
xman.engb