@ECHO OFF
REM This file is a collaboration between ak2yny, BaconWizard17, and Rampage.

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
	IF ERRORLEVEL 1	SET game=MUA
	IF ERRORLEVEL 2 SET game=XML2
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


:FEtoLower
call :toLower %*
echo .%1 to .%o%
forfiles /S /M *.%1 /C "cmd /c ren @file @fname.%o%"
EXIT /b

:FOtoLower
call :toLower %*
echo ren "%f%" "%o%"
EXIT /b

:toLower
set "o=%*"
for %%g in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do call set "o=%%o:%%g=%%g%%"
EXIT /b


:XML2
REM Game display name:
set gamename=X-Men Legends 2

REM ask if file extensions should be changed to lowercase
echo.
CHOICE /M "Do you want to change file extensions to lowercase?"
SET lowercaseFiles=%ERRORLEVEL%
echo.

REM ask if folder names should be changed to lowercase
CHOICE /M "Do you want to change folder names to lowercase?"
SET lowercaseFolders=%ERRORLEVEL%
echo.

REM execute the main file deletion script
call :main "%gamename%" XMen2

echo.
REM make the files lowercase if the user chooses
if %lowercaseFiles%==1 (
	echo Renaming file extensions to lowercase. This operation will take several minutes...
    for %%B in (BOYB CHRB IGB NAVB PKGB PKGB PY XMLB) do call :FEtoLower %%B
	echo All files are now lowercase.
	echo.
)

REM Make the folders lowercase if the user chooses
if %lowercaseFolders%==1 (
	echo Renaming all folders to lowercase...
    for /f "delims=" %%i in ('dir /b /ad /s 2^>nul') do set "f=%%~i" & call :FOtoLower %%~ni
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