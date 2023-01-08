REM This file is a collaboration between ak2yny, BaconWizard17, and Rampage.

@ECHO OFF

REM Define game (MUA; XML2; choice)
set game=choice
REM Define file formats to remove (use spaces to separate):
set ff=igt xml
REM Define languages to keep (use spaces to separate):
set lk=eng

if %game%==choice (
	echo Game not selected. 
	echo [1] Marvel: Ultimate Alliance
	echo [2] X-Men Legends II
	CHOICE /C 12 /M "Which game are you using? "
	IF ERRORLEVEL 2 SET game=XML2 & goto XML2
	IF ERRORLEVEL 1	SET game=MUA & goto MUA
)

goto %game% 


:main
title %gamename% File Cleanup
color 0b

REM Define variables:
set lf=eng ita fre ger spa pol rus 

REM Display welcome message
echo Welcome to the %gamename% File Cleanup Script
echo.

REM Check the name of the current folder
for %%I in (.) do set "EXE=%%~dpI%~1\%2.exe"
REM If it's in the game folder, don't need the file path. 
REM Otherwise ask for it.
if NOT exist "%EXE%" (
	set /p gamepath=Please paste or type the path to %game% here: 
)
cd %gamepath%
echo.

REM begin the file deletion process with generally unused files.
echo Removing generally unused files . . .
setlocal enableDelayedExpansion
for %%L in (%lk%) do set lf=!lf:%%L =!
set ff=%lf: =b %%ff%
del >nul *.%ff: = *.% /s
for %%B in (%lf%) do del >nul 2>nul igct%%B.bnx

REM remove .xmlb files that have .engb equivalents.
echo Removing duplicate .xmlb files . . .
for /r %%I in (*.xmlb) do (
	if exist "%%~pnI.%lk:~,3%b" del "%%I"
)
EXIT /b


:MUA
REM Game display name:
set gamename=Marvel: Ultimate Alliance

REM execute the main script
call :main "%gamename::= -%" game

REM remove unused files from the actors folder.
echo Removing unused files from the actors folder . . .
REM remove unused animation. (fightstyle_finesse1.igb)
del >nul actors\fightstyle_finesse1.igb /s

goto End


:XML2
REM Game display name:
set gamename=X-Men Legends 2

REM ask if file extensions should be changed to lowercase
echo.
CHOICE /M "Do you want to change file extensions to lowercase?"
IF ERRORLEVEL 1 SET lowercaseFiles=Y
IF ERRORLEVEL 2 SET lowercaseFiles=N
echo.

REM ask if folder names should be changed to lowercase
CHOICE /M "Do you want to change folder names to lowercase?"
IF ERRORLEVEL 1 SET lowercaseFolders=Y
IF ERRORLEVEL 2 SET lowercaseFolders=N
echo.

REM execute the main file deletion script
call :main "%gamename%" XMen2

REM make the files lowercase if the user chooses
if %lowercaseFiles%==Y (
	echo.
	echo Renaming file extensions to lowercase. This operation will take several minutes...
	echo .BOYB to .boyb
	forfiles /S /M *.BOYB /C "cmd /c rename @file @fname.boyb"
	echo .CHRB to .chrb
	forfiles /S /M *.CHRB /C "cmd /c rename @file @fname.chrb"
	echo .IGB to .igb
	forfiles /S /M *.IGB /C "cmd /c rename @file @fname.igb"
	echo .NAVB to .navb
	forfiles /S /M *.NAVB /C "cmd /c rename @file @fname.navb"
	echo .PKGB to .pkgb
	forfiles /S /M *.PKGB /C "cmd /c rename @file @fname.pkgb"
	echo .PY to .py
	forfiles /S /M *.PY /C "cmd /c rename @file @fname.py"
	echo .XMLB to .xmlb
	forfiles /S /M *.XMLB /C "cmd /c rename @file @fname.xmlb"
	echo All files are now lowercase.
	echo.
)

REM Make the folders lowercase if the user chooses
if %lowercaseFolders%==Y (
	echo Renaming folders to lowercase...
	ren "Actors" "actors"
	ren "Automaps" "automaps"
	ren "Conversations" "conversations"
	ren "Data" "data"
	ren "Dialogs" "dialogs"
	ren "Docs" "docs"
	ren "Effects" "effects"
	ren "HUD" "hud"
	ren "Maps" "maps"
	ren "maps/Act0" "act0"
	ren "maps/Act1" "act1"
	ren "maps/Act2" "act2"
	ren "maps/Act3" "act3"
	ren "maps/Act4" "act4"
	ren "maps/Act5" "act5"
	ren "maps/Bonus" "bonus"
	ren "maps/Briefing" "briefing"
	ren "maps/Menu" "menu"
	ren "maps/Package" "package"
	ren "maps/Svs" "svs"
	ren "Models" "models"
	ren "MotionPaths" "motionpaths"
	ren "Movies" "movies"
	ren "Packages" "packages"
	ren "Plugins" "plugins"
	if exist "Save" ren "Save" "save"
	if exist "Screenshots" ren "Screenshots" "screenshots"
	ren "Scripts" "scripts"
	ren "Skybox" "skybox"
	ren "Sounds" "sounds"
	ren "Subtitles" "subtitles"
	ren "Texs" "texs"
	ren "Textures" "textures"
	ren "UI" "ui"
	echo All folders are now lowercase
	echo.
)

:End
echo.
echo Removal of all unused content is now completed.
pause
goto EOF

REM Hulk has many unused convos in the game files, i'm just not sure which they are exactly. -Rampage
REM There are tons of scripts in the scripts folder that aren't used in-game but it's tough to know which are and arent used so I didnt remove any script files. -Rampage