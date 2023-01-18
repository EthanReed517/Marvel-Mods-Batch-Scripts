@echo off

set zsnd=false false false
set default=json false %zsnd%
mkdir QuickBatch Zsnd 2>nul
(call :writeBAT "(RF)AIO.bat" compile %default%)>QuickBatch\(RF)Compile.bat
(call :writeBAT "(RF)AIO.bat" decompile json false %zsnd%)>QuickBatch\(RF)DecompileJSON.bat
(call :writeBAT "(RF)AIO.bat" decompile xml false %zsnd%)>QuickBatch\(RF)DecompileTrueXML.bat
(call :writeBAT "(RF)AIO.bat" edit %default%)>QuickBatch\(RF)Edit.bat
(call :writeBAT "(RF)AIO.bat" convert %default%)>QuickBatch\(XCtoRF)Convert.bat
(call :writeBAT "(RF)AIO.bat" compile lxml false %zsnd% txt)>(XC)Compile.bat
(call :writeBAT "(RF)AIO.bat" decompile lxml false %zsnd% txt)>QuickBatch\(XC)Decompile.bat
(call :writeBAT "(RF)AIO.bat" edit lxml false %zsnd% txt)>QuickBatch\(XC)Edit.bat
copy Cleanup.bat QuickBatch\Cleanup.bat
copy ReadMe.md QuickBatch\!ReadMe.md
(call :writeBAT "(RF)AIO.bat" PackageCloner %default%)>PackageCloner.bat
(call :writeBAT "(RF)AIO.bat" ModCloner %default%)>ModRenumberer.bat
(call :writeBAT "(RF)AIO.bat" Herostat-Skin-Editor lxml false %zsnd% txt)>Herostat-Skin-Editor.bat
(call :writeBAT "(RF)AIO.bat" SkinsHelper %default%)>SkinInstaller.bat
(call :writeBAT "(RF)AIO.bat" editZSSZSM json true false true false)>Zsnd\Zsnd..bat
(call :writeBAT "(RF)AIO.bat" update json true true true true "" %%%%~dp0x_voice.json)>Zsnd\build_x_voice.bat
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
call :RFsettings %2 %3 %4 %5 %6 %7 %8 %9
echo.
echo REM -----------------------------------------------------------------------------
more +%l% "%~1"
EXIT /b

:RFsettings
echo REM What operation should be made? (=decompile; =compile; =edit; =convert; =ask; =detect)
echo REM (Operations for Zsnd: =extract; =combine; =update; =editZSSZSM; =editJSON; add sound files =addWAV; convert WAV files for old versions of Zsnd =convertW; convert multi-channel sounds =ravenAudio)
echo REM (Operations that use Raven-Formats: =PackageCloner; =ModCloner; =Herostat-Skin-Editor; =SkinsHelper)
echo REM (Alchemy operations used by other operations: =genGColorFix; =SkinEditFN)
echo set operation=%1
echo REM Set the decompile/convert format: (JSON =json; true XML =xml; NBA2kStuff's XML =lxml)
echo set decformat=%2
echo REM Rename the decompiled extension to below? (enter the extension, eg.: =txt; don't rename: customext=)
echo set customext=%~7
echo REM Allow all file formats, when dragging^&dropping files? (yes =true; no =false)
echo set allowfext=false
echo REM Always compile to this format if the format couldn't be detected (eg. =xmlb)
echo set extALL=
echo REM Delete decompiled files? (yes =true; no =false)
echo set deletedec=false
echo REM Ask before backing up existing files? (yes =true; no =false; always replace, not safe! =replace)
echo set askbackup=false
echo REM Include subfolders (recursive mode)? (yes =true; no =false)
echo set recursive=%3
echo REM Path to MUA, or a MUA MO2 mod folder, or OpenHeroSelect? (for herostat names)
echo set "MUAOHSpath="
echo.
echo REM Zsnd settings:
echo REM Location of portable Zsnd? (folder where zsnd.py and hashes.json are in)
echo set "zsndp=%%~dp0zsnd"
echo REM Use portable Zsnd? (Yes =true; No =false) (Still used for conversion)
echo set usezsnd=%4
echo REM Extract to the input folder? (yes, extract at same location as file =true; no, extract to where Zsnd..bat is =false; can be a path ending with \ as well)
echo set outfile=true
echo.
echo REM addWAV and modify JSON Settings:
echo REM Specify a JSON file to add the sounds to. This is useful for x_voice for example.
echo set "oldjson=%8"
echo REM Automatically combine to ZSS/ZSM at the end? (Yes =true; No =false)
echo set combine=%5
echo REM For the new file: Do you want to be asked for a new name? (ask, even if a JSON has been found or selected =true; ask, always create new json =new; auto name if JSON exists =false; update if JSON exists =update; take the name of the input folder instead of the JSON, behaves like false =folder; always take the folder name, will never ask =forcefolder)
echo REM For other Zsnd operations, it will take the names of ZSS/ZSM or JSON files respectively.
echo set askname=false
echo REM Define a specific subfolder to move WAV files into. Only for x_voice.
echo set subfolder=
echo REM Move? (move to the folder next to the JSON, as defined =destination; use the source file - when conv. move the files back and make a backup of the unconverted files =source; when conv. move the files back to the source and replace the unconverted files =replace)
echo REM WARNING for destination: Avoid identical names if dropping files from multiple sources.
echo set movewhr=destination
echo REM Remove the header of WAV files? (only useful for old versions of Zsnd).
echo REM (no, my portable Zsnd is new =false; yes, default, converts all WAVs =true)
echo set remHead=%6
echo REM Read sample-reate, and flags, in addition to the hash in the source JSON? (yes =true; no, read hash only =false; no, don't read hash either =never)
echo set asample=never
echo REM Ask for a new hash? (yes =true; automatically generate a custom hash, eg. =REPLACE_THIS_HASH; automatically generate hash with filename =file)
echo set askhash=file
echo REM Choose a sample_index number? (Yes =true; No, add at end =false; Yes, same for all =all)
echo set chIndex=all
echo REM Define a minimum index number (default =0; allow all minindx=)
echo set minindx=0
echo REM Pre-define sample information (leave undefined to get prompted):
echo REM Sample rate PSP/PS2 standard =11025; all other standard =22050; music standard =41000; =44100
echo set sr=
echo REM Channels =1; =2; =4
echo set channels=
echo REM Loop =true; =false
echo set loop=
echo REM Hash flags =31; =255 (Currently unknow what it does. Leave it 31 or 255.)
echo set flgh=31
echo.
echo REM PackageCloner settings:
echo REM New package number(s)? (a number eg. =12-14; =ask; ask once only =all)
echo set newPKGn=ask
echo REM Clone existing NC packages, when not among input files? (no, clone from combat instead =false; yes =true; no, only clone combat, ignore NC =never)
echo REM Also sets behaviour if no NC package exists. (clone from combat =false; don't create =true or =never)
echo set cloneNC=true
echo.
echo REM SkinsHelper settings:
echo REM Edit herostats to add or (re)name a skin? (yes =true; no =false)
echo set EditStat=true
EXIT /b
