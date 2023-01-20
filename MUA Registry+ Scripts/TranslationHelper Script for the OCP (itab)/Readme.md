## Credits:
-----------

- Many thanks to the authors of OCP 1.3.
- Package created by ak2yny.
- gamevicio.com (PT-BR translation)
- Surfer (RU translation)
- DLAN (ES translation)
- Enchlore (title font)
- ak2yny (medium font)



## Introduction:
----------------

This package provides existing .itab files for modders who would like to contribute to an Italian translation for OCP content.
There are over 300 new and updated files that need translation, but many lines can be copied from an earlier version or original file.

IMPORTANT: For some new files (eg. talents files, some conversation files) of OCP don't exist any .itab files. See "Other Languages" and "ita translation" for more info.


## Description of folders:
--------------------------

`batch`:             Move files in here and click on the batch that does what you want. Dropping files/folders onto batch works too.
`conversion`:        Use this folder and the TranslationHelper.bat inside to create a full translation.
`eng translation`:  `.engb` only from a fully installed OCP updated MUA.
`ita translation`:  `.engb` + `.itab` from a fully installed OCP updated MUA, w/o files that have an Italian translation already.

#### existing translations: Various translations from other sources. Only the unmodded game is available. More infos inside.
`MUA_Portugese_Translation`: Pt. Brazil by Gamevicio. (Its font has a small problem).
`Spanish by DLAN`: Full Spanish translation (only very few missing). Replaces engb instead of using its own spab.
`Russian by Surfer (marvelgames.3bb.ru)`: Russian translation. The igct.bnx originally wasn't encoded correctly.
`Italian backup`: .itab files that come with the game. Only used files are translated, but all untranslated files are included too.

`MUA Font update for EUR translations`:
An updated font for European and Brazilian translations (Russian & Polish not included).
Small font on low resolution (640x480 + 800x600) is not supported.
Spanish isn't fully supported because the game replaces ¿ with ™ (see below).


## How to:
----------

- Step 1 (setup):
  Extract the archive to a place where you have FULL permission to EDIT files. Make sure that the path only contains latin characters.

- Step 2 (decompile):
  Each file has to be translated individually. Some contain complete conversations, some only a few words. To edit them, you need to decompile them with the tools, available from marvelmods.com. Command tools are included, so are some useful batch files. It doesn't matter how it's done, but using batch conversion is highly recommended (check bottom).
  For batch conversion, go to the `conversion` folder. Execute "TranslationHelper.bat", chose `D` and other options and wait until it is finished.
  The process will create a new folder with the name `MUA_[Language]_Translation`. In there, you can find every file, ready to edit in ".json", ".txt" (xmlb-compile), or ".xml" format. Continue with Step 3.
  To decompile or edit single files, move or copy them into the `batches` folder and execute the batch according to the batch list below.
  Chose a Decompile or Edit batch and continue with Step 3 (skip open, if you use an Edit batch).

- Step 3 (edit):
  Use any text editor (eg. Notepad) to open .txt, .xml, or .json files. To determine which text needs translation, here some hints:
  1. Look for sentences.
  2. All words, sentences, and conversations start with a capital letter. BUT few code starts with capital letters too.
  3. If you used a (RF) batch or raven-formats tool (xmlb in command line), the lines are within `""`. BUT some code as well.
  4. To be absolutely sure, you can check the corresponding ".xmlb" files from within the game files: All lines that need translation are marked with `@` there.

- Step 4 (compile):
  For batch conversion execute "TranslationHelper.bat", chose `C`, and an extension and wait until it is finished. You'll get the option to delete work-files after the compiling process has finished.
  To compile single files (Skip this step if you chose an Edit batch): execute (RF)Compile.bat.
  If you get the wrong language (file extension), rename or batch rename all file extensions.

- Step 5 (optional, sort):
  Skip this step if you used batch conversion.
  If you compiled single files, they need to be put back into the right location again. 

- Step 6 (install and publish):
  For a completed translation, pack the folders and files with the same structure as the original game (eg. conversations/act1...; data/talents/colossus.itab). Make sure to include font files, if the translation requires that.
  To install the translation, put the contents of the newly created pack into the installed game directory, so that the folders match.

#### Batch list:
`(RF)Compile.bat`:          Compile .txt, .xml, and .json files to the format of your choice.

                            Automatically detects the output format, if part of the filename, like this: "herostat.engb.txt".
                            Automatically detects the input format (JSON, NBA2kStuff’s XML, and true XML) and converts if necessary.
                            "Converter.py" is required for the old XML format by NBA2kStuff. Keep it next to the BAT.
                            WARNING: Avoid multiple input files with the same name (eg. "herostat.xml" and "herostat.json").

`(RF)DecompileJSON.bat`:    Decompile Raven Format files* to [.json](https://www.w3schools.com/js/js_json_intro.asp) files.

`(RF)DecompileTrueXML.bat`: Decompile Raven Format files* to true [.xml](https://www.w3schools.com/xml/xml_whatis.asp) files.

`(RF)Edit.bat`:             Decompile Raven Format files* to .json files and open them one by one in Notepad.

                            When Notepad is closed, compiles the .json files to back to the original files.

`(XC)Decompile.bat`:        Decompile Raven Format files* to .txt files ([NBA2kStuff’s XML format** - left in the picture](https://i.imgur.com/mtEzMDh.png)).

`(XC)Edit.bat`:             Decompile Raven Format files* to .txt files (NBA2kStuff’s XML format**) and open them one by one in Notepad.

                            When Notepad is closed, compiles the ".txt" files to back to the original files.

`(XCtoRF)Convert.bat`:      Convert NBA2kStuff’s XML format** (XC) files to .json for Raven Formats (RF).

                            The file "converter.py" needs to be next to the .BAT.

`Cleanup.bat`:              Delete all .txt, .xml, .json, and .bak files in this folder.
```
*   Raven Format files are: xmlb, engb (and other languages, eg. itab, freb, etc), pkgb, boyb, chrb, navb
```
```
**  IMPORTANT: XC doesn't work with special characters, such as "&" or cyrillic letters. This limitation doesn't apply to the other formats.
```



## Special Info:
----------------

Following files are duplicates (copy the translated file):
```
conversations/act2/murder/murder4/2_murder3_80
 from conversations/act2/murder/murder3/2_murder3_80
conversations/act2/murder/murder4/2_murder3_90
 from conversations/act2/murder/murder3/2_murder3_90
conversations/sim/silversurfer
 (intro and epilogue from Ulik SIM)
conversations/sim/moonknight
 (epilogue from Thunderball SIM)
```

Following files from OCP1 replaced existing Italian versions with updated English versions:
```
conversations/act2/mephisto/mephisto4/2_mephisto4_050.itab
conversations/act2/strange/strange1/2_strange1_060.itab
conversations/act2/strange/strange1/2_strange1_710.itab
```

Following files from OCP2.3 replace original files, that have an Italian translation (at least partially):
```
(WARNING: This list has not been updated since OCP 2.3)
conversations\act1\atlantis\atlantis1\1_atlantis1_010
conversations\act1\heli\heli1\1_heli1_010
conversations\act1\heli\heli2\1_heli2_010
conversations\act1\heli\heli2\1_heli2_012
conversations\act1\heli\heli2\1_heli2_020
conversations\act1\heli\heli2\1_heli2_020a
conversations\act1\heli\heli2\1_heli2_030
conversations\act1\heli\heli2\1_heli2_040
conversations\act1\heli\heli2\1_heli2_050
conversations\act1\heli\heli2\1_heli2_060
conversations\act1\heli\heli2\1_heli2_070
conversations\act1\heli\heli2\1_heli2_080
conversations\act1\heli\heli2\1_heli2_090
conversations\act1\heli\heli2\1_heli2_130
conversations\act1\heli\heli2\1_heli2_140
conversations\act1\heli\heli2\1_heli2_150
conversations\act1\heli\heli3\1_heli3_010
conversations\act1\heli\heli3\1_heli3_038
conversations\act1\heli\heli3\1_heli3_060
conversations\act1\heli\heli4\1_heli4_010
conversations\act1\heli\heli4\1_heli4_030
conversations\act1\mandarin\mandarin1\1_mandarin1_010
conversations\act1\mandarin\mandarin1\1_mandarin1_020
conversations\act1\mandarin\mandarin4\1_mandarin4_020
conversations\act1\mandarin\mandarin4\1_mandarin4_040
conversations\act1\mandarin\mandarin5\1_mandarin5_020
conversations\act1\omega\omega1\1_omega1_010
conversations\act1\omega\omega3\1_omega3_110
conversations\act1\stark\1_stark1_010
conversations\act1\stark\1_stark1_030
conversations\act1\stark\1_stark1_310
conversations\act1\stark\1_stark1_320
conversations\act1\stark\1_stark1_350
conversations\act1\stark\1_stark1_510
conversations\act1\stark\1_stark1_520
conversations\act1\stark\1_stark1_710
conversations\act1\stark\1_stark1_720
conversations\act1\stark\1_stark2_330
conversations\act1\stark\1_stark2_340
conversations\act1\stark\1_stark2_350
conversations\act1\stark\1_stark2_370
conversations\act1\stark\1_stark2_380
conversations\act1\stark\1_stark2_530
conversations\act1\stark\1_stark2_540
conversations\act1\stark\1_stark2_550
conversations\act1\stark\1_stark2_570
conversations\act2\mephisto\mephisto1\2_mephisto1_010
conversations\act2\mephisto\mephisto1\2_mephisto1_012
conversations\act2\mephisto\mephisto1\2_mephisto2_010
conversations\act2\mephisto\mephisto2\2_mephisto2_030
conversations\act2\mephisto\mephisto3\2_mephisto3_030
conversations\act2\mephisto\mephisto3\2_mephisto3_050
conversations\act2\mephisto\mephisto4\2_mephisto4_020
conversations\act2\mephisto\mephisto4\2_mephisto4_030
conversations\act2\mephisto\mephisto4\2_mephisto4_040
conversations\act2\murder\murder1\2_murder1_010
conversations\act2\murder\murder1\2_murder1_012
conversations\act2\murder\murder1\2_murder1_014
conversations\act2\murder\murder2\2_murder2_022
conversations\act2\murder\murder3\2_murder3_012
conversations\act2\strange\1_strange1_720
conversations\act2\strange\2_strange1_010
conversations\act2\strange\2_strange1_015
conversations\act2\strange\2_strange1_020
conversations\act2\strange\2_strange1_060
conversations\act2\strange\2_strange1_110
conversations\act2\strange\2_strange1_210
conversations\act2\strange\2_strange1_220
conversations\act2\strange\2_strange1_260
conversations\act2\strange\2_strange1_720
conversations\act2\strange\2_strange2_060
conversations\act2\strange\2_strange2_070
conversations\act2\strange\2_strange2_080
conversations\act2\strange\2_strange2_090
conversations\act2\strange\2_strange2_100
conversations\act2\strange\2_strange2_102
conversations\act2\strange\2_strange2_240
conversations\act2\strange\2_strange2_250
conversations\act2\strange\2_strange2_260
conversations\act2\strange\2_strange2_270
conversations\act2\strange\2_strange2_280
conversations\act3\asgard\asgard1\heal
conversations\act3\niffleheim\niffleheim4\3_niffleheim4_020
conversations\act3\niffleheim\niffleheim4\3_niffleheim4_030
conversations\act3\valhalla\3_valhalla1_010
conversations\act3\valhalla\3_valhalla1_012
conversations\act3\valhalla\3_valhalla1_014
conversations\act3\valhalla\3_valhalla1_020
conversations\act3\valhalla\3_valhalla1_510
conversations\act3\valhalla\3_valhalla1_520
conversations\act3\valhalla\3_valhalla2_350
conversations\act3\valhalla\3_valhalla2_360
conversations\act3\valhalla\3_valhalla2_370
conversations\act3\valhalla\3_valhalla2_380
conversations\act3\valhalla\3_valhalla2_390
conversations\act3\valhalla\3_valhalla2_400
conversations\act3\valhalla\3_valhalla2_535
conversations\act3\valhalla\3_valhalla2_550
conversations\act3\valhalla\3_valhalla2_560
conversations\act3\valhalla\3_valhalla2_570
conversations\act3\valhalla\3_valhalla2_580
conversations\act3\valhalla\3_valhalla2_582
conversations\act3\valhalla\3_valhalla2_590
conversations\act3\valhalla\3_valhalla2_600
conversations\act4\attilan\4_attilan1_020
conversations\act4\attilan\4_attilan1_320
conversations\act4\attilan\4_attilan2_370
conversations\act4\skrull\skrull1\4_skrull1_010
conversations\act4\skrull\skrull1\4_skrull1_020
conversations\act4\skrull\skrull1\4_skrull1_022
conversations\act4\skrull\skrull1\4_skrull3_010
conversations\act4\skrull\skrull3\4_skrull3_020
conversations\act4\skrull\skrull3\4_skrull3_022
conversations\act4\skrull\skrull4\4_skrull4_040
conversations\act4\skrull\skrull5\4_skrull5_020
conversations\act4\skrull\skrull5\4_skrull5_030
conversations\act4\skrull\skrull5\4_skrull5_032
conversations\act4\skrull\skrull5\4_skrull5_035
conversations\act4\skrull\skrull5\4_skrull5_038
conversations\act4\skrull\skrull5\4_skrull5_040
conversations\act5\doom\doom1\5_doom1_042
conversations\act5\doom\doom4\5_doom4_010
conversations\act5\doom\doom4\5_doom4_020
conversations\act5\doomstark\5_doomstark1a_010
conversations\act5\doomstark\5_doomstark1a_040
conversations\act5\doomstark\5_doomstark1b_010
conversations\act5\doomstark\5_doomstark1b_030
conversations\act5\doomstark\5_doomstark1b_050
conversations\act5\doomstark\doomstark2\5_doomstark2_010
conversations\act5\doomstark\doomstark2\5_doomstark2_030
 (most of these conversations have only the display-name changed)
data\herostat
data\items
data\npcstat
data\review_paths
data\shared_talents
data\simulator
data\team_bonus
data\zoneinfo
data\powerstyles\ps_blade
data\powerstyles\ps_captainamerica
data\powerstyles\ps_daredevil
data\powerstyles\ps_deadpool
data\powerstyles\ps_drstrange
data\powerstyles\ps_humantorch
data\powerstyles\ps_iceman
data\powerstyles\ps_invisiblewoman
data\powerstyles\ps_ironman
data\powerstyles\ps_lukecage
data\powerstyles\ps_mrfantastic
data\powerstyles\ps_nickfury
data\powerstyles\ps_silversurfer
data\powerstyles\ps_spiderman
data\powerstyles\ps_storm
data\powerstyles\ps_thor
data\powerstyles\ps_warbird
data\talents\deadpool
data\talents\humantorch
data\talents\lukecage
data\talents\thing
data\talents\thor
data\talents\warbird
data\talents\wolverine
maps\act1\heli\heli1
maps\act1\heli\heli2
maps\act1\heli\heli3
maps\act1\stark\stark2
maps\act2\mephisto\mephisto1
maps\act2\mephisto\mephisto3
maps\act2\murder\murder2
maps\act2\strange\strange1
maps\act3\asgard\asgard3
maps\act5\doom\doom2
maps\act5\doom\doom3
maps\act5\doom\doom4
maps\act5\doomstark\doomstark1b
maps\sim\sim_heli1
maps\sim\sim_murder1
maps\sim\sim_omega1
maps\sim\sim_skrull1
```

Following files have been updated form OCP1 to OCP2.3 (the OCP1 versions are not included):
```
(WARNING: This list has not been updated since OCP 2.3)
conversations\act2\mephisto\mephisto1\2_mephisto1_012_dlc (ProfX NPC name change)
conversations\act2\mephisto\mephisto3\2_mephisto3_053m    (ProfX NPC name change)
conversations\act2\mephisto\mephisto3\2_mephisto3_055m    (ProfX NPC name change)
conversations\act2\mephisto\mephisto4\2_mephisto4_029     (German spelling improved)
conversations\act2\murder\murder2\2_murder2_070m          (Special conversation replaced)
conversations\act2\strange\2_strange1_060m                (ProfX NPC name change)
conversations\act2\strange\2_strange1_260m                (ProfX NPC name change)
conversations/sim/captainmarvel/epilogue
conversations/sim/captainmarvel/intro
conversations/sim/captainmarvel/villain
conversations/sim/hawkeye/epilogue
conversations/sim/hawkeye/intro
conversations/sim/hawkeye/villain
conversations/sim/hulk/intro
```

Following files have been reported to cause errors when decompiling:
```
conversations\act3\asgard\asgard3\3_asgard3_052.engb
```

Following files have been reported to cause errors when compiling:
```
movies\mb05.engb
movies\mb11.engb
```

Following files in ui/menus are known to be used by the PC (2006/Beenox) version of the game:
```
  default menus:
ui\menus\danger_room
ui\menus\debug
ui\menus\esrb_warning
ui\menus\image_viewer
ui\menus\legal_ps2    (additional legal text is in igct.bnx)
ui\menus\main_beenox
ui\menus\myteam
ui\menus\options_beenox
ui\menus\pda
ui\menus\review
ui\menus\team
ui\menus\trivia
ui\menus\worldmap
  next-gen menus (they replace default menus when added), only for RE UI mod:
ui\menus\ng_danger_room
ui\menus\ng_myteam
ui\menus\ng_pda
ui\menus\ng_review
ui\menus\ng_team
ui\menus\ng_trivia
ui\menus\ng_worldmap
  online menus:
ui\menus\campaign_lobby
ui\menus\games_list
ui\menus\game_options
ui\menus\host
ui\menus\join
ui\menus\online
ui\menus\players_list
ui\menus\player_game_options
ui\menus\text_entry
```


## Other Languages:
-------------------

The game's language can be configured in `[MUA main directory]/build.ini`.
The pre-defined languages are:
```
eng (English)
fre (French)
ger (German)
ita (Italian)
spa (Spanish)
pol (Polish)
rus (Russian)
```
WARNING: By default, only `ita` and `eng` are allowed languages, even though three others are listed as well.
         (Please contact me, if you find a build that supports others.)
Example: If you want to use German language, change the line to `DefaultTextLanguage = ger`. The game will now search for the ".gerb" files.
         (Video and audio language are more complicated.)
Any three letter language code can be used as well, as long as the Game.exe is patched with the same three letters (use "TranslationHelper.bat" to patch).

`[MUA main directory]/igct.bnx`: This file doesn't need to be decompiled and can be opened with any text editor. It must be renamed for each language. Eg. to use it with German, copy igct.bnx > igctger.bnx.

The content of this package can help to identify the files which need to be translated. Every file in the original game and in OCP, that has the ".engb" extension, contains English text. All of these can be translated into different languages.
The ".engb" files can be copied and the extension renamed, to ".gerb" for example. This will work perfectly for `DefaultTextLanguage = ger`, only the text will still be English.
This method can also be used to rename to the correct extension if you accidentally chose the wrong language to compile.

#### Fonts:

The Spanish `¿` provides a small challenge, and for everyone interrested in creating a new Spanish translation, please contact ak2yny @ marvelmods.com.

Polish special characters (`Ą, Ć, Ę, Ł, Ń, Ś, Ź, Ż` and lowercase) are not supported by the UI database. They will have to be tied to other special characters. The easiest is to use the encoding Windows-1250 during writing of the translation. When the file is saved (before conversion), make sure the encoding is ANSI (Windows-1252). Eg. convert the encoding to ANSI. The characters should change to ANSI characters (eg. `Ą` to `¥`). There is currently no font to display these characters, however. When creating a font, make sure to match them to the Win 1250 chart (while the hex numbers in the 16x16 chart are to be translated to decimal single numbers, counting from 0 up, ending at 255), ie. glyphs 0-139 are covered by the Latin font and can just be copied, so continue with `Ś` on 140.

The Cyrillic alphabet for Russian has to be converted. This is done automatically in some programs when saved as text (txt or xml). `Â` (`B` in Cyrillic) mustn't be replaced. The latin `B` can be used instead. The igct.bnx file will not be converted automatically. To do it correctly, copy the content to a new text file and make sure it's encoded as Windows-1251. When finished, encode it in ANSI (Windows-1252). All Cyrillic letters should change to special latin characters (eg. `в` becomes `â`). Then convert the encoding to UCS-2 Little Endian and save as a new file. Make sure the file is called igct or igctrus and the extension is bnx (rename when necessary).

More information about how to create the ingame font for Polish and Russian, can be found on https://marvelmods.com/forum/index.php/topic,10987.

----------------------------------------------------------------------

Hint:    More fan translations may exist, in dedicated communities, in various languages.
Warning: Some original files might give problems while decompiling. Please report this.
         If a compile process doesn't complete, there is a problem in one of the files (.txt, .xml, .json). Please consult marvelmods.com or its Discord channel.

#### Batch conversion:

The most efficient tool available for XMLB batch conversion is "raven-formats" by nikita488: https://pypi.org/project/raven-formats/
Follow the instructions on this webpage to install both, Python and Raven-Formats.
Xmlb-compile.exe is installed by moving/copying it to `C:\Windows`.

Raven-Formats is abbreviated (RF), xmlb-compile.exe by NBA2kStuff is abbreviated (XC)
Both tools convert from and to Raven's xml binary formats. They are:
*.xmlb, *.engb, *.freb, *.gerb, *.itab, *.polb, *.rusb, *.spab, *.pkgb, *.boyb, *.chrb, *.navb

Decompiled formats include:
".txt" for (XC)/xmlb-compile (can also use the .xml extension or even others)
".xml" for (RF)/raven-formats (XML format)
".json" for (RF)/raven-formats (JSON format)