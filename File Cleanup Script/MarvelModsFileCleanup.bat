@ECHO OFF
REM This file is a collaboration between ak2yny, BaconWizard17, and Rampage.

title Marvel Mods File Cleanup
color 0b

REM Define game (MUA; XML2; choice)
set game=choice
REM Define file formats to remove (use spaces to separate):
set ff=igt
REM Define languages to keep (use spaces to separate):
set lk=eng

if %game%==choice (
	echo Game not selected. Please select from the list. 
	echo [1] Marvel: Ultimate Alliance
	echo [2] X-Men Legends 2
	CHOICE /C 12 /M "Which game are you using? "
	IF ERRORLEVEL 1	SET game=MUA
	IF ERRORLEVEL 2 SET game=XML2
	echo.
)

goto %game% 


:main
title %gamename% File Cleanup

REM Define variables:
set lf=eng ita fre ger spa pol rus 

REM Display welcome message
echo Welcome to the %gamename% File Cleanup Script
echo.

REM Check the name of the current folder
for %%I in (.) do set "EXE=%%~dpI%~1\%2.exe"
REM If it's in the game folder, don't need the file path. 
REM Otherwise ask for it.
if NOT exist "%EXE%" (
	set /p gamepath=Please paste or type the path to %game% here: 
)
cd %gamepath%
echo.

REM begin the file deletion process with generally unused files.
echo Removing generally unused files . . .
setlocal enableDelayedExpansion
for %%L in (%lk%) do set lf=!lf:%%L =!
set ff=%lf: =b %%ff%
del >nul *.%ff: = *.% /s
for %%B in (%lf%) do del >nul 2>nul igct%%B.bnx

REM remove .xmlb files that have .engb equivalents.
echo Removing duplicate .xmlb files . . .
for /r %%I in (*.xmlb) do (
	if exist "%%~pnI.%lk:~,3%b" del "%%I"
)
EXIT /b


:MUA
REM Game display name:
set gamename=Marvel: Ultimate Alliance

REM execute the main script
call :main "%gamename::= -%" game


REM Remove unused animation from the actors folder. (fightstyle_finesse1.igb)
echo Removing unused files from the actors folder . . .
del >nul actors\fightstyle_finesse1.igb
REM Remove unused conversations (wrong folder, leftover).
echo Removing unused conversations . . .
for %%c in (
conversations\act1\atlantis\atlantis1\1_atlantis3_065.*
conversations\act2\murder\murder1\2_murder2_012.*
conversations\act2\murder\murder1\2_murder2_014.*
scripts\act1\stark\stark_hello.*
conversations\act1\atlantis\start.*
conversations\act1\atlantis\atlantis1\1_atlantis1_030_old.*
conversations\act1\atlantis\atlantis1\break.*
conversations\act1\atlantis\atlantis1\free_namor.*
conversations\act1\atlantis\atlantis1\injected.*
conversations\act1\atlantis\atlantis1\namorita_*
conversations\act1\atlantis\atlantis1\see_namor.*
conversations\act1\atlantis\atlantis1\start.*
conversations\act1\atlantis\atlantis2\leave.*
conversations\act1\atlantis\atlantis2\temp*
conversations\act1\atlantis\atlantis3\door1_notopen.*
conversations\act1\atlantis\atlantis3\door2_notopen.*
conversations\act1\atlantis\atlantis3\find_trident.*
conversations\act1\atlantis\atlantis3\got_first_bead.*
conversations\act1\atlantis\atlantis3\got_second_bead.*
conversations\act1\atlantis\atlantis3\rare_kelp.*
conversations\act1\atlantis\atlantis3\statue_hint.*
conversations\act1\atlantis\atlantis3\trident_tip_start.*
conversations\act1\atlantis\atlantis3\trident_tip_take.*
conversations\act1\atlantis\atlantis3\zone_intro.*
conversations\act1\atlantis\atlantis4\attuma_intro.*
conversations\act1\atlantis\atlantis4\boss_intro.*
conversations\act1\atlantis\atlantis4\boss_outro.*
conversations\act1\atlantis\atlantis5\airride.*
conversations\act1\atlantis\atlantis5\killkrak.*
conversations\act1\atlantis\atlantis5\summonkrak.*
conversations\act1\heli\heli1\engine_blownup.*
conversations\act1\heli\heli1\firstencounter.*
conversations\act1\heli\heli1\gamestart.*
conversations\act1\heli\heli1\scorpion_*
conversations\act1\heli\heli2\1_heli2_030_old.*
conversations\act1\heli\heli2\1_heli2_040_old.*
conversations\act1\heli\heli2\1_heli2_100_old.*
conversations\act1\heli\heli2\1_heli2_110_old.*
conversations\act1\heli\heli2\1_heli2_120_old.*
conversations\act1\heli\heli2\1_heli2_130_old.*
conversations\act1\heli\heli2\break_stuff.*
conversations\act1\heli\heli2\bull_*
conversations\act1\heli\heli2\comp*
conversations\act1\heli\heli2\destroy_consoles.*
conversations\act1\heli\heli2\fury_*
conversations\act1\heli\heli2\push_pull.*
conversations\act1\heli\heli2\ultron01.*
conversations\act1\heli\heli3\1_heli3_024_old.*
conversations\act1\heli\heli3\agent_*
conversations\act1\heli\heli3\elevator_disabled.*
conversations\act1\heli\heli3\huh.*
conversations\act1\heli\heli3\laser*
conversations\act1\heli\heli3\playtime_is_over.*
conversations\act1\heli\heli3\there_they_go.*
conversations\act1\heli\heli3\villain_final_encounter.*
conversations\act1\heli\heli4\fff_*
conversations\act1\mandarin\mandarin1\temp*
conversations\act1\mandarin\mandarin2\grey_defeat.*
conversations\act1\mandarin\mandarin4\got_key.*
conversations\act1\mandarin\mandarin4\locked_door.*
conversations\act1\mandarin\mandarin4\saved_strange.*
conversations\act1\mandarin\mandarin4\strange_encounter.*
conversations\act1\mandarin\mandarin5\beat_mandarin.*
conversations\act1\mandarin\mandarin5\hint.*
conversations\act1\mandarin\mandarin5\meet_*
conversations\act1\omega\omega1\controlroom.*
conversations\act1\omega\omega1\dum_follow_conv.*
conversations\act1\omega\omega1\first_cr.*
conversations\act1\omega\omega1\meet_*
conversations\act1\omega\omega2\copter.*
conversations\act1\omega\omega2\temp*
conversations\act1\omega\omega3\aux_*
conversations\act1\omega\omega3\caproom.*
conversations\act1\omega\omega3\door_gun.*
conversations\act1\omega\omega3\hanging_room.*
conversations\act1\omega\omega3\inhibitor1.*
conversations\act1\omega\omega3\mysterio_dead.*
conversations\act1\omega\omega3\reed_*
conversations\act1\omega\omega3\save_reed.*
conversations\act1\omega\omega3\trigger_*
conversations\act1\omega\omega3b\elevator_stop.*
conversations\act1\omega\omega3b\end.*
conversations\act1\omega\omega3b\intro.*
conversations\act1\omega\omega4\gunner_conv.*
conversations\act1\omega\omega4\modok_*
conversations\act1\omega\omega4\security_*
conversations\act1\omega\omega4\what_have_we_done.*
conversations\act2\mephisto\mephisto1\brazier_puzzle_hint.*
conversations\act2\mephisto\mephisto1\grave_puzzle_hint.*
conversations\act2\mephisto\mephisto1\lava_puzzle_hint.*
conversations\act2\mephisto\mephisto1\power_puzzle_hint.*
conversations\act2\mephisto\mephisto1\sacrifice_puzzle_hint.*
conversations\act2\mephisto\mephisto3\temp*
conversations\act2\mephisto\mephisto4\intro.*
conversations\act2\mephisto\mephisto4\stage*
conversations\act2\murder\murder1\temp001.*
conversations\act2\murder\murder2\2_murder2_020_old.*
conversations\act2\murder\murder2\temp001.*
conversations\act2\murder\murder2\ticket_booth.*
conversations\act2\murder\murder3\temp_*
conversations\act2\murder\murder5\arcade*
conversations\act2\murder\murder5\headstone.*
conversations\act2\strange\1_stark2_360.*
conversations\act2\strange\1_strange1_720.*
conversations\act2\strange\2_strange1_100_old.*
conversations\act2\strange\no_enter_bedroom.*
conversations\act2\strange\temp_conv.*
conversations\act3\asgard\asgard1\balder01.*
conversations\act3\asgard\asgard1\battle_test.*
conversations\act3\asgard\asgard1\enchant.*
conversations\act3\asgard\asgard1\thor_statue.*
conversations\act3\asgard\asgard1\thor_trial.*
conversations\act3\asgard\asgard1\trolllt01.*
conversations\act3\asgard\asgard1\trolllt02.*
conversations\act3\asgard\asgard2\clay_event01.*
conversations\act3\asgard\asgard2\heimdallspeaks.*
conversations\act3\asgard\asgard2\push_pull.*
conversations\act3\asgard\asgard2\ss_*
conversations\act3\asgard\asgard2\tyrspeaks.*
conversations\act3\asgard\asgard2\use_hand.*
conversations\act3\asgard\asgard3\temp*
conversations\act3\asgard\asgard4\behindhere.*
conversations\act3\asgard\asgard4\bothsametime.*
conversations\act3\asgard\asgard4\donotmessaround.*
conversations\act3\asgard\asgard4\found_horn.*
conversations\act3\asgard\asgard4\givehorn.*
conversations\act3\asgard\asgard4\itsatrap.*
conversations\act3\asgard\asgard4\nowwhat.*
conversations\act3\asgard\asgard4\part*
conversations\act3\asgard\asgard4\rescuedheimdall.*
conversations\act3\asgard\asgard4\rhino_shocker.*
conversations\act3\asgard\asgard4\thereheis.*
conversations\act3\bifrost\bifrost2\bossfight.*
conversations\act3\bifrost\bifrost2\zone_leave.*
conversations\act3\niffleheim\niffleheim1\found_key.*
conversations\act3\niffleheim\niffleheim1\ulik_kurse.*
conversations\act3\niffleheim\niffleheim1\volla_*
conversations\act3\niffleheim\niffleheim2\battleground_conversation.*
conversations\act3\niffleheim\niffleheim2\temp*
conversations\act3\niffleheim\niffleheim2\ymir_*
conversations\act3\niffleheim\niffleheim3\beat_bosses.*
conversations\act3\niffleheim\niffleheim3\broken_bridge.*
conversations\act3\niffleheim\niffleheim3\giantbridge.*
conversations\act3\niffleheim\niffleheim3\giantbridge2.*
conversations\act3\niffleheim\niffleheim3\mordo_bridge.*
conversations\act3\niffleheim\niffleheim3\pre_boss_battle.*
conversations\act3\niffleheim\niffleheim3\rightspear.*
conversations\act3\niffleheim\niffleheim3\ring_reacts.*
conversations\act3\niffleheim\niffleheim3\villianencounter1.*
conversations\act3\niffleheim\niffleheim3\villianencounter2.*
conversations\act3\niffleheim\niffleheim3\zone_opening.*
conversations\act3\niffleheim\niffleheim4\crystaldestroyed.*
conversations\act3\niffleheim\niffleheim4\destroyersecrets.*
conversations\act3\niffleheim\niffleheim4\doom.*
conversations\act3\niffleheim\niffleheim4\intro.*
conversations\act3\niffleheim\niffleheim4\lokidead1.*
conversations\act3\niffleheim\niffleheim4\needmore.*
conversations\act3\valhalla\temp_act3_end.*
conversations\act4\shiar\shiar1\corsair_exit.*
conversations\act4\shiar\shiar1\corsair_intro.*
conversations\act4\shiar\shiar1\force_fields.*
conversations\act4\shiar\shiar1\shiar_start.*
conversations\act4\shiar\shiar2\gladiator_intro.*
conversations\act4\shiar\shiar2\keyguydeathconv1.*
conversations\act4\shiar\shiar2\keyguydeathconv2.*
conversations\act4\shiar\shiar3\corsair_message*
conversations\act4\shiar\shiar3\guns_and_dish.*
conversations\act4\shiar\shiar3\shiar3_start.*
conversations\act4\shiar\shiar3\starbolt.*
conversations\act4\shiar\shiar3\warstar.*
conversations\act4\shiar\shiar4\temp*
conversations\act4\shiar\shiar5\deathbird_hello.*
conversations\act4\shiar\shiar5\deathbird_self_destruct.*
conversations\act4\shiar\shiar5\lackey01.*
conversations\act4\shiar\shiar5\lackey02.*
conversations\act4\shiar\shiar5\leave_shiar.*
conversations\act4\shiar\shiar5\lilandra_goodbye.*
conversations\act4\shiar\shiar5\look_power_nodes.*
conversations\act4\shiar\shiar5\meet_lilandra.*
conversations\act4\shiar\shiar5\saved_lilandra.*
conversations\act4\shiar\shiar5\stop_self_destruct.*
conversations\act4\shiar\shiar5\temp001.*
conversations\act4\skrull\skrull1\drill_encounter.*
conversations\act4\skrull\skrull1\on_skrull.*
conversations\act4\skrull\skrull2\4_skrull2_010_old.*
conversations\act4\skrull\skrull2\4_skrull2_020_old.*
conversations\act4\skrull\skrull2\4_skrull2_030_old.*
conversations\act4\skrull\skrull2\4_skrull2_070_old.*
conversations\act4\skrull\skrull2\4_skrull2_080_old.*
conversations\act4\skrull\skrull2\ambush01.*
conversations\act4\skrull\skrull2\dooropened.*
conversations\act4\skrull\skrull2\paibok.*
conversations\act4\skrull\skrull2\pun_*
conversations\act4\skrull\skrull2\queen_*
conversations\act4\skrull\skrull2\scardy01.*
conversations\act4\skrull\skrull2\superskrull.*
conversations\act4\skrull\skrull3\4_skrull3_010_old.*
conversations\act4\skrull\skrull3\4_skrull3_020_old.*
conversations\act4\skrull\skrull3\4_skrull3_030_old.*
conversations\act4\skrull\skrull3\4_skrull3_040_old.*
conversations\act4\skrull\skrull1\4_skrull3_040.*
conversations\act4\skrull\skrull3\all_gens.*
conversations\act4\skrull\skrull3\followhim.*
conversations\act4\skrull\skrull3\stop.*
conversations\act4\skrull\skrull4\temp*
conversations\act4\skrull\skrull5\intro.*
conversations\act4\skrull\skrull5\outro.*
conversations\act4\skrull\skrull5\surfer*
conversations\act5\doom\doom1\checkstatue.*
conversations\act5\doom\doom1\doom2_door.*
conversations\act5\doom\doom1\doom_speak1.*
conversations\act5\doom\doom1\lab_door.*
conversations\act5\doom\doom1\leap_conv.*
conversations\act5\doom\doom1\many_doors.*
conversations\act5\doom\doom2\dark_colossus.*
conversations\act5\doom\doom3\cap_intro.*
conversations\act5\doom\doom3\cyc_comeback.*
conversations\act5\doom\doom3\final.*
conversations\act5\doom\doom3\psy_*
conversations\act5\doom\doom4\temp*
conversations\act5\doomstark\5_doomstark1b_050_old.*
conversations\act5\doomstark\accessdenied.*
conversations\act5\doomstark\doomstark1a_end.*
conversations\act5\doomstark\nick_temp.*
conversations\act5\doomstark\doomstark2\fury_intro.*
conversations\act5\doomstark\doomstark2\pym_dooropened.*
conversations\act5\doomstark\doomstark2\pym_intro.*
conversations\act1\atlantis\atlantis1\1_atlantis1_025.*
conversations\act1\atlantis\atlantis1\1_atlantis1_027.*
conversations\act1\atlantis\atlantis1\1_atlantis1_030.*
conversations\act1\heli\heli2\1_heli2_050.*
conversations\act1\heli\heli2\1_heli2_060.*
conversations\act1\heli\heli2\1_heli2_070.*
conversations\act1\heli\heli2\1_heli2_080.*
conversations\act1\heli\heli2\1_heli2_090.*
conversations\act1\heli\heli2\1_heli2_150.*
conversations\act1\stark\1_stark1_010.*
conversations\act2\strange\2_strange1_102.*
conversations\act5\doomstark\5_doomstark1b_110.*
) do del >nul "%%~fc"
rd /q /s ^
conversations\act1\heli\heli1b\ ^
conversations\act1\heli\heli3\old\ ^
conversations\act4\murder\ ^
conversations\sims\
REM Remove leftover powerstyles and entities files.
REM WARNING: Only use on the vanilla game, as mods use some of these as well.
echo Removing unused files from the data folder . . .
del >nul 2>nul ^
data\entities\ents_abyss.xmlb ^
data\entities\ents_anubite.xmlb ^
data\entities\ents_apoc* ^
data\entities\ents_archangel.xmlb ^
data\entities\ents_assassindroid.xmlb ^
data\entities\ents_bishop.xmlb ^
data\entities\ents_brood.xmlb ^
data\entities\ents_colarm.xmlb ^
data\entities\ents_cyclops.xmlb ^
data\entities\ents_deadpool.xmlb ^
data\entities\ents_deathhand.xmlb ^
data\entities\ents_gambit.xmlb ^
data\entities\ents_infinite.xmlb ^
data\entities\ents_kojak.xmlb ^
data\entities\ents_madri.xmlb ^
data\entities\ents_magneto.xmlb ^
data\entities\ents_merc.xmlb ^
data\entities\ents_mik.xmlb ^
data\entities\ents_morlock.xmlb ^
data\entities\ents_mystique.xmlb ^
data\entities\ents_nrgdmn.xmlb ^
data\entities\ents_prelate.xmlb ^
data\entities\ents_pyro.xmlb ^
data\entities\ents_pyro_hero.xmlb ^
data\entities\ents_sauron.xmlb ^
data\entities\ents_scarletwitch.xmlb ^
data\entities\ents_sentinel.xmlb ^
data\entities\ents_sentry.xmlb ^
data\entities\ents_sentryrobot.xmlb ^
data\entities\ents_shifter.xmlb ^
data\entities\ents_sinagt.xmlb ^
data\entities\ents_sunfire.xmlb ^
data\entities\ents_zealot.xmlb ^
data\entities\ps_* ^
data\powerstyles\ps_assassindroid.* ^
data\powerstyles\ps_clawbeast.xmlb ^
data\powerstyles\ps_coreguard.xmlb ^
data\powerstyles\ps_cullingprobe.* ^
data\powerstyles\ps_deathhand.xmlb ^
data\powerstyles\ps_empty.xmlb ^
data\powerstyles\ps_energy_demon.xmlb ^
data\powerstyles\ps_holocaust.xmlb ^
data\powerstyles\ps_madrihighpriest.xmlb ^
data\powerstyles\ps_madripriest.xmlb ^
data\powerstyles\ps_marauder.xmlb ^
data\powerstyles\ps_morlock_bruiser.xmlb ^
data\powerstyles\ps_morlock_claw.xmlb ^
data\powerstyles\ps_morlock_psionic.xmlb ^
data\powerstyles\ps_psychicdemon.xmlb ^
data\powerstyles\ps_sentryrobot.* ^
data\powerstyles\ps_shadowcat.xmlb ^
data\powerstyles\ps_shifter.xmlb ^
data\powerstyles\ps_spirit.xmlb ^
data\powerstyles\ps_terror.xmlb ^
data\codex.*
REM Remove leftover subtitles folder, as cutscenes are in movies (incl. subtitles).
echo Removing unused subtitles folder . . .
rd /q /s subtitles\
REM Remove unused menus. Consoles or leftover.
echo Removing unused files from the ui\menus folder . . .
del >nul 2>nul ^
ui\menus\blumel_* ^
ui\menus\console.igb.igb ^
ui\menus\image_viewer.igb ^
ui\menus\legal_360.* ^
ui\menus\legal_360_uk.* ^
ui\menus\legal_ps2_uk.* ^
ui\menus\legal_ps3.* ^
ui\menus\legal_ps3_uk.* ^
ui\menus\legal_xbox.* ^
ui\menus\legal_xbox_uk.* ^
ui\menus\list_view* ^
ui\menus\loading.igb ^
ui\menus\loading_anim.igb ^
ui\menus\m_common_divider.igb ^
ui\menus\main.* ^
ui\menus\main_pc.* ^
ui\menus\mlm_main.igb ^
ui\menus\marvel_* ^
ui\menus\menu_* ^
ui\menus\mlm_automap.igb ^
ui\menus\mlm_host.igb ^
ui\menus\mlm_shop.igb ^
ui\menus\mlm_simulator.igb ^
ui\menus\mlm_user_select.igb ^
ui\menus\model_* ^
ui\menus\movie.igb ^
ui\menus\options.* ^
ui\menus\options_360.* ^
ui\menus\options_controller.igb ^
ui\menus\options_ps3.* ^
ui\menus\options_xbox.* ^
ui\menus\mlm_options.igb ^
ui\menus\players.* ^
ui\menus\region.* ^
ui\menus\sebas.* ^
ui\menus\start.* ^
ui\menus\mlm_start.igb ^
ui\menus\x2m_* ^
packages\generated\maps\package\menus\act_team_* ^
packages\generated\maps\package\menus\characters_heads* ^
packages\generated\maps\package\menus\legal_360.pkgb ^
packages\generated\maps\package\menus\legal_360_uk.pkgb ^
packages\generated\maps\package\menus\legal_ps2_uk.pkgb ^
packages\generated\maps\package\menus\legal_ps3.pkgb ^
packages\generated\maps\package\menus\legal_ps3_uk.pkgb ^
packages\generated\maps\package\menus\legal_xbox.pkgb ^
packages\generated\maps\package\menus\legal_xbox_uk.pkgb ^
packages\generated\maps\package\menus\list_view_back.pkgb ^
packages\generated\maps\package\menus\main.pkgb ^
packages\generated\maps\package\menus\main_pc.pkgb ^
packages\generated\maps\package\menus\options.pkgb ^
packages\generated\maps\package\menus\options_360.pkgb ^
packages\generated\maps\package\menus\options_ps3.pkgb ^
packages\generated\maps\package\menus\options_xbox.pkgb ^
packages\generated\maps\package\menus\pda_act* ^
packages\generated\maps\package\menus\players.pkgb ^
packages\generated\maps\package\menus\region.pkgb ^
packages\generated\maps\package\menus\sebas.* ^
packages\generated\maps\package\menus\start.pkgb ^
REM Remove live-menus, probably Xbox-Live exclusive. ^
ui\menus\live_accounts.* ^
ui\menus\live_connect.* ^
ui\menus\live_feedback.xmlb ^
ui\menus\live_friends_list.* ^
ui\menus\live_game_type.* ^
ui\menus\live_join_by_id.* ^
ui\menus\live_optimatch.* ^
ui\menus\live_options.* ^
ui\menus\live_password.xmlb ^
ui\menus\live_quickmatch.* ^
ui\menus\live_voice_message.xmlb ^
ui\menus\mlm_svs_campaignstage.igb ^
ui\menus\mlm_svs_generic_list.igb ^
ui\menus\mlm_svs_live_gametype.igb ^
ui\menus\mlm_svs_password.igb ^
packages\generated\maps\package\menus\live_accounts.pkgb ^
packages\generated\maps\package\menus\live_connect.pkgb ^
packages\generated\maps\package\menus\live_feedback.pkgb ^
packages\generated\maps\package\menus\live_friends_list.pkgb ^
packages\generated\maps\package\menus\live_game_type.pkgb ^
packages\generated\maps\package\menus\live_join_by_id.pkgb ^
packages\generated\maps\package\menus\live_optimatch.pkgb ^
packages\generated\maps\package\menus\live_options.pkgb ^
packages\generated\maps\package\menus\live_password.pkgb ^
packages\generated\maps\package\menus\live_quickmatch.pkgb ^
packages\generated\maps\package\menus\live_voice_message.pkgb
REM Keep potentially used menus for now.
REM ui\menus\blank.xmlb & pkgb
REM ui\menus\mlm_blank.igb
REM ui\menus\debug.* & pkgb
REM ui\menus\pause.igb

echo Removing unused scripts. . .
del >nul 2>nul ^
scripts\act1\omega\omega3\reed.py ^
scripts\act2\murder\murder4\blade_button.py ^
scripts\common\shop.py

goto End

:XML2
REM Game display name:
set gamename=X-Men Legends 2

REM execute the main file deletion script
call :main "%gamename%" XMen2

REM ask if file extensions should be changed to lowercase
echo.
CHOICE /M "Do you want to change file extensions to lowercase?"
SET lowercaseFiles=%ERRORLEVEL%
REM ask if folder names should be changed to lowercase
CHOICE /M "Do you want to change folder names to lowercase?"
SET lowercaseFolders=%ERRORLEVEL%

echo.
REM make the files lowercase if the user chooses
if %lowercaseFiles%==1 (
	echo Renaming file extensions to lowercase. This will take a few minutes . . .
	for %%B in (BOYB CHRB IGB NAVB PKGB PY XMLB) do (
		echo .%%B to lowercase
		for /f "delims=" %%F in ('dir /b /a-d /s /l *.%%B 2^>nul') do for %%E in ("_%%~F") do ren "%%~F" "%%~nF%%~xE"
	)
	echo All files are now lowercase.
	echo.
)

REM Make the folders lowercase if the user chooses
if %lowercaseFolders%==1 (
	echo Renaming all folders to lowercase. This will take a few seconds . . .
	for /f "delims=" %%F in ('dir /b /ad /s /l 2^>nul') do for %%E in ("_%%~F") do ren "%%~F" "%%~nE"
	echo All folders are now lowercase.
)

:End
echo.
echo Removal of all unused content is now completed.
pause
goto EOF

REM Hulk has many unused convos in the game files, i'm just not sure which they are exactly. -Rampage
REM There are tons of scripts in the scripts folder that aren't used in-game but it's tough to know which are and arent used so I didnt remove any script files. -Rampage
REM There are still a lot of other files which are unused. - ak2yny
