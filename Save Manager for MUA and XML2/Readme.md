# Features
- Backup saves and settings to profiles
- Restore saves and settings from profiles
- Supports MUA and XML
- Modifies the registry for controllers and display separately
- Is able to change the resolution in the registry

# Instructions
It works with folders in the save folder in documents (`[...]\Documents\Activision\[game]`), which it calls profiles.
Registry is saved as REG files, which can manually be restored (added) by double-clicking on them. The save manager restores them as well, as long as they exist (with the correct file name) in the profile folder.
There are options to define what the save manager should do. By default, it saves the save and dat files in the Save folder and the complete registry to a profile of your choice. To change this, you can open the BAT file with a text editor (right-click > Edit) and change the letters after `set o=`.
- Initially this is set to `set o=buas`, which means backup Ultimate Alliance, all registry & saves.
- To change it to restore XML2 controller registry, you would have to set it to `set o=rxc`.
- You can combine as many options as you want even all of them, ie. `set o=bruxacds`.
When you set-up your options, you can save a copy of the BAT with a name that describes the options. For example:
- Save a BAT as backupXML2settings.bat with the options `set o=bxa`
- Save a BAT as backupMUAsave.bat with the options `set o=bus`.
- To change the resolution, you have to use these options: `set o=rxd` for XML2 or `set o=rud` for MUA (can be combined as well).

# [Release](https://discord.com/channels/449510825385000960/459862699870781451/1036370347391455312)
