#macro OBJECT_MODE 0
#macro DECO_MODE 1
#macro NODE_MODE 2
#macro JADE_VERSION "5"

global.tilesets={}
//add tilesets
global.tilesets[$ "tTilesetMain"]=[spr_TilesetMain, tTilesetMain, "Floragrande Tiles"]
global.tilesets[$ "tTilesetPipes"]=[spr_TilesetPipes, tTilesetPipes, "Pipe Tiles"]
global.tilesets[$ "tTilesetMainDeco"]=[spr_TilesetMainDeco, tTilesetMainDeco, "Floragrande Decoration"]
global.tilesets[$ "tTilesetWorld5"]=[spr_TilesetWorld5, tTilesetWorld5, "Frigid Dark Tiles"]
global.tilesets[$ "tTilesetWorld5BG"]=[spr_TilesetWorld5BG, tTilesetWorld5BG, "Frigid Dark Background Tiles"]
global.tilesets[$ "tTilesetWorld5Deco"]=[spr_TilesetWorld5Deco, tTilesetWorld5Deco, "Frigid Dark Decoration"]
global.tilesets[$ "tTilesetPipesW5"]=[spr_TilesetPipesW5, tTilesetPipesW5, "Pipe Tiles (Frigid Dark)"]
global.tilesets[$ "tTilesetBowserLand"]=[spr_TilesetBowserLand, tTilesetBowserLand, "Bowser Land Tiles"]

global.musiclist={}

//Music tracks list
global.musiclist[$ "floragrande"]={
	formatted_name: "Floragrande",
	leadmix: "overworld bgm FG",
	backmix: "overworld bgm BG"
}
global.musiclist[$ "frigiddark"]={
	formatted_name: "Frigid Dark",
	leadmix: "frigid dark bgm",
	backmix: undefined
}


function JADE_initializeobj() {
	guiw = window_get_width();
	guih = window_get_height();
	
	obj_data = {};
	properties = new JADEproperties();
	objectthemes = new JADEproperties();
	objectlist = new JADElisthandler(guiw-216-14,56, 216, 640, "selected_obj");
	gizmolist = new JADElisthandler(guiw-216-14,56, 216, 640, "selected_obj");
	decolist = new JADElisthandler(guiw-216-14,56, 216, 640, "selected_deco_obj");
	bglist = new JADEbglisthandler(guiw-216-14,56, 216, 480);
	propertylist = new JADEpropertylisthandler(guiw-216-14,56, 216, 640);
	nodepropertylist = new JADEnodepropertylisthandler(guiw-216-14,56, 216, 640);
	selectednodelist = new JADEselectednodelisthandler(guiw-216-14,56, 216, 640);
	rotatorpropertylist = new JADErotatorpropertylisthandler(guiw-216-14,56, 216, 640);
	
	list_tabbuttons = new JADEsmallbuttons(guiw-216-14,38,96,20,8,false, true)
	
	list_tabbuttons.add("Object List", function() {
		properties_tab_active = false;
	});
	list_tabbuttons.add("Properties", function() {
		properties_tab_active = true;
	});
	list_tabbuttons.selected_button=0
	
	
	var tilesetlist=[
	"tTilesetMain",
	"tTilesetPipes",
	"tTilesetMainDeco",
	"tTilesetWorld5",
	"tTilesetWorld5BG",
	"tTilesetPipesW5",
	"tTilesetWorld5Deco",
	"tTilesetBowserLand",
	]

	//auto generation the list of names for dropdown, dont touch!
	var tilesetnames=[];
	var i=0;
	repeat(array_length(tilesetlist)) {
		array_push(tilesetnames, global.tilesets[$ tilesetlist[i]][2])
		i++;
	}
	
	//registerobj(oPlayerSpawn, spr_spawner, 8, 8, 16, 16, false, false, objectlist, "Player Spawn") //Replaced with spawn tool
	registerobj(oCollider, spr_collider, 0, 0, 16, 16, true, true, objectlist, "Collider", true)
	properties.addCheckbox(oCollider, "Is Slippery", "slippery", false)
	properties.addDropdown(oCollider, "Footstep Material", "footstep_material", footstepMaterial.Default, ["Default", "Grass", "Stone", "Snow", "Wood", "Plastic", "Metal", "Ice","Crunchy"], [footstepMaterial.Default,footstepMaterial.Grass,footstepMaterial.Stone,footstepMaterial.Snow,footstepMaterial.Wood,footstepMaterial.Plastic,footstepMaterial.Metal,footstepMaterial.Ice,footstepMaterial.Crunchy])
	registerobj(oSlopeCollider, spr_slopesolid, 0, 0, 16, 16, true, true, objectlist, "Slope Collider", true)
	properties.addCheckbox(oSlopeCollider, "Flipped", "hflip", false)
	properties.addCheckbox(oSlopeCollider, "Is Ramp", "ramp", false)
	properties.addCheckbox(oSlopeCollider, "Is Slippery", "slippery", false)
	properties.addDropdown(oSlopeCollider, "Footstep Material", "footstep_material", footstepMaterial.Default, ["Default", "Grass", "Stone", "Snow", "Wood", "Plastic", "Metal", "Ice","Crunchy"], [footstepMaterial.Default,footstepMaterial.Grass,footstepMaterial.Stone,footstepMaterial.Snow,footstepMaterial.Wood,footstepMaterial.Plastic,footstepMaterial.Metal,footstepMaterial.Ice,footstepMaterial.Crunchy])
	registerobj(oSemilider, spr_semilider, 0, 0, 16, 16, true, false, objectlist, "Semisolid", true)
	properties.addCheckbox(oSemilider, "Is Slippery", "slippery", false)
	properties.addDropdown(oSemilider, "Footstep Material", "footstep_material", footstepMaterial.Default, ["Default", "Grass", "Stone", "Snow", "Wood", "Plastic", "Metal", "Ice","Crunchy"], [footstepMaterial.Default,footstepMaterial.Grass,footstepMaterial.Stone,footstepMaterial.Snow,footstepMaterial.Wood,footstepMaterial.Plastic,footstepMaterial.Metal,footstepMaterial.Ice,footstepMaterial.Crunchy])
	registerobj(oSemiSlope, spr_slopesemi, 0, 0, 16, 16, true, true, objectlist, "Semisolid Slope", true)
	properties.addCheckbox(oSemiSlope, "Flipped", "hflip", false)
	properties.addCheckbox(oSemiSlope, "Is Ramp", "ramp", false)
	properties.addCheckbox(oSemiSlope, "Is Slippery", "slippery", false)
	properties.addDropdown(oSemiSlope, "Footstep Material", "footstep_material", footstepMaterial.Default, ["Default", "Grass", "Stone", "Snow", "Wood", "Plastic", "Metal", "Ice","Crunchy"], [footstepMaterial.Default,footstepMaterial.Grass,footstepMaterial.Stone,footstepMaterial.Snow,footstepMaterial.Wood,footstepMaterial.Plastic,footstepMaterial.Metal,footstepMaterial.Ice,footstepMaterial.Crunchy])
	registerobj(oBarrier, spr_barrier, 0, 0, 16, 16, true, true, objectlist, "Barrier", true)
	
	var blockcategory = new JADElistcategory("Blocks")
	
	var containers = new JADElistcategory("Containers")
	registerobj(oItemBox, spr_itemboxJADE, 8, 8, 16, 16, false, false, containers, "Item Box", true)
	properties.addDropdown(oItemBox, "Content", "content", "coin", ["Single Coin", "Multiple Coins", "Super Mushroom", "Fire Flower", "Thunder Flower", "Starman", "1UP Mushroom", "3UP Moon", "Poison Mushroom", "Shield Mushroom", "P-Switch"], ["coin", "multicoins", "mushroom", "fireflower", "thunderflower", "star", "1up", "3up", "poison", "shield", "pswitch"])
	properties.addNumberInput(oItemBox, "Amount", "amount", 1, true)
	properties.addCheckbox(oItemBox, "Is Brick", "bricked", false)
	properties.addCheckbox(oItemBox, "Is Hidden", "hidden", false)
	properties.addCheckbox(oItemBox, "Is Dispenser", "eject", false)
	properties.addLink(oItemBox, new basicLink("On Hit", "onhit_link"));
	registerobj(oLongItemBox, spr_longitemboxJADE, 24, 8, 48, 16, false, false, containers, "Long Item Box", true)
	properties.addDropdown(oLongItemBox, "Content", "content", "coin", ["Single Coin", "Multiple Coins", "Super Mushroom", "Fire Flower", "Thunder Flower", "Starman", "1UP Mushroom", "3UP Moon", "Poison Mushroom", "Shield Mushroom", "P-Switch"], ["coin", "multicoins", "mushroom", "fireflower", "thunderflower", "star", "1up", "3up", "poison", "shield", "pswitch"])
	properties.addNumberInput(oLongItemBox, "Amount", "amount", 1, true)
	properties.addCheckbox(oLongItemBox, "Is Hidden", "hidden", false)
	properties.addCheckbox(oLongItemBox, "Is Dispenser", "eject", false)
	properties.addLink(oLongItemBox, new basicLink("On Hit", "onhit_link"));
	registerobj(oMonitor, spr_monitor, 8, 8, 16, 16, false, false, containers, "Monitor", true)
	properties.addDropdown(oMonitor, "Content", "content", "coin", ["10 Coins", "Super Mushroom", "Fire Flower", "Thunder Flower", "Starman", "1UP Mushroom", "3UP Moon", "Poison Mushroom", "Shield Mushroom"], ["coin", "mushroom", "fireflower", "thunderflower", "star", "1up", "3up", "poison", "shield"])
	properties.addCheckbox(oMonitor, "Has Gravity", "physics_enabled", false)
	properties.addCheckbox(oMonitor, "Bump From Below", "bumpable", false)
	properties.addLink(oMonitor, new basicLink("On Hit", "onhit_link"));
	registerobj(oCrate, spr_crate, 8, 8, 16, 16, false, false, containers, "Crate", true)
	properties.addDropdown(oCrate, "Content", "content", "coin", ["Single Coin", "Super Mushroom", "Fire Flower", "Thunder Flower", "Starman", "1UP Mushroom", "3UP Moon", "Poison Mushroom", "Shield Mushroom", "P-Switch"], ["coin", "mushroom", "fireflower", "thunderflower", "star", "1up", "3up", "poison", "shield", "pswitch"])
	properties.addLink(oCrate, new basicLink("On Hit", "onhit_link"));
	blockcategory.add(containers);
	
	var liquids = new JADElistcategory("Liquids")
	registerobj(oWater, spr_water, 0, 0, 16, 16, true, true, liquids, "Water",false,0.25,0.5)
	blockcategory.add(liquids);
	
	registerobj(oBrick, spr_brick, 8, 8, 16, 16, true, false, blockcategory, "Brick Block", true)
	properties.addLink(oBrick, new basicLink("On Hit", "onhit_link"));
	registerobj(oHardBlock, spr_hardblock, 0, 0, 16, 16, false, false, blockcategory, "Hard Block", true)
	registerobj(oBigHardBlock, spr_bighardblock, 0, 0, 32, 32, false, false, blockcategory, "Big Hard Block", true)
	registerobj(oFlipblock, spr_flipblock, 8, 8, 16, 16, false, false, blockcategory, "Flip Block", true)
	properties.addLink(oFlipblock, new basicLink("On Hit", "onhit_link"));
	registerobj(oNoteBlock, spr_noteblock, 8, 8, 16, 16, false, false, blockcategory, "Note Block", true)
	properties.addLink(oNoteBlock, new basicLink("On Hit", "onhit_link"));
	registerobj(oShootBlock, spr_shootblock, 8, 8, 16, 16, false, false, blockcategory, "Shoot Block", true)
	properties.addCheckbox(oShootBlock, "Is Disguised", "disguised", false)
	properties.addLink(oShootBlock, new basicLink("On Hit", "onhit_link"));
	registerobj(oDonutBlock, spr_donutblock, 0, 0, 16, 16, false, false, blockcategory, "Donut Block")
	properties.addCheckbox(oDonutBlock, "Collapsing", "collapsing", false)
	properties.addCheckbox(oDonutBlock, "Is Icy", "slippery", false)
	registerobj(oGrate, spr_grate, 0, 0, 16, 16, true, true, blockcategory, "Grate")
	registerobj(oGrateSemi, spr_gratesemi, 0, 0, 16, 16, true, false, blockcategory, "Grate (Semi)")
	registerobj(oEnemyGround, spr_enemyground, 0, 0, 16, 16, true, true, blockcategory, "Enemy Ground")
	registerobj(oEnemyGroundSemi, spr_enemygroundsemi, 0, 0, 16, 16, true, false, blockcategory, "Enemy Ground (Semi)")
	
	objectlist.add(blockcategory); //we added the items to the category, but we still need to apply the category to the main list
	
	var items = new JADElistcategory("Items")
	
	registerobj(oCoin, spr_coin, 8, 8, 16, 16, false, false, items, "Coin", true)
	registerobj(oDottedCoin, spr_dottedcoin, 8, 8, 16, 16, false, false, items, "Dotted Coin", true)
	registerobj(oMushroom, spr_mushroom, 8, 8, 16, 16, false, false, items, "Super Mushroom", true)
	registerobj(oFireFlower, spr_fireflower, 8, 10, 16, 16, false, false, items, "Fire Flower", true)
	registerobj(oThunderFlower, spr_thunderflowerJADE, 8, 10, 16, 16, false, false, items, "Thunder Flower", true)
	registerobj(oStar, spr_starman, 8, 8, 16, 16, false, false, items, "Starman", true)
	registerobj(o1up, spr_1up, 8, 8, 16, 16, false, false, items, "1-UP Mushroom", true)
	registerobj(o3up, spr_3up, 8, 8, 16, 16, false, false, items, "3-UP Moon", true)
	registerobj(oPoisonShroom, spr_poisonmushroom, 8, 8, 16, 16, false, false, items, "Poison Mushroom", true)
	registerobj(oShieldShroom, spr_shieldmushroom, 8, 8, 16, 16, false, false, items, "Shield Mushroom", true)
	registerobj(oShard, spr_shard, 8, 8, 16, 16, false, false, items, "Boll Shard", true)
	properties.addNumberInput(oShard, "Shard ID", "shardid", 0, true);
	registerobj(oFrozenItem, spr_frozenitem, 8, 8, 16, 16, false, false, items, "Frozen Item")
	properties.addDropdown(oFrozenItem, "Content", "content", "coin", ["Single Coin", "Super Mushroom", "Fire Flower", "Thunder Flower", "Starman", "1UP Mushroom", "3UP Moon", "Mystery Orb"], ["coin", "mushroom", "fireflower", "thunderflower", "star", "1up", "3up", "mysteryorb"])
	registerobj(oGrabBlock, spr_grabblock, 8, 8, 16, 16, true, false, items, "Grab Block", true)
	
	objectlist.add(items);
	
	var gizmos = new JADElistcategory("Gizmos")
	
	var springs = new JADElistcategory("Springs")
	registerobj(oTerrainSpreng, spr_yellowterrainspring, 8, 8, 16, 16, false, false, springs, "Terrain Spring (Weak)")
	properties.addDropdown(oTerrainSpreng, "Direction", "image_angle", 0, ["Up", "Left", "Right", "Down"], [0,90,270,180])
	registerobj(oTerrainSpring, spr_redterrainspring, 8, 8, 16, 16, false, false, springs, "Terrain Spring (Normal)")
	properties.addDropdown(oTerrainSpring, "Direction", "image_angle", 0, ["Up", "Left", "Right", "Down"], [0,90,270,180])
	registerobj(oTerrainSprong, spr_greenterrainspring, 8, 8, 16, 16, false, false, springs, "Terrain Spring (Strong)")
	properties.addDropdown(oTerrainSprong, "Direction", "image_angle", 0, ["Up", "Left", "Right", "Down"], [0,90,270,180])
	gizmos.add(springs)
	
	var switchblocks = new JADElistcategory("Switch Blocks")
	registerobj(oMysterySwitch, spr_mysteryswitchon, 8, 8, 16, 16, false, false, switchblocks, "? Switch", true)
	properties.addDropdown(oMysterySwitch, "Direction", "image_angle", 0, ["Up", "Left", "Right", "Down"], [0,90,270,180])
	properties.addCheckbox(oMysterySwitch, "Inverted", "switch_state", false)
	properties.addLink(oMysterySwitch, new basicLink("On Trigger", "ontrigger_link"));
	properties.addLink(oMysterySwitch, new basicLink("On Reset", "onreactivate_link"));
	registerobj(oONOFFSwitch, spr_onoffswitch_red, 8, 8, 16, 16, false, false, switchblocks, "ON/OFF Switch", true)
	properties.addLink(oONOFFSwitch, new basicLink("On Hit", "onhit_link"));
	registerobj(oONOFFBlock, spr_onoffblockon_red, 0, 0, 16, 16, false, false, switchblocks, "ON/OFF Block", true)
	registerobj(oONOFFBlockOff, spr_onoffblockoff_blue, 0, 0, 16, 16, false, false, switchblocks, "ON/OFF Block (Off)", true)
	registerobj(oONOFFSingleSwitchRed, spr_onoffsingleswitchon_red, 8, 8, 16, 16, false, false, switchblocks, "ON/OFF Single Switch (On)", true)
	properties.addDropdown(oONOFFSingleSwitchRed, "Direction", "image_angle", 0, ["Up", "Left", "Right", "Down"], [0,90,270,180])
	properties.addLink(oONOFFSingleSwitchRed, new basicLink("On Trigger", "ontrigger_link"));
	registerobj(oONOFFSingleSwitchBlue, spr_onoffsingleswitchon_blue, 8, 8, 16, 16, false, false, switchblocks, "ON/OFF Single Switch (Off)", true)
	properties.addDropdown(oONOFFSingleSwitchBlue, "Direction", "image_angle", 0, ["Up", "Left", "Right", "Down"], [0,90,270,180])
	properties.addLink(oONOFFSingleSwitchBlue, new basicLink("On Trigger", "ontrigger_link"));
	registerobj(oYellowSwitch, spr_yellowswitch, 8, 8, 16, 16, false, false, switchblocks, "Yellow Switch", true)
	properties.addLink(oYellowSwitch, new basicLink("On Hit", "onhit_link"));
	registerobj(oYellowSwitchBlock, spr_yellowswitchblock, 0, 0, 16, 16, false, false, switchblocks, "Yellow Switch Block", true)
	registerobj(oYellowSwitchBlockOff, spr_yellowswitchblockoff, 0, 0, 16, 16, false, false, switchblocks, "Yellow Switch Block (Off)", true)
	registerobj(oYellowSwitchSlope, spr_yellowswitchslope, 0, 0, 16, 16, false, false, switchblocks, "Yellow Switch Slope", true)
	registerobj(oCyanSwitch, spr_cyanswitch, 8, 8, 16, 16, false, false, switchblocks, "Cyan Switch", true)
	properties.addLink(oCyanSwitch, new basicLink("On Hit", "onhit_link"));
	registerobj(oCyanSwitchBlock, spr_cyanswitchblock, 0, 0, 16, 16, false, false, switchblocks, "Cyan Switch Block", true)
	registerobj(oCyanSwitchBlockOff, spr_cyanswitchblockoff, 0, 0, 16, 16, false, false, switchblocks, "Cyan Switch Block (Off)", true)
	registerobj(oCyanSwitchSlope, spr_cyanswitchslope, 0, 0, 16, 16, false, false, switchblocks, "Cyan Switch Slope", true)
	registerobj(oMagentaSwitch, spr_magentaswitch, 8, 8, 16, 16, false, false, switchblocks, "Magenta Switch", true)
	properties.addLink(oMagentaSwitch, new basicLink("On Hit", "onhit_link"));
	registerobj(oMagentaSwitchBlock, spr_magentaswitchblock, 0, 0, 16, 16, false, false, switchblocks, "Magenta Switch Block", true)
	registerobj(oMagentaSwitchBlockOff, spr_magentaswitchblockoff, 0, 0, 16, 16, false, false, switchblocks, "Magenta Switch Block (Off)", true)
	registerobj(oMagentaSwitchSlope, spr_magentaswitchslope, 0, 0, 16, 16, false, false, switchblocks, "Magenta Switch Slope", true)
	gizmos.add(switchblocks)
	
	registerobj(oMovingPlatform, spr_movingplatform, 16, 8, 32, 16, true, false, gizmos, "Moving Platform", true)
	registerobj(oSwingingPlatform, spr_movingplatform, 16, 8, 32, 16, true, false, gizmos, "Swinging Platform", false)
	properties.addNumberInput(oSwingingPlatform, "Chain Length", "chain_length", 4, true)
	properties.addNumberInput(oSwingingPlatform, "Start Angle", "start_angle", 0, true)
	properties.addNumberInput(oSwingingPlatform, "End Angle", "end_angle", 180, true)
	properties.addNumberInput(oSwingingPlatform, "Offset Angle", "offset_angle", 0, true)
	properties.addNumberInput(oSwingingPlatform, "Swing Speed", "swing_speed", 4, true)
	properties.addCheckbox(oSwingingPlatform, "Reversed", "reverse", false)
	properties.addCheckbox(oSwingingPlatform, "Continuous", "continuous", false)
	properties.addCheckbox(oSwingingPlatform, "Lock X", "lock_x", false)
	properties.addCheckbox(oSwingingPlatform, "Lock Y", "lock_y", false)
	registerobj(oZapper, spr_zapper, 8, 8, 32, 16, true, false, gizmos, "Zapper", true)
	properties.addDropdown(oZapper, "Direction", "dir", "right", ["Up", "Left", "Right", "Down"], ["up","left","right","down"])
	
	objectlist.add(gizmos)
	
	var enemies = new JADElistcategory("Enemies")
	
	registerobj(oGoomba, spr_goombawalk, 8, 8, 16, 16, false, false, enemies, "Goomba")
	registerobj(oGoombrat, spr_goombratwalk, 8, 8, 16, 16, false, false, enemies, "Goombrat")
	registerobj(oKoopa, spr_koopawalk_g, 8, 7, 16, 16, false, false, enemies, "Koopa Troopa (Green)")
	registerobj(oKoopaRed, spr_koopawalk_r, 8, 7, 16, 16, false, false, enemies, "Koopa Troopa (Red)")
	registerobj(oKoopaYellow, spr_koopawalk_y, 8, 7, 16, 16, false, false, enemies, "Koopa Troopa (Yellow)")
	registerobj(oKoopaSkating, spr_koopawalk_skate, 8, 7, 16, 16, false, false, enemies, "Koopa Troopa (Skating)")
	registerobj(oBuzzyBeetle, spr_buzzybeetle_walk, 8, 8, 16, 16, false, false, enemies, "Buzzy Beetle")
	registerobj(oPiranhaPlant, spr_piranhaplant, 16, 6, 16, 16, false, false, enemies, "Piranha Plant")
	registerobj(oJumpingPiranha, spr_jumpingpiranhafly, 16, 7, 16, 16, false, false, enemies, "Jumping Piranha")
	registerobj(oBillBlaster, spr_billblasterJADE, 0, 0, 16, 32, false, true, enemies, "Bullet Bill Blaster")
	properties.addNumberInput(oBillBlaster, "Timer Offset", "timer_offset", 0, true)
	registerobj(oBanzaiBlaster, spr_banzaiblasterJADE, 32, 32, 64, 64, false, true, enemies, "Banzai Bill Blaster")
	registerobj(oShyGuy, spr_shyguy, 8, 8, 16, 16, false, false, enemies, "Shy Guy")
	registerobj(oIceSnifit, spr_icesnifit, 8, 8, 16, 16, false, false, enemies, "Ice Snifit")
	registerobj(oPylom, spr_pylom, 8, 8, 16, 16, false, false, enemies, "Pylom")
	properties.addNumberInput(oPylom, "Log Length", "maxammo", 2, true);
	properties.addCheckbox(oPylom, "Standby Mode", "standby", false);
	properties.addCheckbox(oPylom, "Flipped", "flipped", false);
	registerobj(oPolarBear, spr_polarbear, 8, 8, 16, 16, false, false, enemies, "Polar Bear")
	properties.addNumberInput(oPolarBear, "Balloon Height", "bheight", 4, true)
	registerobj(oBumpty, spr_bumpty, 8, 8, 16, 16, false, false, enemies, "Bumpty")
	properties.addDropdown(oBumpty, "Behavior", "behavior_mode", bumptyBehaviors.wander_mode, ["Wander", "Chasing", "Flying"], [bumptyBehaviors.wander_mode, bumptyBehaviors.jumping_mode, bumptyBehaviors.flying_mode])
	registerobj(oBigBumpty, spr_bigbumpty, 16, 16, 32, 32, false, false, enemies, "Big Bumpty")
	properties.addDropdown(oBigBumpty, "Behavior", "behavior_mode", bumptyBehaviors.wander_mode, ["Wander", "Chasing", "Flying"], [bumptyBehaviors.wander_mode, bumptyBehaviors.jumping_mode, bumptyBehaviors.flying_mode])
	registerobj(oStopbob, spr_stopbob, 8, 8, 16, 16, false, false, enemies, "Stopbob")
	properties.addNumberInput(oStopbob, "Timer Offset", "timer_offset", 0, true)
	registerobj(oFrozenEnemy, spr_frozenenemy, 16, 16, 32, 32, false, false, enemies, "Frozen Enemy")
	properties.addDropdown(oFrozenEnemy, "Content", "content", "nothing", ["Nothing", "Goomba", "Goombrat", "Green Koopa", "Red Koopa", "Buzzy Beetle", "Bumpty", "Shy Guy", "Ice Snifit"], ["nothing", "goomba", "goombrat", "gkoopa", "rkoopa", "beetle", "bumpty", "shyguy", "icesnifit"])
	
	objectlist.add(enemies);
	
	var hazards = new JADElistcategory("Hazards")
	registerobj(oSolidSpike, spr_solidspike, 0, 0, 16, 16, true, true, hazards, "Solid Spike", true)
	properties.addDropdown(oSolidSpike, "Direction", "dir", "up", ["Up", "Left", "Right", "Down", "None"], ["up","left","right","down","none"])
	registerobj(oAmp, spr_amp, 8, 8, 16, 16, false, false, hazards, "Amp", true)
	registerobj(oChainsaw, spr_chainsaw, 8, 8, 16, 16, false, false, hazards, "Chainsaw", true)
	registerobj(oIcicle, spr_icicle, 0, 0, 16, 32, false, false, hazards, "Icicle")
	properties.addCheckbox(oIcicle, "Can Fall", "can_fall", true)
	registerobj(oBigSteely, spr_bigsteely, 24, 24, 48, 48, false, false, hazards, "Big Steely")
	
	objectlist.add(hazards);
	
	var stagecomp = new JADElistcategory("Stage Components")
	
	registerobj(oPipe, spr_pipe, 16, 16, 32, 32, false, false, stagecomp, "Pipe")
	properties.addDropdown(oPipe, "Direction", "image_angle", 0, ["Up", "Left", "Right", "Down"], [0,90,270,180])
	properties.addStringInput(oPipe, "Warp Name", "warpname", "")
	properties.addStringInput(oPipe, "Warp Target", "warptarget", "")
	properties.addDropdown(oPipe, "Content", "content", "nothing", ["Nothing", "Piranha Plant", "Fire Piranha", "Jumping Piranha", "Goomba", "Goombrat", "Green Koopa", "Red Koopa", "Yellow Koopa", "Iceskating Koopa", "Buzzy Beetle", "Shy Guy", "Wandering Bumpty", "Chasing Bumpty"], ["nothing", "piranha plant", "fire piranha", "jumping piranha", "goomba", "goombrat", "green koopa", "red koopa", "yellow koopa", "iceskating koopa", "buzzy beetle", "shy guy", "wandering bumpty", "chasing bumpty"])
	properties.addNumberInput(oPipe, "Spawn Timer", "spawn_timer", 120, true)
	registerobj(oCheckpoint, spr_checkpoint_base, 8, 8, 16, 48, false, false, stagecomp, "Checkpoint")
	properties.addCheckbox(oCheckpoint, "Flipped", "dir", false)
	registerobj(oFadeWarpArea, spr_fadewarparea, 0, 0, 16, 16, true, true, stagecomp, "Fade Warp Area")
	properties.addStringInput(oFadeWarpArea, "Warp Target", "warptarget", "")
	registerobj(oWarpDestination, spr_warpdestination, 8, 8, 16, 16, false, false, stagecomp, "Warp Destination")
	properties.addStringInput(oWarpDestination, "Warp Name", "warpname", "")
	properties.addNumberInput(oWarpDestination, "Launch Power", "launchpower", 0, true);
	properties.addNumberInput(oWarpDestination, "Launch Direction", "launchdirection", 0, false);
	properties.addNumberInput(oWarpDestination, "Warp Delay", "delay", 0, true);
	registerobj(oGoalpost, spr_goalpost, 8, 192, 16, 192, false, false, stagecomp, "Goal Post")
	registerobj(oMysteryOrb, spr_mysteryorb, 8, 8, 16, 16, false, false, stagecomp, "Mystery Orb")
	registerobj(oSnowboardRamp, spr_snowboardramp, 0, 0, 64, 32, false, false, stagecomp, "Snowboard Ramp")
	properties.addCheckbox(oSnowboardRamp, "Flipped", "hflip", false)
	registerobj(oSnowboardGiver, spr_collider_poly, 0, 0, 16, 16, false, true, stagecomp, "Snowboard Giver")
	registerobj(oPSwitch, spr_pswitch, 8, 8, 16, 16, false, false, stagecomp, "P-Switch", true)
	properties.addDropdown(oPSwitch, "Direction", "image_angle", 0, ["Up", "Left", "Right", "Down"], [0,90,270,180])
	properties.addLink(oPSwitch, new basicLink("On Trigger", "ontrigger_link"));
	
	objectlist.add(stagecomp);
	
	var technical = new JADElistcategory("Technical")
	
	registerobj(oTyler, spr_tyler, 0, 0, 16, 16, false, false, technical, "Tyler")
	properties.addTylerPicker(oTyler,"UV","uv")
	properties.addDropdown(oTyler,"Tileset","tileset",tilesetlist[0],tilesetnames,tilesetlist)
	properties.addNumberInput(oTyler,"Offset X","off_x", 0)
	properties.addNumberInput(oTyler,"Offset Y","off_y", 0)
	properties.addNumberInput(oTyler,"Layer Depth","my_depth", 0)
	properties.addNumberInput(oTyler,"Offset Depth","offset_depth", 0)
	properties.addNumberInput(oTyler,"Repeat X","repeat_x", 0)
	properties.addNumberInput(oTyler,"Repeat Y","repeat_y", 0)
	properties.addCheckbox(oTyler,"Mirror","mirror", false)
	properties.addCheckbox(oTyler,"Flip","flip", false)
	properties.addCheckbox(oTyler,"Rotate","rotate", false)
	
	objectlist.add(technical);
	
	var npcs = new JADElistcategory("NPCs")
	
	registerobj(oNPCparent, spr_collider_poly, 0, 0, 16, 16, false, false, npcs, "Blank NPC")
	properties.addStringInput(oNPCparent, "Text", "text", "Hello World!");
    registerobj(oCommentary, spr_commentary, 16, 16, 32, 32, false, false, npcs, "Commentary Node", true)
	
	objectlist.add(npcs)
	
	//NODE MODE
	registerobj(oCameraRegion, spr_cameraregion, 0, 0, 16, 16, false, false, gizmolist, "Camera Region")
	properties.addNumberInput(oCameraRegion, "Nudge X", "nudge_x", 0, false)
	properties.addNumberInput(oCameraRegion, "Nudge Y", "nudge_y", 0, false)
	//properties.addNumberInput(oCameraRegion, "Zoom Level", "zoom", 1, true)
	properties.addCheckbox(oCameraRegion, "Constrain Left", "left", false)
	properties.addCheckbox(oCameraRegion, "Constrain Right", "right", false)
	properties.addCheckbox(oCameraRegion, "Constrain Top", "top", false)
	properties.addCheckbox(oCameraRegion, "Constrain Bottom", "bottom", false)
	properties.addNumberInput(oCameraRegion, "Constrain Offset", "constrain_offset", 0, true);
	//registerobj(oCameraBoundary, spr_cameraboundary, 0, 0, 16, 16, false, false, gizmolist, "Camera Boundary")
	registerobj(oActivationRegion, spr_activationregion, 0, 0, 16, 16, false, false, gizmolist, "Activation Region")
	registerobj(oDeactivationRegion, spr_deactivationregion, 0, 0, 16, 16, false, false, gizmolist, "Deactivation Region")
	registerobj(oDeathPit, spr_deathpit, 0, 0, 16, 16, true, false, gizmolist, "Death Pit")
	registerobj(oLevelBorder, spr_barrier, 0, 0, 16, 16, false, true, gizmolist, "Level Border")
	
	//ASSETS
	var w1deco = new JADElistcategory("Floragrande Gardens")
	registerasset(spr_grass2, 0, 16, false, false, w1deco, "2-Wide Grass")
	registerasset(spr_grass3, 8, 16, false, false, w1deco, "3-Wide Grass")
	registerasset(spr_grass4, 0, 16, false, false, w1deco, "4-Wide Grass")
	registerasset(spr_bigwidetree, 8, 16, false, false, w1deco, "Big Wide Tree")
	registerasset(spr_palmtree, 8, 16, false, false, w1deco, "Palm Tree")
	registerasset(spr_palmtree2, 8, 16, false, false, w1deco, "Palm Tree (2)")
	registerasset(spr_bigflower, 8, 16, false, false, w1deco, "Big Flower")
	decolist.add(w1deco)
	
	var w5deco = new JADElistcategory("Frigid Dark")
	
	var w5decopipes = new JADElistcategory("Pipes")
	var w5decofoilage = new JADElistcategory("Foilage")
	var w5decocrystals = new JADElistcategory("Crystals")
	var w5decostructures = new JADElistcategory("Structures")
	registerasset(spr_arrowsignspruce, 0, 0, false, false, w5decostructures, "Arrow Sign (Right)")
	registerasset(spr_textsignspruce, 0, 0, false, false, w5decostructures, "Text Sign")
	registerasset(spr_pitsignspruce, 0, 16, false, true, w5decostructures, "Pit Sign")
	registerasset(spr_snowboardbuilding, 0, 16, false, false, w5decostructures, "Snowboard Building")
	registerasset(spr_snowboardbuildingdoors, 0, 16, false, false, w5decostructures, "Snowboard Building Doors")
	registerasset(spr_snowboardbuildingfloors, 0, 16, false, true, w5decostructures, "Snowboard Building Layer")
	w5deco.add(w5decostructures);
	registerasset(spr_grass2snowy, 0, 16, false, false, w5decofoilage, "2-Wide Grass (Snowy)")
	registerasset(spr_grass3snowy, 8, 16, false, false, w5decofoilage, "3-Wide Grass (Snowy)")
	registerasset(spr_grass4snowy, 0, 16, false, false, w5decofoilage, "4-Wide Grass (Snowy)")
	registerasset(spr_sprucetree, 8, 16, false, false, w5decofoilage, "Spruce Tree")
	registerasset(spr_bigwidetreesnowy, 8, 16, false, false, w5decofoilage, "Big Wide Tree (Snowy)")
	registerasset(spr_cherryspruce, 8, 16, false, false, w5decofoilage, "Cherry Tree (Spruce)")
	w5deco.add(w5decofoilage);
	registerasset(spr_pinkcrystalbig, 8, 16, false, false, w5decocrystals, "Crystal (Pink, Big)")
	registerasset(spr_pinkcrystal1, 8, 16, false, false, w5decocrystals, "Tall Crystal (Pink, Short)")
	registerasset(spr_pinkcrystal2, 8, 16, false, false, w5decocrystals, "Tall Crystal (Pink, Medium)")
	registerasset(spr_pinkcrystal3, 8, 16, false, false, w5decocrystals, "Tall Crystal (Pink, Long)")
	registerasset(spr_buriedshardspink1, 0, 16, false, false, w5decocrystals, "Buried Crystal (Pink)")
	registerasset(spr_buriedshardspink2, 0, 16, false, false, w5decocrystals, "Buried Crystal (Pink)")
	registerasset(spr_greencrystaltiny, 8, 16, false, false, w5decocrystals, "Crystal (Green, Tiny)")
	registerasset(spr_greencrystal1, 8, 16, false, false, w5decocrystals, "Tall Crystal (Green, Short)")
	registerasset(spr_greencrystal2, 8, 16, false, false, w5decocrystals, "Tall Crystal (Green, Medium)")
	registerasset(spr_greencrystal3, 8, 16, false, false, w5decocrystals, "Tall Crystal (Green, Long)")
	registerasset(spr_buriedshardsgreen1, 0, 16, false, false, w5decocrystals, "Buried Crystal (Green)")
	registerasset(spr_buriedshardsgreen2, 0, 16, false, false, w5decocrystals, "Buried Crystal (Green)")
	w5deco.add(w5decocrystals);
	registerasset(spr_greenfovpipe_w5, 0, 0, false, false, w5decopipes, "Background Pipe (Green)")
	registerasset(spr_greenfovpipe_w5_grate, 0, 0, false, false, w5decopipes, "Background Pipe (Green, Grated)")
	registerasset(spr_bluefovpipe_w5, 0, 0, false, false, w5decopipes, "Background Pipe (Blue)")
	registerasset(spr_bluefovpipe_w5_grate, 0, 0, false, false, w5decopipes, "Background Pipe (Blue, Grated)")
	registerasset(spr_redfovpipe_w5, 0, 0, false, false, w5decopipes, "Background Pipe (Red)")
	registerasset(spr_redfovpipe_w5_grate, 0, 0, false, false, w5decopipes, "Background Pipe (Red, Grated)")
	registerasset(spr_yellowfovpipe_w5, 0, 0, false, false, w5decopipes, "Background Pipe (Yellow)")
	registerasset(spr_yellowfovpipe_w5_grate, 0, 0, false, false, w5decopipes, "Background Pipe (Yellow, Grated)")
	w5deco.add(w5decopipes);
	registerasset(spr_snowmangeneric, 0, 16, false, false, w5deco, "Snowman")
	registerasset(spr_snowmanmario, 0, 16, false, false, w5deco, "Snowman (Mario)")
	registerasset(spr_snowmansonic, 0, 16, false, false, w5deco, "Snowman (Sonic)")
	registerasset(spr_snowmantoad, 0, 16, false, false, w5deco, "Snowman (Toad)")
	registerasset(spr_engravement, 32, 64, false, false, w5deco, "Engravement")
	decolist.add(w5deco)
	
	//BACKGROUNDS
	var w1bg = new JADElistcategory("Floragrande Gardens")
	registerbackground(spr_plains_bg_hills, 0, 0, w1bg,"Plains (Hills)",true,false,10,0)
	registerbackground(spr_plains_bg_hills2, 0, 0, w1bg,"Plains (Front Hills)",true,false,4,0)
	registerbackground(spr_plains_bg_sky, 0, 0, w1bg,"Plains (Sky)",true,false,0,0)
	registerbackground(spr_plains_bg_clouds, 0, 0, w1bg,"Plains (Clouds)",true,false,1,0)
	bglist.add(w1bg)
	
	var w5bg = new JADElistcategory("Frigid Dark")
	registerbackground(spr_w5mountain_bg_snow, 0, 0, w5bg,"Mountains (Coast)",true,false,10,0)
	registerbackground(spr_w5mountain_bg_hills, 0, 0, w5bg,"Mountains (Hills)",true,false,7,0)
	registerbackground(spr_w5mountain_bg_sky, 0, 0, w5bg,"Mountains (Sky)",false,false,0,0)
	registerbackground(spr_w5mountain_bg_stars, 0, 0, w5bg,"Mountains (Stars)",false,false,0,0)
	bglist.add(w5bg)
}

function WM_initializeobj() {	
	/*obj_data = ds_map_create();
	obj_name = ds_list_create();
	
	#region Categories
		cat_blocks = ds_list_create();
		cat_tech = ds_list_create();
		cat_node = ds_list_create();
		
		jade_cats[OBJECT_MODE] = [cat_blocks, cat_tech];
		jade_cats[NODE_MODE] = [cat_node];
	#endregion


	show_debug_message("Registering JADE object list...")
	registerobj(object_get_name(oPlayerSpawn), spr_spawner, -sprite_get_xoffset(spr_spawner), -sprite_get_yoffset(spr_spawner), sprite_get_width(spr_spawner), sprite_get_height(spr_spawner), false, false, OBJECT_MODE, 0, object_get_properties("oPlayerSpawn"), "Player Spawn")
	registerobj(object_get_name(oCollider), spr_collider, -sprite_get_xoffset(spr_collider), -sprite_get_yoffset(spr_collider), sprite_get_width(spr_collider), sprite_get_height(spr_collider), true, true, OBJECT_MODE, 0, object_get_properties("oCollider"), "Collider")
	registerobj(object_get_name(oSlopeCollider), spr_slopesolid, -sprite_get_xoffset(spr_slopesolid), -sprite_get_yoffset(spr_slopesolid), sprite_get_width(spr_slopesolid), sprite_get_height(spr_slopesolid), true, true, OBJECT_MODE, 0, object_get_properties("oSlopeCollider"), "Solid Slope")
	
	registerobj(object_get_name(oScript), spr_scripttrigger, 0, 0, 16, 16, true, true, OBJECT_MODE, 1, object_get_properties("oScript"), "Script Block", true)
	registerobj(object_get_name(oCustomObject), spr_customobject, 0, 0, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oCustomObject"), "Custom Object", true)
	
	//NODE MODE
	registerobj(object_get_name(oCameraRegion), spr_cameraregion, -sprite_get_xoffset(spr_cameraregion), -sprite_get_yoffset(spr_cameraregion), sprite_get_width(spr_cameraregion), sprite_get_height(spr_cameraregion), true, true, NODE_MODE, 0, object_get_properties("oCameraRegion"), "Camera Region")
	registerobj(object_get_name(oCameraBoundary), spr_cameraboundary, -sprite_get_xoffset(spr_cameraboundary), -sprite_get_yoffset(spr_cameraboundary), sprite_get_width(spr_cameraboundary), sprite_get_height(spr_cameraboundary), true, true, NODE_MODE, 0, object_get_properties("oCameraBoundary"), "Camera Boundary")
	*/
}

function registerobj(uuid,_sprite,_xoff,_yoff,_width,_height,_can_xscale,_can_yscale,_list,_name,_nodeable=false,_sizex=1,_sizey=1) {
	var _id=object_get_name(uuid)
	if is_undefined(obj_data[$ _id]) {
		obj_data[$ _id]=new JADEobj(_id,_sprite,_xoff,_yoff,_width,_height,_can_xscale,_can_yscale,_name,_nodeable,_sizex,_sizey)
		properties.initProperties(uuid)
		_list.add(obj_data[$ _id])
	} else {
		show_debug_message($"JADE object {_id} has already been initialized! Ignoring...")
	}
}

function registerasset(_sprite,_xoff,_yoff,_can_xscale,_can_yscale,_list,_name,_sizex=1,_sizey=1) {
	var _id=sprite_get_name(_sprite)
	if is_undefined(obj_data[$ _id]) {
		var _width = sprite_get_width(_sprite);
		var _height = sprite_get_height(_sprite);
		obj_data[$ _id]=new JADEasset(_id,_sprite,_xoff,_yoff,_width,_height,_can_xscale,_can_yscale,_name,_sizex,_sizey)
		properties.initProperties(_sprite)
		_list.add(obj_data[$ _id])
	} else {
		show_debug_message($"JADE object {_id} has already been initialized! Ignoring...")
	}
}

function registerbackground(_sprite,_xoff,_yoff,_list,_name,_tiled_h=false,_tiled_v=false,_parallax_x=0,_parallax_y=0,_attach_x=false,_attach_y=false) {
	var _id=sprite_get_name(_sprite)
	if is_undefined(obj_data[$ _id]) {
		var _width = sprite_get_width(_sprite);
		var _height = sprite_get_height(_sprite);
		obj_data[$ _id]=new JADEbackground(_id,_sprite,_xoff,_yoff,_width,_height,_tiled_h,_tiled_v,_parallax_x,_parallax_y,_attach_x,_attach_y,_name)
		properties.initProperties(_sprite)
		_list.add(obj_data[$ _id])
	} else {
		show_debug_message($"JADE object {_id} has already been initialized! Ignoring...")
	}
}

function JADE_save(file=game_save_id+"\save.jade") {
	file_delete(file)
	show_debug_message($"Saving JADE file to: {file}")
	var struct = {};
	var regionarr = [];
	var r=0;
	repeat(array_length(regions)) {
		var region = regions[r];
		var regionstruct = {};
		var layers = region.mylayerlist.listcontents;
		var layerarr = [];
		var i=0;
		repeat(array_length(layers)) {
			var _layer = layers[i];
			if !is_instanceof(_layer, JADElistunselectable) {
				if (is_instanceof(_layer, JADEtilelayer)) { 
					var tile_layer_contents = []; //wow!
					var j=0;
					repeat(ds_list_size(_layer.tilemap)) {
						array_push(tile_layer_contents,_layer.tilemap[| j])
						j++;
					}
					var _arr = ["TILE",_layer.tileset,_layer.name,_layer.layerdepth,tile_layer_contents,_layer.hide_behavior]
					array_push(layerarr,_arr);
				} else if (is_instanceof(_layer, JADEassetlayer)) {
					var asset_layer_contents = []; //wow!
					var j=0;
					repeat(ds_list_size(_layer.assetmap)) {
						var uuid = _layer.assetmap[| j][0]
						var obj = _layer.assetmap[| j][1]
						var _x = layer_sprite_get_x(obj);
						var _y = layer_sprite_get_y(obj);
						var _xscale = layer_sprite_get_xscale(obj);
						var _yscale = layer_sprite_get_yscale(obj);
						var arr = [uuid,_x,_y,_xscale,_yscale]
						array_push(asset_layer_contents,arr)
						j++;
					}
					var _arr = ["ASSET",_layer.name,_layer.layerdepth,_layer.parallax_x,_layer.parallax_y,asset_layer_contents]
					array_push(layerarr,_arr);
				} else if (is_instanceof(_layer, JADEbackgroundlayer)) {
					var saved = -1
					if (is_struct(_layer.selected_bg))
					saved = _layer.selected_bg.uuid
					var _arr = ["BACK",_layer.name,_layer.layerdepth,saved,_layer.parallax_x,_layer.parallax_y,_layer.attach_x,_layer.attach_y,_layer.tiled_h,_layer.tiled_v,_layer.off_x,_layer.off_y]
					array_push(layerarr,_arr);
				}
			} else {
				var _arr = ["MAIN",_layer.name]
				array_push(layerarr,_arr);
			}
			i++;
		}
		var obj_arr = [];
		var node_arr = [];
		var j=0;
		repeat(ds_list_size(region.object_layer_map)) {
			var temp_obj = variable_clone(region.object_layer_map[| j]);
			temp_obj[15] = [];
			var l=0;
			repeat(array_length(region.object_layer_map[| j][15])) {
				var link = region.object_layer_map[| j][15][l];
				array_push(temp_obj[15],link.export_contents());
				l++;
			}
			array_push(obj_arr, temp_obj);
			j++;
		}
		j=0;
		repeat(ds_list_size(region.node_layer_map)) {
			var temp_obj = variable_clone(region.node_layer_map[| j]);
			temp_obj[15] = [];
			var l=0;
			repeat(array_length(region.object_layer_map[| j][15])) {
				var link = region.object_layer_map[| j][15][l];
				array_push(temp_obj[15],link.export_contents());
				l++;
			}
			array_push(node_arr, temp_obj);
			j++;
		}
		
		regionstruct[$ "name"] = region.name;
		regionstruct[$ "width"] = region.width;
		regionstruct[$ "height"] = region.height;
		regionstruct[$ "music_track"] = region.music_track;
		regionstruct[$ "objects"] = obj_arr;
		regionstruct[$ "node_objects"] = node_arr;
		regionstruct[$ "layers"] = layerarr;
		array_push(regionarr,regionstruct);
		
		r++;
	}
	
	struct[$ "level_data"] = regionarr;
	struct[$ "level_properties"] = level_properties;
	struct[$ "version"] = JADE_VERSION;
	struct[$ "spawnpoints"] = [spawnpoint_x, spawnpoint_y, 0, testpoint_x, testpoint_y, 0];
	var _json=json_stringify(struct); //compile all saved things
	var save_file = buffer_create(string_byte_length(_json), buffer_grow, 1);
	buffer_write(save_file, buffer_string, _json); //save compilation into a buffer
	var compressed = buffer_compress(save_file, 0, buffer_tell(save_file))
	buffer_save(compressed, file); //save buffer into the save file
	buffer_delete(save_file)
	buffer_delete(compressed)
	show_debug_message($"Successfully saved JADE file to: {file}!")
}

function JADE_load(file=game_save_id+"\save.jade") {
	if !file_exists(file) exit;
	var loaded = buffer_load(file)
	var save_file = buffer_decompress(loaded)
	var level_data = json_parse(buffer_read(save_file,buffer_string))
	
	object_uuids = {};
	
	if (string_starts_with(string(level_data[$ "version"]),"4")) {
		buffer_delete(loaded);
		buffer_delete(save_file);
		var i=0;
		repeat(array_length(regions)) {
			var region = regions[i];
			region.cleanup();
			delete region;
			i++;
		}
		regions = [];
		JADE_load_legacy(file);
	} else if (string_starts_with(string(level_data[$ "version"]),"5")) {
		level_properties = level_data[$ "level_properties"]
		struct_remove(level_properties,"music_track");
		var i=0;
		repeat(array_length(regions)) {
			var region = regions[i];
			region.cleanup();
			delete region;
			i++;
		}
		regions = [];
		var regionlist = level_data[$ "level_data"]
		var len=array_length(regionlist);
		var spawnpoints = [];
		i=0;
		repeat(len) {
			var regionstruct = regionlist[i];
			var regionwidth = regionstruct[$ "width"]
			var regionheight = regionstruct[$ "height"]
			var newregion = new JADEregion(regionwidth, regionheight, regionstruct[$ "name"]);
			var track = regionstruct[$ "music_track"];
			if is_undefined(track) track = "floragrande";
			newregion.music_track = track;
			var layerlist = regionstruct[$ "layers"];
			
			var j=0;
			repeat(array_length(layerlist)) {
				var _layer;
				var _layer_contents = layerlist[j];
				
				if (_layer_contents[0]!="MAIN") {
					if (_layer_contents[0] == "TILE") {
						_layer = new JADEtilelayer(_layer_contents[2],_layer_contents[1],regionwidth,regionheight)
					
						_layer.hide_behavior = _layer_contents[5]
					
						var tile_layer_contents = _layer_contents[4]
				
						var g=0;
						repeat(array_length(tile_layer_contents)) {
							ds_list_add(_layer.tilemap, tile_layer_contents[g])
							tilemap_set(_layer.my_deco_layer, tile_layer_contents[g][0], tile_layer_contents[g][1], tile_layer_contents[g][2]);
							g++;
						}
					} else if (_layer_contents[0] == "ASSET") {
						_layer = new JADEassetlayer(_layer_contents[1])
						_layer.parallax_x = _layer_contents[3]
						_layer.parallax_y = _layer_contents[4]
					
						var asset_layer_contents = _layer_contents[5]
					
						var g=0;
						repeat(array_length(asset_layer_contents)) {
							var obj = asset_layer_contents[g]
							var data = obj_data[$ obj[0]];
							asset_place(obj[0],obj[1]-data.xoff,obj[2]-data.yoff,obj[3],obj[4],_layer)
							g++;
						}
					} else if (_layer_contents[0] == "BACK") {
						if (_layer_contents[3] != -1) {
							var bg = obj_data[$ _layer_contents[3]]
							_layer = new JADEbackgroundlayer(_layer_contents[1], bg)
							_layer.selected_bg = bg
							_layer.sprite = bg.sprite
						} else {
							_layer = new JADEbackgroundlayer(_layer_contents[1], -1)
						}
						_layer.parallax_x = _layer_contents[4]
						_layer.parallax_y = _layer_contents[5]
						_layer.attach_x = _layer_contents[6]
						_layer.attach_y = _layer_contents[7]
						_layer.tiled_h = _layer_contents[8]
						_layer.tiled_v = _layer_contents[9]
						_layer.off_x = _layer_contents[10]
						_layer.off_y = _layer_contents[11]
						_layer.update_settings();
					}
				} else {
					_layer = new JADElistunselectable(_layer_contents[1])
				}
			
				newregion.mylayerlist.add(_layer);
				
				j++;
			}
			
			
			var objects = regionstruct[$ "objects"]
			var node_objects = regionstruct[$ "node_objects"]
			
			j=0;
			repeat(array_length(objects)) {
				var obj = objects[j]
			
				var dont_load = false;
				if (is_undefined(obj_data[$ obj[0]])) {
					dont_load = true;
				}
			
				if !(dont_load) {
					var props = properties.getDefaultValues(obj[0])
					
					if (array_length(obj[5]) != array_length(props)) {
						var o=0;
						repeat (array_length(props)) {
							if (array_length(obj[5])-1 < o) && is_array(props[o]){
								obj[5][o] = variable_clone(props[o]);
							}
							o++;
						}
					}
					
					var linkdata = obj[15];
					obj[15] = variable_clone(properties.getDefaultLinks(obj[0]));
					
					if (array_length(obj)<15) {
						var oid = generate_jadeuuid();
						while struct_exists(object_uuids,oid) {
							oid = generate_jadeuuid();
						}
						object_uuids[$ oid] = [ds_list_size(newregion.object_layer_map), 0, i];
						obj[14] = oid;
					} else {
						object_uuids[$ obj[14]] = j;
						
						var l=0;
						repeat(array_length(obj[15])) {
							obj[15][l].import_contents(linkdata[l]);
							l++;
						}
					}
					
					ds_list_add(newregion.object_layer_map, obj)
				}
				j++;
			}
			j=0;
			repeat(array_length(node_objects)) {
				var obj = node_objects[j]
			
				var dont_load = false;
				if (is_undefined(obj_data[$ obj[0]])) {
					dont_load = true;
				}
			
				if !(dont_load) {
					var props = properties.getDefaultValues(obj[0])
					
					if (array_length(obj[5]) != array_length(props)) {
						var o=0;
						repeat (array_length(props)) {
							if (array_length(obj[5])-1 < o) && is_array(props[o]) {
								obj[5][o] = variable_clone(props[o]);
							}
							o++;
						}
					}
					
					var linkdata = obj[15];
					obj[15] = variable_clone(properties.getDefaultLinks(obj[0]));
					
					if (array_length(obj)<15) {
						var oid = generate_jadeuuid();
						while struct_exists(object_uuids,oid) {
							oid = generate_jadeuuid();
						}
						object_uuids[$ oid] = [ds_list_size(newregion.node_layer_map), 1, i];
						obj[14] = oid;
					} else {
						object_uuids[$ obj[14]] = j;
						
						var l=0;
						repeat(array_length(obj[15])) {
							obj[15][l].import_contents(linkdata[l]);
							l++;
						}
					}
				
					ds_list_add(newregion.node_layer_map, obj)
				}
				j++;
			}
			
			newregion.mylayerlist.update_depths();
		
			array_push(regions,newregion);
			
			i++;
		}
		
		spawnpoints = level_data[$ "spawnpoints"];
		
		if (array_length(spawnpoints) != 4) {
			spawnpoint_x = spawnpoints[0];
			spawnpoint_y = spawnpoints[1];
			testpoint_x = spawnpoints[3];
			testpoint_y = spawnpoints[4];
		} else {
			spawnpoint_x = spawnpoints[0];
			spawnpoint_y = spawnpoints[1];
			testpoint_x = spawnpoints[2];
			testpoint_y = spawnpoints[3];
		}
	}
	buffer_delete(loaded)
	buffer_delete(save_file)
	
	selected_region = 0;
	update_region();
	show_debug_message($"Successfully loaded JADE file from: {file}!")
}

function JADE_load_legacy(file=game_save_id+"\save.jade") {
	if !file_exists(file) exit;
	var loaded = buffer_load(file)
	var save_file = buffer_decompress(loaded)
	var level_data = json_parse(buffer_read(save_file,buffer_string))
	if (string_starts_with(string(level_data[$ "version"]),"4")) {
		if (struct_exists(level_data, "level_properties")) {
			level_properties = level_data[$ "level_properties"]
		} else {
			level_properties =
			{
			    name : "Danger Room",
			    desc : ""
			};
		}
		var newregion = new JADEregion(800,171,"Region 1");
		newregion.music_track = "frigiddark";
		
		var layers = level_data[$ "layers"]
		var len=array_length(layers);
		var i=0;
		var foundpipinglayer = false;
		var spawnpoints = [];
		repeat(len) {
			var _layer_contents = layers[i];
			
			var _layer;
			
			if (_layer_contents[0]!="MAIN") {
				if (_layer_contents[0] == "TILE") {
					_layer = new JADEtilelayer(_layer_contents[2],_layer_contents[1],800,171)
					
					if (array_length(_layer_contents) > 5) {
						_layer.hide_behavior = _layer_contents[5]
					}
					
					var tile_layer_contents = _layer_contents[4]
				
					var j=0;
					repeat(array_length(tile_layer_contents)) {
						ds_list_add(_layer.tilemap, tile_layer_contents[j])
						tilemap_set(_layer.my_deco_layer, tile_layer_contents[j][0], tile_layer_contents[j][1], tile_layer_contents[j][2]);
						j++;
					}
				} else if (_layer_contents[0] == "ASSET") {
					_layer = new JADEassetlayer(_layer_contents[1])
					_layer.parallax_x = _layer_contents[3]
					_layer.parallax_y = _layer_contents[4]
					
					var asset_layer_contents = _layer_contents[5]
					
					var j=0;
					repeat(array_length(asset_layer_contents)) {
						var obj = asset_layer_contents[j]
						var data = obj_data[$ obj[0]];
						asset_place(obj[0],obj[1]-data.xoff,obj[2]-data.yoff,obj[3],obj[4],_layer)
						j++;
					}
				} else if (_layer_contents[0] == "BACK") {
					if (_layer_contents[3] != -1) {
						var bg = obj_data[$ _layer_contents[3]]
						_layer = new JADEbackgroundlayer(_layer_contents[1], bg)
						_layer.selected_bg = bg
						_layer.sprite = bg.sprite
					} else {
						_layer = new JADEbackgroundlayer(_layer_contents[1], -1)
					}
					_layer.parallax_x = _layer_contents[4]
					_layer.parallax_y = _layer_contents[5]
					_layer.attach_x = _layer_contents[6]
					_layer.attach_y = _layer_contents[7]
					_layer.tiled_h = _layer_contents[8]
					_layer.tiled_v = _layer_contents[9]
					_layer.off_x = _layer_contents[10]
					_layer.off_y = _layer_contents[11]
					_layer.update_settings();
				}
			} else {
				if _layer_contents[1]=="Piping Objects"
				foundpipinglayer = true;
				
				_layer = new JADElistunselectable(_layer_contents[1])
			}
			
			newregion.mylayerlist.add(_layer);
			i++;
		}
		
		if !(foundpipinglayer) {
			var _layer = new JADElistunselectable("Piping Objects")
			newregion.mylayerlist.add(_layer);
		}
		newregion.mylayerlist.update_depths();
		//region count, change laters
		var objects = level_data[$ "objects"]
		var node_objects = level_data[$ "node_objects"]
		i=0
		var j=0;
		repeat(array_length(objects[i])) {
			var obj = objects[i][j]
			
			var dont_load = false;
			if (is_undefined(obj_data[$ obj[0]])) {
				dont_load = true;
			}
			
			if !(dont_load) {
				if (obj[0] == "oPlayerSpawn") { //lame conversion to spawn tool
					spawnpoints = [
						objects[i][j][1],
						objects[i][j][2],
						objects[i][j][1],
						objects[i][j][2]
					]
				} else {
					var props = properties.getDefaultValues(obj[0])
					
					if array_length(obj) < 11 {
						obj[10] = [];
						obj[11] = [2,0,false,false,false,true];
					}
					
					if (array_length(obj[5]) != array_length(props)) {
						var o=0;
						repeat (array_length(props)) { 
							if (array_length(obj[5])-1 < o) && is_array(props[o]) {
								obj[5][o] = variable_clone(props[o]);
							}
							o++;
						}
					}
					
					ds_list_add(newregion.object_layer_map, obj)
				}
			}
			j++;
		}
		j=0;
		repeat(array_length(node_objects[i])) {
			var obj = node_objects[i][j]
			
			var dont_load = false;
			if (is_undefined(obj_data[$ obj[0]])) {
				dont_load = true;
			}
			
			if !(dont_load) {
				if array_length(obj) < 11 {
					obj[10] = [];
					obj[11] = [2,0,false,false,false,true];
				}
				
				if (node_objects[i][j][0] == "oCameraRegion") {
					var props = properties.getDefaultValues(obj[0])
					
					if (array_length(obj[5]) != array_length(props)) {
						var o=0;
						repeat (array_length(props)) { 
							if (array_length(obj[5])-1 < o) && is_array(props[o]) {
								obj[5][o] = variable_clone(props[o]);
							}
							o++;
						}
					}
				}
				
				ds_list_add(newregion.node_layer_map, obj)
			}
			j++;
		}
		
		array_push(regions,newregion);
		
		if (!is_undefined(level_data[$ "spawnpoints"]))
			spawnpoints = level_data[$ "spawnpoints"];
		
		spawnpoint_x = spawnpoints[0];
		spawnpoint_y = spawnpoints[1];
		testpoint_x = spawnpoints[2];
		testpoint_y = spawnpoints[3];
	}
	buffer_delete(loaded)
	buffer_delete(save_file)
	
	selected_region = 0;
	update_region();
	show_debug_message($"Successfully loaded legacy JADE file from: {file}!")
}

function JADE_load_properties(file=game_save_id+"\save.jade") {
	if !file_exists(file)  {
		var struct = {
		    name : "Placeholder",
		    desc : ""
		}
		return struct;
		exit;
	}
	var loaded = buffer_load(file)
	var save_file = buffer_decompress(loaded)
	var level_data = json_parse(buffer_read(save_file,buffer_string))
	
	buffer_delete(loaded)
	buffer_delete(save_file)
	
	if !string_starts_with(string(level_data[$ "version"]),"5") {
		var struct = {
		    name : "OUTDATED",
		    desc : ""
		}
		return struct;
	}
	
	return level_data[$ "level_properties"];
}

function generate_jadeuuid() {
    static hex = "0123456789abcdef";
    static variant = "jade5";
    static str = "xyxxxyyxxy";
    var uuid = "";
    var i=0;
	repeat (string_length(str)) {
        var c = string_char_at(str,i);
        if (c == "x") {
            uuid += string_char_at(hex,irandom_range(1,string_length(hex)));
        } else if (c == "y") {
            uuid += string_char_at(variant,irandom_range(1,string_length(variant)));
        } else {
            uuid += c;
        }
		
		i++;
    }
    return uuid;
}

function tile_layer_alpha_check() {
	if (event_type == ev_draw)
    {
        if (event_number == ev_draw_normal)
        {
			//This makes the tile layer transparent if you arent in tile mode by using layer scripts
			if (oJADEController.selected_mode!=DECO_MODE || oJADEController.selected_layer == noone || layer!=oJADEController.selected_layer.my_layer) {
				shader_set(shd_alpha)
				var alpha = shader_get_uniform(shd_alpha, "alpha");
				shader_set_uniform_f(alpha,0.33)
			}
		}
	}
}

function tile_layer_alpha_end() {
	if (event_type == ev_draw)
    {
        if (event_number == ev_draw_normal)
        {
            shader_reset();
        }
    }
}