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
- Run Zsnd.
  If a ZSM/ZSS file exists in the folder, all of them are extracted.
  A .json file with the same name (.json extension instead of .zss/.zsm) is created by Zsnd.
  A new BAT file with the name of the JSON file (.bat extension instead of .json) will be created.
  If no ZSM/ZSS file exist (and if none is dropped on the BAT), you're asked for a name and platform,
  and an empty .json file will be created.
- Add and remove sound files to your hearts desire.
  You can make new folders and add sound files anywhere in the same folder and its sub-folders.
- Run the new BAT file (the one with the same name as the JSON).
  The directories will be scanned for any changes twice (added files and removed ones), so it will take a while.
- You'll be asked for details of any new file, so be sure that you know them.
  It's possible do set-up the BAT to include this information, so you're not asked each time.
  For example: If your files are always 22050hz mono (what you usually use in zsm-editor),
  you can open the Zsnd..bat with a text editor (eg. Notepad) and change lines 64, 66, and 68:
  64 to `set sr=22050`
  66 to `set channels=1`
  68 to `set loop=false`
  Similarly, it's possible to define all other inputs in the BAT, except the hash.
- ZSS/ZSM file is automatically created.
  (You'll be asked for the extension, if the filename doesn't end in `_m` or `_v` or is `x_voice` or `x_common`)

## Known issues
- The BAT has a lot of features, but they haven't all been tested.
  If you want to use any of these features (eg. add music) consider this batch in alpha state.

## Tips
- [XiMpLe](http://www.ximple.cz/download.php) or another JSON table viewer.
