@echo off
REM chcp 65001 >nul

REM -----------------------------------------------------------------------------

REM Settings:

REM What operation should be made? (=IGBconverter; extract images =Extract; =image2igb; hex edit skins =SkinEdit; generate GlobalColor (fix black status effect) =genGColorFix; =previewAnimations; =extractAnimations; =combineAnimations; =listAnimations; make HUD heads from images =hud_head_e; same for team logos =logos_e; =convert_to_igGeometryAttr2; Texture Map Editor =Maps; write igSceneInfo =fixSkins; =ask)
set operation=Maps
REM Create mip-maps? (=true or =false), useful for lower resolutions only - to ask for each input file, use =ask at the operation settings
set mipmaps=false
REM Remove optimization sets? (Yes =true; No =false; Remove useful ones as well =all)
set delOptSets=true
REM Remove the input files when done? (Yes =true; No =false)
REM WARNING! Don't set it to =true, unless you're 100% sure you don't need them anymore.
set delInputFiles=false

REM IGBconverter settings (detects actorConverter):
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

REM image2igb settings:
REM Prompt for conversion? (ask for all exc. dds =true; ask for all exc. png+dds =false; no conversion =never; ask for all + dds =dds)
REM Always convert all, except png+dds. (to DDS DXT1 =dxt1; to DDS DXT5 =dxt5)
REM Force conversion of all files (to DDS DXT1 =fdxt1; to DDS DXT5 =fdxt5; to other formats, as defined below, eg. =IG_GFX_TEXTURE_FORMAT_RGBA_5551_16)
set askconv=dxt1
REM Force conversion to one of the following formats (use the format as option in the askconv= setting above):
REM -- rgb formats for icons and effect textures
REM IG_GFX_TEXTURE_FORMAT_RGBA_4444_16
REM IG_GFX_TEXTURE_FORMAT_RGBA_8888_32
REM IG_GFX_TEXTURE_FORMAT_RGBA_2222_8
REM IG_GFX_TEXTURE_FORMAT_RGBA_5551_16   (default)
REM IG_GFX_TEXTURE_FORMAT_RGBA_128F
REM -- dxt textures for most model (skin, boltons, etc) textures
REM IG_GFX_TEXTURE_FORMAT_RGBA_DXT1
REM IG_GFX_TEXTURE_FORMAT_RGBA_DXT3
REM IG_GFX_TEXTURE_FORMAT_RGBA_DXT5
REM -- gamecube textures
REM IG_GFX_TEXTURE_FORMAT_TILED_DXT1_GAMECUBE          (seems not to work, use normal DXT1 instead)
REM IG_GFX_TEXTURE_FORMAT_TILED_RGBA_5553_16_GAMECUBE
REM IG_GFX_TEXTURE_FORMAT_TILED_L_8_GAMECUBE
REM IG_GFX_TEXTURE_FORMAT_TILED_LA_88_16_GAMECUBE
REM IG_GFX_TEXTURE_FORMAT_TILED_LA_44_8_GAMECUBE
REM -- rgb formats without transparency
REM IG_GFX_TEXTURE_FORMAT_RGB_332_8
REM IG_GFX_TEXTURE_FORMAT_RGB_888_24
REM IG_GFX_TEXTURE_FORMAT_RGB_565_16
REM IG_GFX_TEXTURE_FORMAT_TILED_RGB_565_16_GAMECUBE
REM -- indexed color formats
REM IG_GFX_TEXTURE_FORMAT_X_8
REM IG_GFX_TEXTURE_FORMAT_X_4
REM IG_GFX_TEXTURE_FORMAT_TILED_X_8_PSP
REM IG_GFX_TEXTURE_FORMAT_TILED_X_4_PSP
REM -- intensity/grayscale formats
REM IG_GFX_TEXTURE_FORMAT_L_8
REM IG_GFX_TEXTURE_FORMAT_LA_44_8
REM IG_GFX_TEXTURE_FORMAT_LA_88_16
REM IG_GFX_TEXTURE_FORMAT_A_8
REM -- reset: =IG_GFX_TEXTURE_FORMAT_INVALID
REM -- example:
REM set askconv=IG_GFX_TEXTURE_FORMAT_RGBA_8888_32
REM -- 
REM Force asking to convert PNG. (=true; =false)
set askpng=false
REM Resize? (no resize =false; to loading screens for Ultimate Alliance 2048x1024 =MUA, for X-Men Legends 2 512x512 =XML2; icons for last-gen consoles 128x128 =ILQ; icons for PC & next-gen consoles 256x256 =IHQ; prompt for each file =ask)
REM Custom resize values possible (eg. 1024x1024 =1024; 100x100 =100)
set maxHeight=false
REM Custom width, to be used with custom height (eg. 64x64 =same & maxHeight=64; 1024x512 =1024 & maxHeight=512)
set maxWidth=same
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
REM Do you want to risk that existing files are replaced? (Yes =true; No =false)
set unsafe=false
REM Always use the first folder name when combining animations? (Yes =true; No =false)
set autonm=false
REM Enter an IGB file for the skeleton. (Use the first input file "skeleton="; use fightstyle default incl. ponytail =_fightstyle_default)
REM Can include path relative to the BAT. Eg. skeleton=skeletons\humanWponytail\elektra.igb
set skeleton=_fightstyle_default
REM Extract skin? (Yes =true; Skin only =only; No =false)
set exskin=false
REM Combine skin? (Yes, specify the skin IGB, eg. =subfolder\skin.igb; No =false)
set coskin=false

REM Texture Map Editor settings:
REM Convert PNG to DXT/DDS? Ideal for PC. (yes =true; no =false)
set ConvertPNGs=true
REM Convert to DXT1 or DXT3? (Normal maps are always DXT5) (DXT1 =1; DXT3 =3)
set ConvertDDSf=1
REM List all images in subfolders? (yes, always =true; no, root folder only =false; ask once =ask)
set SubfoldAuto=true
REM Always process all input files (IGB)?  (Yes =true; No, asks first =false)
set MultiInputA=false
REM Always process all textures? (Yes, asks each texture =true; No, asks first =false)
set MultiTextAl=false

REM -----------------------------------------------------------------------------

REM these are automatic settings, don't edit them:
if "%operation%" == "ask" call :opswitcher
set inext=.igb
set optSet="%~dp0%operation%.ini"
set optSetT="%~dp0%operation%T.ini"
set tmp="%~dp0tempN.txt"
set "TC=%~dp0tempC"
call :start%operation% 2>nul
if %errorlevel% NEQ 0 call :sgO
if "%unsafe%" == "false" (set unsafe=-) else set unsafe=
if exist "%~dp0error.log" del "%~dp0error.log"
if exist %tmp% del %tmp%
set "askallsw=Ask for the next input file again"

set "outfile=%~dp0temp.igb"
set isExclude=exclude
for %%p in (%*) do goto isnotbatch

:isbatch
set "f=%~dp0"
set "fullpath=%f:~0,-1%"
call :isfolder
GOTO End

:isnotbatch
if not defined inall call :convCCL inall
for %%p in (%inall%) do (
 set fullpath=%%~p
 2>nul pushd "%%~p" && call :isfolder || call :isfiles
)
GOTO End

:isfolder
for %%e in (%inext%) do for /f "delims=" %%i in ('dir /b "%fullpath%\*%%e" 2^>nul') do if /i not "%fullpath%\%%~i" == "%outfile%" if /i "%%~xi" == "%%e" (
 set "fullpath=%fullpath%\%%~i"
 call :filesetup
 call :%operation%
 call :delInFiles
)
EXIT /b

:isfiles
call :filesetup
for %%e in (%inext%) do if /i "%xtnsonly%" == "%%e" call :%operation%
call :delInFiles
EXIT /b

:convCCL
set "i=%cmdcmdline:"=""%"
set "i=%i:*"" =%"
set "i=%i:~0,-2%"
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
EXIT /b

:test
echo %namextns%
pause
EXIT /b


:startimage2igb
call :checkTools image2igb || EXIT
set inext=.dds, .png, .tga, .jpg, .bmp, .igt
goto sgO
:startSkinEdit
set aSeIn=igActor01Appearance
set aSeOut=f
set aSeAll=1
if "%SkinEditToFilename%" == "true" set aSeIn=c& set aSeAll=a
goto sgO
:startlistAnimations
mkdir "%~dp0animLists" 2>nul
(call :OptHead 1 & call :optAnimExt 1)>%optSet%
goto sgO
:starthud_head_e
set inext=.png, .tga
goto sgO
:startlogos_e
set inext=.tga
goto sgO
:startfixSkins
call :checkTools animdb2actor || EXIT
:startIGBconverter
:startMaterialInfo
:startExtract
:sgO
call :checkTools sgOptimizer && EXIT /b 0
echo "%IG_ROOT%\bin\sgOptimizer.exe" must exist. Please check your Alchemy 5 installation.
goto Errors
:startextractAnimations
(call :OptHead 1 & call :optAnimExt 1)>%optSet%
call :sgO
:startcombineAnimations
set inext=.txt, .igb
:aP
call :checkTools animationProducer && EXIT /b 0
set animationProducer="%IG_ROOT%\animationProducer\DX\animationProducer.exe"
if exist %animationProducer% EXIT /b 0
echo "%IG_ROOT%\bin\animationProducer.exe" or %animationProducer% must exist. Please check your Alchemy 5 installation.
goto Errors
:startpreviewAnimations
call :checkTools insight && EXIT /b 0
set insight="%IG_ROOT%\ArtistPack\insight\DX9\insight.exe"
if exist %insight% EXIT /b 0
echo Insight Viewer not found. Please check your Alchemy 5 installation.
goto Errors

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

:IGBconverter
echo %askallsw% | find "Ask" >nul && if /i %format%==ask call :askformat3D
if /i %format%==FBX ( set format=fbx
) else if /i %format%==OBJ ( set format=obj
) else if /i %format%==DAE set format=dae
set c=actorConverter
findstr "igAnimationDatabase" <"%fullpath%" >nul 2>nul || call :remInfo
if not defined %c% call :checkTools %c% || (echo "%fullpath%": %c%.exe not found.)>>"%~dp0error.log" || EXIT /b
call set conv=%%%c%%%
%conv% "%fullpath%" "%pathname%.%format%"
if "%exttextrs%" == "true" goto Extract
EXIT /b
:remInfo
set c=%operation%
findstr "igActorInfo" <"%fullpath%" >nul 2>nul || EXIT /b
(call :OptHead 1 & call :optCombAnimDB 1)>%optSet%
set "fullpath=%outfile%"
goto Optimizer

:askformat3D
CLS
echo Convert "%namextns%" to...
echo.
echo F) FBX ("%nameonly%.fbx")
echo O) OBJ ("%nameonly%.obj")
echo D) DAE ("%nameonly%.dae")
echo A) Press A to switch: %askallsw%
echo.
choice /c FODA /m "What format do you want to convert %namextns% into"
IF ERRORLEVEL 4 call :askallswitch & goto askformat3D
IF ERRORLEVEL 3 set "format=dae" & EXIT /b
IF ERRORLEVEL 2 set "format=obj" & EXIT /b
IF ERRORLEVEL 1 set "format=fbx" & EXIT /b

:Extract
set iformat=tga
if "%detectPNG%" == "true" call :fetchFormat & del "%pathname%.txt"
if "%subfolder%" == "true" set "sfolder=%nameonly%" & mkdir "%pathname%"
if "%subfolder%" == "false" set "sfolder="
if "%refExtTex%" == "true" set "outfile=%fullpath%"
(call :OptHead 1 & call :OptExt 1 %iformat% %refExtTex% false %enm%)>%optSet%
call :Optimizer
if %remMipMap%==true goto remMM
EXIT /b

:remMM
set "sf=%sfolder%\"
for %%m in ("%pathonly%%sf%*.tga", "%pathonly%%sf%*.png") do for /l %%a in (1,1,20) do if exist "%%~dpnm-%%a%%~xm" del "%%~dpnm-%%a%%~xm"
EXIT /b

:fetchFormat
call :fetchTexInfo
set iformat=png
for /f "usebackq skip=%skipt% delims=" %%a in ("%pathname%.txt") do (
 echo "%%a" | find "IG_GFX_TEXTURE_FORMAT_RGBA_8888_32">nul && EXIT /b
 echo "%%a" | find "IG_GFX_TEXTURE_FORMAT_X">nul && EXIT /b
 set iformat=tga
 EXIT /b
 echo "%%a" | find "---------------------">nul && EXIT /b
)
EXIT /b

:MaterialInfo
call :fTi 0x000003ff
EXIT /b

:fetchTexInfo
call :fTi 0x00000011
goto sTi
:fTi
(call :OptHead 1 & call :OptInfo 1 %1) >%optSet%
(call :Optimizer)>"%pathname%.txt"
EXIT /b
:sTi
REM Format must be selected to make skipt work.
for /f "delims=:" %%a in ('findstr /n /c:"Format (IG_GFX_TEXTURE_FORMAT)" ^<"%pathname%.txt"') do set skipt=%%a
EXIT /b

:fetchTextures
call :fetchTexInfo
set count=0
echo Textures found in "%namextns%":
for /f "usebackq skip=%skipt% tokens=1 delims=|" %%a in ("%pathname%.txt") do (
 echo %%a | find "---------------------">nul && EXIT /b
 echo  %%a
 call :remSpacesLT %%a
 set /a count+=1
)
EXIT /b

:image2igb
REM Automatic and manual setup for the texture format:
if "%askconv%" == "never" EXIT /b
if "%askconv%" == "true" ( set "askpng=true" & set checkformat=true
) else if "%askconv%" == "dds" ( set askpng=true
) else if "%askconv%" == "dxt1" ( set checkformat=true
) else if "%askconv%" == "dxt5" ( set checkformat=true
) else if "%askconv%" == "false" ( set checkformat=true )
if "%askconv:~0,21%" == "IG_GFX_TEXTURE_FORMAT" call :setIMGformat %askconv%
if not "%askallsw%" == "Use the same setting for all input files" call :checkconvert
if "%checkformat%" == "true" if /i "%xtnsonly%" == ".png" ( if not "%askpng%" == "true" EXIT /b
) else if /i "%xtnsonly%" == ".dds" EXIT /b
REM Automatic and manual setup for the texture size:
if not "%askallsz%" == "Use the same setting for all input files" call :checkresize
if not defined createINI (set createINI=true) else set createINI=false
for %%s in ("%askallsw%", "%askallsz%") do for /f %%f in ('echo %%s ^| findstr "again" 2^>nul') do set createINI=true
set ini=%optSet%
if "%MagFilter%" == "false" if "%WrapST%" == "false" set ini=
if defined ini (call :i2iSettings)>"%ini%"
set "infile=%pathname%.igb"
%image2igb% "%fullpath%" "%infile%" %ini%
set "outfile=%infile%"
if "%createINI%" == "true" goto i2iOptSet
goto Optimizer

:checkconvert
set convert=
if "%askconv%" == "fdxt1" ( call :setIMGformat IG_GFX_TEXTURE_FORMAT_RGBA_DXT1
) else if "%askconv%" == "fdxt5" ( call :setIMGformat IG_GFX_TEXTURE_FORMAT_RGBA_DXT5
) else if /i "%xtnsonly%" == ".png" ( if "%askpng%" == "true" call :askconvert PNG
) else if /i "%xtnsonly%" == ".dds" ( if "%askconv%" == "dds" call :askconvert DDS
) else if "%askconv%" == "dds" ( call :askconvert %xtnsonly%
) else if "%askconv%" == "true" ( call :askconvert %xtnsonly%
) else if "%askconv%" == "false" ( call :askconvert %xtnsonly%
) else if "%askconv%" == "dxt1" ( call :setIMGformat IG_GFX_TEXTURE_FORMAT_RGBA_DXT1
) else if "%askconv%" == "dxt5" call :setIMGformat IG_GFX_TEXTURE_FORMAT_RGBA_DXT5
EXIT /b
:askconvert
CLS
echo Note: JPG and TGA don't work ingame, PNG works sometimes.
echo.
echo N^) No, keep current format %1
echo 1^) Convert to DDS DXT1
echo 5^) Convert to DDS DXT5
echo 0^) More conversion formats
echo S^) Press S to switch: %askallsw%
echo M^) Press M to switch Magnification method: %magmthd%
echo W^) Press W to switch WrapS/T method: %wrmthd%
echo.
choice /c N150SMW /m "Convert %namextns%"
IF ERRORLEVEL 7 (if %WrapST%==false (set WrapST=true&set wrmthd=Clamp) else set WrapST=false&set wrmthd=Repeat) & goto askformat
IF ERRORLEVEL 6 (if %MagFilter%==false (set MagFilter=true&set magmthd=Linear) else set MagFilter=false&set magmthd=Nearest) & goto askformat
IF ERRORLEVEL 5 call :askallswitch askallsw & goto askconvert
set format=IG_GFX_TEXTURE_FORMAT_RGBA_4444_16
IF ERRORLEVEL 4 call :IGBimgFormats & goto askformat
IF ERRORLEVEL 3 call :setIMGformat IG_GFX_TEXTURE_FORMAT_RGBA_DXT5 askagain & EXIT /b
IF ERRORLEVEL 2 call :setIMGformat IG_GFX_TEXTURE_FORMAT_RGBA_DXT1 askagain & EXIT /b
IF ERRORLEVEL 1 set convert=false & EXIT /b
:askformat
CLS
echo Note: JPG and TGA don't work ingame, PNG works sometimes.
echo.
echo Format to convert into: %format%
echo %desc%
echo.
echo F^) Press F to switch the format
echo A^) Press A to accept the format and continue
echo.
choice /c AF /m "Press 'F' to change the format. Press 'A' to continue"
IF ERRORLEVEL 2 call :IGBimgFormats & goto askformat
IF ERRORLEVEL 1 set "convert=true" & EXIT /b

:setIMGformat
set format=%1
set convert=true
if not "%2" == "askagain" set "askallsw=Use the same setting for all input files"
EXIT /b

:checkresize
set "askallsz=%askallsw%"
if "%maxHeight%" == "ask" ( call :asksize
) else if /i "%maxHeight%" == "MUA" ( set "maxHeight=1024" & set "maxWidth=2048"
) else if /i "%maxHeight%" == "XML2" ( set "maxHeight=512" & set "maxWidth=512"
) else if /i "%maxHeight%" == "ILQ" ( set "maxHeight=128" & set "maxWidth=128"
) else if /i "%maxHeight%" == "IHQ" ( set "maxHeight=256" & set "maxWidth=256"
) else if "%maxWidth%" == "same" ( set "maxWidth=%maxHeight%" )
EXIT /b
:asksize
CLS
echo Enter the pixel size you want to change the image into. It's recommended to have a bigger input size.
echo.
echo U^) Loading screen size for MUA 2048x1024
echo X^) Loading screen size for XML2 512x512
echo L^) Icon size for last-gen consoles 128x128
echo H^) Icon size for PC and next-gen consoles 256x256 
echo C^) Enter a custom height value
echo W^) Press W to switch: Use %maxWidth% values for the width
echo M^) Press M to switch: Generate mipmaps? %mipmaps%
echo N^) No, keep current size
echo S^) Press S to switch: %askallsz%
echo.
choice /c UXLHCWMNS /m "Resize %~1"
IF ERRORLEVEL 9 call :askallswitch askallsz & goto asksize
IF ERRORLEVEL 8 set "maxHeight=false" & EXIT /b
IF ERRORLEVEL 7 call :switch mipmaps true false & goto asksize
IF ERRORLEVEL 6 call :switch maxWidth same different & goto asksize
IF ERRORLEVEL 5 goto enterSize
IF ERRORLEVEL 4 set "maxHeight=256" & set "maxWidth=256" & EXIT /b
IF ERRORLEVEL 3 set "maxHeight=128" & set "maxWidth=128" & EXIT /b
IF ERRORLEVEL 2 set "maxHeight=512" & set "maxWidth=512" & EXIT /b
IF ERRORLEVEL 1 set "maxHeight=1024" & set "maxWidth=2048" & EXIT /b
:enterSize
echo.
set /p maxHeight=Enter the height in pixels for the new size: 
if "%maxWidth%" == "different" (
 echo It's highly recommended to have a height:width ratio of 1:1, 1:2, or 2:1.
 set /p maxWidth=Enter the width in pixels for the new size: 
)
if "%maxWidth%" == "same" set maxWidth=%maxHeight%
echo.
echo Height: %maxHeight%
echo Width:  %maxWidth%
choice /m "Are these values correct"
if not ERRORLEVEL 2 EXIT /b
goto asksize

:i2iOptSet
type nul>%optSetT%
set optcnt=0
if not "%maxHeight%" == "false" call :writeOpt optRes
if "%convert%" == "true" call :writeOpt optConv
if "%mipmaps%" == "true" call :writeOpt optMipmap
if not %optcnt% GTR 0 EXIT /b
(call :optHead %optcnt%)>%optSet%
type %optSetT%>>%optSet%
goto Optimizer

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
set "outfile=%~dp0temp.igb"
call :askSkinEdit
(call :OptHead 1 & call :OptRen 1)>%optSet%
set targetName=
if "%targetName%" == "%newName%" EXIT /b
set "outfile=%infile%"
goto Optimizer

:getSkinName
if not exist "%~dp0igStatisticsSkin.ini" (call :OptHead 1 & call :OptSkinStats 1)>"%~dp0igStatisticsSkin.ini"
( %sgOptimizer% "%fullpath%" "%outfile%" "%~dp0igStatisticsSkin.ini" )>"%~dp0%nameonly%.txt"
set targetName=
for /f "delims=:" %%a in ('findstr /n /c:"Skin name" ^<"%~dp0%nameonly%.txt"') do set skipt=%%a
for /f "usebackq skip=%skipt% tokens=1 delims=| " %%a in ("%~dp0%nameonly%.txt") do if not defined targetName set "targetName=%%a"
del "%~dp0%nameonly%.txt"
EXIT /b

:genGColorFix
if not exist "%~dp0igGenerateGlobalColor.ini" (call :OptHead 1 & call :optGGC 1)>"%~dp0igGenerateGlobalColor.ini"
%sgOptimizer% "%fullpath%" "%fullpath%" "%~dp0igGenerateGlobalColor.ini"
EXIT /b

:convert_to_igGeometryAttr2
(call :OptHead 1 & call :optCGA 1)>%optSet%
set "outfile=%infile%"
goto Optimizer

:previewAnimations
set va=%va%"%fullpath%" 
EXIT /b
:previewAnimationsPost
start "" %insight% "%actorSkin%" %va%
EXIT /b

:listAnimations
echo Listing animations from %namextns% . . .
(call :Optimizer)>"%pathname%.txt"
(call :writeProcFile2 list)>"%~dp0animLists\animList-%nameonly%.txt"
del "%pathname%.txt"
EXIT /b
:listFiles
echo %nameonly: =_%\%animname%
EXIT /b
:listAnimationsPost
copy "%~dp0animLists\*txt" "%~dp0allAnims.txt" /b
rmdir /s /q "%~dp0animLists"
EXIT /b

:extractAnimations
set "AnimProcess=%pathonly%extract-%nameonly%.txt"
call :checktxt extract || EXIT /b
set "outpath=%~dp0%nameonly: =_%"
set "infile=%outpath%.igb"
set deli=
if /i not "%fullpath%" == "%infile%" if not exist "%infile%" copy "%fullpath%" "%infile%" & set deli=true
echo Extracting animations from %namextns% . . .
(call :Optimizer)>"%pathname%.txt"
mkdir "%outpath%" >nul 2>nul
if not "%exskin%" == "only" (
 (call :writeProcFile anim)>"%AnimProcess%"
 call :animationProducer
)
if not "%exskin%" == "false" (
 (call :writeProcFile skin & call :skinSave)>"%AnimProcess%"
 call :animationProducer
)
if defined deli del "%infile%"
del "%pathname%.txt"
if "%remext%" == "true" del "%AnimProcess%"
EXIT /b
:animLoad
echo load_actor								%nameonly: =_%.igb
echo extract_skeleton						%nameonly: =_%_skel
EXIT /b
:skinLoad
echo create_actor_database					%nameonly: =_%
echo load_actor_database						%nameonly: =_%.igb
EXIT /b
:writeProcFile
echo create_animation_database				%nameonly: =_%
call :%1Load
:writeProcFile2
for /f skip^=2^ tokens^=2^ delims^=^" %%a in ('find "Skipping igAnimation" "%pathname%.txt"') do set "animname=%%a" & call :extractAnimationsFiles %1
for /f "skip=2 delims=[]" %%a in ('find /n "Quantization error" "%pathname%.txt"') do set skipl=%%a
for /f "skip=%skipl% usebackq" %%a in ("%pathname%.txt") do (
 echo %%a | find "-------------------------------------------------" >nul && EXIT /b
 set "animname=%%a"
 call :extractAnimationsFiles %1
)
EXIT /b
:extractAnimationsFiles
if not "%animname:&=%" == "%animname%" echo "%animname%" can not be extracted, because it contains "&">>"%~dp0error.log" & EXIT /b
if not "%animname: =%" == "%animname%" echo "%animname%" can not be extracted, because it contains spaces>>"%~dp0error.log" & EXIT /b
if "%extall%" == "false" findstr /i "\<%animname%\>" <"%~dp0_animations.ini" >nul || EXIT /b
goto %1Files
:animFiles
echo extract_animation						%animname%
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
:extractAnimationsPost
if not "%nevtxt%" == "usetxt" EXIT /b
set "AnimProcess=%~dp0extract.txt" 
if exist "%AnimProcess%" goto animationProducer
EXIT /b
:extractAnimAllTxt
call :txtChck || EXIT /b 1
for /f "tokens=1*" %%a in ('findstr /bi "save" ^<"%fullpath%"') do mkdir "%%~dpb" >nul 2>nul
for /f "skip=2 tokens=1*" %%a in ('find "load_actor" "%fullpath%"') do (
 if not "%pathonly%%nameonly:~8%.igb" == "%~dp0%%b" if exist "%~dp0%%b" ( 
  choice /m "Replace %~dp0%%b"
  if errorlevel 2 EXIT /b
 )
 move "%pathonly%%nameonly:~8%.igb" "%~dp0%%b"
 call :animationProducer
 move "%~dp0%%b" "%pathonly%%nameonly:~8%.igb"
)
EXIT /b 1

:combineAnimations
call :checktxt combine || EXIT /b
if defined outanim goto combineAnimationFiles
set "AnimProcess=%~dp0combine.txt"
for %%a in ("%pathonly:~0,-1%") do set outanim=%%~na
if "%autonm%" == "false" set /p outanim=Please enter the name you want to save your new animation set as (without extension). Press enter to use "%outanim%": 
set outanim=%outanim:&=_%
set outanim=%outanim: =_%
if exist "%~dp0%outanim%.igb" move /%unsafe%y "%~dp0%outanim%.igb" "%~dp0%outanim%.igb.bak"
set "outpath=%outanim%\"
if "%pathonly%" == "%~dp0" set outpath=
if not defined skeleton set "skeleton=%outanim%\%namextns%"
CLS
echo Creating combine list for "%outanim%" . . .
if "%coskin%" == "false" (set combine=anim) else set combine=skin
(call :writeTop %combine%)>"%AnimProcess%"
:combineAnimationFiles
if "%extall%" == "false" call :animNames %nameonly% || choice /m "'%nameonly%' is not in shared_anims. Continue"
if ERRORLEVEL 2 EXIT /b
for %%i in ("%coskin%") do if not "%%~ni" == "false" if "%nameonly%" == "%%~ni" EXIT /b
(call :writeFiles)>>"%AnimProcess%"
if not defined outpath EXIT /b
if "%fullpath%" == "%~dp0%outpath%%namextns%" EXIT /b
REM This currently copies a lot of files. Mayhap, they should be moved instead, or deleted after completion.
if not exist "%~dp0%outpath%" mkdir "%~dp0%outpath%"
if exist "%~dp0%outpath%%namextns%" move /%unsafe%y "%~dp0%outpath%%namextns%" "%namextns%.bak"
copy "%fullpath%" "%~dp0%outpath%%namextns%"
EXIT /b
:combineAnimationsPost
(call :%combine%Combine)>>"%AnimProcess%"
goto animationProducer
:combineAnimAllTxt
call :txtChck || EXIT /b 1
call :animationProducer
EXIT /b 1

:writeTop
echo create_animation_database				%outanim%
call :%1Top 2>nul
echo load_actor								%skeleton%
echo extract_skeleton						%outanim%_skel
Exit /b
:skinTop
echo create_actor_database					%outanim%
echo load_actor_database						%coskin%
Exit /b

:writeFiles
REM load_actor (all instances of it) supports paths, but it cannot contain spaces (not in the filename either). Quotes are understood literally, so wrapping in them fails too.
echo load_actor								%outpath%%namextns%
echo extract_animation						%nameonly%
Exit /b

:animCombine
echo save_external_animation_database		%outanim%.igb
Exit /b
:skinCombine
rem some fail with load_actor_database. Use below instead of load_actor_database.
rem echo load_actor								%coskin%
rem echo extract_skin							%outanim%
rem echo create_actor							%outanim%
echo save_actor_database						%outanim%.igb
Exit /b

:checktxt
set x=1
if /i "%xtnsonly%" == ".igb" set x=0
if "%nevtxt%" == "true" EXIT /b %x%
if not exist "%pathonly%%1*.txt" set t=%1
if not defined t goto asktxt
if %x%==0 if exist "%AnimProcess%" ( goto %1AnimAllTxt
) else EXIT /b 0
set "AnimProcess=%fullpath%"
echo "%namextns%"|findstr /bei "\"%1.*\.txt\"" >nul && goto %1AnimAllTxt
EXIT /b 1
:asktxt
choice /m "Do you want to use the existing %1 database (%1.txt)"
if ERRORLEVEL 2 set nevtxt=true
set t=%1
goto checktxt
:txtChck
set /p ck=<"%fullpath%"
echo %ck%|find "create_animation_database" || EXIT /b 1
EXIT /b 0

:fixSkins
rem findstr "igActorInfo" <"%fullpath%" >nul 2>nul && EXIT /b
set "infile=%~dp0%nameonly: =_%.igb"
if /i not "%fullpath%" == "%infile%" if not exist "%infile%" set of=dd
if "%of%" == "dd" ( set "of=%infile%"
) else set "of=%pathname%_scene.igb"
%animdb2actor% "%fullpath%" "%of%"
choice /m "View %namextns%"
if not errorlevel 2 "%of%"
EXIT /b

:hud_head_e
REM For 256 MUA icons, the format is DXT, therefore the images extract to TGA only
if /i "%xtnsonly%" == ".tga" call :hudextract tga hud_head_0201 hud_conversation DXT1 true
REM For 128 MUA icons, the template is PNG compatible, and extracts to PNG
if /i "%xtnsonly%" == ".png" call :hudextract png hud_head_0000 hud_conversation DXT5
del "%~dp0hud_conversation*"
EXIT /b

:hudextract - format (tga or png); IGB template; intern text. name to repl.; target format; has mipmaps (true/false)
if "%nameonly%" == "%3" EXIT /b
if exist "%~dp0%nameonly%" echo WARNING: "%~dp0%nameonly%" exists. Please move this folder to avoid data loss. & goto Errors
mkdir "%~dp0%nameonly%" & set "sfolder=%nameonly%"
(call :OptHead 1 & call :OptExt 1 %1 true false false)>%optSet%
%sgOptimizer% "%~dp0%2.igb" "%~dp0%nameonly%\%nameonly%.igb" %optSet%
if not "%~dp0%nameonly%" == "%pathname%" xcopy /i /y "%~dp0%nameonly%" "%pathname%" & rmdir /s /q "%~dp0%nameonly%"
copy /y "%fullpath%" "%pathname%\%3.%1" & set sfolder=
set format=IG_GFX_TEXTURE_FORMAT_RGBA_%4
if "%5" == "true" (set optcnt=3) else set optcnt=2
(call :OptHead %optcnt% & call :OptExt 1 png false true false & call :optConv 2)>"%pathname%\%operation:~0,-2%_i.ini"
if "%5" == "true" (call :optMipmap 3)>>"%pathname%\%operation:~0,-2%_i.ini"
REM Injecting the images from batch fails. Has to be made manually in Finalizer.
EXIT /b

:logos_e
if "%namextns%" == "power_ring.tga" EXIT /b
call :hudextract tga 0000 team DXT5
move /y "%~dp0power_ring.tga" "%pathname%\power_ring.tga"
EXIT /b


:Maps
if "%inputfiles%"=="existonall" goto addNewTextures
set subf=
for /f %%a in ('dir /ad /b "%pathonly%"') do goto askSubfolder
goto Mchck
:askSubfolder
if "%SubfoldAuto%" == "ask" (
 choice /m "Do you want to search subfolders for textures as well"
 if not errorlevel 2 set SubfoldAuto=true
)
if "%SubfoldAuto%" == "true" set "subf= /s"
:Mchck
call :checkMapTexs
call :Mset && set inputfiles=asked && choice /m "Optimization set found (%operation%.ini). Do you want to apply it on all input files"
if not errorlevel 2 set inputfiles=existonall& goto addNewTextures
set /a count+=1
echo "%fullpath%">>%tmp%
EXIT /b
:checkMapTexs
for /f "delims=" %%t in ('for %%f in ^(png, tga, dds, jpg, bmp^) do @dir /a-d /b%subf% "%pathonly%*.%%f" 2^>nul') do EXIT /b
echo No map textures detected. Please move them to the same folder as the input IGB file.
goto Errors
:Mset
if not defined inputfiles if exist %optSet% (
 call :MTitle
 type %optSet%
 echo.
 EXIT /b 0
)
EXIT /b 2

:MTitle
CLS
echo.
echo --------------------------------------------
echo   Raven: Setup MUA Material for Alchemy 5
echo --------------------------------------------
echo.
EXIT /b

:MapsPost
if not defined count EXIT /b
if %count% GTR 1 if "%MultiInputA%" == "false" call :IGBselect
for /f "usebackq delims=" %%i in (%tmp%) do set "fullpath=%%~fi" & call :IntImages
EXIT /b

:IGBselect
set input=
set fullpath=
call :MTitle
echo Multiple input files found:
type %tmp%
echo.
set /p input=Enter the name of the file you want to process, or press enter to process all files: 
if not defined input EXIT /b
for /f "usebackq delims=" %%i in (%tmp%) do echo %%~nxi | find /i "%input%" && echo "%%~fi">%tmp% && set "fullpath=%%~fi"
if not defined fullpath goto IGBselect
EXIT /b

:mapsD
echo.>%tmp%
set dc=-1
set mz=0
call :MTitle
echo "%namextns%":
echo.
for /f "skip=2 tokens=1* delims=|" %%a in ('findstr /l "|" ^<"%pathname%.txt"') do set mi=%%b & call :printDiff %%a
if %dc% LEQ 0 goto MapSelect
echo.
echo Only select diffuse textures. Ask for help, if you are unsure.
echo.
if defined duplicate (
 echo  WARNING: Duplicate texture names found. They must be the identical textures. 
 echo           If you think it's possible that this is not the case, abort now,
 echo           and rename one or both textures, if they're truly different.
 echo.
 set duplicate=
)
if not defined options for /l %%d in (0,1,%dc%) do if %%d LEQ 9 call set options=%%options%%%%d
set /a d+=1
choice /c %options%A /m "Select the number of a diffuse texture to add texture maps to. Press 'A' to accept and continue."
if %errorlevel%==%d% EXIT /b
call :MapSelect %errorlevel%
goto mapsD
:printDiff
call :chMM %* && EXIT /b
if exist %tmp% findstr /bei /c:"%*" <%tmp% >nul && set duplicate=found
echo %*>> %tmp%
set /a dc+=1
if %dc% LEQ 9 set /a d=dc+1
set nr=%dc%.
set sfx=
echo %done% | find "%d%" >nul && set sfx=-- Done
if %dc% GTR 9 set nr=  & set sfx=(unable to modify)
echo %nr% %* %sfx%
EXIT /b
:chMM
for /f "tokens=1-2 delims=|" %%y in ("%mi%") do (
 set mz=%%z
 set mf=%%y
 if %mz% LSS %%z EXIT /b 1
 if not "%mf%"=="%%y" EXIT /b 1
)
for %%m in ("%*") do set mm=a%%~nm
if "%mm:~-3,1%"=="-" set mm=%mm:~-2,1%
if "%mm:~-2,1%"=="-" set mm=%mm:~-1,1%
for /f "delims=0123456789" %%i in ("%mm%") do EXIT /b 1
EXIT /b 0

:MapSelect
echo %done% | find "%1" >nul || set done=%done% %1
call :mapsS %sv%%1 restore
for /f "usebackq skip=%1 delims=" %%a in (%tmp%) do (
 set intTex=%%~na
 call :mapsM %1
 EXIT /b
)
EXIT /b
:mapsM
if defined Environment (set "ER=%Environment%") else set "ER=%reflectance%"
if not defined reflectance set reflectance=0.000000
call :MTitle
echo "%namextns%":
echo.
echo 0. Diffuse:      %intTex%
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
choice /c 1245A /m "Select a number to add or replace a texture map. Press 'A' to accept and continue."
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
(call :OptRSMUAMat %1) >"%TC%%1.ini"
call :mapsS %sv%%1
EXIT /b
:mapsS
set s=
set r=%1
if "%2"=="" set r=&set s=%1
for %%m in (Normal Specular reflectionR reflectionL reflectionB reflectionF reflectionU reflectionD Environment reflectance Emissive) do call set "%%m%s%=%%%%m%r%%%"
EXIT /b

:IntImages
if defined options timeout 1
call :filesetup
call :Mset && choice /m "Do you want to add the same textures to '%namextns%'"
if not errorlevel 2 goto addNewTextures
set count=0
set /a sv+=1
del "%TC%T.txt" 2>nul
del "%TC%N.txt" 2>nul
del %optSetT% 2>nul
set done=
set options=
call :fTi 0x00000091
call :mapsD 1
for %%d in (%done%) do call :cRSMMo %%d>>%optSetT%
if exist "%TC%T.txt" call :convMaps T %ConvertDDSf%
if exist "%TC%N.txt" call :convMaps N 5
if "%mipmaps%" == "true" set /a count+=1
if "%mipmaps%" == "true" (call :optMipmap %count%)>>%optSetT%
(call :OptHead %count% & type %optSetT%) > %optSet%
del %optSetT%
del "%pathname%.txt"
:addNewTextures
set outfile=
call :MTitle
set /p outfile=Enter a name to save "%nameonly%" as ^(existing files will be replaced^). Press enter to update "%namextns%": 
if defined outfile (set "outfile=%pathonly%%outfile%.igb") else (set "outfile=%fullpath%")
goto Optimizer
:cRSMMo
set /a count+=1
call :OptN %count%
more +1 "%TC%%1.ini"
del "%TC%%1.ini"
EXIT /b

:multiTex
set noSpace=
if "%MultiTextAl%" == "true" call :askTextures & EXIT /b
echo.
echo  WARNING: Identical texture names should be the identical texture as well. 
echo           If you think it's possible that this is not the case, abort now,
echo           and rename one or both textures if they're truly different.
:multiText
set intTex=
echo.
set /p intTex=Multiple textures found. Enter the name of the diffuse texture you want to add texture maps to, or press enter to choose multiple textures: 
if not defined intTex call :askTextures & EXIT /b
for /f "tokens=1 delims=|" %%i in ('findstr "|" ^<"%pathname%.txt" ^| find /i "%intTex%"') do call :remSpacesLT %%i & EXIT /b
goto multiText
:warnMulti
if defined warning EXIT /b
echo.
echo  Hint: If you want to add different texture maps to multiple files with 
echo        identical diffuse textures ^(names^), abort, and start again by dropping
echo        them onto the batch, one after the other.
set warning=warned
EXIT /b

:convMaps
set /a count+=1
set isExclude=include
set "convertlist=%TC%%1.txt"
set format=IG_GFX_TEXTURE_FORMAT_RGBA_DXT%2
(call :optConv %count%)>>%optSetT%
EXIT /b

:askTextures
del %tmp%
set count=0
set countb=0
for /f "usebackq skip=%skipt% tokens=1 delims=|" %%a in ("%pathname%.txt") do (
 echo %%a | find "---------------------">nul && EXIT /b
 call :askTextures2 %%a
)
EXIT /b
:askTextures2
set /a countb+=1
echo.
if %countb% GTR 1 echo WARNING: multiple textures in "%nameonly%" - this might be a non-diffuse map
if exist %tmp% findstr /bei /c:"%*" <%tmp% >nul && set duplicate=found
if defined duplicate ( 
 echo Duplicate texture name: "%*". The duplicate one is skipped. Abort now, if the textures aren't identical.
 set duplicate=
) else (
 choice /m "Do you want to add texture maps to %*"
 if not errorlevel 2 set /a count+=1 & echo %*>> %tmp%
)
EXIT /b

:askNewTextures
set /a count+=1
echo.
echo.
echo diffuseMapName = "%intTex%"
echo --------------------------------------------
call :askTexMaps T Specular Specular
call :askTexMaps N Normal Normal " (Bump map)"
call :askTexMaps T Emissive Emissive " (gloss/illuminating)"
call :askTexMaps T Environment Environment " (reflections)"
call :askReflectance
(call :OptRSMUAMat %count%)>>%optSetT%
EXIT /b
:askTexMaps
echo.
echo Texture files found:
for /f "delims=" %%t in ('for %%f in ^(png, tga, dds, jpg, bmp^) do @dir /a-d /b%subf% "%pathonly%*.%%f" 2^>nul') do echo %%~nxt
set map=
set %3=
echo.
set /p map=Enter the name of the texture you want to use for the %~2 map%~4, or press enter to skip this map: 
if not defined map EXIT /b
set "map=%map:"=%"
if %map:~1,1%==: goto isFullPath
for /f "delims=" %%t in ('for %%f in ^(png, tga, dds, jpg, bmp^) do @dir /a-d /b%subf% "%pathonly%*.%%f" 2^>nul') do echo %%~nxt | find /i "%map%" && set "%3=%%~ft" && if not "%~1"=="" call :chkFrmt %%~xt && echo %%~nxt>>"%TC%%~1.txt"
if not defined %3 goto askTexMaps
EXIT /b
:isFullPath
set "%3=%map%"
for %%t in ("%map%") do call :chkFrmt %%~xt && echo %%~nxt>>"%TC%%~1.txt"
EXIT /b
:chkFrmt
if /i "%1" == ".png" if "%ConvertPNGs%" == "false" EXIT /b 1
if /i "%1" == ".dds" EXIT /b 1
EXIT /b 0
:askReflectance
if defined Environment goto CubeMaps
echo.
set /p reflectance=Enter a number between 0 and 1 [eg. 0.001] for an environment mask of an even reflection of the entered value [1=100%%], or press enter to skip: 
if %reflectance% EQU 0.000000 EXIT /b
if %reflectance% GTR 1 goto askReflectance
if %reflectance% LSS 0 goto askReflectance
for /f usebackq %%d in (`PowerShell "('%reflectance%' -replace '[^.]').length"`) do if %%d GTR 1 (goto askReflectance) else if %%d EQU 1 if not "%reflectance:~1,1%" == "." goto askReflectance
:prettyPrintRefl
echo %reflectance% | find "." >nul || set reflectance=%reflectance%.
set reflectance=%reflectance%000000
set reflectance=%reflectance:~0,8%
:CubeMaps
set cubemap=%5
for %%r in (R:right L:left B:back F:front U:top D:bottom) do for /f "tokens=1* delims=:" %%a in ("%%r") do call :askCubeMaps %%a %%b && EXIT /b
EXIT /b 0
:askCubeMaps
call :askTexMaps "" "%2 side cube" reflection%1 " (reflection cube/sphere)"
if not defined reflectionR EXIT /b 0
if %1==R goto askCubeMapsSame
EXIT /b 1
:askCubeMapsSame
choice /m "Do you want to use the same texture for all sides"
if errorlevel 2 EXIT /b 1
for %%r in (L, B, F, U, D) do set "reflection%%r=%reflectionR%"
EXIT /b 0


:removeSpaces
set "infile=%pathonly%%nameonly: =_%%xtnsonly%"
if exist "%infile%" move /%unsafe%y "%infile%" "%infile%.bak"
copy "%fullpath%" "%infile%"
EXIT /b

:remSpacesLT
set noSpace=%*
EXIT /b

:askallswitch
call :switch %1 "Ask for the next input file again" "Use the same setting for all input files"
EXIT /b

:switch
call echo "%%%1%%" | find "%~2" && set "%1=%~3" || set "%1=%~2"
EXIT /b

:writeOpt
set /a optcnt+=1
(call :%1 %optcnt%)>>%optSetT%
EXIT /b

:Optimizer
%sgOptimizer% "%infile%" "%outfile%" %optSet% || goto Errors
EXIT /b

:animationProducer
REM the animationProducer needs the file locally and without spaces.
if "%operation%" == "extractAnimations" copy "%~dp0_combine.bat" "%outpath%" & if "%skeleton%" == "_fightstyle_default" copy "%~dp0_fightstyle_default" "%outpath%"
cd /d "%~dp0"
%animationProducer% "%AnimProcess%"
if %errorlevel% NEQ 0 goto Errors
EXIT /b


:optHead
echo [OPTIMIZE]
echo optimizationCount = %1
echo hierarchyCheck = true
EXIT /b

:OptN
echo [OPTIMIZATION%1]
EXIT /b

:OptExt
call :OptN %1
echo name = igImageExternal
echo forceExternalUsage = %3
echo forceInternalImage = %4
echo extension = %2
echo imageSubDirectory = %sfolder%
echo enummerateSameNamedImages = %5
EXIT /b

:optConv
echo %format% | find /i "DXT" >nul && set "order=IG_GFX_IMAGE_ORDER_DX" || set "order=IG_GFX_IMAGE_ORDER_DEFAULT"
call :OptN %1
echo name = igConvertImage
echo format = %format%
echo sourceFormat = invalid
echo order = %order%
echo isExclude = %isExclude%
echo convertIfSmaller = false
echo imageListFilename = %convertlist%
EXIT /b

:optRes
call :OptN %1
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
call :OptN %1
echo name = igUseMipmap
echo filterType = 6
echo mipmapTaggedOnly = false
echo minFilter = NearestMipmapLinear
echo magFilter = Linear
echo isExclude = exclude
echo minSize = 1
echo imageListFilename = 
EXIT /b

:OptInfo
call :OptN %1
echo name = igStatisticsTexture
echo separatorString = ^|
echo columnMaxWidth = -1
echo showColumnsMask = %2
echo sortColumn = -1
echo useFullPath = false
EXIT /b

:OptSkinStats
call :OptN %1
echo name = igStatisticsSkin
echo separatorString = ^|
echo columnMaxWidth = -1
echo showColumnsMask = 0x00000002
echo sortColumn = -1
EXIT /b

:OptRen
call :OptN %1
echo name = igChangeObjectName
echo objectTypeName = igNamedObject
echo targetName = %targetName%
echo newName = %newName%
EXIT /b

:optGGC
call :OptN %1
echo name = igGenerateGlobalColor
EXIT /b

:optCGA
call :OptN %1
echo name = igConvertGeometryAttr
echo accessMode = 3
echo storeBoundingVolume = false
EXIT /b

:optAnimExt
call :OptN %1
echo name = igEnbayaCompressAnimations
echo quantizationError = 0.0001
echo sampleRate = -1
echo forceTrackCount = -1
echo printStatistics = true
echo ignoreBones = 
echo specialCaseIniFilename = 
echo separator = :
echo sortColumn = -1
EXIT /b

:optCombAnimDB
call :OptN %1
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

:OptRSMUAMat
call :OptN %1
echo name = igRavenSetupMUAMaterial
echo diffuseMapName = %intTex:&=^&%
echo normalMap = %Normal:&=^&%
echo specularMap = %Specular:&=^&r%
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
if "%format%" == "IG_GFX_TEXTURE_FORMAT_TILED_X_4_PSP" (
 set format=IG_GFX_TEXTURE_FORMAT_L_8
 set desc=Intensity aka grayscale image with 8 bits ^(1 channel^) - no transparency supported
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_L_8" (
 set format=IG_GFX_TEXTURE_FORMAT_A_8
 set desc=Alpha channel only, with 8 bits
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_A_8" (
 set format=IG_GFX_TEXTURE_FORMAT_LA_44_8
 set desc=Intensity aka grayscale image with alpha channel and 4 bits per channel
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_LA_44_8" (
 set format=IG_GFX_TEXTURE_FORMAT_LA_88_16
 set desc=Intensity aka grayscale image with alpha channel and 8 bits per channel
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_LA_88_16" (
 set format=IG_GFX_TEXTURE_FORMAT_RGB_332_8
 set desc=RGB ^(Red Green Blue channels^) 8bit image with 3 and 2 bits per channel - no transparency supported
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_RGB_332_8" (
 set format=IG_GFX_TEXTURE_FORMAT_RGB_888_24
 set desc=RGB ^(Red Green Blue channels^) 24bit image with 8 bits per channel - no transparency supported
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_RGB_888_24" (
 set format=IG_GFX_TEXTURE_FORMAT_RGBA_2222_8
 set desc=RGBA ^(Red Green Blue Alpha channels^) 8bit image with 2 bits per channel - PNG
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_RGBA_2222_8" (
 set format=IG_GFX_TEXTURE_FORMAT_RGBA_4444_16
 set desc=RGBA ^(Red Green Blue Alpha channels^) 16bit image with 4 bits per channel - PNG
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_RGBA_4444_16" (
 set format=IG_GFX_TEXTURE_FORMAT_RGBA_8888_32
 set desc=RGBA ^(Red Green Blue Alpha channels^) 32bit image with 8 bits per channel - PNG
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_RGBA_8888_32" (
 set format=IG_GFX_TEXTURE_FORMAT_RGB_565_16
 set desc=RGB ^(Red Green Blue channels^) 16 bit image with 5 and 6 bits per channel - no transparency supported
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_RGB_565_16" (
 set format=IG_GFX_TEXTURE_FORMAT_RGBA_5551_16
 set desc=RGBA ^(Red Green Blue Alpha channels^) 16 bit image with 5 and 1 bits per channel - PNG
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_RGBA_5551_16" (
 set format=IG_GFX_TEXTURE_FORMAT_X_8
 set desc=Indexed color image with 8 bits - limited transparency
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_X_8" (
 set format=IG_GFX_TEXTURE_FORMAT_X_4
 set desc=Indexed color image with 4 bits - limited transparency
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_X_4" (
 set format=IG_GFX_TEXTURE_FORMAT_RGBA_DXT1
 set desc=DirectX texture 1 ^(Red Green Blue Alpha channels^) for textured 3d objects - DDS - transparency not fully supported
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_RGBA_DXT1" (
 set format=IG_GFX_TEXTURE_FORMAT_RGBA_DXT3
 set desc=DirectX texture 2 ^(Red Green Blue Alpha channels^) for textured 3d objects - DDS
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_RGBA_DXT3" (
 set format=IG_GFX_TEXTURE_FORMAT_RGBA_DXT5
 set desc=DirectX texture 3 ^(Red Green Blue Alpha channels^) for textured 3d objects with best alpha channel support - DDS
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_RGBA_DXT5" (
 set format=IG_GFX_TEXTURE_FORMAT_TILED_DXT1_GAMECUBE
 set desc=DirectX texture 1 ^(Red Green Blue Alpha channels^) for textured 3d objects on Gamecube and Wii consoles - DDS - transparency not fully supported
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_TILED_DXT1_GAMECUBE" (
 set format=IG_GFX_TEXTURE_FORMAT_TILED_RGBA_5553_16_GAMECUBE
 set desc=RGBA ^(Red Green Blue Alpha channels^) 16bit image with 5 and 3 bits per channel for Gamecube and Wii consoles - PNG - please give me a message if you know more
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_TILED_RGBA_5553_16_GAMECUBE" (
 set format=IG_GFX_TEXTURE_FORMAT_TILED_RGB_565_16_GAMECUBE
 set desc=RGB ^(Red Green Blue channels^) 16bit image with 5 and 6 bits per channel for Gamecube and Wii consoles - no transparency supported
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_TILED_RGB_565_16_GAMECUBE" (
 set format=IG_GFX_TEXTURE_FORMAT_TILED_L_8_GAMECUBE
 set desc=Intensity aka grayscale image with 8 bits ^(1 channel^) for Gamecube and Wii consoles - no transparency supported
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_TILED_L_8_GAMECUBE" (
 set format=IG_GFX_TEXTURE_FORMAT_TILED_LA_88_16_GAMECUBE
 set desc=Intensity aka grayscale image with alpha channel and 8 bits per channel for Gamecube and Wii consoles
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_TILED_LA_88_16_GAMECUBE" (
 set format=IG_GFX_TEXTURE_FORMAT_TILED_LA_44_8_GAMECUBE
 set desc=Intensity aka grayscale image with alpha channel and 4 bits per channel for Gamecube and Wii consoles
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_TILED_LA_44_8_GAMECUBE" (
 set format=IG_GFX_TEXTURE_FORMAT_RGBA_128F
 set desc=Unknown - please give me a message if you know more
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_RGBA_128F" (
 set format=IG_GFX_TEXTURE_FORMAT_TILED_X_8_PSP
 set desc=Indexed color image with 8 bits for PSP - limited transparency
) else if "%format%" == "IG_GFX_TEXTURE_FORMAT_TILED_X_8_PSP" (
 set format=IG_GFX_TEXTURE_FORMAT_TILED_X_4_PSP
 set desc=Indexed color image with 4 bits for PSP - limited transparency
)
EXIT /b

:animNames anim
echo :step_forward:ground_attack1:ground_attack2:attack_heavy1:attack_heavy2:jump_attack1:jump_attack2:attack_jumpslam:jump_smash_loop:jump_smash:jump_smash_hold:attack_knockback:attack_knockback1:attack_knockback2:attack_light1:attack_light2:attack_light3:attack_popup1:attack_popup2:attack_stun1:attack_stun2:attack_stun3:attack_trip1:attack_trip2:block:blocking:bored_1_1:bored_1_2:bored_1_3:bored_1_4:bored_loop_1:clingwall_backflip:crouch_end:crouch_idle:crouch_start:jumpdouble_start:evade_backwards:evade_forwardroll:evade_left:evade_right:fall_FeetFirst:fly_fast:fly_idle:fly_slow:flying_attack1:flying_attack2:flyingback_getup:getup_attack_faceup:flyingforward_getup:getup_attack_facedown:grab_attack:grab_attack_finisher:grabbed_attack:grab_break:grabbed_break:grab_fallback:grab_loop:grabbed_loop:grab_smash:grabbed_smash:grab_attempt:grabbed_attempt:throw_ally_hero:throw_ally_ally:grab_throw_back:grabbed_throw_back:grab_throw_forward:grabbed_throw_forward:grab_throw_left:grabbed_throw_left:grab_throw_right:grabbed_throw_right:slamfront_slump:slamback_slump:idle:idle_to_bored:jump_attack_land:jump_land:jump_loop:jump_smash_land:jump_start:flyingback_loop:flyingforward_loop:death_gen:NO_ANIM:NO_ANIM:flyingback_landloop:slamback_getup:flyingforward_landloop:levelup:lunge_loop:lunge_land:lunge_offwall:menu_action:menu_goodbye:menu_idle:pain_airFeetfirst:pain_airHeadfirst:pain_InAirSpin:pain_rear:pain_blocking:pain_electric:groundpain_back:groundpain_forward:pain_high:pain_low:twitch_left:twitch_right:pickup_object_idle:pickup_object_lift:pickup_object_start:pickup_object_throw:pickup_object_walk:popup_break:popup_bounce:popup_loop:popup:power_1:power_10:power_11:power_12:power_13:power_14:power_15:power_16:power_17:power_18:power_19:power_1_end:power_1_loop:power_1_start:power_2:power_20:power_2_end:power_2_loop:power_3:power_3_end:power_3_loop:power_4:power_4_end:power_4_loop:power_5:power_5_end:power_6:power_7:power_8:power_8_end:power_8_loop:power_8_start:power_9:psylift:telekinesis_victim:push_heavy_object:push_heavy_object_fail:resist_knockback:resist_popup:resist_stun:resist_trip:resurrect_v:step_backward:run:spin_left:spin_right:run_sprint:step_left:step_right:sticky_floor:stun:talking_01:talking_02:talking_03:talking_04:telebuddy_grab:telebuddy_land:telebuddy_loop:slamback_loop:flyingback_land:flyingback_loop:slamfront_loop:flyingforward_land:flyingforward_loop:grabbed_throw:grabbed_throwland:grabbed_throwloop:tpose:trip:grabbed_throwslam:grabbed_throwslump:grabbed_throwslumpland:use_button:victim1:victim10:victim11:victim12:victim2:victim3:victim4:victim5:victim6:victim7:victim8:victim9:walk:zone1:zone10:zone11:zone12:zone13:zone14:zone15:zone16:zone17:zone18:zone19:zone2:zone20:zone21:zone22:zone23:zone24:zone25:zone3:zone4:zone5:zone6:zone7:zone8:zone9: | find /i ":%1:" >nul || EXIT /b 1
EXIT /b 0

:checkTools program
if not defined IG_ROOT echo The IG_ROOT variable is not defined. Please check your Alchemy 5 installation. & goto Errors
if exist "%~dp0%1.exe" set %1="%~dp0%1.exe"
if not defined %1 for /f "delims=" %%a in ('where %1.exe 2^>nul') do set %1=%1
if not defined %1 if exist "%IG_ROOT%\bin\%1.exe" set %1="%IG_ROOT%\bin\%1.exe"
if defined %1 EXIT /b 0
EXIT /b 1

:delInFiles
if "%delInputFiles%" == "true" del "%fullpath%"
EXIT /b


:End
call :%operation%Post
CLS
if not exist "%~dp0error.log" goto cleanup
:Errors
echo.
echo There was an error in the process. Check the error description.
if exist "%~dp0error.log" (
 echo.
 type "%~dp0error.log"
)
pause
:cleanup
if exist "%~dp0temp.igb" del "%~dp0temp.igb"
if exist %tmp% del %tmp%
if exist "%TC%T.txt" del "%TC%T.txt"
if exist "%TC%N.txt" del "%TC%N.txt"
if exist "%~dp0Maps2.txt" del "%~dp0Maps2.txt"
if "%delOptSets%" == "false" EXIT
if exist %optSet% del %optSet%
if exist %optSetT% del %optSetT%
if "%delOptSets%" == "true" EXIT
if exist "%~dp0igGenerateGlobalColor.ini" del "%~dp0igGenerateGlobalColor.ini"
if exist "%~dp0igStatisticsSkin.ini" del "%~dp0igStatisticsSkin.ini"
EXIT