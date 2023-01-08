@echo off
REM chcp 65001 >nul

REM -----------------------------------------------------------------------------

REM Settings:
REM Include subfolders (recursive mode)? (yes =true; no =false)
set recursive=false

REM -----------------------------------------------------------------------------

REM these are automatic settings, don't edit them:
set inext=.bak, .xml, .txt, .json

for %%p in (%*) do goto ccl
set "f=%~dp0"
set "fullpath=%f:~0,-1%"
call :isfolder
GOTO End

:ccl
if ""=="%ccl%" call :convCCL ccl
for %%p in (%ccl%) do (
 set fullpath=%%~p
 2>nul pushd "%%~p" && call :isfolder || call :isfiles
)
GOTO End

:isfolder
cd /d "%fullpath:"=%"
call :rec%recursive%
for /f "delims=" %%i in ('dir %inext:.=*.% 2^>nul') do (
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
del "%fullpath:"=%"
EXIT /b

:convCCL
set "i=%cmdcmdline:"=""%"
set "i=%i:*"" =%"
set "%1=%i:~0,-2%"
:fixQ
call set "i=%%%1:^=^^%%"
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