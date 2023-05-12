# How to make HUD heads with Alchemy 5

[![MarvelMods Tutorial: Create HUD Heads With Alchemy 5 for MUA](https://img.youtube.com/vi/PyRXGYM1eyo/mqdefault.jpg)](https://youtu.be/PyRXGYM1eyo)

### Supported Formats
- [PNG](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/Alchemy%20Scripts/hud#PNG)
- [TGA](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/Alchemy%20Scripts/hud#TGA)
- [GIF](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/Alchemy%20Scripts/hud#GIF)

### Common Instructions
1. Create an image in one of the supported formats (e.g. `hud_head_sample.png`)
2. Drag & drop the image onto hud_head_e.bat
3. Open the folder next to hud_head_e.bat with the same name as the image file (e.g. `hud_head_sample`)
4. Open the IGB file cointained with Finalizer
5. Load the hud_head_i.ini file from the same folder (optimization set)

    [![MarvelMods Tutorial: Load Optimization Set](https://www.mediafire.com/convkey/2cc0/xoxit6ztpab8lbh3g.jpg)](https://www.mediafire.com/convkey/2cc0/xoxit6ztpab8lbhzg.jpg)
6. Run the optimizations (Ctrl + R)
7. Save the file (Ctrl + S)
8. Copy or move the HUD head to a new location and remove the remaining files ([video](https://www.youtube.com/watch?v=PyRXGYM1eyo&t=160))

### HUD Heads with Transparent Backgrounds
- Use the transparent HUD cration tools and follow the [common instructions](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/Alchemy%20Scripts/hud#common-instructions).
- Alternatively, Follow the common instructions until step 6 and ...
7. Create the alpha attributes as pictured in the video below:

    [![MarvelMods Tutorial: Create HUD Heads With Alchemy 5 for MUA](https://img.youtube.com/vi/PyRXGYM1eyo/mqdefault.jpg)](https://www.youtube.com/watch?v=PyRXGYM1eyo&t=65)

8. Save the file (Ctrl + S)
9. Copy or move the HUD head to a new location and remove the remaining files [video](https://www.youtube.com/watch?v=PyRXGYM1eyo&t=160)

### PNG
- Any PNG image works, but I recommend to use an image with a size around 128x128, as other dimensions will be scaled in-game.
- Follow the [common instructions](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/Alchemy%20Scripts/hud#common-instructions) as pictured in the video below:

[![MarvelMods Tutorial: Create HUD Heads With Alchemy 5 for MUA](https://img.youtube.com/vi/PyRXGYM1eyo/mqdefault.jpg)](https://www.youtube.com/watch?v=PyRXGYM1eyo&t=180)

### TGA
- I highly recommend to use an image with the dimensions **256x256**. The TGA format uses a template that has 8 mipmap textures (1x1 to 128x128 pixels). The target format will be DXT1 and this format requires dimensions with a power of two (1, 2, 4, 8, 16, etc.).
- Follow the [common instructions](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/Alchemy%20Scripts/hud#common-instructions) as pictured in the video below:

[![MarvelMods Tutorial: Create HUD Heads With Alchemy 5 for MUA](https://img.youtube.com/vi/PyRXGYM1eyo/mqdefault.jpg)](https://www.youtube.com/watch?v=PyRXGYM1eyo&t=15)

### GIF
- Only GIF files with 16 frames work at the moment.
- A size between 128x128 and 256x256 is recommended.
- Follow the [common instructions](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/Alchemy%20Scripts/hud#common-instructions).
- If the GIF doesn't have full frames (some incomplete images) do following between steps 3 and 4:
3. - Get 16 full frames as PNG images and sort them in a sequence
   - Name them identical to the images that were created from the GIF
   - Copy them and replace the images that were created from the GIF

