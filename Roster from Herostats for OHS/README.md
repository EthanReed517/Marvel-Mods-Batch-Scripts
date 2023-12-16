# Roster from Herostats for OpenHeroSelect
A roster_from_herostats.bat file for each game to generate a herostat differently.


## Compatibility
Win 10+ (OHS), XML2 & MUA1


## Usage

 1. Place the batch file in the OHS' mua or xml2 folder.
 2. In the "mua" or "xml2" folder, a config.ini must exist. If it doesn't run OpenHeroSelect.exe and enter the configurations.
 3. Once a config.ini exists, you can open the herostat folder ("xml" by default) and rename the files (herostats) as follows:
    - At the beginning of the filename, enter the menulocation that this character should appar at, followed by a space or minus.
    - For XML2, just enter any number ('1 ' for example).
    - Example: If the herostat is called "Juggernaut", you can rename it to "12 Juggernaut" to place Juggernaut at location "12".
    - Optionally, you can make a copy of the herostat and name it "12 Juggernaut Roster1" for example. (You're free to use any name.)
    - If needed, use the stage previews for the menulocatons.
 4. When you're done renaming the files (herostats), go back to the "mua" or "xml2" folder and run roster_from_herostats.bat (double-click on it). Let OHS finish its job before running the game.

https://github.com/TheRealPSV/OpenHeroSelect/assets/92672223/d6cf9ab2-a3c1-49b3-9c12-a94da08c3004

Important: Any files that start with a number will be added to the roster. In MUA, filenames with identical numbers will cause problems.


## Credits
ak2yny