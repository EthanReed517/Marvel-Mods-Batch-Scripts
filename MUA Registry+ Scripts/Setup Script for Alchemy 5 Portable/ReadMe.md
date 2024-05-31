#### Instructions:
Run Setup.bat with Administrator rights.
  - If the command window doesn't open (flashes only), there is a problem with the current path.
    In this case, run Setup.bat from a NEW [elevated command prompt](https://www.youtube.com/watch?v=tK6jJFsLnqY) and type the path and name of the Setup BAT, including double-quotes, eg. `"C:\Alchemy\Setup.bat"`, then press enter.
  - Associate IGB files with Finalizer (view and modify content as text), Insight viewer (view IGB visually), or not, as you want.

This allows Alchemy batches/tools to run correctly, and associates IGB files with the Alchemy 5 Finalizer.

#### Hints:
If you move Alchemy Portable to a different folder, you can run Setup.bat again to update the information.
If you want to remove Alchemy Portable, you can run Setup.bat - if it is registered, you can choose to uninstall it.
A reboot or login may be required for the dll libraries to register correctly (path variable).

#### Notes:
 - Starting from May 30th 2024, PowerShell 3.0 (i.e. Windows 7 SP1 or newer) is required. For older systems, please use [this](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/3e39bf6b8e5dfc0640af57919d7c71eeabf71829/MUA%20Registry%2B%20Scripts/Setup%20Script%20for%20Alchemy%205%20Portable/Setup.bat) version.
 - PowerShell scripts (.ps1) can't be shared, because execution of scripts originating from other systems is prevented by default for security reasons. If someone wishes to use the .ps1 script, they should create a new file, name it Setup.ps1 and copy/paste the contents from [here](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/MUA%20Registry%2B%20Scripts/Setup%20Script%20for%20Alchemy%205%20Portable/Setup.ps1).
