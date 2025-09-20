@echo off

set psc=Powershell ^
"Add-Type -AssemblyName System.Windows.Forms; ^
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{^
  Title = 'Select Herostat...';^
  Filter = 'Herostat^|herostat.engb'^
}; ^
if^($FileBrowser.ShowDialog^(^) -eq 'OK'^) {^
  $shell = New-Object -COM WScript.Shell; ^
  $l = Join-Path ([Environment]::GetFolderPath('Desktop')) 'MUA Edit Herostat.lnk'; ^
  $s = $shell.CreateShortcut($l); ^
  $cd = Resolve-Path '.'; ^
  $s.WorkingDirectory = $cd.Path; ^
  $s.TargetPath = Join-Path $cd '(XC)Edit.bat'; ^
  $s.Arguments = '"""' + $FileBrowser.FileName + '"""'; ^
  $s.Save^(^)^
}"
%psc%
if errorlevel 0 echo Shortcut created successfully.
pause