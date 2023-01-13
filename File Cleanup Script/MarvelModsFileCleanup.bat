@ECHO OFF
REM This file is a collaboration between ak2yny, BaconWizard17, and Rampage.

title Marvel Mods File Cleanup
color 0b

REM Define game (MUA; XML2; choice)
set game=choice
REM Define file formats to remove (use spaces to separate):
set ff=igt xml
REM Define languages to keep (use spaces to separate):
set lk=eng

if %game%==choice (
	echo Game not selected. Please select from the list. 
	echo [1] Marvel: Ultimate Alliance
	echo [2] X-Men Legends 2
	CHOICE /C 12 /M "Which game are you using? "
	IF ERRORLEVEL 1	SET game=MUA
	IF ERRORLEVEL 2 SET game=XML2
	echo.
)

goto %game% 


:main
title %gamename% File Cleanup

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

REM execute the main file deletion script
call :main "%gamename%" XMen2

REM ask if file extensions should be changed to lowercase
echo.
CHOICE /M "Do you want to change file extensions to lowercase?"
SET lowercaseFiles=%ERRORLEVEL%
REM ask if folder names should be changed to lowercase
CHOICE /M "Do you want to change folder names to lowercase?"
SET lowercaseFolders=%ERRORLEVEL%

echo.
REM make the files lowercase if the user chooses
if %lowercaseFiles%==1 (
	echo Renaming file extensions to lowercase. This will take a few minutes . . .
    for %%B in (BOYB CHRB IGB NAVB PKGB PY XMLB) do echo .%%B to lowercase & for /f "delims=" %%F in ('dir /b /a-d /s /l *%%B 2^>nul') do for %%E in ("_%%~F") do ren "%%~F" "%%~nF%%~xE"
	echo All files are now lowercase.
	echo.
)

REM Make the folders lowercase if the user chooses
if %lowercaseFolders%==1 (
	echo Renaming all folders to lowercase. This will take a few seconds . . .
    for /f "delims=" %%i in ('dir /b /ad /s /l 2^>nul') do for %%t in ("a%%~i") do ren "%%~i" "%%~nt"
	echo All folders are now lowercase.
)

:End
echo.
echo Removal of all unused content is now completed.
pause
goto EOF

REM Hulk has many unused convos in the game files, i'm just not sure which they are exactly. -Rampage
REM There are tons of scripts in the scripts folder that aren't used in-game but it's tough to know which are and arent used so I didnt remove any script files. -Rampage