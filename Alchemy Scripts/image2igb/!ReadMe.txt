Requires Alchemy 5
Credits for image2igb.exe: nikita488


Instructions:
- Any texture               execute "image2igb.bat"              Works for: .jpg, .png, .tga, .dds (manually process further as needed)
- Power Icons and fonts     execute "image2igb-icons,fonts.bat"  Works for: .jpg, .png, .tga, .dds 
- Power Icons               execute "image2igb-pngicons.bat"     Works for: .png only, others with the above BAT. Preferred for icons.
- Mip-map batch is removed. edit "image2igb-icons,fonts.bat" and change "mipmaps=false" on line 13 to "mipmaps=true"
- Loading Screens           execute "image2igb-ls.bat"           Works for: .jpg, .png, .tga, .dds, 16:9 (min 1920x1080) for MUA
                                                                                                     4:3 (min 683x512) for XML2*
- Effect Textures           execute "image2igb-fxtext.bat"       Works for: .jpg, .png, .tga, .dds (incl. loading screens)
                                                                 1:1 (eg. 128x128, or 1:2) only

(Work like the others: put all contents of the archive in the same folder as the source images + double click on the .bat file)
(Work with drag&drop:  drag source images or folders with source images onto the .bat file)
(Reminder: HUD heads don't work)
.jpg and .tga are not compatible with the games, but they should be automatically converted to DDS DXT1.
*XML2 is not compatible with Alchemy hex version 08. However, for images it may be possible to change the hex version at offset 2c to 05.


Please give me a feedback, if something doesn't work as intended.
by ak2yny for MarvelMods.com