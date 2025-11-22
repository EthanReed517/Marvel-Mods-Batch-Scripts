@echo off
REM for /f "tokens=2 delims=:" %%c in ('chcp') do if %%c NEQ 850 chcp 65001 >nul

REM -----------------------------------------------------------------------------

REM Settings:

REM What operation should be made? (=IGBconverter; extract images =Extract; =image2igb; hex edit skins =SkinEdit; generate GlobalColor (fix black status effect) =genGColorFix; =previewAnimations; =extractAnimations; =combineAnimations; =listAnimations; Optimize animations =ExtractMotionRaven; make HUD heads from images =hud_head_e; same for team logos =logos_e; and stages =stages_e; =convert_to_igGeometryAttr2; Texture Map Editor =Maps; write igSceneInfo =fixSkins; remove igSceneInfo =remInfo; =ask)
set operation=ask
REM Is this a simple tool with the same name as operation? (=true or =false) 
set OpIsTool=false
REM Create mip-maps? (=true or =false), useful for lower resolutions only - to ask for each input file, use =ask at the operation settings
set mipmaps=false
REM Remove optimization sets? (Yes =true; No =false; Remove useful ones as well =all)
set delOptSets=true
REM Remove the input files when done? (Yes =true; No =false)
REM WARNING! Don't set it to =true, unless you're 100% sure you don't need them anymore.
set delInputFiles=false
REM Ask before backing up existing files? (yes =true; no =false; always replace, not safe! =replace)
set askbackup=false
REM Include subfolders (recursive mode)? (yes =true; no =false)
set recursive=false

REM IGBconverter settings (detects actorConverter and animationConverter):
REM Format (valid values: =FBX, =OBJ, =DAE, =ask)
set format=OBJ
REM Extract textures as well? (yes =true, no =false)
set exttextrs=true

REM Image Extract settings:
REM Create subfolders for each file, where the images are put in? (yes =true, no =false)
set subfolder=false
REM Check for PNG format, and extract PNG instead of TGA when found? (yes =true, no =false)
set detectPNG=true
REM Remove Mip Map textures? (yes =true, no =false) (enm must be opposite)
set remMipMap=true
set enm=false
REM Remove internal and reference extracted instead? (yes =true, no =false)
set refExtTex=false

REM HUD settings:
REM Quality and speed of animated HUDs aka FPS (=10, =16)
set hud_fps=16
REM Play mode of animated HUDs (repeat =0, bounce =2)
set hud_apm=0
REM Are .png files animated aPNG format? (yes =true, no =false)
set hud_apng=false
REM Define a tile side count: (Auto =[Math]::Round($time + 3.7), (4x4 or 16 =4), min. =4, max. =10)
set tile_num=[Math]::Round($time + 3.7)
REM Define a texture quality for animated stages: (0-10; or a full side dimension, e.g. 7200)
set st_animq=
REM For which platform? (MUA for PC =PC; for PS2 =PS2; for PSP =PSP; for original Xbox =Xbox; XML2 for PC =XML2; XML2 for GameCube =GC; MUA for Wii =Wii; MUA for Xbox360 =360; MUA for PS3 =PS3; MUA RE for PC =Steam; MUA RE for Xbox One =X1; MUA RE for PS4 =PS4)
set ForPltfrm=PC
REM ImageMagick colourswap command: (leave empty for no swapping)
set colourswap=-separate -swap 0,2 -combine 
if "%ForPltfrm%" == "XML2" set colourswap=

REM image2igb settings:
REM Prompt for conversion? (ask for all exc. dds =true; ask for all exc. png+dds =false; no conversion =never; ask for all + dds =dds)
REM Always convert all, except png+dds. (to DDS DXT1 =dxt1; to DDS DXT5 =dxt5)
REM Force conversion of all files (to DDS DXT1 =fdxt1; to DDS DXT5 =fdxt5; to other formats, as defined below, eg. =RGBA_5551_16)
set askconv=dxt1
REM Force conversion to one of the following formats (use the format as option in the askconv= setting above):
REM -- rgb formats for icons and effect textures
REM RGBA_4444_16
REM RGBA_8888_32
REM RGBA_2222_8
REM RGBA_5551_16   (default)
REM RGBA_128F
REM -- dxt textures for most model (skin, boltons, etc) textures
REM RGBA_DXT1
REM RGBA_DXT3
REM RGBA_DXT5
REM -- indexed PNG color formats
REM X_8
REM X_4
REM TILED_X_8_PSP
REM TILED_X_4_PSP
REM -- gamecube textures
REM TILED_DXT1_GAMECUBE   (seems not to work, use normal DXT1 instead)
REM TILED_RGBA_5553_16_GAMECUBE
REM TILED_L_8_GAMECUBE
REM TILED_LA_88_16_GAMECUBE
REM TILED_LA_44_8_GAMECUBE
REM -- rgb formats without transparency
REM RGB_332_8
REM RGB_888_24
REM RGB_565_16
REM TILED_RGB_565_16_GAMECUBE
REM -- intensity/grayscale formats
REM L_8
REM LA_44_8
REM LA_88_16
REM A_8
REM -- reset: =INVALID
REM -- example:
REM set askconv=RGBA_8888_32
REM -- 
REM Force asking to convert PNG. (=true; =false)
set askpng=false
REM Resize? (no resize =false; to loading screens for Ultimate Alliance 2048x1024 =MUA, for X-Men Legends 2 512x512 =XML2; icons for last-gen consoles 128x128 =ILQ; icons for PC & next-gen consoles 256x256 =IHQ; prompt for each file =ask)
REM Custom resize values possible (eg. 1024x1024 =1024; 100x100 =100)
set maxHeight=false
REM Custom width, to be used with custom height (eg. 64x64 =identical & maxHeight=64; 1024x512 =1024 & maxHeight=512)
set maxWidth=identical
REM Minification/Magnification method? (linear =true; nearest, recommended =false)
set MagFilter=false
REM WrapS/T method? (repeat, default =false; clamp =true)
set WrapST=false

REM SkinEdit (hex-editing with Alchemy) Settings:
REM Always rename (hex-edit) to the Filename? (yes =true; no =false)
REM The file must already have the correct name.
set SkinEditToFilename=true

REM Preview Animations Settings:
REM Enter the full path and name to the skin (rigged IGB model) that you want to use to preview the animations with.
set "actorSkin=%IG_ROOT%\ArtistPack\insight\DX9\actor.igb"

REM Animation Mixer Settings (combine and extract):
REM Never use existing extraction.txt/combine.txt files? (Yes =true; No =false)
set nevtxt=false
REM Extract/combine animations with wrong names as well? (Yes =true; No =false)
set extall=false
REM Remove extract TXT files? (Yes =true; No =false)
set remext=false
REM Auto name when combining: Always use the first folder name? ( =true); Always use the first file name? ( =file); (No =false)
set autonm=false
REM Enter an IGB file for the skeleton. (Use the first input file "skeleton="; use fightstyle default incl. ponytail =_fightstyle_default)
REM Can be skin or animation. Can include path relative to the BAT. Eg. skeleton=skeletons\humanWponytail\elektra.igb
set skeleton=_fightstyle_default
REM Use name of files for animations? (Yes, they match the anim. name =true; No, scan the files for anim. names =false)
set animfn=true
REM Extract skin? (Yes =true; Skin only =only; No =false)
set exskin=false
REM Combine skin? (Yes =true; Specific skin IGB, eg. =subfolder\skin.igb; No =false)
set coskin=false
REM Use better scene construction load_actor_database (often fails)? (Yes =true; No =false)
set actor+=true
REM Experimental: Use source skin name? (Yes =true; No =false)
set skinSr=false

REM Texture Map Editor settings:
REM Convert to DXT/DDS? Ideal for PC. (yes to DXT1 =1; yes to DXT3 =3; no =false)
REM Normal maps are always DXT5; DDS never converted; PNG acc. settings; Other always converted
set ConvertDDSf=1
REM List all images in subfolders? (yes, always =true; no, root folder only =false; ask once =ask)
set SubfoldAuto=true
REM Always process all input files (IGB)?  (Yes =true; No, asks first =false)
set MultiInputA=false

REM -----------------------------------------------------------------------------

REM these are automatic settings, don't edit them:
if "%operation%"=="ask" call :opswitcher
set inext=.igb
if ""=="%temp%" set "temp=%~dp0"
set optSet="%temp%\%operation%.ini"
set optSetT="%temp%\%operation%T.ini"
set optOut="%temp%\optOut.txt"
set "tem=%temp%\%operation%.txt"
set "erl=%~dp0error.log"
set "outfile=%temp%\temp.igb"
set igTF=IG_GFX_TEXTURE_FORMAT_
call :start%operation% 2>nul || call :sgO
del "%erl%" "%tem%" %optSetT% "%outfile%"

if /i %OpIsTool%==True call :chkTlMsg %operation%

set askallsw=true
set askallsz=true
set isExclude=exclude
CLS

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
for /f "delims=" %%i in ('dir %inext:.=*.% 2^>nul ') do (
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
if /i "%fullpath%"=="%outfile%" EXIT /b
call :filesetup
if not "%inext%"==".*" echo %xtnsonly%|findstr /eil "%inext:,=%" >nul || EXIT /b
call :%operation%
if %delInputFiles%==true del "%fullpath%"
set any=true
EXIT /b

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

:test
for %%i in ("%pathonly:~,-1%") do set "sh=%%~dpihud\hud_head_%namextns%"
echo "%fullpath%"
if exist "%sh%" echo "%sh%"
pause
EXIT /b


:startimage2igb
call :chkTlMsg image2igb
set inext=.dds, .png, .tga, .jpg, .bmp, .igt
goto sgO
:startSkinEdit
set aSeIn=igActor01Appearance
set aSeOut=f
set aSeAll=1
if %SkinEditToFilename%==true set aSeIn=c&set aSeAll=a
goto sgO
:startlistAnimations
mkdir "%~dp0animLists" 2>nul
goto oAnim
:startstages_e
set inext=.png
goto sgO
:startCSP_XML2
:startstages_anim
:starthud_head_e
set inext=.png, .tga, .gif, .mp4, .webm
echo PC 360 PS3 Steam X1 PS4 | find /i "%ForPltfrm%">nul && goto sgO
set inext=.dds, .png, .tga, .jpg, .bmp, .igt
if exist "%~dp0NRskinner.exe" EXIT /b 0
echo The specified platform %ForPltfrm%, requires NRskinner/PS2skinner for hud_heads.
goto Errors
:startlogos_e
set inext=.tga
goto sgO
:startfixSkins
call :chkTlMsg animdb2actor
:startremInfo
:startIGBconverter
:startMaterialInfo
:startExtract
:startExtractMotionRaven
:sgO
call :checkTools sgOptimizer && EXIT /b
echo "%IG_ROOT%\bin\sgOptimizer.exe" must exist. Please check your Alchemy 5 installation.
goto Errors
:startcombineSkinsAnims
:startcombineAnimations
:startextractAnimations
set inext=.txt, .igb
call :checkTools animationProducer && goto oAnim
set animationProducer="%IG_ROOT%\animationProducer\DX\animationProducer.exe"
if exist %animationProducer% goto oAnim
echo "%IG_ROOT%\bin\animationProducer.exe" or %animationProducer% must exist. Please check your Alchemy 5 installation.
goto Errors
:oAnim
set opts=optAnimExt
call :writeOptSet
goto sgO
:startpreviewAnimations
call :checkTools insight && EXIT /b
set insight="%IG_ROOT%\ArtistPack\insight\DX9\insight.exe"
if exist %insight% EXIT /b 0
echo Insight Viewer not found. Please check your Alchemy 5 installation.
goto Errors
:chkTlMsg
call :checkTools %1 && EXIT /b
echo %1.exe not found.
if "%2"=="" goto Errors
EXIT /b 1

:askop
CLS
ECHO.
ECHO %operationtext%
ECHO.
CHOICE /C AS /M "Press 'A' to accept and continue with this process, press 'S' to switch"
IF ERRORLEVEL 2 goto opswitcher
IF ERRORLEVEL 1 EXIT /b
:opswitcher
if not defined o set o=0
call :OPS%o%
set o=%errorlevel%
goto askop
:OPS0
set operation=IGBconverter
set operationtext=IGB Converter by nikita488. Converts IGB models to FBX/OBJ.
EXIT /b 1
:OPS1
set operation=actorConverter 
set operationtext=IGB Converter by nikita488. Converts IGB skins to FBX/OBJ, incl. actors and skeletons.
EXIT /b 2
:OPS2
set operation=Extract
set operationtext=Extract images/textures.
EXIT /b 3
:OPS3
set operation=image2igb
set operationtext=Image2igb by nikita488. Make IGB images, that don't need a model.
EXIT /b 4
:OPS4
set operation=logos_e
set operationtext=Make team icons from images. Injecting the images has to be done manually with Finalizer.
EXIT /b 5
:OPS5
set operation=hud_head_e
set operationtext=Make HUD heads from images. Injecting the images has to be done manually with Finalizer.
EXIT /b 6
:OPS6
set operation=combineAnimations
set operationtext=Animation Mixer: Combine animations.
EXIT /b 7
:OPS7
set operation=extractAnimations
set operationtext=Animation Mixer: Extract animations.
EXIT /b 8
:OPS8
set operation=previewAnimations
set operationtext=Preview animations.
EXIT /b 9
:OPS9
set operation=listAnimations
set operationtext=Make an allAnims.txt file containing all animations of each input file .
EXIT /b 10
:OPS10
set operation=SkinEdit
set operationtext=Hex edit skins: Give the IGB a new internal name. It should be identical to the final filename.
EXIT /b 11
:OPS11
set operation=fixSkins
set operationtext=Add igSceneInfo and igActorInfo to a skin for better support with Alchemy 5.
EXIT /b 12
:OPS12
set operation=MaterialInfo
set operationtext=Dump info of each texture into a txt file.
EXIT /b 13
:OPS13
set operation=Maps
set operationtext=Texture map editor to add normal, specular, environment and reflection maps.
EXIT /b 14
:OPS14
set operation=genGColorFix
set operationtext=Generate GlobalColor (fixes black status effects on skins, eg. when hit).
EXIT /b 15
:OPS15
set operation=convert_to_igGeometryAttr2
set operationtext=convert igGeometryAttr attributes to v2 (igGeometryAttr2).
EXIT /b 0

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

:combineSkinsAnims
goto combineAnimations
:combineSkinsAnimsPost
call :combineAnimationsPost
set "fullpath=%~dp0%outanim%.igb"
call :filesetup
%actorConverter% "%fullpath%" "%pathname%.%format%"

:IGBconverter
if %askallsw%==true if /i %format%==ask call :askformat3D
call :toLower format
set "convOut=%pathname%.%format%"
set conv=actorConverter
findstr "igEnbaya" <"%fullpath%" >nul 2>nul && call :AnimConverter || findstr "igAnimationDatabase" <"%fullpath%" >nul 2>nul || set conv=IGBconverter
if %exttextrs%==true call :Extract
call :fixIGB
if not defined %conv% call :chkTlMsg %conv% x >>"%erl%" || EXIT /b
call set c=%%%conv%%%
%c% "%fullpath%" "%convOut%"
EXIT /b
:AnimConverter
set conv=animationConverter
set exttextrs=false
set format=%format:obj=fbx%
EXIT /b 0
:fixIGB
if "%conv%"=="animationConverter" EXIT /b 0
set opts=OptGeoInfo 0x00000001
call :runOpts >%optOut%
set opts=
findstr "invalid" <%optOut% >nul 2>nul && set opts=optCGA,optStripTri false true
if "%conv%"=="IGBconverter" findstr "igActorInfo" <"%fullpath%" >nul 2>nul && set opts=optCombAnimDB,%opts%
if not defined opts EXIT /b
if "%conv%"=="actorConverter" call :writeOS >%optSetT% && set opts=optActorSkins
REM goto runOptsOnI
call :runOpts
set "fullpath=%outfile%"
call :filesetup
EXIT /b 0

:askformat3D
CLS
echo Convert "%namextns%" to...
echo.
echo F) FBX ("%nameonly%.fbx")
echo O) OBJ ("%nameonly%.obj")
echo D) DAE ("%nameonly%.dae")
echo.
call :askallD askallsw A
choice /c FODA /m "What format do you want to convert %namextns% into"
IF ERRORLEVEL 4 call :switchBool askallsw & goto askformat3D
IF ERRORLEVEL 3 set "format=dae" & EXIT /b
IF ERRORLEVEL 2 set "format=obj" & EXIT /b
IF ERRORLEVEL 1 set "format=fbx" & EXIT /b

:Extract
set iformat=tga
set sfolder=
if %detectPNG%==true call :fetchFormat
if %subfolder%==true set "sfolder=%nameonly%" & mkdir "%pathname%"
if %refExtTex%==true set "outfile=%fullpath%"
set opts=OptExt %iformat% %refExtTex% false %enm%
if %remMipMap%==true set opts=optRemMM,%opts%
call :runOpts
EXIT /b

:fetchFormat
call :fetchTexInfo
set iformat=png
for /f "delims=" %%a in ('findstr "%igTF%" ^<%optOut%') do (
 echo "%%a" | find "%igTF%RGBA_8888_32">nul && EXIT /b
 echo "%%a" | find "%igTF%X">nul && EXIT /b
 set iformat=tga
 EXIT /b
)
EXIT /b

:MaterialInfo
call :fTi 0x000003ff
EXIT /b

:fetchTexInfo
call :fTi 0x00000011
EXIT /b
:fTi
set opts=OptTexInfo %1
call :runOpts >%optOut%
EXIT /b

:fetchTextures
call :fetchTexInfo
set count=0
echo Textures found in "%namextns%":
for /f "delims=|" %%a in ('findstr "%igTF%" ^<%optOut%') do (
 echo  %%a
 call :remSpacesLT %%a
 set /a count+=1
)
EXIT /b

:image2igb
if %askallsw%==true call :checkconvert
if %askallsz%==true call :checkresize
set ini=%optSet%
if %MagFilter%%WrapST%==falsefalse set ini=
if defined ini call :i2iSettings >"%ini%"
set "infile=%pathname%.igb"
%image2igb% "%fullpath%" "%infile%" %ini%
set "outfile=%infile%"
if ""=="%createINI%" goto i2iOptSet
if %askallsw%==true goto i2iOptSet
if %askallsz%==true goto i2iOptSet
goto Optimizer

:checkconvert
REM Automatic and manual setup for the texture format:
set convert=false
set format=%askconv%
if %format:_=%==%format% (
 if %format%==never EXIT /b
 echo :dxt5.png:dxt1.png:false.png:dxt5.dds:dxt1.dds:false.dds:true.dds: | find /i ":%format%%xtnsonly%:" >nul && if %askpng%==false EXIT /b
 if /i %format:~-4%==dxt1 set format=RGBA_DXT1
 if /i %format:~-4%==dxt5 set format=RGBA_DXT5
)
set convert=true
if %format:_=% NEQ %format% if %askpng%==false EXIT /b
:askconvert
call :CTitle %xtnsonly%
echo N^) No conversion ^(JPG and TGA don't work, PNG usually works^)
echo 1^) Convert to DDS DXT1
echo 5^) Convert to DDS DXT5
echo 0^) More conversion formats
call :askCopt
choice /c N150SMW /m "Convert %namextns%"
call :askC%errorlevel% && EXIT /b
goto askconvert
:askF3
:askC7
call :switchBool WrapST
set wrmthd=Repeat
if %WrapST%==true set wrmthd=Clamp
EXIT /b 1
:askF2
:askC6
call :switchBool MagFilter
set magmthd=Nearest
if %MagFilter%==true set magmthd=Linear
EXIT /b 1
:askF1
:askC5
call :switchBool askallsw
EXIT /b 1
:askC1
set convert=false
EXIT /b 0
:askC2
set format=RGBA_DXT1
EXIT /b 0
:askC3
set format=RGBA_DXT5
EXIT /b 0
:askC4
set format=RGBA_4444_16
call :IGBimgFormats
:askformat
call :CTitle %1
echo %format%
echo %desc%
call :askCopt
choice /c SMWFA /m "Press 'F' to change the format. Press 'A' to accept and continue"
IF ERRORLEVEL 5 EXIT /b 0
IF ERRORLEVEL 4 call :IGBimgFormats
call :askF%errorlevel%
goto askformat
:CTitle
CLS
echo Current format: %1
echo.
echo Format to convert into:
EXIT /b
:askCopt
echo.
echo Options:
echo Magnification method (Press 'M' to switch)
echo %magmthd%
echo Wrap S/T method      (Press 'W' to switch)
echo %wrmthd%
echo.
call :askallD askallsw S
EXIT /b

:checkresize
REM Automatic and manual setup for the texture size:
set askallsz=%askallsw%
if /i %maxHeight%==false EXIT /b
if /i %maxHeight%==MUA set maxHeight=1024&set maxWidth=2048
if /i %maxHeight%==XML2 set maxHeight=512&set maxWidth=512
if /i %maxHeight%==ILQ set maxHeight=128&set maxWidth=128
if /i %maxHeight%==IHQ set maxHeight=256&set maxWidth=256
call :validateSize && EXIT /b
REM maxHeight is "ask" or invalid
:asksize
CLS
echo Enter the pixel size you want to change the image into. It's recommended to have a bigger input size.
echo.
echo N^) Keep current size, No resize
echo U^) Loading screen size for MUA 2048x1024
echo X^) Loading screen size for XML2 512x512
echo L^) Icon size for last-gen consoles 128x128
echo H^) Icon size for PC and next-gen consoles 256x256 
echo C^) Enter a custom height value
echo.
echo Options:
echo Current width     (Press 'W' to switch)
if %maxWidth%==identical (echo %maxHeight%) else echo.%maxWidth:different=%
echo Generate mipmaps? (Press 'M' to switch)
echo %mipmaps%
echo.
call :askallD askallsz S
choice /c UXLHCWMNS /m "Resize %~1"
IF ERRORLEVEL 9 call :switchBool askallsz & goto asksize
IF ERRORLEVEL 8 set maxHeight=false&set maxWidth=false&EXIT /b
IF ERRORLEVEL 7 call :switchBool mipmaps & goto asksize
IF ERRORLEVEL 6 call :switch maxWidth identical different & goto asksize
IF ERRORLEVEL 5 goto enterSize
IF ERRORLEVEL 1 set maxHeight=MUA
IF ERRORLEVEL 2 set maxHeight=XML2
IF ERRORLEVEL 3 set maxHeight=ILQ
IF ERRORLEVEL 4 set maxHeight=IHQ
goto checkresize
:enterSize
echo.
set /p maxHeight=Enter the height in pixels for the new size: 
if %maxWidth%==different (
 echo Enter the width in pixels for the new size.
 echo It's highly recommended to have a height:width ratio of 1:1, 1:2 or 2:1.
 set /p maxWidth=Enter number, or press enter to use %maxHeight%: || set maxWidth=%maxHeight%
)
call :validateSize || goto enterSize
:askSc
echo.
echo Height: %maxHeight%
echo Width:  %maxWidth%
choice /m "Are these values correct"
if not ERRORLEVEL 2 EXIT /b
goto asksize
:validateSize
if %maxWidth%==identical set maxWidth=%maxHeight%
call :isNumber %maxHeight% && call :isNumber %maxWidth% && EXIT /b
EXIT /b 1

:i2iOptSet
set opts=
if not %maxHeight%==false set opts=optRes
if %convert%==true set opts=%opts%,optConv
if %mipmaps%==true set opts=%opts%,optMipmap
goto runOpts

:askSkinEdit
if %aSeOut%==f set "newName=%nameonly%" & set "oName=%nameonly%"
call :aSeT
if not defined 1st if %aSeAll%==a goto aSeE
set 1st=2
set rnf=all remaining input files
set iName=%aSeIn:nt=nt name/number%
if %aSeOut%==n (set oName=a number of your choice) else if %aSeAll%==a set oName=the filename
if %aSeAll%==1 set rnf="%namextns%"& if %aSeIn:~0,1%==c set "iName=%targetName%"
call :aSeO
echo To  : "%oName%"
echo.
choice /c IOSA /m "Press to switch: 'i' in (from); 'o' out (to); 's' same for all | press 'a' to accept and continue"
if errorlevel 4 goto aSeN
if errorlevel 3 call :switch aSeAll 1 a & goto askSkinEdit
if errorlevel 2 call :switch aSeOut f n & goto askSkinEdit
if errorlevel 1 call :switch aSeIn igActor01Appearance current & goto askSkinEdit
:aSeT
if defined targetName EXIT /b
if %aSeIn:~0,1%==i EXIT /b
goto getSkinName
:aSeN
if %aSeOut%==n call :aSeO & set /p newName=To  : 
set "newName=%newName:"=%"
:aSeE
if %aSeIn:~0,1%==i set "targetName=%aSeIn%"
set 1st=
EXIT /b
:aSeO
CLS
echo.
echo Rename the internal name of %rnf% ...
echo From: "%iName%"
EXIT /b

:SkinEdit
call :askSkinEdit
if /i "%targetName%"=="%newName%" EXIT /b
if /i "%targetName%"=="Bip01" EXIT /b
set opts=OptRen
goto runOptsOnI

:getSkinName
set targetName=
set opts=OptSkinStats
set "igSS=%temp%\igStatisticsSkin.ini"
if not exist "%igSS%" call :writeOS >"%igSS%"
%sgOptimizer% "%fullpath%" "%temp%\temp.igb" "%igSS%" >"%temp%\%nameonly%.txt"
for /f "tokens=1 delims=| " %%a in ('findstr /ir "ig.*Matrix.*Select" ^<"%temp%\%nameonly%.txt"') do set targetName=%%a
del "%temp%\%nameonly%.txt"
EXIT /b

:genGColorFix
set opts=optGGC
set "igGGC=%temp%\igGenerateGlobalColor.ini"
if not exist "%igGGC%" call :writeOS >"%igGGC%"
%sgOptimizer% "%fullpath%" "%fullpath%" "%igGGC%"
EXIT /b

:convert_to_igGeometryAttr2
set opts=optCGA
goto runOptsOnI

:ExtractMotionRaven
set opts=optExtrMotion
goto runOptsOnI

:igbUncombiner
REM Not using "%pathonly%", it seems like the unbundler does that already
%igbUncombiner% "%fullpath%" || goto Errors
EXIT /b

:mirror_boltons
set nodeMeta=igGeometry
findstr "igTransform" <"%fullpath%" >nul 2>nul && set nodeMeta=igTransform
set "outfile=%pathname%_mirrored%xtnsonly%"
set opts=optFlip
goto runOpts

:previewAnimations
set va=%va%"%fullpath%" 
EXIT /b
:previewAnimationsPost
start "" %insight% "%actorSkin%" %va%
EXIT /b

:listAnimations
echo Listing animations from %namextns% . . .
call :IntAnimations list >"%~dp0animLists\animList-%nameonly%.txt"
EXIT /b
:listFiles
echo %nameonly: =_%\%animname%
EXIT /b
:listAnimationsPost
copy "%~dp0animLists\*txt" "%~dp0allAnims.txt" /b
rmdir /s /q "%~dp0animLists"
EXIT /b
REM This code was used to compare powerstyle animations to cap's fightstyle_default.igb from the OCP1.3 (fightstyle animations only), and if the fighmoves are not covered by the powerstyle (powerstyle was checked separately), they are checked in the listed animations, and put to the a new list, if missing.
for %%p in ("%~dp0ps_*.xml") do for /f "usebackq delims=" %%l in (`PowerShell "$a = '%~dp0allAnims.txt'; [xml]$x = gc -raw '%%~p'; (@{anim='attack_light1';name='attacklight1'},@{anim='attack_light2';name='attacklight2'},@{anim='attack_light3';name='attacklight3'},@{anim='attack_stun2';name='attackstun_finish'},@{anim='attack_heavy1';name='attackheavy1'},@{anim='attack_knockback1';name='attack_knockback_charge'},@{anim='attack_knockback2';name='attackknockback2'} | ? {$x.powerstyle.fightmove.name -NotContains $_.name}).anim | ? {$a -NotContains $_}"`) do echo %%l>>"%~dp0missingFSDanims.txt"

:extractAnimations
set "AnimProcess=%pathonly%extract-%nameonly%.txt"
call :checktxt extract || EXIT /b
set "outpath=%~dp0%nameonly: =_%"
set "infile=%outpath%.igb"
set deli=
if /i not "%fullpath%"=="%infile%" if not exist "%infile%" copy "%fullpath%" "%infile%" & set deli=true
echo Extracting animations from %namextns% . . .
mkdir "%outpath%" >nul 2>nul
if not %exskin%==only (
 (call :writeProcFile anim)>"%AnimProcess%"
 call :animationProducer
)
if not %exskin%==false (
 (call :writeProcFile skin & call :skinSave)>"%AnimProcess%"
 call :animationProducer
)
if defined deli del "%infile%"
if %remext%==true del "%AnimProcess%"
EXIT /b
:animLoad
call :load_actor								%nameonly: =_%.igb
echo extract_skeleton						%nameonly: =_%_skel
EXIT /b
:skinLoad
echo create_actor_database					%nameonly: =_%
echo load_actor_database						%nameonly: =_%.igb
EXIT /b
:writeProcFile
echo create_animation_database				%nameonly: =_%
call :%1Load
:IntAnimations
call :EnbCompr
call :Optimizer >%optOut%
for /f tokens^=2^ delims^=^" %%a in ('findstr /b "Skipping" ^<%optOut%') do set "animname=%%a" & call :checkAnimations %1
EXIT /b
REM use this if animations are not found:
REM for /f tokens^=2^ delims^=^" %%a in ('findstr /lc:"Skipping igAnimation" %optOut%') do set "animname=%%a" & call :checkAnimations %1
REM for /f %%a in ('findstr /lc:"true  " /c:"false  " %optOut%') do set "animname=%%a" & call :checkAnimations %1
:checkAnimations
echo "%animname%" | find "uniformly constructed of igTransformSequences" >nul && echo An animation could not be processed, because it has no name>>"%erl%" && EXIT /b
if not "%animname:&=%"=="%animname%" echo "%animname%" could not be processed, because it contains "&">>"%erl%" & EXIT /b
if not "%animname: =%" == "%animname%" echo "%animname%" could not be processed, because it contains spaces>>"%erl%" & EXIT /b
if %extall%==false findstr /i "\<%animname%\>" <"%~dp0_animations.ini" >nul || EXIT /b
goto %1Files
:extrFiles
echo extract_animation						%animname%
EXIT /b
:animFiles
call :extrFiles
echo save_external_animation_database		%nameonly: =_%\%animname%.igb
:skinFiles
echo remove_animation						%animname%
EXIT /b
:skinSave
rem some fail with load_actor_database. Use below instead of load_actor_database.
rem echo load_actor								%nameonly: =_%.igb
rem echo extract_skin							%nameonly: =_%
rem echo create_actor							%nameonly: =_%
echo save_actor_database						%nameonly: =_%\skin.igb
EXIT /b
:extractAnimAllTxt
call :txtChck || EXIT /b
for /f "tokens=1*" %%a in ('findstr /bi "save" ^<"%fullpath%"') do mkdir "%%~dpb"
set "srcf=%pathonly%%nameonly:~8%.igb"
for /f "skip=2 tokens=1*" %%a in ('find "load_actor" "%fullpath%"') do set "srca=%~dp0%%b" & call :eAAT
EXIT /b 1
:eAAT
if not "%srcf%"=="%srca%" call :numberedBKP srca
move "%srcf%" "%srca%"
call :animationProducer
move "%srca%" "%srcf%"
EXIT /b

:combineAnimations
call :checktxt combine || EXIT /b
if "%skeleton%"=="%namextns%" EXIT /b
if defined outanim goto combineAnimationFiles
set "AnimProcess=%~dp0combine.txt"
for %%a in ("%pathonly:~0,-1%") do set outanim=%%~na
if %autonm%==file set "outanim=%nameonly%"
if %autonm%==false set /p outanim=Please enter the name you want to save your new animation set as (without extension). Press enter to use "%outanim%": 
set outanim=%outanim:&=_%
set outanim=%outanim: =_%
set "oa=%~dp0%outanim%.igb" & call :numberedBKP oa
set "outpath=%outanim%\"
if "%pathonly%"=="%~dp0" set outpath=
if not defined skeleton for /f "usebackq delims=" %%p in (`PowerShell "Set-Location '%~dp0'; $rp = Resolve-Path -relative '%fullpath%'; if ($rp[1] -eq '.') { $rp } else { $rp.Substring(2) }"`) do set "skeleton=%%p"
CLS
echo Creating combine list for "%outanim%" . . .
call :writeTop "%coskin: =_%" >"%AnimProcess%"
:combineAnimationFiles
if "%coskin%"=="true" find "igSkin" "%fullpath%" | findstr "\<igSkin\>" && call :loadActorDB "%namextns: =_%" >>"%AnimProcess%" && goto moveToAP
call :load_actor %outpath%%namextns% >>"%AnimProcess%"
set "animname=%nameonly%"
if %animfn%==false (
 call :IntAnimations aname
) else (
 call :anameFiles
)
:moveToAP
if not defined outpath EXIT /b
set "AP=%~dp0%outpath%%namextns%"
if "%fullpath%"=="%AP%" EXIT /b
REM This currently copies a lot of files. Mayhap, they should be moved instead, or deleted after completion.
if not exist "%~dp0%outpath%" mkdir "%~dp0%outpath%"
call :numberedBKP AP
copy "%fullpath%" "%AP%"
EXIT /b
:anameFiles
if %extall%==false call :EnbCompr & call :animNames %animname% || choice /m "'%animname%' is not in shared_anims. Continue"
if ERRORLEVEL 2 EXIT /b
for %%i in ("%coskin%") do if not "%%~ni"=="false" if "%nameonly%" == "%%~ni" EXIT /b
call :extrFiles >>"%AnimProcess%"
EXIT /b
:combineAnimationsPost
call :animCombine >>"%AnimProcess%"
goto animationProducer
:combineAnimAllTxt
call :txtChck || EXIT /b
call :animationProducer
EXIT /b 1

:writeTop
echo create_animation_database				%outanim%
if not "%~1"=="false" if %actor+%==true (
 echo create_actor_database					%outanim%
)
call :load_actor								%skeleton%
echo extract_skeleton						%outanim%_skel
echo %~1|findstr /be "false true" >nul && EXIT /b
:loadActorDB
set save=actor
set targetName=%outanim%
if %skinSr%==true call :getSkinName
if %actor+%==true (
 echo load_actor_database						%~1
) else (
 call :load_actor								%~1
 echo extract_skin							%targetName%
)
EXIT /b

:load_actor
REM load_actor (all instances of it) supports paths, but it cannot contain spaces (not in the filename either). Quotes are understood literally, so wrapping in them fails too.
if "%la%"=="%~1" EXIT /b
set la=%~1
echo load_actor								%~1
EXIT /b

:animCombine
REM if defined save <<<< Working, but it seems like animation database is better.
if %actor+%==true goto skinCombine
echo save_external_animation_database		%outanim%.igb
Exit /b
:skinCombine
REM create_actor is not required but it enables preview. Fails sometimes w/ and sometimes w/o.
echo create_actor							%outanim%
echo save_actor_database						%outanim%.igb
Exit /b

:EnbCompr
set "outfile=%fullpath%"
call :Optimizer >nul
set "outfile=%temp%\temp.igb"
EXIT /b

:checktxt
set x=1
if /i "%xtnsonly%"==".igb" set x=0
if %nevtxt%==true EXIT /b %x%
if not exist "%pathonly%%1*.txt" set t=%1
if not defined t goto asktxt
if %x%%1==0extract if exist "%AnimProcess%" goto %1AnimAllTxt
if %x%==0 EXIT /b 0
set "AnimProcess=%fullpath%"
echo "%namextns%"|findstr /bei "\"%1.*\.txt\"" >nul && goto %1AnimAllTxt
EXIT /b 1
:asktxt
if /i "%xtnsonly%" NEQ ".txt" choice /m "Do you want to use the existing %1 database (%1.txt)"
if ERRORLEVEL 2 set nevtxt=true
set t=%1
goto checktxt
:txtChck
set /p ck=<"%fullpath%"
echo %ck%|find "create_animation_database" || EXIT /b
EXIT /b 0

:animationProducer
REM the animationProducer needs the file locally and without spaces.
if "%operation%"=="extractAnimations" copy "%~dp0_combine.bat" "%outpath%" & if "%skeleton%"=="_fightstyle_default" copy "%~dp0_fightstyle_default" "%outpath%"
cd /d "%~dp0"
%animationProducer% "%AnimProcess%"
if %errorlevel% NEQ 0 goto Errors
EXIT /b

:fixSkins
rem findstr "igActorInfo" <"%fullpath%" >nul 2>nul && EXIT /b
set "of=%~dp0%nameonly: =_%.igb"
if /i "%fullpath%"=="%of%" set "of=%pathname%_scene.igb"
if exist "%of%" set "of=%pathname%_scene.igb"
%animdb2actor% "%fullpath%" "%of%"
choice /m "View %namextns%"
if not errorlevel 2 "%of%"
EXIT /b

:hud_head_e
REM PSP?, Wii?
echo PC 360 PS3 Steam X1 PS4 | find /i "%ForPltfrm%">nul || goto hud_head_PS2skinner
call :numberedBKP pathname x /i
mkdir "%pathname%"
set opts=OptExt png false true false,optConv
set "psc=$time = [float](&$ffp '%fullpath%' -show_entries format=duration -v quiet -of csv='p=0');$s = %tile_num%; $f = $s * $s; $fps = $f / $time + 0.1"
call :hud%xtnsonly%
EXIT /b

:hud_head_PS2skinner
call :PS2skinner hud_head_11101_DXT1
EXIT /b

:PS2skinner template_name
REM Only DDS at this time, and only square
set "PScmd=$im = '%~dp0res\magick.exe'; $i = '%fullpath%'; $d = $env:TEMP + '\%operation%.dds'; $w, $h = (&$im identify -ping -format '%%w %%h' $i).split(); $s = [math]::Min([math]::Pow(2, [math]::Floor([math]::Log([math]::Min($w, $h), 2))), 256).ToString(); &$im $i -resize ($s + 'x' + $s) -flip %colourswap% $d; $s"
for /f %%s in ('PowerShell "%PScmd%"') do set template=%1_%%s.igb
cd /d "%~dp0"
if not exist %template% copy res\%template% %template%
NRskinner %template% "%temp%\%operation%.dds"
set "outfile=%pathname%.igb"
call :numberedBKP outfile
move "%~dp0%template%" "%outfile%"
EXIT /b

:hud.tga
REM For 256 MUA icons, we use a TGA template and convert it to DXT1
REM set opts=%opts%,optMipmap
set w=-write "%pathname%\hud_conversation"
"%~dp0res\magick.exe" "%fullpath%" -resize 128 %w:~,-1%-1.tga" -resize 64 %w:~,-1%-2.tga" -resize 32 %w:~,-1%-3.tga" -resize 16 %w:~,-1%-4.tga" -resize 8 %w:~,-1%-5.tga" -resize 4 %w:~,-1%-6.tga" -resize 2 %w:~,-1%-7.tga" -resize 1 %w:~7,-1%-8.tga"
call :hudextract hud_head_0201 1 hud_conversation.tga
EXIT /b
:hud.gif
for /f %%f in ('^""%~dp0res\magick.exe" identify -format %%n\n -ping "%fullpath%"^"') do set f=%%f
call :SquareRoot %f% s
set /a f = %s% * %s%
"%~dp0res\magick.exe" montage "%fullpath%" -coalesce -geometry 256 -gravity center -extent 256x256 -background black -tile %s%x%s% "%pathname%\hud_conversation.png"
goto hudextanim
:hud.webm
set ffcodec=-c:v libvpx-vp9 
goto hud.mp4
:hud.png
REM For 128 MUA icons, the template is PNG compatible
if /i not "%hud_apng%"=="true" call :hudextract hud_head_0000 5 hud_conversation.png & EXIT /b
set "psc=$f = (&$ffp '%fullpath%' -count_packets -show_entries stream=r_frame_rate,nb_read_packets -v quiet -of csv='p=0').split(','); $fps = [Math]::Round((Invoke-Expression $f[0])); $f = $f[1]; $s = [Math]::Round([Math]::Sqrt($f))"
:hud.mp4
call :checkTools ffprobe
call :checkTools ffmpeg
set "ffprobe=%ffprobe:"=%"
set "ffmpeg=%ffmpeg:"=%"
for /f usebackq %%f in (`PowerShell "$ffp = '%ffprobe%'; %psc%; $vf = 'fps={0},scale=256:256,tile={1}x{1}' -f $fps, $s; &'%ffmpeg%' %ffcodec%-i '%fullpath%' -y -v error -metadata:s:v:0 alpha_mode="1" -vf $vf -frames:v $f '%pathname%\hud_conversation.png'; $s * $s"`) do set f=%%f

:hudextanim
call :isNumber %hud_apm% && if %hud_apm% GTR 0 set opts=%opts%,optAnimPM %hud_apm%
call :hudext hud_head_a%f%f%hud_fps%fps 5
EXIT /b
:hudextract - IGB template; target format; int. texture name
copy /y "%fullpath%" "%pathname%\%3"
:hudext - IGB template; target format
copy "%~dp0res\%1.igb" "%pathname%\%nameonly%.igb"
set format=RGBA_DXT%2
call :writeOS >"%pathname%\%operation:~,-2%_i.ini"
REM Injecting the images from batch fails. Has to be made manually in Finalizer.
EXIT /b

:logos_e
call :numberedBKP pathname x /i
mkdir "%pathname%"
if "%namextns%"=="power_ring.tga" EXIT /b
copy /y "%~dp0res\power_ring.tga" "%pathname%\power_ring.tga"
call :hudextract 0000 5 team.tga
EXIT /b

:stages_e
call :numberedBKP pathname x /i
mkdir "%pathname%"
set opts=OptExt png false true false,optConv
copy /y "%pathonly%\m_team_stage_circle_rows.png" "%pathname%\m_team_stage_circle_rows.png"
call :hudextract m_team_stage 1 m_team_stage_background.png
EXIT /b

:stages_anim
if not defined st_animq call :stages_animq
if %st_animq% GTR 12 (set tsl=%st_animq%) else (
  set tsl=16
  for /l %%a in (1, 1, %st_animq%) do call set /a tsl *= 2
)
call :checkTools ffprobe
call :checkTools ffmpeg
set "ffprobe=%ffprobe:"=%"
set "ffmpeg=%ffmpeg:"=%"
set "stage_igb=%~dp0m_team_stage.igb"
call :numberedBKP stage_igb /i
copy "%~dp0res\m_team_stage.igb" "%stage_igb%"
if "%~n0"=="m_team_stage_circle" call :stages_anim_create %~n0 64 1
if "%~n0"=="m_team_stage_background" call :stages_anim_create %~n0 50 2
EXIT /b
:stages_animq
CLS
set /p st_animq=Enter a quality for the animated texture (0 to 10): || goto stages_animq
if %st_animq% LSS 0  goto stages_animq
if %st_animq% GTR 10 goto stages_animq
EXIT /b
:stages_anim_create texture_name frames ratio.w
PowerShell "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('en-US'); $culture.NumberFormat.NumberDecimalSeparator = '.'; [System.Threading.Thread]::CurrentThread.CurrentCulture = $culture; $time = [float](&'%ffprobe%' '%fullpath%' -show_entries format=duration -v quiet -of csv='p=0'); $f = %2; $s = [int]([Math]::Sqrt($f * %3)); if ($s %% %3 -ne 0) { $s += 1 }; $fps = $f / $time + 0.1; $vf = 'fps={0},scale={1}:{2},tile={3}x{4},scale={5}:{5}' -f $fps, (%tsl% / ($s / %3)), (%tsl% / $s), ($s / %3), $s, %tsl%; &'%ffmpeg%' %ffcodec%-i '%fullpath%' -y -v error -metadata:s:v:0 alpha_mode='1' -vf $vf -frames:v $f '%~dp0%~1.png'"
EXIT /b
REM vflip,

:CSP_XML2
call :PS2skinner CSP_11101_DXT1
EXIT /b


:Maps
for /d %%a in ("%pathonly%\*") do goto askSubfolder
goto Mchck
:askSubfolder
if %SubfoldAuto%==ask (
 choice /m "Do you want to search subfolders for textures as well"
 if errorlevel 2 (set SubfoldAuto=false) else set SubfoldAuto=true
)
:Mchck
call :rec%SubfoldAuto:ask=false%
if ""=="%oo%" (
 set oo=done
 copy /y "%fullpath:~,-4%.ini" %optSet% >nul
 copy /y "%pathonly%%operation%.ini" %optSet% >nul
 call :Mset && choice /m "Optimization set found (%operation%.ini). Do you want to apply it on all input files"
 if not errorlevel 2 goto Mapply
)
if %MultiInputA%==true goto MapsMain
set /a c+=1
echo "%fullpath%">>"%tem%"
EXIT /b
:Mset
if exist %optSet% (
 call :MTitle
 type %optSet%
 echo.
 EXIT /b 0
)
EXIT /b 2
:Mapply
copy /y %optSet% %optSetT%
call :chkConvert
set operation=addNewTextures
goto addNewTextures

:MapsPost
if ""=="%c%" EXIT /b
if %c% GTR 1 call :IGBselect
for /f "usebackq delims=" %%i in ("%tem%") do set "fullpath=%%~fi" & call :MapsMain
EXIT /b

:MTitle
CLS
echo.
echo --------------------------------------------
echo   Raven: Setup MUA Material for Alchemy 5
echo --------------------------------------------
echo.
EXIT /b

:IGBselect
call :MTitle
echo Multiple input files found:
type "%tem%"
echo.
set /p input=Enter the name of the file you want to process, or press enter to process all files: || EXIT /b
for /f "usebackq delims=" %%i in ("%tem%") do echo "%%~nxi" | find /i "%input%" && echo "%%~fi">"%tem%" && EXIT /b
goto IGBselect

:MapsMain
call :filesetup
if defined options (
 timeout 1
 call :Mset && choice /m "Do you want to add the same textures to '%namextns%'"
 if not errorlevel 2 goto addNewTextures
)
set done= 
set dc=0
set /a sv+=1
REM Write internal texture info to "%tem%" and call the dialogue
set "subf=%pathonly%" & if %SubfoldAuto%==true set subf=
del "%tem%" "%tem:~,-4%T.txt" "%tem:~,-4%N.txt" %optSetT% 2>nul
call :fTi 0x00000111
for /f "tokens=1,3 delims=|" %%a in ('findstr "%igTF%" ^<%optOut%') do set mi=%%b & call :filterDiff %%a
if %dc%==1 call :MapSelect 0 & goto mapsWO
set to=0123456789
call set options=%%to:~,%dc%%%
call :mapsD
:mapsWO
set oc=0
for %%d in (%done%) do call :mapsR %%d && call :mapsWTO OptRSMUAMat
call :chkConvert
if %mipmaps%==true call :mapsWTO optMipmap
(call :OptHead %oc% & type %optSetT%) >%optSet%
:addNewTextures
set outfile=
call :MTitle
echo Enter a name to save "%nameonly%" as (existing files will be replaced).
set /p outfile=Enter a name or press enter to update "%namextns%": 
if defined outfile (set "outfile=%pathonly%%outfile%.igb") else (set "outfile=%fullpath%")
if exist "%outfile:~,-4%.ini" goto Optimizer
choice /m "Save the optimization set as well"
if not errorlevel 2 copy %optSet% "%outfile:~,-4%.ini"
goto Optimizer
:chkConvert
call :chkC N 5 Normal
call :chkC T %ConvertDDSf:false=1% Specular Environment Emissive
EXIT /b
:chkC
set "convertlist=%tem:~,-4%%1.txt"
set any=0
set tx=%*
for %%d in (%done%) do for %%m in (%tx:~4%) do if defined %%m%%d call :chkCmap %1 %%m%%d
if %any%==0 EXIT /b
set isExclude=include
set format=RGBA_DXT%2
call :mapsWTO optConv
EXIT /b
:chkFrmt
if /i "%1"==".dds" EXIT /b 1
if %2==N EXIT /b 0
if /i "%1"==".png" if %ConvertDDSf%==false EXIT /b 1
EXIT /b 0
:chkCmap
call set txc="%%%2%%" 
for %%t in (%txc%) do call :chkFrmt %%~xt %1 && echo %%~nxt>>"%convertlist%" && set /a any+=1
EXIT /b

:mapsD
set dc=0
call :MTitle
echo "%namextns%":
echo.
echo Select the number of a diffuse texture to add texture maps to.
echo Ask for help, if you are unsure about diffuse textures.
echo.
for /f "usebackq delims=" %%a in ("%tem%") do call :printDiff %%a
echo.
if defined duplicate (
 echo  WARNING: Duplicate texture names found. They must be the identical texture. 
 echo           If you think it's possible that this is not the case, abort now,
 echo           and rename one or both textures.
 echo.
 set duplicate=
)
choice /c A%options% /m "Press 'A' to accept and continue."
if %errorlevel%==1 EXIT /b
set /a d=%errorlevel%-2
call :MapSelect %d%
goto mapsD
:printDiff
set nr=%dc%.
set sfx=
if %dc% GTR 9 ( set nr=  & set sfx=^(unable to modify^)
) else echo %done% | find "%dc%" >nul && set sfx=-- Done
echo %nr% %* %sfx%
set /a dc+=1
EXIT /b
:filterDiff
echo %mi%|find /i "Mip"|find /i /v "Mip00" >nul && EXIT /b
if exist "%tem%" findstr /bei /c:"%*" <"%tem%" >nul && set duplicate=found
echo %*>> "%tem%"
set /a dc+=1
EXIT /b

:MapSelect
call :mapsR %1
:mapsM
if defined Environment (set "ER=%Environment%") else set "ER=%reflectance%"
if not defined reflectance set reflectance=0.000000
call :MTitle
echo "%namextns%":
echo.
echo 0. Diffuse:      %intTex%
echo.
echo Select a number to add or replace a texture map.
echo.
echo 1. Normal:       "%Normal%"
echo 2. Specular:     "%Specular%"
echo 3. Env. cubemap: "%reflectionR%"
if defined reflectionL echo                  "%reflectionL%"
if defined reflectionB echo                  "%reflectionB%"
if defined reflectionF echo                  "%reflectionF%"
if defined reflectionU echo                  "%reflectionU%"
if defined reflectionD echo                  "%reflectionD%"
echo 4. Env. mask:    "%ER%"
echo 5. Emissive:     "%Emissive%"
echo.
choice /c 1245A /m "Press 'A' to accept and continue."
goto map%errorlevel%
:map1
call :askTexMaps N Normal Normal " (Bump map)"
goto mapsM
:map2
call :askTexMaps T Specular Specular
goto mapsM
:map3
call :askTexMaps T Environment Environment " (reflections)"
call :askReflectance
goto mapsM
:map4
call :askTexMaps T Emissive Emissive " (gloss/illuminating)"
goto mapsM
:map5
call set done=%%done: %1=%% %1
call :mapsS %sv%%1
EXIT /b
:askTexMaps
echo.
echo Texture files found:
echo - INFORMATION: Must provide full path if no files found -
for %%e in (png, tga, dds, jpg, bmp) do for /f "delims=" %%t in ('dir "%pathonly%*.%%e" 2^>nul ') do echo %%~nxt
:aTMnL
set %3=
echo.
echo Press enter to skip.
echo Enter the name of the texture to be added as ...
set /p map=%~2 map%~4: || EXIT /b
call :stripQ map
echo "%map:~,2%" | findstr /l "\\\\ :" >nul && goto isFullPath
for %%e in (png, tga, dds, jpg, bmp) do for /f "delims=" %%t in ('dir "%pathonly%*.%%e" 2^>nul ') do echo %%~nxt | find /i "%map%" && set "map=%subf%%%~t" && goto isFullPath
goto aTMnL
:isFullPath
set "%3=%map%"
EXIT /b 0
:askReflectance
if defined Environment goto CubeMaps
echo.
echo Press enter to skip.
echo Enter a number for an environment mask with an even reflection of a percentual intensity, based on the entered value. Example: 20.1  [=20.1%%]
set /p reflectance=Enter a number between 0 and 100: || EXIT /b
for /f usebackq %%r in (`PowerShell "try {[decimal]$t = '%reflectance%'} catch {exit}; if ($t -ge 0 -and $t -le 100) {[string]$t = $t/100; if (!$t.Contains('.')) {$t += '.'}; $t.PadRight(8,'0').Substring(0,8)}"`) do set reflectance=%%r& goto CubeMaps
goto askReflectance
:CubeMaps
for %%r in (R:Right L:Left B:Back F:Front U:Top D:Bottom) do for /f "tokens=1* delims=:" %%a in ("%%r") do call :askCubeMaps %%a %%b && EXIT /b
EXIT /b 0
:askCubeMaps
call :aTMnL "" "%2 side cube" reflection%1 " (reflection cube/sphere)" || EXIT /b 0
if %1 NEQ R EXIT /b 1
echo.
choice /m "Do you want to use the same texture for all sides"
if errorlevel 2 EXIT /b 1
for %%r in (L, B, F, U, D) do set "reflection%%r=%reflectionR%"
EXIT /b 0
:mapsS
set s=
set r=%1
if "%2"=="" set r=&set s=%1
for %%m in (Normal Specular reflectionR reflectionL reflectionB reflectionF reflectionU reflectionD Environment reflectance Emissive) do call set "%%m%s%=%%%%m%r%%%"
EXIT /b
:mapsR
call :mapsS %sv%%1 restore
set skip=
if %1 GTR 0 set skip=skip=%1
for /f "usebackq %skip% delims=" %%a in ("%tem%") do (
 set intTex=%%~na
 EXIT /b
)
EXIT /b

:mapsWTO
set /a oc+=1
echo [OPTIMIZATION%oc%]>>%optSetT%
call :%1 >>%optSetT% 2>nul
EXIT /b


:checkExist extension
set "%1=%pathname%.%1"
:numberedBKP var
if %askbackup%==replace EXIT /b 0
call set "NB=%%%1%%"
if not exist "%NB%" EXIT /b 0
set /a n+=1
if exist "%NB%.%n%.bak" goto numberedBKP
if %askbackup%==true (
 choice /m "'%NB%' exists already. Do you want to make a backup"
 if ERRORLEVEL 2 EXIT /b
)
%2copy "%NB%" "%NB%.%n%.bak" %3
set n=0
EXIT /b 0

:removeSpaces
set "infile=%pathonly%%nameonly: =_%%xtnsonly%"
call :numberedBKP infile
copy "%fullpath%" "%infile%"
EXIT /b

:remSpacesLT
set noSpace=%*
EXIT /b

:stripQ
if defined %1 call set "%1=%%%1:"=%%"
EXIT /b

:toLower
call set "_in=%%%1%%"
for %%g in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do call set _in=%%_in:%%g=%%g%%
set "%1=%_in%"
EXIT /b

:toUpper
call set "_in=%%%1%%"
for %%g in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do call set _in=%%_in:%%g=%%g%%
set "%1=%_in%"
EXIT /b

:isNumber string
for /f "delims=0123456789" %%i in ("%*") do EXIT /b 1
EXIT /b 0

:SquareRoot
set root=1
:SRLoop
set /a sqr = %root% * %root%
if %sqr% GEQ %1 set %2=%root%&& EXIT /b
set /a root = %root% + 1
goto SRLoop

:switchBool
call :switch %1 true false
EXIT /b
:switch
call echo "%%%1%%" | find "%~2" && set "%1=%~3" || set "%1=%~2"
EXIT /b

:askallD
echo Ask again for the next input file (Press '%2' to switch)
call echo %%%1%%
echo.
EXIT /b


:writeOptSet
call :writeOS >%optSet%
EXIT /b
:writeOS
set c=0
for %%o in (%opts: =_%) do set /a c+=1
if %c%==0 EXIT /b 1
call :OptHead %c%
for /l %%i in (1,1,%c%) do call :writeOpts %%i
EXIT /b
:writeOpts
set i=%1
echo [OPTIMIZATION%1]
for /f "tokens=%i% delims=," %%o in ("%opts%") do for /f "tokens=1*" %%a in ("%%o") do call :%%a %%b
EXIT /b
:runOptsOnI
set "outfile=%infile%"
:runOpts
call :writeOS >%optSet%
set createINI=false
set targetName=

:Optimizer
%sgOptimizer% "%infile%" "%outfile%" %optSet% || goto Errors
EXIT /b

:optHead
echo [OPTIMIZE]
echo optimizationCount = %1
echo hierarchyCheck = true
EXIT /b
REM file names have to be echoed to sets, can cause errors on certain paths

:OptExt
echo name = igImageExternal
echo forceExternalUsage = %2
echo forceInternalImage = %3
echo extension = %1
echo imageSubDirectory = %sfolder%
echo enummerateSameNamedImages = %4
EXIT /b

:optConv
echo %format% | find /i "DXT" >nul && set "order=DX" || set "order=DEFAULT"
echo name = igConvertImage
echo format = %igTF%%format%
echo sourceFormat = invalid
echo order = IG_GFX_IMAGE_ORDER_%order%
echo isExclude = %isExclude%
echo convertIfSmaller = false
echo imageListFilename = %convertlist%
EXIT /b

:optRes
echo name = igResizeImage
echo widthFactor = -1
echo heightFactor = -1
echo minHeight = 1
echo minWidth = 1
echo maxHeight = %maxHeight%
echo maxWidth = %maxWidth%
echo resizeMipmap = false
echo useNextPowerOfTwo = false
echo filterType = 4
REM Filter LANCZOS3 (4) gives the best result for sharpness, without being too much.
REM Filter TRIANGLE (1) gives nice results with less sharpness, sometimes better non-straight lines.
REM Filter NEAREST (7) is the sharpest that looks best on high quality, non-stretched images.
REM Filter GAUSSIAN (6) is the most blurry, and results are usually too lq.
REM Other filters are between 4 and 6 (most between 4 and 1).
EXIT /b

:optMipmap
echo name = igUseMipmap
echo filterType = 6
echo mipmapTaggedOnly = false
echo minFilter = NearestMipmapLinear
echo magFilter = Linear
echo isExclude = exclude
echo minSize = 1
echo imageListFilename = 
EXIT /b

:optRemMM
echo name = igRemoveMipMaps
EXIT /b

:OptGeoInfo
echo name = igStatisticsGeometry
goto OptInfo
:OptTexInfo
echo name = igStatisticsTexture
echo useFullPath = false
:OptInfo
echo separatorString = ^|
echo columnMaxWidth = -1
echo showColumnsMask = %1
echo sortColumn = -1
EXIT /b

:OptSkinStats
echo name = igStatisticsSkin
call :OptInfo 0x00000006
EXIT /b

:OptRen
echo name = igChangeObjectName
echo objectTypeName = igNamedObject
echo targetName = %targetName%$
echo newName = %newName%
REM Unknown how to define beginning of line in Alchemy regex
REM targetMeta = igSkin doesn't work
EXIT /b

:optGGC
echo name = igGenerateGlobalColor
EXIT /b

:optCGA
echo name = igConvertGeometryAttr
echo accessMode = 3
echo storeBoundingVolume = false
EXIT /b

:optExtrMotion
echo name = ExtractMotionRaven
EXIT /b

:optAnimExt
echo name = igEnbayaCompressAnimations
echo quantizationError = 0.0001
echo sampleRate = -1
echo forceTrackCount = -1
echo printStatistics = true
echo ignoreBones = Motion
echo specialCaseIniFilename = 
echo separator = :
echo sortColumn = -1
EXIT /b

:optCombAnimDB
echo name = igCombineAnimDatabases
echo contextFileListString = 
echo includedSkeletonListString = .*
echo includedSkinListString = .*
echo includedAnimationListString = .*
echo includedAppearanceListString = 
echo resetAnimationBindings = true
echo createDefaultActor = true
echo defaultSkeleton = 
echo defaultSkin = 
echo defaultAnimation = 
EXIT /b

:optAnimPM
echo name = igChangePlayMode
echo playMode = %1 
EXIT /b

:optFlip
call :optTransform "su-1 rz180"
EXIT /b

:optTransform
echo name = igCreateTransform
echo nodeMeta = %nodeMeta%
echo nodeName = 
echo matrixString = %~1
EXIT /b

:optStripTri
echo name = igStripTriangles
echo minNumberOfTriangle = 5
echo stitch = false
echo strip = %1
echo index = %2
echo compactGeometry = false
EXIT /b

:optActorSkins
echo name = igOptimizeActorSkinsInScenes
echo fileName = %optSetT:"=%
echo applySkinLocal = false
EXIT /b

:OptRSMUAMat
echo name = igRavenSetupMUAMaterial
echo diffuseMapName = %intTex:&=^&%
echo normalMap = %Normal:&=^&%
echo specularMap = %Specular:&=^&%
echo reflectionMapRight = %reflectionR:&=^&%
echo reflectionMapLeft = %reflectionL:&=^&%
echo reflectionMapBack = %reflectionB:&=^&%
echo reflectionMapFront = %reflectionF:&=^&%
echo reflectionMapUp = %reflectionU:&=^&%
echo reflectionMapDown = %reflectionD:&=^&%
echo reflectance = %reflectance:&=^&%
echo reflectionMaskMap = %Environment:&=^&%
echo emissiveMap = %Emissive:&=^&%
echo generateTangentBinormals = true
EXIT /b

:i2iSettings
echo [image2igb]
echo linear = %MagFilter%
echo clamp = %WrapST%
EXIT /b

:IGBimgFormats
if "%format%" == "TILED_X_4_PSP" (
 set format=L_8
 set desc=Intensity aka grayscale image with 8 bits ^(1 channel^) - no transparency supported
) else if "%format%" == "L_8" (
 set format=A_8
 set desc=Alpha channel only, with 8 bits
) else if "%format%" == "A_8" (
 set format=LA_44_8
 set desc=Intensity aka grayscale image with alpha channel and 4 bits per channel
) else if "%format%" == "LA_44_8" (
 set format=LA_88_16
 set desc=Intensity aka grayscale image with alpha channel and 8 bits per channel
) else if "%format%" == "LA_88_16" (
 set format=RGB_332_8
 set desc=RGB ^(Red Green Blue channels^) 8bit image with 3 and 2 bits per channel - no transparency supported
) else if "%format%" == "RGB_332_8" (
 set format=RGB_888_24
 set desc=RGB ^(Red Green Blue channels^) 24bit image with 8 bits per channel - no transparency supported
) else if "%format%" == "RGB_888_24" (
 set format=RGBA_2222_8
 set desc=RGBA ^(Red Green Blue Alpha channels^) 8bit image with 2 bits per channel - PNG
) else if "%format%" == "RGBA_2222_8" (
 set format=RGBA_4444_16
 set desc=RGBA ^(Red Green Blue Alpha channels^) 16bit image with 4 bits per channel - PNG
) else if "%format%" == "RGBA_4444_16" (
 set format=RGBA_8888_32
 set desc=RGBA ^(Red Green Blue Alpha channels^) 32bit image with 8 bits per channel - PNG
) else if "%format%" == "RGBA_8888_32" (
 set format=RGB_565_16
 set desc=RGB ^(Red Green Blue channels^) 16 bit image with 5 and 6 bits per channel - no transparency supported
) else if "%format%" == "RGB_565_16" (
 set format=RGBA_5551_16
 set desc=RGBA ^(Red Green Blue Alpha channels^) 16 bit image with 5 and 1 bits per channel - PNG
) else if "%format%" == "RGBA_5551_16" (
 set format=X_8
 set desc=Indexed color image with 8 bits - limited transparency
) else if "%format%" == "X_8" (
 set format=X_4
 set desc=Indexed color image with 4 bits - limited transparency
) else if "%format%" == "X_4" (
 set format=RGBA_DXT1
 set desc=DirectX texture 1 ^(Red Green Blue Alpha channels^) for textured 3d objects - DDS - transparency not fully supported
) else if "%format%" == "RGBA_DXT1" (
 set format=RGBA_DXT3
 set desc=DirectX texture 2 ^(Red Green Blue Alpha channels^) for textured 3d objects - DDS
) else if "%format%" == "RGBA_DXT3" (
 set format=RGBA_DXT5
 set desc=DirectX texture 3 ^(Red Green Blue Alpha channels^) for textured 3d objects with best alpha channel support - DDS
) else if "%format%" == "RGBA_DXT5" (
 set format=TILED_DXT1_GAMECUBE
 set desc=DirectX texture 1 ^(Red Green Blue Alpha channels^) for textured 3d objects on Gamecube and Wii consoles - DDS - transparency not fully supported
) else if "%format%" == "TILED_DXT1_GAMECUBE" (
 set format=TILED_RGBA_5553_16_GAMECUBE
 set desc=RGBA ^(Red Green Blue Alpha channels^) 16bit image with 5 and 3 bits per channel for Gamecube and Wii consoles - PNG - please give me a message if you know more
) else if "%format%" == "TILED_RGBA_5553_16_GAMECUBE" (
 set format=TILED_RGB_565_16_GAMECUBE
 set desc=RGB ^(Red Green Blue channels^) 16bit image with 5 and 6 bits per channel for Gamecube and Wii consoles - no transparency supported
) else if "%format%" == "TILED_RGB_565_16_GAMECUBE" (
 set format=TILED_L_8_GAMECUBE
 set desc=Intensity aka grayscale image with 8 bits ^(1 channel^) for Gamecube and Wii consoles - no transparency supported
) else if "%format%" == "TILED_L_8_GAMECUBE" (
 set format=TILED_LA_88_16_GAMECUBE
 set desc=Intensity aka grayscale image with alpha channel and 8 bits per channel for Gamecube and Wii consoles
) else if "%format%" == "TILED_LA_88_16_GAMECUBE" (
 set format=TILED_LA_44_8_GAMECUBE
 set desc=Intensity aka grayscale image with alpha channel and 4 bits per channel for Gamecube and Wii consoles
) else if "%format%" == "TILED_LA_44_8_GAMECUBE" (
 set format=RGBA_128F
 set desc=Unknown - please give me a message if you know more
) else if "%format%" == "RGBA_128F" (
 set format=TILED_X_8_PSP
 set desc=Indexed color image with 8 bits for PSP - limited transparency
) else if "%format%" == "TILED_X_8_PSP" (
 set format=TILED_X_4_PSP
 set desc=Indexed color image with 4 bits for PSP - limited transparency
)
EXIT /b

:animNames anim
echo :step_forward:ground_attack1:ground_attack2:attack_heavy1:attack_heavy2:jump_attack1:jump_attack2:attack_jumpslam:jump_smash_loop:jump_smash:jump_smash_hold:attack_knockback:attack_knockback1:attack_knockback2:attack_light1:attack_light2:attack_light3:attack_popup1:attack_popup2:attack_stun1:attack_stun2:attack_stun3:attack_trip1:attack_trip2:block:blocking:bored_1_1:bored_1_2:bored_1_3:bored_1_4:bored_loop_1:clingwall_backflip:crouch_end:crouch_idle:crouch_start:jumpdouble_start:evade_backwards:evade_forwardroll:evade_left:evade_right:fall_FeetFirst:fly_fast:fly_idle:fly_slow:flying_attack1:flying_attack2:flyingback_getup:getup_attack_faceup:flyingforward_getup:getup_attack_facedown:grab_attack:grab_attack_finisher:grabbed_attack:grab_break:grabbed_break:grab_fallback:grab_loop:grabbed_loop:grab_smash:grabbed_smash:grab_attempt:grabbed_attempt:throw_ally_hero:throw_ally_ally:grab_throw_back:grabbed_throw_back:grab_throw_forward:grabbed_throw_forward:grab_throw_left:grabbed_throw_left:grab_throw_right:grabbed_throw_right:slamfront_slump:slamback_slump:idle:idle_to_bored:jump_attack_land:jump_land:jump_loop:jump_smash_land:jump_start:flyingback_loop:flyingforward_loop:death_gen:NO_ANIM:NO_ANIM:flyingback_landloop:slamback_getup:flyingforward_landloop:levelup:lunge_loop:lunge_land:lunge_offwall:menu_action:menu_goodbye:menu_idle:pain_airFeetfirst:pain_airHeadfirst:pain_InAirSpin:pain_rear:pain_blocking:pain_electric:groundpain_back:groundpain_forward:pain_high:pain_low:twitch_left:twitch_right:pickup_object_idle:pickup_object_lift:pickup_object_start:pickup_object_throw:pickup_object_walk:popup_break:popup_bounce:popup_loop:popup:power_1:power_10:power_11:power_12:power_13:power_14:power_15:power_16:power_17:power_18:power_19:power_1_end:power_1_loop:power_1_start:power_2:power_20:power_2_end:power_2_loop:power_3:power_3_end:power_3_loop:power_4:power_4_end:power_4_loop:power_5:power_5_end:power_6:power_7:power_8:power_8_end:power_8_loop:power_8_start:power_9:psylift:telekinesis_victim:push_heavy_object:push_heavy_object_fail:resist_knockback:resist_popup:resist_stun:resist_trip:resurrect_v:step_backward:run:spin_left:spin_right:run_sprint:step_left:step_right:sticky_floor:stun:talking_01:talking_02:talking_03:talking_04:telebuddy_grab:telebuddy_land:telebuddy_loop:slamback_loop:flyingback_land:flyingback_loop:slamfront_loop:flyingforward_land:flyingforward_loop:grabbed_throw:grabbed_throwland:grabbed_throwloop:tpose:trip:grabbed_throwslam:grabbed_throwslump:grabbed_throwslumpland:use_button:victim1:victim10:victim11:victim12:victim2:victim3:victim4:victim5:victim6:victim7:victim8:victim9:walk:zone1:zone10:zone11:zone12:zone13:zone14:zone15:zone16:zone17:zone18:zone19:zone2:zone20:zone21:zone22:zone23:zone24:zone25:zone3:zone4:zone5:zone6:zone7:zone8:zone9:menu_kowned: | find /i ":%*:" >nul || EXIT /b
EXIT /b 0

:checkTools program
if "%IG_ROOT%"=="" cd /d "%~dp0" & if not exist "%~dp0libIGCore.dll" echo The IG_ROOT variable is not defined. Please check your Alchemy 5 installation. & goto Errors
if exist "%~dp0%1.exe" set %1="%~dp0%1.exe"
if not defined %1 for /f "delims=" %%a in ('where %1.exe 2^>nul') do set %1=%1
if not defined %1 if exist "%IG_ROOT%\bin\%1.exe" set %1="%IG_ROOT%\bin\%1.exe"
set x=1
if defined %1 set x=0
if defined VVreg EXIT /b %x%
set VVreg=HKCU\Software\vicarious visions\driver
for /f "skip=2 tokens=1-3" %%r in ('reg query "%VVreg%" 2^>nul') do if %%t LSS 10000 reg delete "%VVreg%" /f & reg add "%VVreg%" /v %%r /t REG_DWORD /d 1 /f >nul 2>nul
EXIT /b %x%


:End
if defined any call :%operation%Post
CLS
for %%e in ("%erl%") do if %%~ze GTR 0 goto Errors
del "%erl%"
goto cleanup
:Errors
echo.
echo There was an error in the process. Check the error description.
if exist "%erl%" (
 echo.
 type "%erl%"
)
pause
:cleanup
del "%tem%" "%temp%\temp.igb" "%tem:~,-4%N.txt" "%tem:~,-4%T.txt" %optOut%
if %delOptSets%==false EXIT
del %optSet% %optSetT%
if %delOptSets%==true EXIT
del "%igGGC%" "%igSS%"
EXIT