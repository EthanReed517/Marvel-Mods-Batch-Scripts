@echo off

mkdir AnimationMixing hud image2igb "SkinEdit (internal name renamer)" "Alchemy 5 Truly Portable" 2>nul

set default=false dxt1 false true
(call :writeBAT "Alchemy.bat" Extract %default%)>ext.images.bat
(call :writeBAT "Alchemy.bat" IGBconverter %default%)>IGBconverter.bat
(call :writeBAT "Alchemy.bat" image2igb false dds false true)>image2igb\image2igb.bat
(call :writeBAT "Alchemy.bat" image2igb true dxt1 false true)>image2igb\image2igb-fxtext.bat
(call :writeBAT "Alchemy.bat" image2igb false RGBA_8888_32 false true)>"image2igb\image2igb-icons,fonts.bat"
(call :writeBAT "Alchemy.bat" image2igb false fdxt1 MUA true)>image2igb\image2igb-ls.bat
(call :writeBAT "Alchemy.bat" image2igb false false IHQ true)>image2igb\image2igb-pngicons.bat
(call :writeBAT "Alchemy.bat" genGColorFix %default%)>genGColorFix.bat
(call :writeBAT "Alchemy.bat" combineAnimations %default%)>AnimationMixing\_combine.bat
(call :writeBAT "Alchemy.bat" extractAnimations %default%)>AnimationMixing\_extract.bat
(call :writeBAT "Alchemy.bat" previewAnimations %default%)>AnimationMixing\previewAnimations.bat
(call :writeBAT "Alchemy.bat" hud_head_e %default%)>hud\hud_head_e.bat
(call :writeBAT "Alchemy.bat" logos_e %default%)>hud\logos_e.bat
(call :writeBAT "Alchemy.bat" SkinEdit %default%)>"SkinEdit (internal name renamer)\SkinEdit-filenameToSkinName.bat"
(call :writeBAT "Alchemy.bat" SkinEdit false dxt1 false false)>"SkinEdit (internal name renamer)\SkinEdit.bat"
(call :writeBAT "Alchemy.bat" Maps %default%)>Maps.bat
(call :writeBAT "Alchemy.bat" fixSkins %default%)>animdb2actor.bat
(call :writeBAT "Alchemy.bat" ExtractMotionRaven %default%)>ExtractMotion.bat

for /f "delims=" %%b in ('dir /b /s *.bat') do copy /y "%%~b" "Alchemy 5 Truly Portable\"
del "Alchemy 5 Truly Portable\make bat files.bat" "Alchemy 5 Truly Portable\Alchemy.bat"

goto eof

:writeBAT
for /f "skip=2 delims=[]" %%l in ('find /n "automatic settings" "%~1"') do set l=%%l
set /a l-=2
echo @echo off
echo REM chcp 65001 ^>nul
echo.
echo REM -----------------------------------------------------------------------------
echo.
echo REM Settings:
echo.
call :Alchemy %2 %3 %4 %5 %6 %7 %8 %9
echo.
echo REM -----------------------------------------------------------------------------
PowerShell "gc '%~1' | Select-Object -Skip %l%"
EXIT /b

:Alchemy
echo REM What operation should be made? (=IGBconverter; extract images =Extract; =image2igb; hex edit skins =SkinEdit; generate GlobalColor (fix black status effect) =genGColorFix; =previewAnimations; =extractAnimations; =combineAnimations; =listAnimations; Optimize animations =ExtractMotionRaven; make HUD heads from images =hud_head_e; same for team logos =logos_e; =convert_to_igGeometryAttr2; Texture Map Editor =Maps; write igSceneInfo =fixSkins; remove igSceneInfo =remInfo; =ask)
echo set operation=%1
echo REM Is this a simple tool with the same name as operation? (=true or =false) 
echo set OpIsTool=false
echo REM Create mip-maps? (=true or =false), useful for lower resolutions only - to ask for each input file, use =ask at the operation settings
echo set mipmaps=%2
echo REM Remove optimization sets? (Yes =true; No =false; Remove useful ones as well =all)
echo set delOptSets=true
echo REM Remove the input files when done? (Yes =true; No =false)
echo REM WARNING! Don't set it to =true, unless you're 100%% sure you don't need them anymore.
echo set delInputFiles=false
echo REM Ask before backing up existing files? (yes =true; no =false; always replace, not safe! =replace)
echo set askbackup=false
echo REM Include subfolders (recursive mode)? (yes =true; no =false)
echo set recursive=false
echo.
echo REM IGBconverter settings (detects actorConverter and animationConverter):
echo REM Format (valid values: =FBX, =OBJ, =DAE, =ask)
echo set format=FBX
echo REM Extract textures as well? (yes =true, no =false)
echo set exttextrs=true
echo.
echo REM Image Extract settings:
echo REM Create subfolders for each file, where the images are put in? (yes =true, no =false)
echo set subfolder=false
echo REM Check for PNG format, and extract PNG instead of TGA when found? (yes =true, no =false)
echo set detectPNG=true
echo REM Remove Mip Map textures? (yes =true, no =false) (enm must be opposite)
echo set remMipMap=true
echo set enm=false
echo REM Remove internal and reference extracted instead? (yes =true, no =false)
echo set refExtTex=false
echo.
echo REM HUD settings:
echo REM Quality and speed of animated HUDs aka FPS (=10, =16)
echo set hud_fps=16
echo REM Play mode of animated HUDs (repeat =0, bounce =2)
echo set hud_apm=0
echo REM Are .png files animated aPNG format? (yes =true, no =false)
echo set hud_apng=false
echo REM Define a tile side length: (Auto =[Math]::Round($time + 3.7), min. =4, max. =10)
echo set tile_size=[Math]::Round($time + 3.7)
echo.
echo REM image2igb settings:
echo REM Prompt for conversion? (ask for all exc. dds =true; ask for all exc. png+dds =false; no conversion =never; ask for all + dds =dds)
echo REM Always convert all, except png+dds. (to DDS DXT1 =dxt1; to DDS DXT5 =dxt5)
echo REM Force conversion of all files (to DDS DXT1 =fdxt1; to DDS DXT5 =fdxt5; to other formats, as defined below, eg. =RGBA_5551_16)
echo set askconv=%3
echo REM Force conversion to one of the following formats (use the format as option in the askconv= setting above):
echo REM -- rgb formats for icons and effect textures
echo REM RGBA_4444_16
echo REM RGBA_8888_32
echo REM RGBA_2222_8
echo REM RGBA_5551_16   (default)
echo REM RGBA_128F
echo REM -- dxt textures for most model (skin, boltons, etc) textures
echo REM RGBA_DXT1
echo REM RGBA_DXT3
echo REM RGBA_DXT5
echo REM -- indexed PNG color formats
echo REM X_8
echo REM X_4
echo REM TILED_X_8_PSP
echo REM TILED_X_4_PSP
echo REM -- gamecube textures
echo REM TILED_DXT1_GAMECUBE   (seems not to work, use normal DXT1 instead)
echo REM TILED_RGBA_5553_16_GAMECUBE
echo REM TILED_L_8_GAMECUBE
echo REM TILED_LA_88_16_GAMECUBE
echo REM TILED_LA_44_8_GAMECUBE
echo REM -- rgb formats without transparency
echo REM RGB_332_8
echo REM RGB_888_24
echo REM RGB_565_16
echo REM TILED_RGB_565_16_GAMECUBE
echo REM -- intensity/grayscale formats
echo REM L_8
echo REM LA_44_8
echo REM LA_88_16
echo REM A_8
echo REM -- reset: =INVALID
echo REM -- example:
echo REM set askconv=RGBA_8888_32
echo REM -- 
echo REM Force asking to convert PNG. (=true; =false)
echo set askpng=false
echo REM Resize? (no resize =false; to loading screens for Ultimate Alliance 2048x1024 =MUA, for X-Men Legends 2 512x512 =XML2; icons for last-gen consoles 128x128 =ILQ; icons for PC ^& next-gen consoles 256x256 =IHQ; prompt for each file =ask)
echo REM Custom resize values possible (eg. 1024x1024 =1024; 100x100 =100)
echo set maxHeight=%4
echo REM Custom width, to be used with custom height (eg. 64x64 =identical ^& maxHeight=64; 1024x512 =1024 ^& maxHeight=512)
echo set maxWidth=identical
echo REM Minification/Magnification method? (linear =true; nearest, recommended =false)
echo set MagFilter=false
echo REM WrapS/T method? (repeat, default =false; clamp =true)
echo set WrapST=false
echo.
echo REM SkinEdit (hex-editing with Alchemy) Settings:
echo REM Always rename (hex-edit) to the Filename? (yes =true; no =false)
echo REM The file must already have the correct name.
echo set SkinEditToFilename=%5
echo.
echo REM Preview Animations Settings:
echo REM Enter the full path and name to the skin (rigged IGB model) that you want to use to preview the animations with.
echo set "actorSkin=%%IG_ROOT%%\ArtistPack\insight\DX9\actor.igb"
echo.
echo REM Animation Mixer Settings (combine and extract):
echo REM Never use existing extraction.txt/combine.txt files? (Yes =true; No =false)
echo set nevtxt=false
echo REM Extract/combine animations with wrong names as well? (Yes =true; No =false)
echo set extall=false
echo REM Remove extract TXT files? (Yes =true; No =false)
echo set remext=false
echo REM Auto name when combining: Always use the first folder name? ( =true); Always use the first file name? ( =file); (No =false)
echo set autonm=false
echo REM Enter an IGB file for the skeleton. (Use the first input file "skeleton="; use fightstyle default incl. ponytail =_fightstyle_default)
echo REM Can be skin or animation. Can include path relative to the BAT. Eg. skeleton=skeletons\humanWponytail\elektra.igb
echo set skeleton=_fightstyle_default
echo REM Use name of files for animations? (Yes, they match the anim. name =true; No, scan the files for anim. names =false)
echo set animfn=true
echo REM Extract skin? (Yes =true; Skin only =only; No =false)
echo set exskin=false
echo REM Combine skin? (Yes =true; Specific skin IGB, eg. =subfolder\skin.igb; No =false)
echo set coskin=false
echo REM Use better scene construction load_actor_database (often fails)? (Yes =true; No =false)
echo set actor+=false
echo REM Experimental: Use source skin name? (Yes =true; No =false)
echo set skinSr=false
echo.
echo REM Texture Map Editor settings:
echo REM Convert to DXT/DDS? Ideal for PC. (yes to DXT1 =1; yes to DXT3 =3; no =false)
echo REM Normal maps are always DXT5; DDS never converted; PNG acc. settings; Other always converted
echo set ConvertDDSf=1
echo REM List all images in subfolders? (yes, always =true; no, root folder only =false; ask once =ask)
echo set SubfoldAuto=true
echo REM Always process all input files (IGB)?  (Yes =true; No, asks first =false)
echo set MultiInputA=false
EXIT /b