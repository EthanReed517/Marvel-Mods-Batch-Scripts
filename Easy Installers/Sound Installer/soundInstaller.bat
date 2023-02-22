@echo off

REM define initial variables
REM File path where the sounds should be installed (if blank, will ask)
set "%filePath%="
REM Select a language (eng = English, blank = ask)
set language="eng"

REM see if the file path is defined
if "%filePath%"=="" (
	REM get the file path
	set /p "filePath=Enter your game directory or an MO2 mod folder: "
)

REM see if the language is defined
if %language%=="" (
	REM get the language
	set /p "language=Enter a language option (eng = English): "
)

REM enable delayed expansion for the variables in the loop
setlocal EnableDelayedExpansion

REM loop through the drag and dropped files
for %%a in (%*) do (
	REM get the file name
	set fileName=%%~na
	REM define the destination path for the sound
	set "soundPath=!filepath!\sounds\!language!\!fileName:~0,1!\!fileName:~1,1!"
	REM create the destination if it doesn't exist
	if not exist "!soundPath!" md "!soundPath!"
	REM copy the sound
	copy "%%~a" "!soundPath!"
)
pause