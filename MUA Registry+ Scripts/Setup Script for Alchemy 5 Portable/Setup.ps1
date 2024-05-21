Function RunAsAdministrator() {
    $CurrentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $CurrentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        # Create a new elevated PowerShell process and start it
        $ElevatedProcess = New-Object Diagnostics.ProcessStartInfo "PowerShell";
        $ElevatedProcess.Arguments = "& '$PSCommandPath'"
        $ElevatedProcess.Verb = "runas"
        [Diagnostics.Process]::Start($ElevatedProcess)
        # Exit from the current, unelevated, process
        EXIT
    }
}
RunAsAdministrator
CLS


if ($PSScriptRoot.Contains(';')) {Write-Host 'The current path contains a semicolon (";"). Please use a different path (move Alchemy portable to a different folder or rename the folder).' -ForegroundColor red; Timeout 10; EXIT 1}

if ($env:IG_ROOT) {$OldDLL = Join-Path $env:IG_ROOT "DLL"}
$NewDLL = Join-Path $PSScriptRoot "DLL"

@"
------------------------------------------------
            Setup Alchemy 5 Portable
------------------------------------------------

"@
$NY = '&No', '&Yes'
# if ((gi $OldDLL).GetHashCode() -in (gi $NewDLL).GetHashCode())
if ($NewDLL -ieq $OldDLL) {
    $Uninstall = $host.UI.PromptForChoice("", "An identical installation was found. Do you want to unregister Alchemy from this system?", $NY, 0)
    if (!$Uninstall) { EXIT 0 }
} elseif ($env:IG_ROOT) {
    $Uninstall = $host.UI.PromptForChoice("", "Alchemy found. Do you want to unregister Alchemy from this system? (Press Enter to update the setup instead.)", $NY, 0)
}

$envkey = 'registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment'
$em = 'Please run the Setup with administrator rights.'
$wn = @"

 An old Alchemy path still exists in the Path variable.
 Please remove or update it manually:
  Control Panel > System > Advanced system settings (near bottom) > Environment Variables.
  Select the "Path" variable (System and/or User) and click on "Edit".
"@
$AO = '&No', '&Finalizer', '&Insight'
$MPath = ((Get-Item -LiteralPath $envkey).GetValue('Path', '', 'DoNotExpandEnvironmentNames') -split ';' -ne '') | ? {$OldDLL -notin $_.TrimEnd('/').TrimEnd('\')}

$MPath | % {if ($_[1] -ne ':') {Write-Host "One or more paths are broken." -ForegroundColor red; Timeout 10; EXIT 1}}
if ($null -ne ($MPath | ? {$_ -imatch '.*Alchemy.*DLL'})) {$wn; Timeout 20}

if ($Uninstall) {
    rp -LiteralPath $envkey IG_ROOT
    if (!$?) {$em; Timeout 10; EXIT 1}
    sp -Type ExpandString -LiteralPath $envkey Path ($MPath -join ';')
    cmd /c FTYPE igb_auto_file=
    cmd /c ASSOC .IGB=
    Timeout 5
}
else {
    sp -Type String -LiteralPath $envkey IG_ROOT $PSScriptRoot
    if (!$?) {$em; Timeout 10; EXIT 1}
    if ($NewDLL -notin $MPath -and "$NewDLL\" -notin $MPath) {
        Set-ItemProperty -Type ExpandString -LiteralPath $envkey Path (($MPath + $NewDLL) -join ';')
    }
    $AA = $host.UI.PromptForChoice("", "Associate .IGB files with Finalizer or Insight Viewer?", $AO, 0)
    switch($AA) {
        0 { EXIT 0 }
        1 { $igApp = 'Finalizer\sgFinalizer' }
        2 { $igApp = 'insight\DX9\insight' }
    }
    $igApp = Join-Path $PSScriptRoot "ArtistPack\$igApp.exe"
    cmd /c FTYPE igb_auto_file=`"$igApp`" `"%1`"
    cmd /c ASSOC .IGB=igb_auto_file
}

EXIT


  # Part of Function from mklement0 @StackOverflow
  # Broadcast WM_SETTINGCHANGE to get the Windows shell to reload the
  # updated environment, via a dummy [Environment]::SetEnvironmentVariable() operation.
  #$dummyName = [guid]::NewGuid().ToString()
  #[Environment]::SetEnvironmentVariable($dummyName, 'foo', 'User')
  #[Environment]::SetEnvironmentVariable($dummyName, [NullString]::value, 'User')

  # Finally, also update the current session's `$env:Path` definition.
  # Note: For simplicity, we always append to the in-process *composite* value,
  #        even though for a -Scope Machine update this isn't strictly the same.
  #$env:Path = ($env:Path -replace ';$') + ';' + $LiteralPath
