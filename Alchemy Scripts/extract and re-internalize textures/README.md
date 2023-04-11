# Alchemy 5 Texture Replacement Method by MrKablamm0fish

[Tutorial](https://marvelmods.com/forum/index.php/topic,11009.html)

This method must be done with Finalizer. The inject optimization doesn't work with sgOptimizer.

If there are specular, normal, etc. maps, filter them by defining the texture names in an exclude text file (excl.txt - details in `igConvertImage`). For MUA PC 2006 maps are DXT1, except the normal map, which is DXT5. Put the name of the normal map into excl.txt file and add that file to the DXT1 convert optimization with "exclude", and to the DXT5 convert optimization with "include". This is setup in [Alchemy Scripts/extract and re-internalize textures/Inject_Textures_into_IGB_withMaps'n'MipMaps.ini](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/Alchemy%20Scripts/extract%20and%20re-internalize%20textures/Inject_Textures_into_IGB_withMaps'n'MipMaps.ini). This set can also be used to re-create mip-maps, replacing all old mip-maps with the new texture(s).
Other texture maps can be DXT5 as well. Filtering is not necessary in this case. Just change the texture format to DXT5. This is setup in [Alchemy Scripts/extract and re-internalize textures/Inject_Textures_into_IGB-transparency-DXT5.ini](https://github.com/EthanReed517/Marvel-Mods-Batch-Scripts/blob/main/Alchemy%20Scripts/extract%20and%20re-internalize%20textures/Inject_Textures_into_IGB-transparency-DXT5.ini).

After loading these optimization sets into Finalizer, one can remove single optimizations and even add other ones and save them as new sets.
