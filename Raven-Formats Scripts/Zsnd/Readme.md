# Zsnd

## Requirements
- [Python 3.8 or newer](https://www.python.org/downloads/), incl. [PATH variable](https://cloudacademy.com/wp-content/uploads/2020/01/Python-Windows-installer.png)
- Powershell v3 or newer (tested with v5 on Win 10+)
- Optional [ravenAudio](https://discord.com/channels/449510825385000960/459862699870781451/934369862841688154) (in same folder or `%windir%\system32`)
- Optional xmlb-compile (in same folder or `%windir%\system32`)

## Features
- Full support of Zsnd, including formats for different platforms
- As easy as it gets
- Supports drag & drop

## Instructions
(Using mychar_v.zss as an example)
- Run Zsound.bat.
  - If ZSM/ZSS files exist in the folder, all of them are extracted (mychar_v.zss).
  - Alternatively, drop ZSM/ZSS files (mychar_v.zss) on Zsound.bat.
  - A JSON file with the same name (.json extension instead of .zss/.zsm) is created by Zsnd (mychar_v.json).
  - A new BAT file with the name of the JSON file (.bat extension instead of .json) will be created (mychar_v.bat).
  - If no ZSM/ZSS file exist (and if none is dropped on the BAT), you're asked for a name and platform,
    and an empty JSON file will be created.
- Add and remove sound files to your hearts desire.
  You can make new folders and add sound files anywhere in the same folder and its sub-folders.
- Run the new BAT file (mychar_v.bat).
  The directories will be scanned for any changes twice (added files and removed ones), so it will take a while.
- You'll be asked for details of any new file, so be sure that you know them.
  It's possible do set-up the BAT to include this information, so you're not asked each time.
  For example: If your files are always 22050hz mono (what you usually use in zsm-editor),
  you can open the Zsound.bat with a text editor (e.g. Notepad) and change lines 70, 72, and 74:
  70 to `set sr=22050`
  72 to `set channels=1`
  74 to `set loop=false`
  Similarly, it's possible to define all other inputs in the BAT.
- The ZSM/ZSS file is automatically created or updated (mychar_v.zss).
  (You'll be asked for the extension, if the filename doesn't end in `_m` or `_v` or isn't `x_voice` or `x_common`)

#### To extract ZSS and ZSM files:
- Drop them on Zsound.bat.
- An additional batch file is created as explained above. It can be removed if not needed.

#### To combine JSON to ZSS or ZSM files:
- Drop the JSON files on Zsound.bat.
- You'll be asked for the extension, if the filename doesn't end in `_m` or `_v` or isn't `x_voice` or `x_common`

## Known issues
- Currently no known issues. Thanks for all testers, especially BloodyMares. Please report and bugs that you find.

## Tips
- [XiMpLe](http://www.ximple.cz/download.php) or another JSON table viewer.
