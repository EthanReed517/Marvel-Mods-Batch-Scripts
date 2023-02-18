@echo off

REM define initial variables
set "filePath=C:\Users\ethan\Desktop\Temp"
set language=eng

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