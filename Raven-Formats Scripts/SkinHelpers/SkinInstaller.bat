@echo off
REM chcp 65001 >nul

REM -----------------------------------------------------------------------------

REM Settings:

REM What operation should be made? (=decompile; =compile; =edit; =convert; =ask; =detect)
REM (Operations for Zsnd: =extract; =combine; =update; =editZSSZSM; =editJSON; add sound files =addWAV; convert WAV files for old versions of Zsnd =convertW; convert multi-channel sounds =ravenAudio)
REM (Operations that use Raven-Formats: =PackageCloner; =ModCloner; =Herostat-Skin-Editor; =SkinsHelper)
REM (Alchemy operations used by other operations: =genGColorFix; =SkinEditFN)
set operation=SkinsHelper
REM Set the decompile/convert format: (JSON =json; true XML =xml; NBA2kStuff's XML =lxml)
set decformat=json
REM Rename the decompiled extension to below? (enter the extension, eg.: =txt; don't rename: customext=)
set customext=
REM Allow all file formats, when dragging&dropping files? (yes =true; no =false)
set allowfext=false
REM Always compile to this format if the format couldn't be detected (eg. =xmlb)
set extALL=
REM Delete decompiled files? (yes =true; no =false)
set deletedec=false
REM For which platform? (for PC =PC; for PS2 =PS2; for original Xbox =Xbox; XML2 for GameCube =GC; for PSP =PSP; MUA for Wii =Wii; MUA for Xbox360 =360; MUA for PS3 =PS3; MUA RE for PC =Steam; MUA RE for Xbox One =X1; MUA RE for PS4 =PS4)
set ForPltfrm=PC
REM Ask before backing up existing files? (yes =true; no =false; always replace, not safe! =replace)
set askbackup=false
REM Include subfolders (recursive mode)? (yes =true; no =false)
set recursive=false
REM Path to MUA, or a MUA MO2 mod folder, or OpenHeroSelect? (for herostat names)
set "MUAOHSpath="

REM Zsnd settings:
REM Location of portable Zsnd? (folder where zsnd.py/zsnd.exe and hashes.json are in)
set "zsndp=%~dp0zsnd"
REM Use portable Zsnd? (Yes =true; No =false) (Still used for conversion)
set usezsnd=false
REM Extract to the input folder? (yes, extract at same location as file, doesn't work for portable Zsnd =true; no, extract to where Zsound.bat is =false; can be a path ending with \ as well)
set outfile=true

REM addWAV and modify JSON Settings:
REM Specify a JSON file to add the sounds to. This is useful for x_voice for example.
set "oldjson="
REM Automatically combine to ZSS/ZSM at the end? (Yes =true; No =false)
set combine=false
REM For the new file: Do you want to be asked for a new name? (ask, even if a JSON has been found or selected =true; ask, always create new json =new; auto name if JSON exists =false; update if JSON exists =update; take the name of the input folder instead of the JSON, behaves like false =folder; always take the folder name, will never ask =forcefolder)
REM For other Zsnd operations, it will take the names of ZSS/ZSM or JSON files respectively.
set askname=false
REM Define a specific subfolder to move WAV files into. Only for x_voice.
set subfolder=
REM Move? (move to the folder next to the JSON, as defined =destination; use the source file - when conv. move the files back and make a backup of the unconverted files =source; when conv. move the files back to the source and replace the unconverted files =replace)
REM WARNING for destination: Avoid identical names if dropping files from multiple sources.
set movewhr=destination
REM Remove the header of WAV files? (only useful for old versions of Zsnd).
REM (no, my portable Zsnd is new =false; yes, default, converts all WAVs =true)
set remHead=false
REM Read sample-reate, and flags, in addition to the hash in the source JSON? (yes =true; no, read hash only =false; no, don't read hash either =never)
set asample=never
REM Ask for a new hash? (yes =true; automatically generate a custom hash, eg. =REPLACE_THIS_HASH; automatically generate hash with filename =file; automatically genereate with CHAR/[jsonname]/[filename] =char)
set askhash=char
REM Uppercase hashes? (all uppercase =ToUpper; all lowercase =ToLower)
set hshcase=ToUpper
REM Choose a sample_index number? (Yes =true; No, add at end =false; Yes, same for all =all)
set chIndex=all
REM Define a minimum index number (default =0; allow all minindx=)
set minindx=0
REM Save configurations to file? (Yes =true; No =false; Yes and don't update json =only)
set savecfg=false
REM Pre-define sample information (leave undefined to get prompted):
REM Sample rate PSP/PS2 standard =11025; all other standard =22050; music standard =41000; =44100
set sr=
REM Channels =1; =2; =4
set channels=
REM Loop =true; =false
set loop=
REM Hash flags =31; =255 (Currently unknow what it does. Leave it 31 or 255.)
set flgh=31

REM PackageCloner settings:
REM New package number(s)? (a number eg. =12-14; =ask; ask once only =all)
set newPKGn=ask
REM Clone existing NC packages, when not among input files? (no, clone from combat instead =false; yes =true; no, only clone combat, ignore NC =never)
REM Also sets behaviour if no NC package exists. (clone from combat =false; don't create =true or =never)
set cloneNC=true

REM SkinsHelper settings:
REM Edit herostats to add or (re)name a skin? (yes =true; no =false)
set EditStat=true
REM For XML2 or MUA? (XML2 =XML2; MUA =MUA)
set EditGame=MUA
REM Type to install? (mannequin =mannequin; skin =skin, NPC skin =npc) (Make separate batch file)
set InstType=skin

REM -----------------------------------------------------------------------------

REM these are automatic settings, don't edit them:
set x=0
set inext=.txt, .xml, .json
set rf=xml eng fre ger ita pol rus spa pkg boy chr nav
if ""=="%temp%" set "temp=%~dp0"
set "tem=%temp%\%operation%.tmp"
set "rfo=%temp%\RFoutput.log"
set "xco=%temp%\XCoutput.log"
set optSet="%temp%\%operation%.ini"
set optSetT="%temp%\%operation%T.ini"
set "erl=%~dp0error.log"
set igTF=IG_GFX_TEXTURE_FORMAT_
if ""=="%customext%" set customext=%decformat:lxml=xml%
if "%operation%" == "ask" call :askop
if defined sr if defined channels if defined loop set predefined=true
REM Powershell commands
set PSout=[System.IO.File]::WriteAllLines($varp, $var, (New-Object System.Text.UTF8Encoding $False))
set PSbkp=$var ^| %% {if (Test-Path $_) {$b = $_; $i = 1; while ($true) {if (Test-Path $b) {$b = $_ + '.' + $i + '.bak'; $i++} else {Break}}; copy $_ $b}}
if %askbackup%==replace set PSbkp=$null
REM Zsnd formats:
set unk=Unknown (information required, contact ak2yny if you know more)
set .wav=PC 106 WAV 16bit
set .xbadpcm=XBOX 1 XBADPCM: Xbox, %unk%
set .xma=XENO 1 XMA: Xbox 360, %unk%
set .vag=PS2 0 VAG 16bit (WAV converted with FPacker or MFAudio)
set .dsp=GCUB 0 DSP 16bit (Nintendo Gamecube DSPADPCM for GC and Wii)

call :%ForPltfrm%Setup
REM There is an issue with this call on some machines. This comment should fix that.

call :start%operation% %~1
del "%erl%" "%xco%" "%rfo%" "%tem%" "%tem%c" "%tem%m" "%cvd%.json" "%cvd%.zss" %optSetT%
if %allowfext%==true set inext=.*
CLS
if defined zsnd call :ZSTitle

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
if "%inext%"==".n/a" goto %operation%
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
call :%operation%
set any=true
EXIT /b

:convCCL
set "i=%cmdcmdline:"=""%"
set "i=%i:*"" =%"
set "i=%i:~0,-2%"
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
 set infile=%%~fi
)
EXIT /b
:VAR
set "b=%fullpath%"
call set "fullpath=%%%2%%"
call :filesetup
call :%1
set "fullpath=%b%"
call :filesetup
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
set operation=decompile
set operationtext=Decompile.
EXIT /b 1
:OPS1
set operation=compile
set operationtext=Compile.
EXIT /b 2
:OPS2
set operation=edit
set operationtext=Decompile, edit with Notepad, and compile.
EXIT /b 3
:OPS3
set operation=convert
set operationtext=Convert between JSON, XML, and NBA2kStuff's XML formats.
EXIT /b 4
:OPS4
set operation=extract
set operationtext=Extract sound files from ZSS/ZSM files, and create a JSON file with informations.
EXIT /b 5
:OPS5
set operation=combine
set operationtext=Combine sound files to ZSS/ZSM according to a JSON file.
EXIT /b 6
:OPS6
set operation=editJSON
set operationtext=Edit sample indexes in JSON files.
EXIT /b 7
:OPS7
set operation=addWAV
set operationtext=Add WAV, XMA, XBADPCM, VAG, or DSP files to a JSON file, according to settings. Then, optionally combine them to ZSS/ZSM.
EXIT /b 8
:OPS8
set operation=convertW
set operationtext=Convert WAV files for old, portable versions of Zsnd (convert/remove header).
EXIT /b 9
:OPS9
set operation=PackageCloner
set operationtext=Clone package files for other skins of the same character.
EXIT /b 10
:OPS10
set operation=ModCloner
set operationtext=Rename the number of a mod, to fix clashes with another mod. Must be used on a mod folder that's not in the game files. Alchemy 5 recommended.
EXIT /b 11
:OPS11
set operation=Herostat-Skin-Editor
set operationtext=Modify the in game skin information throught the herostat.
EXIT /b 12
:OPS12
set operation=SkinsHelper
set operationtext=Add skins with HUDs to the game or mod folder.
EXIT /b 0

:PCSetup
call :platW .wav
set ConsGen=PC
EXIT /b
:WiiSetup
if %EditGame%==XML2 goto PlatEr
call :platW .dsp
set t=PSP _X_
set z=600000
set ConsGen=Wii
EXIT /b
:PSPSetup
call :platW .vag
set t=GAMECUBE DXT
set z=300000
set ConsGen=PSP
EXIT /b
:GCSetup
if %EditGame%==MUA goto PlatEr
call :platW .dsp
set t=PSP
goto 6Setup
:XboxSetup
call :platW .xbadpcm
goto 6Setup
:PS2Setup
set t=PSP GAMECUBE DXT
call :platW .vag
:6Setup
set z=300000
set ConsGen=6th
EXIT /b
:PS3Setup
call :platW .vag
set t=PSP GAMECUBE _X_
set ConsGen=7th
goto 7Setup
:360Setup
call :platW .xma
set ConsGen=7th
goto 7Setup
:SteamSetup
:X1Setup
:PS4Setup
set t=PSP GAMECUBE _X_
set ConsGen=8th
:7Setup
if %EditGame%==XML2 goto PlatEr
EXIT /b
:PlatEr
echo No support for %EditGame% on %ForPltfrm%.
goto Errors

:starteditZSSZSM
:startextract
set inext=.zss, .zsm
goto czs
:startaddWAV
set inext=.wav, .xma, .xbadpcm, .vag, .dsp
goto conW
:startconvertW
set inext=.wav
:conW
if %askname%==new set oldjson=
set "cvd=%~dp0converted"
for /f %%c in ('dir /b "%cvd%\" 2^>nul') do goto conW2
goto czs
:conW2
set /a n+=1
if exist "%cvd%.%n%" goto conW2
set "cvd=%cvd%.%n%"
set n=0
goto czs
:startravenAudio
set inext=.wav
call :checkTools ravenAudio
EXIT /b
:startupdate
set inext=.wav, .xma, .xbadpcm, .vag, .dsp
call :checkPlat
set movewhr=%movewhr:destination=source%
set askname=update
set recursive=true
goto czs
:startcombine
set inext=.json
:czs
if %ConsGen%==8th echo Zsnd doesn't support the Remastered version of MUA. & goto Errors
call :pZScheck
TITLE Zsnd
call set "outfile=%%outfile:false=%~dp0%%"
set "outfile=%outfile:true=%"
set "tem=%temp%\zsnd.tmp"
call :defineJSON
for %%i in ("%*") do (
 set "zcn=%%~fi"
 if /i "%%~xi"==".txt" goto ZsndLoad
 for %%e in (.zss, .zsm) do if /i "%%~xi"=="%%e" if /i not %operation%==editZSSZSM set operation=extract& set inext=.zss, .zsm
 if /i "%%~xi"==".json" set operation=combine& set inext=.json
)
EXIT /b
:pZScheck
if %remHead%%usezsnd%==falsefalse goto :nZS
if exist "%zsndp%\zsnd.py" call :checkTools py && set zspe=py "%zsndp%\zsnd.py"
if exist "%zsndp%\zsnd.exe" set zspe="%zsndp%\zsnd.exe"
if [%zspe%]==[] set remHead=false& goto :nZS
if %usezsnd%==false goto :nZS
set Zsnd=%zspe%
set "outfile=%outfile:true=false%"
EXIT /b
:nZS
call :checkTools zsnd || call :checkPython
EXIT /b
:startZsndPreConfig
set inext=.txt
goto czs
:starteditJSON
set inext=.json
EXIT /b
:startPackageCloner
set "tpc=%temp%\MUApkgbNames.tmp"
del "%tpc%"
set inext=.pkgb
set minindx=0
set maxindx=99
goto xml
:startModCloner
set minindx=0
set maxindx=255
del "%erl%" "%xco%" "%rfo%" "%tem%"
set inext=.n/a
goto xml
:startHerostat-Skin-Editor
set inext=.%rf: =b, .%b, .xml, .txt, .json
set minindx=0
set maxindx=99
EXIT /b
:startSkinsHelper
set inext=.igb
set minindx=0
set maxindx=255
EXIT /b
:startedit
:startdecompile
set inext=.%rf: =b, .%b
:startdetect
:startcompile
:xml
set xm=xmlb&if %decformat%==lxml set xm=xmlb-compile
call :checkTools %xm% && EXIT /b
if not "%1"=="" EXIT /b 1
echo %xm% not found. Check the Readme.
goto Errors
:startSkinEditFN
:startgenGColorFix
set inext=.igb
:sgO
call :checkAlchemy sgOptimizer && EXIT /b 0
if not "%1"=="" EXIT /b 1
echo "%IG_ROOT%\bin\sgOptimizer.exe" must exist. Please check your Alchemy 5 installation.
goto Errors

:detect
for %%e in (.txt, .xml, .json) do if /i "%xtnsonly%" == "%%e" goto compile
for %%e in (.%rf: =b, .%b) do if /i "%xtnsonly%" == "%%e" goto decompile
for %%e in (.wav, .xma, .xbadpcm, .vag, .dsp) do if /i "%xtnsonly%" == "%%e" goto addWAV
for %%e in (.zss, .zsm) do if /i "%xtnsonly%" == "%%e" goto extract
for %%e in (.json) do if /i "%xtnsonly%" == "%%e" goto combine
EXIT /b

:convert
set XC=%deletedec%
call :checkVersion fullpath && goto convertRF
if %decformat%==lxml EXIT /b 0
call :checkExist json
if ""=="%conv%" call :checkConv
%conv% "%fullpath%" 2>"%rfo%" || call :writerror RF || EXIT /b
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
call set "v=%%%1%%"
set /p version=<"%v%"
set "version=%version%"
if "%version:~,1%" == "<" ( set version=xml
) else if "%version:~0,1%" == "{" ( set version=json
) else if "%version:~3,1%" == "<" ( set version=xml
) else if "%version:~3,1%" == "{" ( set version=json
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
 if not errorlevel 2 set extALL=%extension%
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
for /f "delims=" %%e in ('findstr /i "error Errno" ^<"%rfo%" 2^>nul') do set "msg=%%e" & call :writeMsg>>"%erl%"
if "%1" == "RF" EXIT /b 1
for /f "delims=" %%e in ('type "%xco%"') do set "msg=%%e" & call :writeMsg>>"%erl%"
EXIT /b 1
:writeMsg
if ""=="%errfile%" echo "%fullpath%"
set "errfile=%nameonly%"
echo  %msg:&=^&%
EXIT /b

:PCTitle
CLS
echo --------------------
echo    Package Cloner
echo --------------------
echo.
EXIT /b
:PackageCloner
call :readNumber || EXIT /b
findstr /eil "%pkgnm%.pkgb %pkgnm%_nc.pkgb" <"%tpc%" >nul 2>nul || set /a x+=1
for %%a in ("%fullpath%") do echo %%~a>>"%tpc%"
EXIT /b
:PackageClonerPost
call :srcNum
set rPKG=findstr /eil "%pkgn%.pkgb %pkgn%_nc.pkgb" ^<"%tpc%"
for /f "delims=" %%c in ('%rPKG:<=^<% 2^>nul ^| find /c /v ""') do set m=%%c
for /f "delims=" %%p in ('%rPKG:<=^<% 2^>nul') do (
 set "fullpath=%%~fp"
 call :filesetup
 call :clonePKG
)
del "%tpc%"
EXIT /b

:srcNum
if %x% LEQ 1 set pkgn=& EXIT /b
call :PCTitle
for /f "usebackq delims=" %%p in ("%tpc%") do echo %%~np
echo.
echo Multiple packages found. Please select one by entering the number, or press enter to clone them all.
echo The package you want to clone needs to exist and the numbers inside need to match the number in the filename!
echo.
if "%pkgn%"=="na" (echo Package not found. Try again.) else (echo.)
set /p pkgn=Enter the number of the package to clone: || set pkgn=
findstr /eil "%pkgn%.pkgb %pkgn%_nc.pkgb" <"%tpc%" >nul 2>nul && EXIT /b
set pkgn=na
goto srcNum

:clonePKG
call :readNumber || EXIT /b
REM To only clone one number even if they are named differently, use %pkgn%
echo %cmplt% | find "-%pkgnm%%NC%-" && EXIT /b
set cmplt=%cmplt%-%pkgnm%%NC%-
set "i=%newPKGn%"
if "%i%"=="all" set i=
if "%i%"=="ask" set i=
call :PCTitle
echo Clone "%namextns%". Press enter to skip.
call :AskIrange %i% || EXIT /b
if "%newPKGn%"=="all" set "newPKGn=%i%"
call :askpkg
REM CMD path variables
set "NCpkg=%pathname%_nc.pkgb"
set "ps=%fullpath%.%customext%"
set "nps=%NCpkg%.%customext%"
REM PS variables
REM PS package number regex: (?=_\d+(?!.*_\d))
set e=$e = '        }','','    }','','}'
if %decformat%==lxml set e=%e%; $e = $e[2..4]
if %decformat%==xml set "e=$e = '</packagedef>'"
set r=-replace '%pkgn%',$nn
set "psc=$x = '%NC%.pkgb'; $pn = '%pathonly%%pkgnm:~,-2%'; $ps = gc -raw '%ps%'"
set "pcr=gc '%tem%' | %% {$cn = $_.PadLeft(2,'0'); $nn = '%pkgn:~,-2%' + $cn; $pc = $pn + $cn + $x; $ncc =  $pn + $cn + '_nc' + $x; $pp=$ncp = '%tem%.%dex%'; $nc = $null; if ($nn -eq '%pkgn%') {if ($e) {$nc = $psn}} else {if ($psn) {$nc = $psn %r%}; $p = $ps %r%; %PSbkp:var=pc%; %PSout:var=p%; %xmlb% $pp $pc}; if ($nc) {%PSbkp:var=ncc%; %PSout:var=nc%; %xmlb% $pp $ncc}}"
set pcn=$null
call :numberedBKP ps
call :decompile
if ""=="%NC%" findstr /eilc:"%NCpkg%" <"%tpc%" >nul 2>nul || call :NCcheck %cloneNC%
Powershell "%psc%; %pcn:"=""%; %pcr%" || goto Errors
if %deletedec%==true del "%ps%" "%nps%"
EXIT /b
:NCcheck
call :NC%1
if %errorlevel%==1 EXIT /b
call :numberedBKP nps
if %1==true call :VAR decompile NCpkg
EXIT /b 0
:NCtrue
if not exist "%NCpkg%" EXIT /b 1
set "pcn=$psn = gc -raw '%nps%'"
EXIT /b 0
:NCfalse
set "pcn=%e%; $psn = ($ps -split '(?<=hud_head_%pkgn%.*\r?\n)')[0] + ($e -join ""`n"")"
EXIT /b 2

:readNumber
set NC=
for /f "tokens=2" %%s in ("%nameonly%") do EXIT /b 1
set "pkgnm=%nameonly%"
if "%pkgnm:~-3%"=="_nc" set "pkgnm=%pkgnm:~,-3%" & set NC=_nc
set pkgn=%pkgnm:~-5%
set pkgn=%pkgn:_=%
call :isNumber %pkgn% || EXIT /b
EXIT /b 0
:askpkg
if %m% LEQ 1 EXIT /b
if defined newPKGn if not "%newPKGn%"=="ask" EXIT /b
echo.
choice /c NVY /m "Do you want to clone all remaining input packages to '%i%' - [N]o, Ne[v]er, [Y]es"
if errorlevel 2 set m=0
if errorlevel 3 set "newPKGn=%i%"
EXIT /b

:SHTitle
CLS
echo -----------------------------
echo    Skin Installer for %EditGame%
echo -----------------------------
echo.
EXIT /b
:SkinsHelper
set sn=
set nn=
set "ch=%nameonly%"
call :isNumber %ch:&=_% && set nn=n&set sn=%ch%
call :trimmer %ch:&=;;%
set "ch=%trim:;;=&%"
set "ch=%ch:_= %"
call :getSkinInfo
for %%i in ("%fullpath%") do set size=%%~zi
if /i %InstType%==npc set EditStat=false
if %EditStat%==false goto SH3
set maxindx=99
call :SHTitle
call :HSSetup charactername ch %nn% || goto SH3
call :MUApath
if /i %InstType%==mannequin goto Mannequin
call :SkinEditor "%ch%"
call :SHTitle
call :listSkins
echo.
choice /c %SHo% /m "Select a skin to which you want to install '%nameonly%'"
call set ns=%%skin_0%errorlevel%:~-2%%
set sn=%cn%%ns%
call :PSparseHS name set in charactername match ch
:SkinsHelper2
mkdir "%MUApath%\actors" "%MUApath%\hud" 2>nul
set "ts=%MUApath%\actors\%sn%.igb"
set "sh=%pathonly%hud_head_%namextns%"
set "th=%MUApath%\hud\hud_head_%sn%.igb"
set "tp=%MUApath%\packages\generated\characters\"
set "s3d=%pathname% (3D Head).igb"
set "t3d=%MUApath%\ui\hud\characters\%sn%.igb"
if exist "%ts%" call set ConsGen=%%ConsGen:PC=%EditGame%%%
call :numberedBKP ts
copy /y "%fullpath%" "%ts%"
if not exist "%sh%" for %%a in ("%pathonly:~,-1%") do set "sh=%%~dpahud\hud_head_%namextns%"
if not exist "%sh%" (
 echo Please paste or enter the full path and filename to the HUD head file, including .igb extension.
 set /p sh=Enter path, or press enter to skip: 
)
call :stripQ sh
if exist "%sh%" call :numberedBKP th & copy /y "%sh%" "%th%"
if /i %EditGame%%InstType%==XML2skin call :SH23dHead
set fullpath=
set a=8
set g=2
call :SHTitle
goto SH4%ConsGen%
:SH48th
:SH4PC SkinsHelper4
if /i %InstType% NEQ skin goto SH4%EditGame%
call :SH4%EditStat% 2>nul
if exist "%tp%%in%_%sn%.pkgb" goto SH4%EditGame%
for /f "delims=" %%p in ('dir /b "%tp%%in%_%cn%*.pkgb"') do set "fullpath=%tp%%%p" & call :xml ne && goto SH4cln
echo INFORMATION: A package file was not detected, and no package was found, which could be cloned, or no compiler found for cloning. Manual herostat and package modifications may be required to make powers and HUD work properly for this skin.
pause
if %ConsGen%==8th goto SH48thS
goto SH4%EditGame%
:SH4false
set in=defaultman
for /f "delims=" %%p in ('dir /b "%tp%*_%cn%*.pkgb"') do set "nameonly=%%~np" & goto SH4p2
goto SH4p3
:SH4p2
call :readNumber || goto SH4p3
set "in=%pkgnm:~,-5%"
if "_"=="%in:~-1%" set "in=%in:~,-1%"
:SH4p3
echo Internal name detected: '%in%'.
set /p "in=Press enter to accept, or enter the internal name here: "
EXIT /b
:SH4cln
call :filesetup
set m=1
set newPKGn=%ns%
call :clonePKG
goto SH4%EditGame%
:SH48thS
REM Not sure if the RE has same specs as 360, but Steam does AFAIK.
:SH47th
if %ForPltfrm%==PS3 ( echo Textures should be in DXT1 format and use green normal maps in DXT 5 format, if any.
) else echo Textures should be in DXT5 format and use blue normal maps, if any.
echo.
set z=100000000
goto ConsSpec
:SH4PSP
goto ConsSpec
:SH4Wii
set g=1
goto ConsSpec
:SH4XML2
set t=
set z=100000000
call :SHTitle
:SH46th
set a=6
set g=1
:ConsSpec
set AV=unknown
for /f usebackq %%v in (`PowerShell "try {$bytes  = [System.IO.File]::ReadAllBytes('%ts%'); '{0:X}' -f $bytes[0x2C]} catch {'unknown'}"`) do set AV=%%v
echo INFORMATION: Make sure the skin and head or mannequin meet all specifications for %ForPltfrm%. Use other tools to make them compatible if necessary.
echo.
set al=OK
set sl=OK
set gl=OK
set tl=OK
if ""=="%a%" set a=8
if ""=="%z%" set z=infinite
if %AV% GTR %a% set al=XX& if %AV% NEQ unknown echo WARNING: The skin is Alchemy version %AV:8=3.5% and not compatible with %ForPltfrm%.
set AV=%AV:4=2.5%
set AV=%AV:6=3.2%
set AV=%AV:8=3.5%
if %size% GTR %z% set sl=XX& echo INFORMATION: The file size is %size% bytes and possibly over the limit.
if "%g%"=="1" echo %igGA%|find "2" >nul && set gl=XX
if ""=="%t%" set t=PSP GAMECUBE
echo %igGTF%|findstr /i "%t%" >nul && set tl=XX
set he=OK
if %a%==6 set he=XX
if /i "%targetName%"=="%sn%" set he=OK
if /i "%targetName%"=="Bip01" set he=XX
if /i %InstType%==mannequin set he=OK&& set targetName=%sn%
echo.
echo Statistics for "%namextns%":
echo [%al%] Alchemy version:  %AV%
echo [%sl%] File size:        %size% bytes
if defined targetName (
echo [%gl%] Geometry formats: %igGA%
  echo [??] Vertex count:     %Gvc%
  echo [OK] Geometry count:   %Gn%
echo [%tl%] Texture formats:  %igGTF:IG_GFX_TEXTURE_FORMAT_=%
  echo [??] Biggest Texture:  %TX%x%TY%
  echo [OK] Texture count:    %Tn%
  echo [OK] Has mip-maps:     %MM%
echo [%he%] igSkin name:      %targetName%
)
pause
REM add possible FB package edits here.
if %a%==6 goto SH5nh
:SH4MUA SkinsHelper5
call :SHTitle
call :sgO ne || goto SH5nh
set "fullpath=%ts%"
call :SkinEditFN gn
REM HUDs are not optimized for now, as they need the texture renamed, not igSkin.
goto SH2f
:SH5nh
if /i "%targetName%"=="%sn%" goto SH2f
echo.
echo INFORMATION: %sn%.igb might not be hex-edited.
pause
:SH2f
if /i %InstType% NEQ skin EXIT /b
call :SH2_%cn% 2>nul
EXIT /b
:SH2_198
echo 198 is Emma Frost's number.
set xsn=Diamond Form
set a=4
if %ns:~-1%==9 set a=1
goto SH2xs
:SH2_13
echo 13 is Human Torch's number.
set xsn=Flame On
set a=10
:SH2xs
echo Please paste or enter the full path and filename to the %xsn% skin for %sn%.igb, including .igb extension.
set /p xs=Enter path, or press enter to skip: || EXIT /b
call :sgO
call :stripQ xs
call :numberedBKP xs
set /a xn=100%ns% %% 100 + %a%
if "%xn:~1%"=="" set xn=0%xn%
set "fullpath=%MUApath%\actors\%cn%%xn%.igb"
copy /y "%xs%" "%fullpath%"
goto SkinEditFN
:SH23dHead
if not exist "%s3d%" (
 echo Please paste or enter the full path and filename to the 3D head file, including .igb extension.
 set /p s3d=Enter path, or press enter to skip: || EXIT /b
)
call :stripQ s3d
mkdir "%MUApath%\ui\hud\characters" 2>nul
call :numberedBKP t3d
copy /y "%s3d%" "%t3d%"
EXIT /b
:SH3
set EditStat=false
call :MUApath
call :SkinsHelper3
if /i %InstType%==mannequin goto Mannequin
goto SkinsHelper2
:SkinsHelper3
if defined sn set cn=%sn:~,-2%& set fn=%sn:~-2%
call :isNumber %fn% || set fn=
call :SHTitle
if ""=="%ch%" set "ch=%nameonly%"
if "%fn%"=="" (
 dir /b "%MUApath%\actors\*.igb" | findstr /ir "^[0-9]*.igb$"
 echo.
 echo "%ch%": No skin number detected. All existing skins are listed above.
)
call :asknum cn "for the character (mod number)"
if "%cn:~1%"=="" set cn=0%cn%
if /i %InstType%==mannequin set sn=%cn%01&EXIT /b
echo|set /p=%cn%XX
if defined fn ( echo , detected: %cn%%fn%
) else echo.
set maxindx=99
call :asknum ns "for the skin"
if "%ns:~1%"=="" set ns=0%ns%
set maxindx=255
set sn=%cn%%ns:~-2%
for /f "delims=" %%i in ('dir /b "%MUApath%\actors\%sn%.igb"') do EXIT /b
choice /m "Skin does not seem to exist. Continue creating a new one"
if errorlevel 2 goto SkinsHelper3
EXIT /b
:MUApath
if defined MUApath EXIT /b
if "%hsFo%"=="" set "MUApath=%MUAOHSpath%"
call :SHTitle
if "%MUApath%"=="" (
 echo Please paste or enter a folder path for the installation of the skins ^(IGB files^).
 echo - Mod Organizer 2 ^(MO2^) users use an MO2 mod folder path.
 echo - Console users use an extracted FB package folder path.
 echo - Other users use the %EditGame% installation folder path.
 set /p MUApath=Enter path: 
)
call :stripQ MUApath
EXIT /b
:Mannequin
if %EditStat%==true call :PSparseHS skin set sn charactername match ch
set mq=mannequin
set mn=01
if %EditGame%==XML2 (
 set mq=characters
 if %sn:~-2% GTR 9 set mn=%sn:~-2%
)
set ts=%MUApath%\ui\models\%mq%\%sn:~,-2%%mn%.igb
mkdir "%MUApath%\ui\models\%mq%" 2>nul
call :numberedBKP ts
copy /y "%fullpath%" "%ts%"
call :SHTitle
goto SH4%ConsGen%

:SkinsHelperPost
call :SHTitle
echo Skin installation successfully completed.
pause

:HSETitle
CLS
echo -----------------------------------
echo    Herostat Skin Editor for %EditGame%
echo -----------------------------------
echo.
if defined h (
 echo "%h%"
 echo.
)
EXIT /b
:Herostat-Skin-Editor
set "h=%fullpath%"
:SkinEditor charactername skinnumber
set pcs=
set "ch=%~1"
set "sn=%~2"
set p=$p = %sn%
if defined sn call :isNumber %sn% && set "ss=^%sn:~,-2%\d\d$" && call :readHsn skin sn && goto SkinEditor2
if "%ch%"=="" ( call :readHS charactername ch || EXIT /b
) else call :HScheck || EXIT /b
set "chr=^%ch%$"
call :PSparseHS skin psc psc charactername match chr
set "p=%psc%; [array]$pa = $p; $p = $pa[0]"
:SkinEditor2
set "psc=%p%; $p = 'skin[\s="":]{2,4}' + -join $p; try {$h = (dir -s  '%h%' | select-string -Pattern $p)[0]} catch {exit 1}; $h.path; "
if %hdf% NEQ xml set "psc=%psc%$s = ((gc $h.path) -replace '\s;$' | select -skip ($h.linenumber-1)) -join ""`n"" -replace '(?!\s*""?skin)\n[\s\S]+'; "
if %hdf%==lxml set "psc=%psc%$s"
if %hdf%==json set "psc=%psc%$s = $s -split '\n'; $s[-1] = $s[-1] -replace '.$'; ('{' + $s + '}' | ConvertFrom-Json).psobject.properties | %% {$_.Name + ' = ' + $_.Value}"
if %hdf%==xml set "psc=%psc%([xml]($h.line -replace '.*(?=skin=)(.*?""? (?!skin_))\w.*','<skins $1 />')).skins.attributes | %% {$_.LocalName + ' = ' + $_.Value}"
REM The \w character in the regex makes sure that only quote-space followed by another attribute is found, and not the end. However, the question mark already makes sure to find the first occurrence of non-skin followed quote-space.
set si=
CLS
echo Reading "%h%" . . .
for /f "usebackq tokens=1* delims=:= " %%r in (`Powershell "%psc:"=""%"`) do set "n=%%r" & set "s=%%s" & call :SE2count && set "h=%%r:%%s"
call :isNumber %skin_01% || set skin_01=
if ""=="%skin_01%" echo "%h%" not correctly formatted. & goto Errors
set cn=%skin_01:~,-2%
set p=%skin_01%
:SkinEditor3
call :HSETitle
echo Modify the skin information below.
echo Press the number of an existing skin to edit it,
echo press an unused number to add a new skin.
echo.
call :listSkins
echo.
choice /c A%options% /m "Press 'A' to accept and continue."
set /a n=%errorlevel%-1
if %n%==0 goto SkinEditor4
set nn=
echo.
echo Skin %n% from %cn% %ch%
call :asknum nn
if %EditGame%==XML2 ( call :SkinAutoNameXML2 %n%
) else set /p skin_0%n%_name=Enter a skin name :               || goto SE3clear
set nn=0%nn%
set skin_0%n%=%nn:~-2%
if defined MUApath goto SkinEditor3
if exist "%MUAOHSpath%\actors\%cn%%nn:~-2%.igb" goto SkinEditor3
echo WARNING: %cn%%nn:~-2%.igb not found. Make sure it's in the game^'s actors folder.
pause
goto SkinEditor3
:SE2count
if "%si%"=="" set si=0& set ns= & EXIT /b 0
if /i "%n:~,4%" NEQ "skin" EXIT /b 1
if %EditGame%==XML2 goto SE2XML2
if defined ns ( set /a si+=1 & set ns=
) else set ns=_name
set "skin_0%si%%ns%=%s%"
EXIT /b 1
:SE2XML2
call :SkinReadXML2 "%n:~5%"
set "skin_0%si%=%s%"
EXIT /b 1
:SkinReadXML2
if "%~1"=="" (set nm=Main) else set nm=%~1
if "%nm%"=="Main" set si=1
if "%nm%"=="astonishing" set si=2
if "%nm%"=="aoa" set si=3
if "%nm%"=="60s" set si=4
if "%nm%"=="70s" set si=5
if "%nm%"=="weaponx" set si=6
if "%nm%"=="future" set si=7
if "%nm%"=="winter" set si=8
if "%nm%"=="civilian" set si=9
set skin_0%si%_name=%nm%
EXIT /b
:SkinAutoNameXML2
if %1==1 set nm=Main
if %1==2 set nm=astonishing
if %1==3 set nm=aoa
if %1==4 set nm=60s
if %1==5 set nm=70s
if %1==6 set nm=weaponx
if %1==7 set nm=future
if %1==8 set nm=winter
if %1==9 set nm=civilian
set skin_0%1_name=%nm%
EXIT /b
:SE3clear
set skin_0%n%=
set skin_0%n%_name=
goto SkinEditor3
:listSkins
set sl=6
if %ConsGen%==6th set sl=4
REM Wii, PSP and PS3 allow 6 skins according to jayglass. 6 are confirmed on the 360.
if %EditGame%==XML2 set sl=9
set o=0
set SHo=
set to=123456789
echo ^#   File       Name
for /l %%n in (1,1,%sl%) do if defined skin_0%%n call echo 0%%n  %cn%%%skin_0%%n:~-2%%.igb  "%%skin_0%%n_name%%" & call :SHo %%n & set o=%%n
if %o% LSS %sl% set /a o+=1
call set options=%%to:~,%o%%%
EXIT /b
:SHo
set SHo=%SHo%%1
EXIT /b
:SkinEditor4
if "%skin_01%"=="" goto SkinEditor3
set skin_01=%cn%%skin_01:~-2%
for /l %%n in (1,1,%sl%) do if defined skin_0%%n call :SE4 %%n
set "psc=$h = gc '%h%'; $m = ($h | select-string -Pattern 'skin[\s="":]{2,4}%p%')[0]; $ind = ($m.line -split '(^\s*)')[1]; $s = $h | select -skip ($m.linenumber-1); try {$e = ($s | select-string -Pattern '^((?!^\s*skin).)*$')[0].linenumber-1} catch {exit 1}"
if %hdf%==lxml set "pcr=$n = New-Object PSObject; %pcs%$s = $n.psobject.properties.name | %% {$ind + $_ + ' = ' + $n.$_ + ' ;'}"
if %hdf%==json set "pcr=$n = New-Object PSObject; %pcs%$s = $n | ConvertTo-Json; $s = $s.substring(3,$s.length-6) + ','"
if %hdf%==xml set "pcr=$n = ([xml]($m.line -replace '.$','/>')); %pcs%($n.stats.Attributes | Sort-Object { $_.Name }) | %% {$n.stats.Attributes.Append($_)}; $s = $n.outerxml -replace '/>$','>'; $e = 1"
set "pco=$h = ($h | select -first ($m.linenumber-1)) + $s + ($h | select -skip ($e+$m.linenumber-1)); $hp = '%h%'; %PSout:var=h%"
CLS
echo Writing new skin information to "%h%" . . .
Powershell "%psc:"=""%; %pcr%; %pco%"
if defined xmlbd call :VAR compile h
EXIT /b
:SE4
set s=skin
if %EditGame%==XML2 goto SE4XML2
if %1 GTR 1 set s=skin_0%1
call :SE4%hdf% skin_0%1 %s%
call :SE4%hdf% skin_0%1_name skin_0%1_name
EXIT /b
:SE4XML2
call :SkinAutoNameXML2 %1
if %1 GTR 1 set s=skin_%nm%
call :SE4%hdf% skin_0%1 %s%
EXIT /b
:SE4lxml
:SE4json
call set "pcs=%pcs%$n | Add-Member NoteProperty %2 '%%%1%%'; "
EXIT /b
:SE4xml
call set "pcs=%pcs%$n.stats.SetAttribute('%2','%%%1%%'); "
EXIT /b

:HScheck
for /f "delims=" %%i in ('dir /b /s "%h%"') do echo %%~xi|findstr /eil ".xml .txt .json" >nul && set "hrs=%%~fi" && goto HScheckD
if [%xmlb%]==[] call :xml ne || goto HScCe
call :VAR decompile h || goto HScheckD
set "h=%h%.%customext%"
set xmlbd=true
set hdf=%decformat%
EXIT /b 0
:HScheckD
set xmlbd=
set hdf=lxml
call :checkVersion hrs
if %errorlevel%==0 set hdf=%version%
EXIT /b 0
:HScCe
echo "%h%" can't be decompiled, %xm% not found.
pause
EXIT /b 1

:readHsn
REM For other uses: If the herostat has 1 char, skin will always be set to variable, regardless of the argument
call :HScheck || EXIT /b
if defined ss call :PSparseHS %1 set %2 skin match ss && EXIT /b
CLS
call :PSparseHS skin print %2 && EXIT /b
set /p ss=Choose a skin number from the list above by entering its number [supports regular expressions]: || EXIT /b
goto readHsn

:MCTitle
CLS
echo ---------------------------------
echo    Character Mod Number Editor
echo ---------------------------------
echo.
EXIT /b
:ModCloner
for /f "delims=" %%h in ('where herostat.txt data\:*.txt data\:herostat.engb .\:*.txt 2^>nul') do set "h=%%~fh" & goto ModClonerH
:MChsError
call :MCTitle
echo No herostat found. Mod re-numbering will be incomplete.
pause
for %%i in (actors\*.igb) do set "ig=%%~ni" & call :isNumber %%~ni || call :MC1af && goto MC1cfm
echo.
echo No skin numbers detected. Please enter the old mod number.
:ModCloner1
call :asknum on
if "%on:~1%"=="" set on=0%on%
set ig=%on:~-3%00
:MC1cfm
set on=%ig:~,-2%
echo.
choice /m "Old mod number: %on%. Confrm"
if errorlevel 2 goto ModCloner1
set h=
set psc=$null
set "pcv=$on = '%on%'; $sn = $on + '*'; $ca = '$'"
:ModCloner2
call :MCTitle
echo Enter a new mod number.
call :asknum nn
if "%nn:~1%"=="" set nn=0%nn%
set nn=%nn:~-3%
REM Setup PowerShell:
set "pcl=$a = '%cd%\actors\'; $l = '%cd%\textures\loading\' + $on + '*.igb'; $m = '%cd%\ui\models\mannequin\' + $on + '01.igb*'; $hu = '%cd%\hud\hud_head_'; $pk = '%cd%\packages\generated\*.pkgb'; $ps = '%cd%\data\powerstyles\' + $p.powerstyle + '.engb'; $xd = '%tem%.%dex%'"
set xd=$xd
REM xmlb-compile prints to temp file %xco%, instead of output file
if %decformat%==lxml set "xd='%xco%'"
REM need to wrap JSON number in double-quotes
if %decformat%==json if %nn% LSS 10 set "rd=-replace'(?<=(skin_filter|filename)[\s="":]{2,4})\s(\d{4,5})',' ""$2""'"
REM pct = Title
set "pct=if ($on -eq '%nn%') {exit 2}; $p.charactername + ': From ' + $on + ' to %nn%'"
REM pcd = Decompile code
set "pcd=| Select-String $on).path | %% {if ($_) {%xmlb% -d $_ $xd 2>>'%erl%' 1>'%xco%'"
REM xdc = Compile code (with replace/rename code)
set "xdc=(gc %xd%) %rd% -replace $rd,'%nn%' | Out-File -encoding ASCII $xd; %xmlb% $xd"
REM f = Rename code for filelist f
set "f=dir $f | ren -NewName {$_.name -replace $r,'%nn%'}"
REM pcr = Main rename code
set "pcr=$r = '^' + $on; $f = ($a + $ca + '.igb*'), ($a + $ca + '_4_combat.igb*'), ($a + $sn + '.igb*'), $l, $m; 2..6 | %% {$x = 'skin_0' + $_; if ($p.$x) {$f += $a + $on + $p.$x + '.igb*'}}; %f%; 'characteranims','skin' | %% {$p.$_ = $p.$_ -replace $r,'%nn%'}"
REM pch = Hud rename code
set "pch=$r = '(?<=^hud_head_)' + $on; [array]$f = $hu + $sn + '.igb*'; 2..6 | %% {$x = 'skin_0' + $_; if ($p.$x) {$f += $hu + $on + $p.$x + '.igb*'}}; %f%"
REM pcp = Package clone/rename code. Old packages are currently not deleted
set "pcp=$r = '(?=' + $on + '\d\d(_nc)?\.pkgb$)' + $on; $rd = '(?<=filename[\s="":]{2,4}(.*\/(hud_head_)?)?)' + $on; (dir -s $pk %pcd%; $xds = ($_ -split '\\'); $xdo = ($xds[0..($xds.length-2)] + ($xds[-1] -replace $r,'%nn%')) -join '\'; %xdc% $xdo}}"
REM pcf = Powerstyle code +
set "pcf=$rd = '(?<=skin_filter[\s="":]{2,4})' + $on; (dir $ps %pcd%; %xdc% $ps; $e = (gc %xd% -raw | Select-String 'ents_') -replace '[\s\S]+filename[\s="":]{2,4}(ents_.*?)(""|\s)[\s\S]+','$1'; if ($e) {$e = '%cd%\data\entities\' + $e + '.xmlb'; (dir $e %pcd%; %xdc% $e}}}}}"
REM pcs = Herostat code
if %hdf%==lxml set "pcs=$l = $p.psobject.properties.name | %% {$_ + ' = ' + $p.$_ + ' ;'}"
if %hdf%==json set "pcs=$l = $p | Select -Property * -ExcludeProperty talent,Multipart,StatEffect,BoltOn | ConvertTo-Json; $l = $l.substring(3,$l.length-6) + ','; "
if %hdf%==xml set "pcs=$l = ($p.outerxml -split '(?=<.*?>)')[1]; "
set "pcs=$r = 'charactername[\s="":]{2,4}' + $p.charactername; try {$hp = (dir -s '%h%' | select-string -Pattern $r)[0].path} catch {exit 3}; $hs = $h -split '\r?\n'; $m = ($hs | select-string -Pattern $r)[0].linenumber; try {$b = ($hs | select -first $m | select-string -Pattern '^\s*""?stats')[-1].linenumber} catch {$b = $m - 1}; try {$e = ($hs | select -skip $b | select-string -Pattern '{$')[0].linenumber-1} catch {$e = 1}; %pcs%; [array]$h = ($hs | select -first $b); $h += $l + ($hs | select -skip ($b+$e)); %PSout:var=h%"
if ""=="%h%" set pcs=$null
call :MCTitle
PowerShell "%psc%; %pcv%; %pct%; %pcl%; %pcr%; %pch%; %pcp:"=""%; %pcf:"=""%; %pcs:"=""%" || goto MC2Error
if defined xmlbd call :VAR compile h
call :sgO
for %%i in (actors\*.igb) do set "fullpath=%%~fi" & call :SkinEditFN
for %%e in ("%erl%") do if %%~ze LSS 8 del %%e
EXIT /b
:ModClonerH
call :readHS charactername ch || goto Errors
call :PSparseHS . psc psc charactername match ch
if %hdf%==lxml set "psc=%psc%; $n = New-Object PSObject; $p.GetEnumerator() | sort -Property name | %% {$n | Add-Member NoteProperty $_.name $_.value}; $p = $n"
set "pcv=[string]$sn = $p.skin; $ca = $p.characteranims; $on = $sn.substring(0,$sn.length-2); if ($on -ne ($ca -replace '_.*')) {exit 1}"
goto ModCloner2
:MC2Error
if errorlevel 3 echo Herostat problem. Skins are not hex-edited and herostat is not updated. & goto Errors
if errorlevel 2 echo Old and new number are identical & goto Errors
echo Skin and animation numbers don't match
goto Errors
EXIT /b
:MC1af
set "ca=%ig:*_=%"
call set "ig=%%ig:%ca%=%%"
set "ig=%ig:~,-1%00"
call :isNumber %ig%
EXIT /b

:SkinEditFN
set optcnt=0
call :filesetup
if "%1"=="" call :getSkinName
if %EditGame%==XML2 if %ConsGen% NEQ PSP goto SH5nh
goto SE%ConsGen%
:SE6th
goto SH5nh
:SEPSP
call :writeOpt optCGA
:SEWii
goto SEmain
:SE7th
:SE8th
call :writeOpt optCGA
:SEPC
if /i %InstType%==mannequin goto SErun
REM For PC choice / m "Do you want to convert to igGeometryAttr2"
REM findstr "igActorInfo" <"%infile%" >nul || call :checkAlchemy animdb2actor && %animdb2actor% "%infile%" "%infile%"
findstr "igGlobalColorStateAttr" <"%infile%" >nul 2>nul || call :writeOpt optGGC
:SEmain
if /i %InstType%==mannequin goto SErun
set "newName=%nameonly%"
if /i "%targetName%"=="%newName%" goto SErun
if /i "%targetName%"=="Bip01" goto SH5nh
call :writeOpt OptRen
(call :OptHead %optcnt% & type %optSetT%)>%optSet%
del %optSetT%
set "outfile=%fullpath%"
:SErun
if %optcnt%==0 EXIT /b
goto Optimizer

:getSkinName
set "igSS=%temp%\igStatisticsSkin.ini"
if not exist "%igSS%" (call :OptHead 1 & call :OptSkinStats 1)>"%igSS%"
( %sgOptimizer% "%fullpath%" "%temp%\temp.igb" "%igSS%" )>"%temp%\%nameonly%.txt"
set targetName=
for /f "tokens=1 delims=| " %%a in ('findstr /ir "ig.*Matrix.*Select" ^<"%temp%\%nameonly%.txt"') do set targetName=%%a
del "%temp%\%nameonly%.txt"
EXIT /b

:getSkinInfo
call :sgO ne || EXIT /b
set "iini=%temp%\SkinInfo.ini"
if not exist "%iini%" (call :OptHead 3 & call :OptTexInfo 1 0x00000117 & call :OptGeoInfo 2 0x00500000 & call :OptSkinStats 3)>%iini%
( %sgOptimizer% "%fullpath%" "%temp%\temp.igb" "%iini%" )>"%temp%\%nameonly%.txt"
set Gn=0
set igGA=
for /f "tokens=3 delims=|" %%g in ('findstr "igGeometryAttr" ^<"%temp%\%nameonly%.txt"') do call :gSIga %%g
set Gvc=0
for /f "tokens=4 delims= " %%v in ('findstr /ilc:" vertex total: " ^<"%temp%\%nameonly%.txt"') do set /a Gvc+=%%v
set Tn=0
set ao=0
set MM=false
for /f "tokens=1-5 delims=|" %%t in ('findstr "%igTF%" ^<"%temp%\%nameonly%.txt"') do call :gSIt %%u %%v %%w %%x
for /f "tokens=1 delims=| " %%a in ('findstr /ir "ig.*Matrix.*Select" ^<"%temp%\%nameonly%.txt"') do set targetName=%%a
del "%temp%\%nameonly%.txt"
EXIT /b
:gSIga
set /a Gn+=1
echo %igGA%|find "%1 " >nul || set igGA=%igGA%%1 
EXIT /b
:gSIt
set /a Tn+=1
set /a an=%1*%2
if %an% GTR %ao% set ao=%an% & set TX=%1&set TY=%2
echo %igGTF%|find "%3 " >nul || set igGTF=%igGTF%%3 
echo %5|find /i "Mip" >nul && set MM=true
EXIT /b

:genGColorFix
set "igGGC=%temp%\igGenerateGlobalColor.ini"
if not exist "%igGGC%" (call :OptHead 1 & call :optGGC 1)>"%igGGC%"
%sgOptimizer% "%fullpath%" "%fullpath%" "%igGGC%"
EXIT /b


:ZSTitle
CLS
echo ---------------------------------
echo   Zsnd editor for ZSM/ZSS files
echo ---------------------------------
echo.
EXIT /b
:askSR
REM Better would be automatic detection, if possible
set chd=%channels:1=(Mono)%
set chd=%chd:2=(Stereo)%
set chd=%chd:4=%
if ""=="%channels%" set chd=
call :ZSTitle
echo Check file requirements for "%fullpath%":
echo %Wformat%
echo.
echo S. Sample rate (frequency): %sr% hz
echo C. Channels:                %channels% %chd%
echo L. Loop:                    %loop%
echo.
echo E. Enter a custom sample rate
echo.
echo Information: Abort, if the input file does not match any option.
echo.
choice /c SCLEAR /m "Press [S,C,L] to switch file details. Press 'A' to accept and continue. Press 'R' to accept for all remaining input files."
goto Wopt%errorlevel%
:Wopt1
call :Wopt sr 22050 41000 44100 32000 11025
goto askSR
:Wopt2
call :Wopt channels 1 2 4
goto askSR
:Wopt3
call :Wopt loop true false
goto askSR
:Wopt4
echo.
set /p sr=Enter a frequenzy (sample rate): || set sr=n
call :isNumber %sr% && goto askSR
echo Only numbers are accepted.
goto Wopt4
:Wopt6
set predefined=true
:Wopt5
set flags=%channels:4=34%
if defined sr if defined channels if defined loop EXIT /b
goto askSR
:Wopt
if ""=="%o%" set o=1
set /a o+=1
for /f "tokens=%o%" %%o in ("%*") do set %1=%%o& Exit /b
set o=1
goto Wopt

:extract
set "oj=%outfile%%nameonly%"
call :numberedBKP oj
set "oj=%oj%.json"
call :numberedBKP oj
if defined outfile set "back=%cd%" & cd /d "%zsndp%"
echo extracting . . .
%Zsnd% -d "%fullpath%" "%oj%" 2>"%rfo%" || call :writerror RF
if defined outfile cd /d "%back%"
EXIT /b

:combine
if /i "%nameonly:~-2%"=="_m" ( set ext=zsm
) else if /i "%nameonly:~-2%"=="_v" ( set ext=zss
) else if /i "%nameonly:~,8%"=="x_common" ( set ext=zsm
) else if /i "%nameonly:~,7%"=="x_voice" ( set ext=zss
) else (
 echo.
 choice /c MV /m "Combine to [M] master sounds or [V] voice file"
 if errorlevel 2 (set ext=zss) else set ext=zsm
)
echo combining . . .
set "zs=%pathname%.%ext%"
call :numberedBKP zs
cd /d "%pathonly%"
%Zsnd% "%fullpath%" "%zs%" 2>"%rfo%" || call :writerror RF
EXIT /b

:ZsndPreConfig
if ""=="%oldjson%" EXIT /b
choice /c UN /m "[U] Update '%jsonname%.json' or start with a [N] new, empty file"
if errorlevel 2 call :numberedBKP oldjson & call :writeNewJSON
copy /y "%fullpath%" "%tem%"
call :PSJZ F Upd
call :comb%combine%
EXIT /b

:updatePost
call :addConv
cd /d "%jp%"
echo.& echo|set /p=Removing 
for /f "skip=2 tokens=1*" %%e in ('find /i """file"":" "%oldjson%" 2^>nul') do (
 set "fullpath=%%~f
 call :uChckRem
)
echo.
call :PSJZ F Upd
call :comb%combine%
EXIT /b
:uChckRem
echo|set /p=.
if exist "%fullpath%" EXIT /b
echo -2 "%fullpath:\\=\%">>"%tem%"
EXIT /b

:updatePre
if defined add EXIT /b
set add=1
if ""=="%plat%" call :platW %xtnsonly%
call :ZSTitle
echo The update process may take a while. This window can be minimized to run the process in the background.
echo.
echo|set /p=Adding   
goto prepJSON
:update
call :updatePre
echo|set /p=.
call set "f=%%fullpath:%jp%=%%"
find """file"":" "%oldjson%" | find "%f:\=\\%" >nul && EXIT /b

:addWAV
call :setupW
:checkW
if defined oldjson EXIT /b
set t="%pathonly:~,-1%" 
echo %pl%|find %t:"="""% >nul || set pl=%pl%%t%
EXIT /b
:addWAVPost
REM possibly add option to add more files separately? Would mean that %tem% can't be deleted.
call :prepJSON
call :addConv
call :PSJZ F Add
call :comb%combine%
EXIT /b
:addConv
if %remHead%==false EXIT /b
call :convertWPost
for /f usebackq^ tokens^=1-5^ delims^=^" %%c in ("%tem%") do set "hash=%%~d" & set "fullpath=%%~f" & call :filesetup & call :cM%movewhr% %%c "%%g"
move /y "%tem%c" "%tem%"
move "%cvd%\*" "%jp%%infolder%"
rd /s /q "%cvd%"
EXIT /b
:combtrue
call :VAR combine newjson
EXIT /b

:listJSON
if %askname%==new EXIT /b
if defined oldjson EXIT /b
set "pathonly=%~dp0" & call :checkW
(for %%p in (%pl%) do (
 for /f "delims=" %%j in ('dir "%%~p\*.json" 2^>nul') do set /a x+=1 & echo "%%~p\%%~nxj"
 for %%j in (%%p) do if exist "%%~fj.json" set /a x+=1 & echo "%%~fj.json"
))>"%tem%l"
if ""=="%x%" EXIT /b
if %x% EQU 1 goto autoJSON
call :ZSTitle
type "%tem%l"
:pickJSON
echo.
set /p j=Multiple JSON files found. Enter the filename to choose one, or just press enter to create an all new one: || set j=& EXIT /b
for /f "delims=" %%j in ('findstr /ilc:"%j%" ^<"%tem%l"') do set "oldjson=%%~fj" & EXIT /b
goto pickJSON
:autoJSON
set /p oldjson=<"%tem%l"
set "oldjson=%oldjson:"=%"
EXIT /b

:prepJSON
set "fn=%t:"=%.json"
call :listJSON
if "%oldjson%"=="" call :blankJSON
if not exist "%oldjson%" call :writeNewJSON
call :defineJSON
if %askname%==update EXIT /b
if %askname:~-6%==folder for %%j in ("%fn%") do set "jsonname=%%~nj"
if %askname:~,4%==true set /p jsonname=Enter a name for the new sound file, or just press enter to use "%jsonname%": 
set "newjson=%jp%%jsonname%.json"
EXIT /b
:defineJSON
call :setJP
set "newjson=%oldjson%"
set "jsonname=%jn%"
EXIT /b
:setJP
for %%j in ("%oldjson%") do set "jp=%%~dpj" & set jn=%%~nj
EXIT /b
:blankJSON
if not %askname%==forcefolder set askname=truefolder
set "oldjson=%~dp0new_m.json"
call :writeNewJSON
EXIT /b

:convertWPost
set "bj=%oldjson%"
set "bnj=%newjson%"
set "oldjson=%cvd%.json"
set "newjson=%oldjson%"
echo converting . . .
call :writeNewJSON
call :PSJZ F conv
set "back=%cd%"
if defined jp cd /d "%jp%"
zsnd "%oldjson%" "%cvd%.zss" 2>"%rfo%" || call :writerror RF
cd /d "%zsndp%"
%zspe% -d "%cvd%.zss" "%oldjson%"
cd /d "%back%"
del "%oldjson%" "%cvd%.zss"
set "oldjson=%bj%"
set "newjson=%bnj%"
EXIT /b

:convertW
if %remHead%==false echo Conversion requirements not met. Check portable Zsnd. & goto Errors

:setupW
call :formatW || EXIT /b
if /i "PC" NEQ "%plat%" set remHead=false
call :srchInfo
if 0%flags% GTR 1 call :ravenAudio & set format=0
if "%flags%"=="1" set flags=
if %loop%==true set /a flags+=1
call :hashgen
call :askindx
set "file=%fullpath%"
if defined newjson call set "file=%%file:%jp%=%%"
call :M%movewhr%
call :writefile >>"%tem%"
EXIT /b
:formatW
call :checkPlat || goto fWwrong
if defined formatW if %xtnsonly% NEQ %formatW% goto fWwrong
call :platW %xtnsonly%
EXIT /b 0
:platW
call set formatW=%%%1%%
if ""=="%formatW%" call :platSw1
set PS=%ForPltfrm:~2%
if /i %1==.vag if %ForPltfrm:~,2% NEQ PS call :PS2orPS3
if /i %1==.vag set formatW=PS%PS:P=2%%formatW:~3%
for /f "tokens=1,2*" %%p in ("%formatW%") do set plat=%%p& set format=%%q& set Wformat=%%r
set formatW=%1
EXIT /b
:PS2orPS3
choice /c 23 /m "Are the sounds for PS2 and PSP, or for PS3"
set /a PS=1+%errorlevel%
EXIT /b
:askPlat
call :ZSTitle
echo.
echo %formatW%
echo.
choice /c SA /m "Press 'S' to switch platform. Press 'A' to accept and continue."
goto platSw%errorlevel%
:platSw1
if ""=="%o%" set o=0
set /a o+=1
for /f "tokens=%o%" %%o in (".wav .xma .xbadpcm .vag .dsp") do call set formatW=%%%%o%%& goto askPlat
set o=
goto platSw1
:platSw2
for /f %%p in ("%formatW%") do set plat=%%p
if defined plat EXIT /b
goto askPlat
:fWwrong
echo ERROR: "%fullpath%" is not in the correct format. Expected: %formatW%>>"%erl%"
EXIT /b 1
:checkPlat
if defined oldjson for /f "tokens=2 delims=:," %%p in ('findstr /ilc:"\"platform\":" "%oldjson%" 2^>nul') do for %%f in (%inext%) do call echo %%%%f:~,4%% | find /i %%p >nul && set inext=%%f&& set formatW=%%f&& if "%xtnsonly%" NEQ "%%f" EXIT /b 1
EXIT /b 0
:srchInfo
if defined predefined EXIT /b
if not %asample%==true call :askSR & EXIT /b
set "gs=%namextns%"
echo Searching information for "%namextns%" . . .
call :PSops Get samples sample_rate || EXIT /b && set sr=%sample_rate%
call :PSops Get samples format
call :PSops Get sounds flags && set flgh=%flags%
call :PSops Get samples flags || call :askSR
if %flags% LSS 0 set flags=
if %flags% GTR 99 set flags=
EXIT /b 0
:askindx
set i=%indx%
if %chIndex%==all if defined i EXIT /b
set indx=-1
if %chIndex%==false EXIT /b
if not %askname%==update EXIT /b
if ""=="%oldjson%" EXIT /b
if ""=="%maxindx%" call :countindex oldjson
set /a maxindx+=1
if defined i set indx=%i%
CLS
set /p "indx=Enter the sample_index number between %minindx% and %maxindx% to add '%nameonly%' on, or enter the filename before which to add it (add extension to filenames that are numbers only) [%indx%]: " || EXIT /b
call :isNumber %indx% || goto indxFile
call :isValid %indx% || goto askindx
EXIT /b
:indxFile
set "gs=%indx%"
set indx=
call :PSops Gidx
if defined indx EXIT /b
goto askindx
:isValid
if ""=="%1" EXIT /b 1
call :isNumber %1 || EXIT /b 1
if defined minindx if %1 LSS %minindx% EXIT /b 1
if defined maxindx if %1 GTR %maxindx% EXIT /b 1
EXIT /b 0

:hashgen
call :setJP
call :%jn:~,7%Hash 2>nul && EXIT /b
set "hash=%nameonly%"
if %askhash%==file EXIT /b
if %askhash%==char call :charHash & EXIT /b
set hash=%askhash%
if not %hash%==true EXIT /b
set hash=0
set "gs=%namextns%"
if not %asample%==never call :PSops Get sounds hash
echo.
set /p hash=Enter or paste a hash for "%namextns%", or press enter to use "%hash%": 
EXIT /b
:x_voiceHash
if defined in EXIT /b 0
call :HSSetup name in || set in=0
echo.
choice /c CBX /m "Is '%nameonly%' a name [c]allout or a [b]reak line (press [X] if it's something else)"
if errorlevel 1 set cp=AN_
if errorlevel 2 set cp=BREAK_
set hp=COMMON/MENUS/CHARACTER/
set "hash=%hp%%cp%%in%"
if errorlevel 3 set "hash=%in%"
choice /m "Do you want to use '%hash%' for the hash of all remaining input files"
if errorlevel 2 set in=
EXIT /b 0
:HSSetup
if ""=="%MUAOHSpath%" (
 echo Please paste or enter a folder path.
 echo - OpenHeroSelect ^(OHS^) users use the path to the OHS folder.
 echo - Other users ^(eg. XMLBCUI, QuickBatch^) use the path to ...
 echo   ... the Mod Organizer 2 ^(MO2^) %EditGame% mod folder ...
 echo   ... or an extracted FB package folder ^(console users^) ...
 echo   ... or the %EditGame% installation folder ^(non-MO2 PC users^) ...
 echo   ... containing the data folder with the currently used herostat.engb.
 set /p "MUAOHSpath=Enter path: " || goto HSSE
)
call :stripQ MUAOHSpath
set %2=
set "h=%MUAOHSpath%\data\herostat.engb"
call :checkOHS
if not defined hsFo if not exist "%h%" EXIT /b 1
call :readHS%3 %1 %2 || goto HSSE
if defined %2 EXIT /b 0
:HSSE
if not %1==name EXIT /b 1
set %2=
set /p %2=Enter the internal name for "%nameonly%": || EXIT /b
EXIT /b 0
:readHS
REM For other uses: If the herostat has 1 char, charactername will always be set to variable, regardless of the argument
call :HScheck || EXIT /b
if defined cs call :PSparseHS %1 set %2 charactername match cs && EXIT /b
CLS
call :PSparseHS charactername print %2 && EXIT /b
set /p cs=Choose a character from the list above by entering its name [supports regular expressions]: || EXIT /b
goto readHS

:writefile
REM Add, Update (remove = -2, add at the end = -1), convert (hash = anything)
echo %indx% "%hash%" "%file%" %format% %sr% %flags%
EXIT /b

:cMdestination
call :Mdest
echo %1 "%hash%" "%file%" %~2 >>"%tem%c"
EXIT /b
:cMsource
if %remHead%==true call :numberedBKP fullpath
:cMreplace
if %remHead%==false EXIT /b
if exist "%cvd%\%namextns%" (move /y "%cvd%\%namextns%" "%pathonly%") else (
 echo The converted "%namextns%" could not be found. This is probably due to a too long total file and path name. 
 echo  Check the "converted" folder for any ill-named files and rename them according to the input file. 
 echo  Manually move them to the correct folder, as defined in the JSON file.
)>>"%erl%"
EXIT /b
:Mdest
set "infolder=%jsonname%"
set "tp="%newjson:~,-5%\"
if /i "%jn:~,7%"=="x_voice" ( call :askxv
) else if ""=="%jsonname%" call :askxv
set "file=%infolder%\%namextns%"
mkdir "%tp%" 2>nul
EXIT /b
:Mdestination
if %remHead%==true EXIT /b
call :Mdest
REM move or copy? Converted files are copied.
move "%fullpath%" "%tp%"
:Msource
:Mreplace
EXIT /b
:askxv
set dircmd=/b /a-d
if ""=="%subfolder%" (
 call :ZSTitle
 echo.
 dir /ad "%jp%"
 echo.
 set /p subfolder=Choose an existing folder from the list by entering the name exactly as displayed. Entering a different name creates a new folder: 
 goto askxv
)
set "infolder=%subfolder%"
set "tp=%jp%%infolder%\"
EXIT /b

:countindex (var name for file)
call set "cj=%%%1%%"
set maxindx=-1
for /f "tokens=3 delims=:" %%c in ('find /c """file"":" "%cj%" 2^>nul') do set /a maxindx=%%c-1
EXIT /b

:ravenAudio
set "out=%fullpath%"
call :rA%movewhr%
if ""=="%ravenAudio%" call :checkTools ravenAudio || echo ravenAudio not found. Only 1 channel files possible. || EXIT /b
%ravenAudio% "%fullpath%" "%out%"
EXIT /b
:rAdestination
if defined tp goto rAsource
if ""=="%subfolder%" set /p subfolder=Enter a folder to copy the files to. Press enter to use 'converted': || set subfolder=converted
set "out=%~dp0%subfolder%\%namextns%"
EXIT /b
:rAsource
call :numberedBKP fullpath
EXIT /b

:editZSSZSM
call :extract
:mkZSbat
REM combine must be true
if "%op%"=="" set op=update
set /a l=42-1
PowerShell "$b=gc '%~f0'; $b[%l%]=$b[%l%] -replace '=[^""]*','=%pathname:'=''%.json'; $b[11]=$b[11] -replace '=.*','=%op%'; $b" >"%pathname%%jbs%.bat"
EXIT /b
:editZSSZSMPost
call :ZSTitle
if defined oj echo|set /p=Each & goto eZZmsg
echo Hint: Use a file path or name that is not an existing ZSM/ZSS file to create a new one.
set /p fullpath=Enter or paste the file path to a ZSM/ZSS file, or drag and drop it here: 
call :stripQ fullpath
call :filesetup
REM fixes a bug with the if chain
set "ZS=%xtnsonly:~1,2%"
if not exist "%fullpath%\" if exist "%fullpath%" if /i "%ZS%"=="ZS" call :editZSSZSM & call :ZSTitle & goto eZZmsg
choice /m "Could not find ZSM/ZSS file '%fullpath%'. Create a new file"
if errorlevel 2 goto editZSSZSMPost
if ""=="%plat%" call :platW .none
call :wNJ >"%pathname%.json"
call :mkZSbat
REM This is for a test for BloodyMares
REM set op=ZsndPreConfig& set jbs=_config
REM call :mkZSbat
call :ZSTitle
:eZZmsg
echo ZSM/ZSS has been extracted, and a batch file with the same name has been created.
echo Add sound files to the folder with the extracted ones,
echo then double click, on the batch file to build the updated ZSS/ZSM file.
EXIT /b

:editJSON
set "oldjson=%fullpath%"
call :defineJSON
call :ZSTitle
echo 1^) Create an additional hash for a sound sample.
echo 2^) Remove index number^(s^), hash or file.
echo 3^) Move index number^(s^) or file.
echo 4^) List index ^(just for fun^).
echo.
choice /c 1234 /m "What do you want to do with %namextns%"
if errorlevel 4 goto listIndex
if errorlevel 3 goto moveIndex
if errorlevel 2 goto removeIndex
if errorlevel 1 goto addHash

:moveIndex <sourceIndex or filename> <targetIndex>
call :indexList %1
set /p indx=<"%tem%"
set nindx=%2
call :mIask
(for /f usebackq %%i in ("%tem%") do echo %%i %nindx%)>>"%tem%m"
call :mImore Move %* && goto moveIndex
move /y "%tem%m" "%tem%"
call :PSJZ MI
EXIT /b
:mIask
call :asknum nindx "(lowest index number to move the selection [%indx%] to)"
if %indx% EQU %nindx% set nindx=& goto mIask
EXIT /b
:mIn
echo %1 %nindx%
set /a nindx+=1
EXIT /b
:mImore
if not "%~2"=="" EXIT /b 1
choice /m "%1 more"
if errorlevel 2 EXIT /b 1
EXIT /b 0

:removeIndex <index/filename/hash>
call :indexList %* || EXIT /b
call :mImore Remove %* && goto removeIndex
call :PSJZ RI
EXIT /b
:indexList
for /f "delims=0123456789- " %%i in ("%~1") do goto byForH
call :AskIrange %* || goto indexList
EXIT /b 0
:byForH
set gs=%*
if ""=="%gs%" EXIT /b 1
set "gs=%gs:"=%"
call :ZSTitle
echo Remove by ...
echo F. Filename
echo H. Hash
choice /c FH
if errorlevel 2 goto byH
for /f "skip=2 tokens=1* delims=: " %%a in ('find """file"":" "%oldjson%" ^| find "%gs%"') do set file=%%a
set file=%file:~,-1%
set file=%file:\\=\%
echo -2 %file%>>"%tem%"
call :PSJZ F writeJSON
EXIT /b 1
:byH
call :PSops GidxH
if ""=="%indx%" echo Could not find index of "%gs%".>>"%erl%" & EXIT /b
echo %indx%>>"%tem%"
EXIT /b 0

:listIndex
for /f "skip=2 tokens=2 delims=:, " %%a in ('find """sample_index"":" "%fullpath%"') do echo %%a
pause
EXIT /b

:ZsndSave
if %savecfg%==false EXIT /b 1
call :ZSTitle
choice /m "Save configurations"
if errorlevel 2 EXIT /b
set /p zcn=Enter a file name: || EXIT /b
set "zcn=%~dp0%zcn%.txt"
call :numberedBKP zcn
copy /y "%tem%" "%zcn%"
if %savecfg%==only EXIT /b 0
EXIT /b 1
:ZsndLoad
call :ZSTitle
echo Information: Configuration files are executed but not validated for duplicates or existing files.
echo.
echo "%zcn%":
choice /m "Load configurations"
if errorlevel 2 EXIT /b
set operation=ZsndPreConfig
set inext=.txt
set savecfg=false
EXIT /b


:writeNewJSON
if ""=="%plat%" call :platW .none
call :wNJ >"%oldjson%"
EXIT /b
:wNJ
echo {
echo     "platform": "%plat%",
echo     "sounds": [
echo         {
echo         }
echo     ],
echo     "samples": [
echo         {
echo         }
echo     ]
echo }
EXIT /b


:asknum
call set anc=%%%1%%
call :isValid %anc% && EXIT /b
set /p %1=Enter a number between %minindx% and %maxindx% %~2: 
goto asknum

:AskIrange
if ""=="%maxindx%" call :countindex oldjson
set i=%*
echo.
if "%~1"=="" set /p i=Please enter a number between %minindx% and %maxindx% (may be a range): || EXIT /b
set i=%i:&=,%
set i=%i:+=,%
set i=%i:/=,%
set i=%i:and=,%
set n=
for %%i in (%i%) do call :ix %%i >"%tem%"
if defined pi call :ie %pi% >>"%tem%"
EXIT /b
:ix
set c=%*
call :isNumber %* || call :isNumber %c:~,1% || set n=%*
for /f "tokens=1-2 delims=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz- " %%i in ("%*") do (
 set i1=%%i
 set i2=%%j
 if "%%j"=="" (
  if defined n (set i2=%pi%) else (
   if defined pi set pi=&set n=& call :ie %pi%
   set pi=%%i
   EXIT /b
  )
 )
 call :i2
)
EXIT /b
:i2
if %i2% LSS %i1% set i1=%i2%& set i2=%i1%
for /l %%i in (%i1%,1,%i2%) do call :ie %%i
set n=
set pi=
EXIT /b
:ie
call :isValid %1 && echo %1
EXIT /b

:PSfl
(call :%1 %2 %3 )>"%tem%.ps1"
Powershell -executionpolicy remotesigned -File "%tem%.ps1"
del "%tem%.ps1"
EXIT /b

:PSJZ
if not exist "%tem%" EXIT /b
call :ZsndSave && EXIT /b
for %%n in ("%newjson%") do if %%~zn GTR 200 call :numberedBKP newjson
echo Generating sound database . . .
call :PSfl PSjsonZSND %1 %2
EXIT /b

:PSjsonZSND
echo $sf = gc -raw "%oldjson%" ^| ConvertFrom-Json
echo $max_i = $sf.samples.file.count
echo $end = 0
echo $rQ = '(?=(?:[^^"]*"[^^"]*")*[^^"]*$)'
echo (gc "%tem%" ^| %% {[PSCustomObject]@{index=[int]($_ -Split ' ')[0]; hash=($_ -Split ' ')[1]; file=($_ -Split ' ')[2]; value=$_}} ^| Sort-Object -Property @{Expression = 'index'; Descending = $true}, @{Expression = 'hash'; Descending = $true}, @{Expression = 'file'; Descending = $true}).value ^| %% {
echo   $l = ($_ -Split " +$rQ").Trim('"')
echo   [int]$i, [int]$oi = $l[0]
set ccb=}
goto PSfor%1
:PSforF
if ""=="%flgh%" set flgh=31
echo   if ($i -eq -2) {
echo     $oi = $sf.samples.IndexOf(($sf.samples ^| ? file -eq $l[1])[0])
call :PSrmI
echo   } else {
echo     if ($i -lt 0 -or $i -ge $max_i -and $i -ne 0) {$i = $sf.samples.file.count; $end += 1}
echo     $so = @([PSCustomObject]@{hash=$l[1].%hshcase%(); sample_index=$i; flags=%flgh%})
echo     $sa = @([PSCustomObject]@{file=$l[2]; format=[int]$l[3]; sample_rate=[int]$l[4]})
echo     if ($l[5]) {$sa ^| Add-Member -NotePropertyName flags -NotePropertyValue ([int]$l[5])}
set ccb=%ccb%}
goto PS%2
:PSforRI
call :PSrmI
goto PSfixZ
:PSforMI
set "ic=^| sort -Descending ^| %% {if ($_ -and $_ -le $i) {$ix=1}}"
echo   $a %ic:ix=oi+%
echo   $r = [array]$r + [array]$oi
call :PSsvI
call :PSrmI
echo   [int]$i = $l[1]
echo   $r %ic:x=-%
echo   $a %ic:x=+%
echo   $so = @($so ^| select hash, @{n="sample_index";e={$i}}, flags)
echo   $a = [array]$a + [array]$i
:PSUpd
:PSAdd
call :PSaddHi
call :PSaddFi
goto PSfixZ
:PSaddHi
echo     $ro = 1
echo     if ($sf.sounds.sample_index.count -eq 0) {
echo       $sf.sounds = $so
echo     } else {
echo       $sf.sounds = @($sf.sounds ^| %% {
echo         if ($_.sample_index -eq $i -and $ro) {$so; Clear-Variable ro}
echo         if ($_.sample_index -lt $i) {$_}
echo         else {$_ ^| select hash, @{n="sample_index";e={[int]($_.sample_index+1)}}, flags}
echo       })
echo       if ($i -ge $sf.samples.file.count) {$sf.sounds += $so}
echo     }
EXIT /b
:PSaddHiAlt
REM Sorts all higher sample_indexes from below $i to above. Useless like this:
echo     $sf.sounds = (if ($i -gt 0) {$sf.sounds ^| ? sample_index -lt $i}) + $sf.sounds ^| ? sample_index -ge $i
EXIT /b
:PSaddFi
echo     if ($sf.samples.file.count -eq 0) {
echo       $sf.samples = $sa
echo     } else {
echo       if ($i -gt 0) {$sa = $sf.samples[0..($i-1)] + $sa}
echo       $sf.samples = $sa + $sf.samples[$i..$sf.samples.count]
echo     }
EXIT /b
:PSsvI
echo   $so = @($sf.sounds ^| ? sample_index -eq $oi)
echo   $sa = @($sf.samples[$oi])
EXIT /b
:PSrmI
echo     if ($oi -ge 0) {
echo       $sf.sounds = $sf.sounds ^| %% {
echo         if ($_.sample_index -lt $oi) {$_}
echo         if ($_.sample_index -gt $oi) {$_ ^| select hash, @{n="sample_index";e={[int]($_.sample_index-1)}}, flags}
echo       }
if ""=="%remHashOnly%" (
echo       $t = $sf.samples[^($oi+1^)..$sf.samples.count]
echo       $sf.samples = if ^($oi -gt 0^) {$sf.samples[0..^($oi-1^)] + $t} else {$t}
)
echo       $max_i -= 1
echo     }
EXIT /b
:PSconv
call :PSaddFi
echo.%ccb%
echo $sf.sounds = @([PSCustomObject]@{hash='CONVERT'; sample_index=0; flags=%flgh%})
goto PSwriteJSON
:PSfixZ
echo.%ccb%
REM Fix order of files added at the end
set "sarev=$sf.samples[^($sf.samples.count-1^)..^($sf.samples.count-$end^)]"
set "sorev=^( $sf.sounds[^($sf.sounds.count-1^)..^($sf.sounds.count-$end^)] ^| select hash, @{n="sample_index";e={$sf.sounds.sample_index[($sf.sounds.count-$end+($sf.sounds.count-$_.sample_index-1))]}}, flags ^)"
echo if ($end -gt 0) {
echo   if ($sf.samples.count-$end -gt 0) {
echo     $sf.samples = $sf.samples[0..^($sf.samples.count-$end-1^)] + %sarev%
echo     $sf.sounds = $sf.sounds[0..^($sf.sounds.count-$end-1^)] + %sorev%
echo   } else {
echo     $sf.samples = %sarev%
echo     $sf.sounds = %sorev%
echo   }
echo }
REM Fix random index
set ra=/\*\*\*random\*\*\*/
echo $hs = $sf.sounds ^| select @{n="hash";e={($_.hash -ireplace '%ra%\d\d?$')}}, sample_index, flags
echo $ra = $hs.hash ^| select -unique ^| %% {if (($hs.hash -eq $_).count -gt 1) {$_}}
echo $d = @([PSCustomObject]@{hash=''; i=0})
echo [array]$sf.sounds = Foreach ($s in $hs) {if ($ra -eq $s.hash) {$i = $d.hash.IndexOf($s.hash); if ($i -gt 0) {$d[$i].i++} else {$d += [PSCustomObject]@{hash=$s.hash; i=0}; $i=-1}; $s ^| select @{n="hash";e={($s.hash + '%ra:\=%' + $d[$i].i).%hshcase%()}}, sample_index, flags} else {$s}}
:PSwriteJSON
REM Convert to JSON, and fix bad formatting of v5 (newer versions aren't part of Win)
echo $ind = 0
echo [IO.File]::WriteAllLines("%newjson%", (($sf ^| ConvertTo-Json) -split '\r?\n' ^| ForEach-Object {
echo   if ($_ -match "[}\]]$rQ") {$ind = [Math]::Max($ind - 4, 0)}
echo   $line = (' ' * $ind) + (([Regex]::Replace($_, "\\u(?<Value>[a-zA-Z0-9]{4})", { param($m) ([char]([int]::Parse($m.Groups['Value'].Value, [System.Globalization.NumberStyles]::HexNumber))).ToString() })).TrimStart() -replace ":\s+$rQ", ': ')
echo   if ($_ -match "[\{\[]$rQ") {$ind += 4}
echo   $line
echo }), (New-Object System.Text.UTF8Encoding $False))
EXIT /b
REM Convert to JSON, with bad v5 formatting
echo [IO.File]::WriteAllLines("%newjson%", ($sf ^| ConvertTo-Json), (New-Object System.Text.UTF8Encoding $False))
:PSops
set "gc=(gc -raw '%oldjson%' | ConvertFrom-Json)"
goto PSjson%1
:PSjsonSortH
REM Sort hash table
PowerShell "%gc%.sounds | Sort-Object -Property sample_index"
EXIT /b
:PSjsonGidx
REM samples: sample_rate; format; file; flags | sounds: hash; sample_index; flags
set "gi=%gc%.samples.file"
for /f "usebackq delims=" %%i in (`PowerShell "%gi%.IndexOf([string](%gi% -match '%gs%')[0])"`) do set indx=%%i
EXIT /b
:PSjsonGidxH
for /f "usebackq delims=" %%i in (`PowerShell "((%gc%.sounds | where hash -match '%gs%').sample_index)"`) do set indx=%%i
EXIT /b
:PSjsonGet [table] [content] [index]
if ""=="%indx%" call :PSjsonGidx
if ""=="%indx%" EXIT /b 1
if %2==sounds (set "gt=(%gc%.sounds | ? {$_.sample_index -eq '%indx%'}).hash") else set "gt=%gc%.%2.%3[%indx%]"
for /f "usebackq delims=" %%r in (`PowerShell "%gt%"`) do set "%3=%%~r" & EXIT /b 0
EXIT /b 1
:PStopfolder
powershell "('%cd%' -split ('\\'))[-1]"
EXIT /b
:PSparseHS
REM var h must one or multiple herostat files (multi only tested with lxml)
set "psc=$h = (dir -s '%h%' | %% {gc -raw $_}); $d = "
if %hdf%==lxml set "psc=%psc%$h -split '(?=stats\s{\r?\n[\S\s]*)' | %% {($_ -split '[a-zA-Z]*\s{\r?\n')[1] -replace '(\s;|\s*}) *(?=\r?\n)' | ConvertFrom-StringData}"
if %hdf%==xml set "psc=%psc%([xml]$h).characters.stats"
if %hdf%==json set "psc=%psc%($h -replace '{\r?\n\s*\"characters\":\s{' -replace '\s*}\s*}\r' -split '(?=\"stats\":[\S\s]*},?)') | %% {(('{' + $_.Trim().Trim(',') + '}' | ConvertFrom-Json).stats)}"
set "d=.%1"
if "%1"=="." set d=
set "e=$p = $d"
if not "%4"=="" call set "e=$p = ($d | ? %4 -%5 '%%%6%%')"
set "psc=%psc%; %e%%d%"
if %2==psc EXIT /b 0
for /f "useback delims=" %%h in (`PowerShell "%psc%; $p"`) do set "%3=%%~h" & goto PSpH%2
EXIT /b 1
:PSpHset
EXIT /b 0
:PSpHprint
PowerShell "%psc%; $p; if ($p.count -ne 1) { exit 1 } else { exit 0 }"
EXIT /b
REM Tried to parse lxml with powershell, but there's an issue because of non-indexed identical properties (stats{}, stats{}, etc.)
REM Powershell index (eg. [0]) does not work with property paths, because it's required to be part in the path.
REM (((gc -raw '%h%') -split '(?=stats\s{\r[\S\s]*)')[5] -split '\n') | %% {if ($_ -match '^[{\r]') {$t=$_.trim().trim('{ '); if ($p) {$l+='.'}; $l+=$t; if ($m) {if (!$m.$l) {$m.$p+=@{$t=@{}}}} else {$m=@{$t=@{}}}; $p=$l} elseif ($_ -match '}\r') {$p = $p -replace '\.(\w+)$',''} else {$m.$p+=($_.trim().trim('; ') | ConvertFrom-StringData)}}

:checkOHS
if exist "%MUAOHSpath%\%EditGame%\config.ini" (
 call :readOHS herostatFolder hsFo || set hsFo=xml
 goto HSSOHS
)
set hsFo=xml
goto HSSOHS
:readOHS
for /f "tokens=1* delims=:, " %%a in ('type "%MUAOHSpath%\%EditGame%\config.ini" ^| find """%1"": "') do for %%m in (%%b) do set "%2=%%~m" & EXIT /b
EXIT /b 1
:HSSOHS
if not "%hsFo:~1,1%"==":" set "hsFo=%MUAOHSpath%\%EditGame%\%hsFo%"
if not exist "%hsFo%" set hsFo=& EXIT /b 1
set "h=%hsFo%\*.*"
EXIT /b 0


:writeOpt
set /a optcnt+=1
(call :%1 %optcnt%)>>%optSetT%
EXIT /b

:Optimizer
%sgOptimizer% "%infile%" "%outfile%" %optSet% || goto Errors
EXIT /b

:optHead
echo [OPTIMIZE]
echo optimizationCount = %1
echo hierarchyCheck = true
EXIT /b

:OptGeoInfo
echo [OPTIMIZATION%1]
echo name = igStatisticsGeometry
goto OptInfo
:OptTexInfo
echo [OPTIMIZATION%1]
echo name = igStatisticsTexture
echo useFullPath = false
:OptInfo
echo separatorString = ^|
echo columnMaxWidth = -1
echo showColumnsMask = %2
echo sortColumn = -1
EXIT /b

:OptSkinStats
echo [OPTIMIZATION%1]
echo name = igStatisticsSkin
call :OptInfo %1 0x00000006
EXIT /b

:OptRen
echo [OPTIMIZATION%1]
echo name = igChangeObjectName
echo objectTypeName = igNamedObject
echo targetName = ^%targetName%$
echo newName = %newName%
EXIT /b

:optGGC
echo [OPTIMIZATION%1]
echo name = igGenerateGlobalColor
EXIT /b

:optCGA
echo [OPTIMIZATION%1]
echo name = igConvertGeometryAttr
echo accessMode = 3
echo storeBoundingVolume = false
EXIT /b

:optConv
echo %format% | find /i "DXT" >nul && set "order=DX" || set "order=DEFAULT"
echo [OPTIMIZATION%1]
echo name = igConvertImage
echo format = %igTF%%format%
echo sourceFormat = invalid
echo order = IG_GFX_IMAGE_ORDER_%order%
echo isExclude = %isExclude%
echo convertIfSmaller = false
echo imageListFilename = %convertlist%
EXIT /b


:isNumber string
for /f "delims=0123456789" %%i in ("%*") do EXIT /b 1
EXIT /b 0

:trimmer
set "trim=%*"
EXIT /b

:stripQ
if defined %1 call set "%1=%%%1:"=%%"
EXIT /b


:charHash
call :cHS
set "hash=CHAR/%jsonname%/%hn%"
EXIT /b
:cHS
for %%s in (
DEATH:DEATH
JUMP:JUMP
LAND:LAND
PAIN:PAIN
PICKUP:PICKUP
LIFT:PICKUP
THROW:THROW
FLYBEGIN:FLYBEGIN
FLYEND:FLYEND
CANTGO:CANTGO
CMDATTACKANY:CMDATTACKANY
CMDATTACKTARGET:CMDATTACKTARGET
CMDFOLLOW:CMDFOLLOW
EPITAPH:EPITAPH
ISEEYOU:ISEEYOU
LEVELUP:LEVELUP
LOWHEALTH:LOWHEALTH
NOPOWER:NOPOWER
NOWORK:NOWORK
RESPAFFIRM:RESPAFFIRM
TAUNTKD:TAUNTKD
THROWTAUNT:THROWTAUNT
TOOHEAVY:TOOHEAVY
VICTORY:VICTORY
XTREME:XTREME
BORED:BORED
6_STATS:STATS
STATS:STATS
SIGHT:SIGHT
STRUGGLE:STRUGGLE
LOCKED:LOCKED
CANTTALK:CANTTALK
XTREME2:XTREME2
) do for /f "tokens=1* delims=:" %%a in ("%%s") do echo "%nameonly: =_%" | findstr /bir ^"\^"%%a_*\d*^" >nul && set hn=%%b&& EXIT /b
REM Power sounds not added:
REM P1_POWER
REM P1_CHARGE
REM P1_LOOP
REM P1_IMPACT
set "hn=%nameonly%"
for /l %%e in (5 -1 1) do call :isEnd %%e && EXIT /b
EXIT /b
:isEnd
call set "end=%%hn:~-%1%%"
for /f "delims=1234567890_- " %%n in ("%end%") do EXIT /b 1
call set "hn=%%hn:~0,-%1%%"
EXIT /b 0


REM Unused code
:addVar var string
call set "%1=%%%1%%%2" & EXIT /b
:replaceVar var org.string replace.string
call set "%1=%%%1:%~2=%~3%%" & EXIT /b
:PSfilesetup
echo [IO.DirectoryInfo]$fp = $l[2]
REM Name including extension:
echo $fp.Name
echo $fp.Extension
echo $fp.FullName
REM pathonly, parent folder when folder:
echo $fp.Parent.FullName
REM Drive letter:
echo $fp.Root.Name
REM directory or file:
echo $fp.Attributes
echo $fp.Exists
EXIT /b
REM Old Zsnd code:
:JsonNBA2kSreader var
REM full line as var linein
set %~1=
set d=:
if "%linein:~-1%" == ";" set d==
for /f "tokens=1* delims=%d%" %%u in ("%linein%") do set "v=%%v"
set "le=%v:~-1%"
if "%le:"=q%"==";" set v="%v:~1,-2%"
for /f "delims=" %%v in (%v%) do set "v=%%~v"
EXIT /b
:findLineJSON var; line; searchfile as oldjson
for /f "tokens=1,2* delims=[]:" %%a in ('find /v /n "" "%oldjson%" ^| find "[%2]"') do call :trimmer %%b
set %~1=%trim%
EXIT /b


:checkAlchemy program
if not defined IG_ROOT echo The IG_ROOT variable is not defined. Please check your Alchemy 5 installation. & goto Errors
if exist "%IG_ROOT%\bin\%1.exe" set %1="%IG_ROOT%\bin\%1.exe"
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
if exist "%~dp0OpenHeroSelect.exe" set conv="%~dp0OpenHeroSelect.exe" -c
if exist "%~dp0xml2json.exe" set conv="%~dp0xml2json.exe"
if defined py if exist "%~dp0converter.py" set conv=py "%~dp0converter.py"
if ""=="%conv%" echo Converter not found. Check the Readme.>>"%erl%"
EXIT /b

:checkExist extension
set "%1=%pathname%.%1"
rem if exist "%numBKP%" echo "%fullpath%": Error. "%nameonly%.%1" exists. Please use that file.>>"%erl%" & EXIT /b 1
:numberedBKP var
if %askbackup%==replace EXIT /b 0
call set "NB=%%%1%%"
if not exist "%NB%" EXIT /b 0
set /a n+=1
if exist "%NB%.%n%.bak" goto numberedBKP
if %askbackup%==true (
 choice /m "'%NB%' exists already. Do you want to make a backup"
 if errorlevel 2 EXIT /b 0
)
copy "%NB%" "%NB%.%n%.bak"
set n=0
EXIT /b 0


:End
if defined any call :%operation%Post
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
del "%xco%" "%rfo%" "%tem%" "%tem%l" "%tem%c" "%tem%m" "%tem%.%dex%" "%temp%\temp.igb" %optSet% %optSetT%
EXIT
