## Installation:
- Raven Formats (RF) by nikita488: Install [Python 3.8 or newer](https://www.python.org/downloads/), incl. [PATH variable](https://i.imgur.com/u3yCFxq.png), then enter `pip install raven-formats` in command ([RF](https://pypi.org/project/raven-formats/)).
- xmlb-compile (XC) by NBA2Kstuff: Install it by moving, copying, or extracting [xmlb-compile.exe](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/Raven-Formats%20Scripts/QuickBatch/xmlb-compile.exe) to "C:\Windows".

Portable (no installation required - do this instead):
- Raven Formats (RF) by nikita488: Download and extract [OpenHeroSelect by Tony Stark](https://github.com/TheRealPSV/OpenHeroSelect/releases).
Use the .BAT files from this pack next to "json2xmlb.exe" and "xml2json.exe".
- xmlb-compile (XC) by NBA2Kstuff: [xmlb-compile.exe](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/Raven-Formats%20Scripts/QuickBatch/xmlb-compile.exe) is included. No further steps required (this pack needs to be extracted).

 

## Information about each .BAT file:

`(RF)Compile.bat`:          Compile .txt, .xml, and .json files to the format of your choice.

                            Automatically detects the output format, if part of the filename, like this: "herostat.engb.txt".
                            Automatically detects the input format (JSON, NBA2Kstuff’s XML, and true XML) and converts if necessary.
                            "Converter.py" is required for the old XML format by NBA2Kstuff. Keep it next to the BAT.
                            WARNING: Avoid multiple input files with the same name (eg. "herostat.xml" and "herostat.json").

`(RF)DecompileJSON.bat`:    Decompile Raven Format files* to [.json](https://www.w3schools.com/js/js_json_intro.asp) files.

`(RF)DecompileTrueXML.bat`: Decompile Raven Format files* to true [.xml](https://www.w3schools.com/xml/xml_whatis.asp) files.

`(RF)Edit.bat`:             Decompile Raven Format files* to .json files and open them one by one in Notepad.

                            When Notepad is closed, compiles the .json files to back to the original files.

`(XC)Decompile.bat`:        Decompile Raven Format files* to .txt files ([NBA2Kstuff’s XML format** - left in the picture](https://i.imgur.com/mtEzMDh.png)).

`(XC)Edit.bat`:             Decompile Raven Format files* to .txt files (NBA2Kstuff’s XML format**) and open them one by one in Notepad.

                            When Notepad is closed, compiles the ".txt" files to back to the original files.

`(XCtoRF)Convert.bat`:      Convert NBA2Kstuff’s XML format** (XC) files to .json for Raven Formats (RF).

                            The file "converter.py" needs to be next to the .BAT.

`Cleanup.bat`:              Delete all .txt, .xml, .json, and .bak files in this folder.


All batch files can also be used by dragging & dropping any amount of files or folders on them.
Drag & Drop has a limit of roughly 75 files and folders at a time. ***

```
*   Raven Format files are: xmlb, engb (and other languages, eg. itab, freb, etc), pkgb, boyb, chrb, navb
```
```
**  XC doesn't work with special characters, such as "&" or cyrillic letters. This limitation doesn't apply to the other formats.
```
```
*** The string length limit is 8191. Calculations:
    File limit average: 8158 ÷ 110 = 75 (74)
    File limit long MUA path: 8158 ÷ 140 = 58
    File limit max path length: 8158 ÷ 280 = 29

    Note: The limit does NOT include files inside dropped folders.

    Average path length 100, plus reserve: 110
    Path length using "C:\Program Files (x86)\Activision\Marvel - Ultimate Alliance\conversations\act1\atlantis\atlantis1\namorita_kelp_found.engb", plus reserve: 140
    Max. path length with the standard limit (260), plus reserve: 280
    Max. path length without the standard limit: infinite (not gonna calculate, this will cause issues, only drop one file/folder at a time)

    Subtraction of cmd string C:\Windows\system32\cmd.exe /c "": 33 (8191-33=8158)
```

 

## Expert tips:

- If you open a .BAT file with a text editor, you can change the settings at the top.
  All .BAT files are actually identical, except for the settings at the top. Explore the settings ;).
  
- I intentionally created it so, that sub-folders are ignored.
  Use the search function of the file explorer to display all files, even in sub-folders.
  Then use drag&drop with all or a selection of files and/or folders.
  Sub-folders can be included by setting the recurseive mode to `true` in the settings.

- The batches will show a message when there is an error.
  When the input file is in the old XML format, the error can sometimes not be located exactly.
   In this case, the error will show an `IndexError` from the converter and a `file not found` error from the compiler.
   Usually the error is extra white spaces, as added after a bracket `} `, or added by the editor with a new line `   }/n   /n   […]`.
