@echo off

REM define initial variables
REM File path where the sounds should be installed (if blank, will ask)
set filePath=""
set language=eng

REM see if the file path is defined
if %filePath%=="" (
	set /p "filePath=Enter your game directory or an MO2 mod folder: "
)

REM enable delayed expansion for the variables in the loop
setlocal EnableDelayedExpansion

REM loop through the drag and dropped files
for %%a in (%*) do (
	REM get the file name
	set fileName=%%~na
	REM define the destination path for the sound
	set soundPath=!filepath!\sounds\!language!\!fileName:~0,1!\!fileName:~1,1!
	REM create the destination if it doesn't exist
	if not exist !soundPath! md !soundPath!
	REM copy the sound
	copy %%a !soundPath!
)
pause