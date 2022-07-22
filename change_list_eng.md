# Changes in ComRem and ComPatch
## Bug fixes

### Cutscenes
* **Vaterland - Quest 'Find and destroy bandits' camp'**: reworked cutscene to be more intuitive in showing the player that the bandit should be followed, decreasing the chances that the player will be disoriented and will miss the time window to chase after the bandit. THe bandit will drive faster, consistent with the fact that this is, in fact, a chase. Changed the success condition for a chase to a more logical one. [[#168]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/168)
* **Vaterland - Quest 'Follow the mayor'**: fixed possible explosion of mayor's car in cutscene showing his stash [[#83]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/83)
* **Vaterland - Quest 'Search the father's home'** - the player's truck is stopped on entering the cutscene, preventing it from ramming into the house wall [[#158]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/158)
* **Vaterland - Quest 'Return to the father's house'** - the player's truck is stopped on entering the cutscene, preventing it from ramming into the house wall [[#158]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/158)
* **Hel - Quest 'Free the extremists' leader'**: pauses hostile bots from attacking the player in the middle of cutscenes (the cutscene shown when player kills the leader and the cutscene shown kill the guards). The player's truck is stopped on entering the cutscene, preventing it from ramming the caravan or driving pass it uncontrollably while cutscene is still playing [[#144]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/144) [[#158]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/158)
* **Hel - Cutscene on travel to port from Cordan**: pauses hostile bots from attacking the player in the middle of the cutscene [[#144]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/144)
* **Ignott - Quest 'Bring the monster's head'**: cutscene's background music is now stopped on cutscene end. Pauses hostile bots from attacking the player in the middle of the cutscene shown after we kill the "monster" Battle robot [[#75]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/75) [[#144]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/144)
* **Ignott - Quest 'Bring Oracle two artifacts'**: pauses hostile bots from attacking the player in the middle of cutscenes (the cutscene shown when first traveling to the factory and cutscene shown when changing vehicle to a Scout GT [[#144]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/144)
* **Ignott - Quest 'Bypass the Oracle Disciples'**: cutscene's background music is now stopped on cutscene end [[#75]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/75)
* **Ignott - Stages of 'Help Oracle to regain memory'**: pauses hostile bots from attacking the player in the middle of cutscenes played on different stages of the quest, in places where devs missed that convention [[#75]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/75)
* **Ignott - Quest 'Signs on the field'**: the player's truck is stopped on entering the cutscene, preventing it from driving through the field uncontrollably while cutscene is still playing [[#158]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/158)
* **Vahat - Quest 'Fight with the madmen'**: the player's truck is stopped on entering the cutscene shown when the player defeats the madmen, preventing it from driving in circles and ramming random objects [[#158]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/158)
* **Zarmek - Father's truck found**: pauses hostile bots from attacking the player in the middle of the cutscene shown when the player founds Ivan's vehicle wreck [[#144]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/144)
* **General**: for every cutscene in the game faction emblems of NPC vehicles were aligned with their actual factions according to the story (i.e. every cutscene where Alice's car is present, vehicles of Felix and his gang, Colosseum Gladiator vehicles, Mayor of Minin's Scout, Stranger's Hunter in 'Find a place for the ambush -> Follow the car' quest, recruiter's Van in 'Find Axel' quest, Axel's Belaz in 'Fight Axel' quest, vehicles in 'Save the druids of Uluk', vehicles in 'Save the Bukhara people', Scientist's defenders vehicles in Zarmek)  [[#164]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/164)

### Quests
* **Vaterland - Overtake Alice in the North**: added condition for receving "The sea gate key" quest item, preventing player from getting a duplicate submarine key in the proccess [[#67]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/67) [[#83]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/83)
* **Vaterland - Catch the runner at the abandoned town**: Runaway bandit will now follow his predefined path and patrol the abandoned town instead of standing in place
* **Argen - Take a look at the field** (Part of 'Signs' quest chain): quest failure states are now straightforward and player will be unable to fail it while traveling between maps of the first three regions. The quest will still end prematurely if the player travels to Vahat before finishing it. Additional quest markers are added wherever they were missing.
* **Ignott - Signs on the field** (Part of 'Signs' quest chain): quest failure states are now straightforward and player will be unable to fail it while traveling between maps of the first three regions. The quest will still end prematurely if the player travels to Vahat before finishing it. Additional quest markers are added wherever they were missing. Part of the quest chain taking place in Ignott is now independent from the 'Go to see the druid' quest and can still be taken and completed even if that quest wasn't taken. Circumstances of discussion about the field will change accordingly.
* **Librium - Eliminate the jamming station**: the player will now be able to intimidate 'Electrician' in Seil by threatening to call for help from the Scarlet Dawn thugs only if he finished the war as a hero of the Scarlet Dawn Army [[#148]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/148)
* **Argen - Go to the Monastery**: added quest item reward for quest replacing non-existing trigger game tries to activate [[#67]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/67)
* **Vahat - Deliver oil to Kef**: fixed player's vehicle switch in Kef to Lorry with trailer and back, all towns in the area are closed and the race can't be started while the quest is in progress to prevent softlocks [[#54]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/54)
* **Vahat - Race**: fixed player's vehicle switch to Turbo GT and back [[#54]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/54)


### Locations / Maps
* **Town exits**: fixed exit paths for following towns: Porto(Ridzin), Area 51(Vaterland), Helvetia(Librium), First and Seth(Sacred Grove). The original exit paths could have damaged the vehicle on an exit or even destroy it [[#69]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/69)
* **Vaterland - The Amusement Center**: instead of continuing to burn endlessly, fire at The Amusement Center will now be extinguished when a player trips one of the predetermined story checkpoints. Triggers also take into consideration if a player had spoken with Manny about The Amusement Center. [[#76]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/76)
* **Hel - Lootbox location**: lootbox spawned at SecretPlace13_loc location can now be reached by the player, previously was inside the invisible walls [[#145]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/145)
* **Hel - Olme**: people walking near Olme will now less often get teleported to the roof of the town. This still can happen because of a flawed game engine mechanic [[#146]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/146)

### Sound
* **Weapon - Rainmetal**: fixed sound clipping, lowdness is normalised, fire rate gadgets effect is accounted for [[#91]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/91)
* **Vehicle - Turbo GT**: Turbo GT now has an engine sound, which can be heard when racing in Vahat [[#128]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/128)

### Balance
* **Gun affixes**: fixed rusty_gun, useless_gun, excellent_gun, advanced_gun affixes affecting Accuracy in the wrong direction, affix price effect added [[#59]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/59)
* **Autoleveling**: random spawn enemies will now use special prototypes prepared just for them. These prototypes have a limited cargo size to limit overflowing with cheap wares caused by limitations of the game's spawn logic [[#97]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/97)
* **Van cab weapon slots**: all three Van cabins now have a 360 gun rotation weapon slots, making all three a valid option for the player [[#173]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/173)
* **Belaz cargo weapon slot**: adds the second missing Giant weapon slot on Thunder cargo compartment [[#176]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/176)
* **Hunter cab weapon slot**: limited turning angle of the small gun slot on the second cab [[#174]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/174)
* **Fighter cab weapon slot**: limited turning angle of the small gun slot on the second cab [[#175]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/175)

### Content design
* **Faction logos - General**: added new logos for factions which previously lacked unique emblems (Desert dwellers, Nomads, Fishermen, Scientist's defenders, PowerStation(Seil), Serseri) [[#164]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/164)
* **Faction affiliation - Hel towns**: all small fishing villages in Hel now belong to Fishermen faction, instead of Free Traders' Alliance [[#164]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/164)
* **Faction affiliation - Quest 'Kill bandits occupying the warehouse'**: Warehouse will change its affiliation from Brigade to Free Traders' Alliance if you kill the Warehouse guards [[#164]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/164)
* **Faction affiliation - Quest 'Find and destroy bandits' camp'**: bandit now has a proper Vagabonds affiliation and will be shown as hostile while player follows him to the camp [[#168]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/168)


### Text
* **Encyclopedia**: proofreading and corrections for uidescription.xml [RU only] [[#64]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/64) [[#74]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/74)
* **Gun affixes**: fixed with_electric_sight_gun affix description name mistype [[#68]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/68)
* **Subtitles**: proofreading and text corrections for strings.xml of various maps, radiosamples.xml text corrections [RU only] [[#70]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/70) [[#94]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/94)
* **Bandit radio messages**: fixed mixup of subtitles for two of the bandit's battle cries [[#94]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/94)

### UI
* **Icons**: fixed missing cargo icons for Peacekeeper, and mixed up cab can cargo icons for Belaz and Ural [[#66]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/66)
* **Statistics screen**: "Was killed (times)' item has been removed from statisics as it never worked and fixing it doesn't seem to be realistic [[#162]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/162)

### Graphics
* **Vehicle - Van**: Van cargo compartments are now paintable, changed cab colors to be more subdued [[#173]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/173)
* **Vehicle - Belaz**: model fixes for Thunder cargo compartment (material properties, breakable groups) [[#176]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/176)
* **Vehicle - Hunter**: Hunter's cabins fixes: the same shader as uses for the playable trucks, increasing visual fidelity of the car, logo on the second cab is visible, added more skins (red and blue), additional loadpoints for the lights [[#174]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/174)
* **Vehicle - Fighter**: the same shader as uses for the playable trucks, increasing visual fidelity of the car, fixed inverted normals, added more skins (red and blue) [[#175]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/175)
* **Texture**: fixed missing alpha-channel for textured used in ship graveyard models [[#65]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/65)
* **Effect**: now only one engine can be dropped as a part of the debris left after the explosion of the truck [[#77]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/77)
* **Model - building**: fixed industrial building model (prom_small.gam) lacking window texture one one side, leaving untextured hole [[#107]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/107)
* **Model - building**: fixed desert house model (r4_freehouse2.gam) lack of collision box [[#110]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/110)
* **Model - object**: fixed railway platform model's (rr_platform.gam) approximate collision box with a better one, to prevent the player from taking damage when climbing it [[#152]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/152)
* **Model - town**: updated town model minin.gam (used for "Sowth" and "Aeterna"), changing bugged stairs normals, adding collision for the pipes, updating shader to an AO version, increasing visual fidelity and fixing overblown specular parts [[#166]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/166)

## Cut content restoration
* **Quest 'Save the druids of Uluk'**: restoration of unfinished/cut quest in Sacred Grove. Quest can now be taken in Seth, if Children of Iron are not yet hostile to player. Quest will became unreachable if player has not taken it by the end of 'Cleanse the sanctuary' chain of quests. [[#116]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/116)
* **Cutscene - Quest 'Bring the monster's head'**: restored cut lines spoken by the main character when encountering "the Monster" [[#75]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/75)
* **Cutscene - Travel from Hel to Sacred Grove**: restored cut lines spoken by the main character talking about the submarine, which are played when exiting Hel on the way to Sacred Grove for the first time. The cutscene itself got a round of polish. [[#75]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/75)
* **Cutscene - Quest 'Destroy the monsters'**: restored cut lines spoken by the main character when he sees the robots in quest given by High Druid [[#75]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/75)

## Improvements
* **Engine patching**: aspect ratio correction fix, bringing proper 90 degree wide FOV and accompaning frustrum culling patch
* **UI - Icons**: fixed damage resist icons mixup, now all damage resist types have new appropriate icons, displayed on crosshair and in a town shop and a vehicle stat interface [[#81]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/81)
* **Lootbox system**: propagated lootbox logic existing in the game to first and second region maps (Krai, Ridzin, Vaterland, Hel, Librium, Argen), icreasing game's replayability [[#83]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/83)
* **Weapons**: new weapon animations, model fixes and reworks, new and fixed fire and shell case ejection effects for almost all weapons in the game. List includes: Bumblebee, Cyclops, Dragon, Fagotto, Flag, Hammer, Hornet, Hurricane, Hurricane, Kord, KPVT, Maxim, Octopus, Odin, Odin, Omega, PKT, Rainmetal, Rapier, Specter, Storm, Swingfire, Turbo, Vector, Vulcan [[#86]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/86)
* **Vehicle camera**: corrected camera height and camera distance range limiter as a result of a wider FOV now being available when driving with a default 3rd-person camera [[#101]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/101)
* **Argen - Vahat transition**: a player will be able to travel from Argen to Vahat after the first Vahat visit. A player will also be able to travel from Vahat to Argen after the first conversation with 'The Scientist'. Necessary cutscenes are also added. [[#147]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/147)
* **Shaders - AO variants**: added new shader varianst for Diffuse and Specular shaders supporting baked AO lightmaps, useful for buildings and other static objects [[#166]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/166)

## Clean up
* **Town prototype**: r4_Scientific town prototype "Import" value fixed, malformed string tripped the game's xml parser [[#57]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/57)
* **Animmodels**: animmodels.xml cleanup from duplicate model declarations [[#58]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/58)
* **Triggers**: removed two unused triggers from Hel [[#144]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/144)
* **Scripts**: commented random debug messages shown in log and console when playing game normally [[#157]](https://github.com/DeusExMachinaTeam/EM-CommunityPatch/pull/157)
