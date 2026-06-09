@echo off

echo Waiting for wmic to get the display resolution...
(for /f "tokens=1,2" %%a in ('"wmic path Win32_VideoController get CurrentVerticalResolution,CurrentHorizontalResolution"') do call :Resolution %%ax%%b) > MUASetDisplayResolution.reg
EXIT

:Resolution
set resolution=%*
for /f "delims=1234567890" %%a in ("%resolution:~,1%") do EXIT /b 1
echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_CURRENT_USER\Software\Activision\Marvel Ultimate Alliance\Settings\Display]
echo "Resolution"="%resolution%"
EXIT /b 0