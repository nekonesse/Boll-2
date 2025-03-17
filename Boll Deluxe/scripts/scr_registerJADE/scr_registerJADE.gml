#macro REGION_MODE 0
#macro OBJECT_MODE 1
#macro TILE_MODE 2
#macro BACKGROUND_MODE 3
#macro NODE_MODE 4
#macro JADE_VERSION 2


function JADE_initializeobj() {	
	obj_data = ds_map_create();
	obj_name = ds_list_create();
	
	#region Categories
		cat_blocks = ds_list_create();
		cat_baddies = ds_list_create();	
		cat_items = ds_list_create();
		cat_tech = ds_list_create();
		cat_node = ds_list_create();
		
		jade_cats[OBJECT_MODE] = [cat_blocks, cat_baddies, cat_items, cat_tech];
		jade_cats[NODE_MODE] = [cat_node];
	#endregion
	
	/*
		hey so let me explain how this works:
		uuid is the 'id' for an object, its used for accessing everything. preferrably a string. 
		DO NOT USE AN INSTANCE ID.
		gamemaker instance ids are dynamic and will regenerate when the game compiles,
		meaning if you try and save that and load it later, it will error, because it doesnt exist!
		
		instead use a string for a name like "brick" or "red_koopa"
	*/
	//1. uuid
	//2. sprite
	//3. placement x offset
	//4. placement y offset
	//5. placement xscale
	//6. placement yscale
	//7. scalable horizontally (bool)
	//8. scalable vertically (bool)
	//9. what editor mode object list to appear in
	//10. object properties (check scr_properties)
	//11. list display name (will use uuid if not set)
	//12. is nodeable in node mode (bool)
	//13. x scale override when placed
	//14. y scale override when place
	show_debug_message("Registering JADE object list...")
	registerobj(object_get_name(oPlayerSpawn), spr_spawner, -sprite_get_xoffset(spr_spawner), -sprite_get_yoffset(spr_spawner), sprite_get_width(spr_spawner), sprite_get_height(spr_spawner), false, false, OBJECT_MODE, 0, object_get_properties("oPlayerSpawn"), "Player Spawn")
	registerobj(object_get_name(oCollider), spr_collider, -sprite_get_xoffset(spr_collider), -sprite_get_yoffset(spr_collider), sprite_get_width(spr_collider), sprite_get_height(spr_collider), true, true, OBJECT_MODE, 0, object_get_properties("oCollider"), "Collider")
	registerobj(object_get_name(oSlopeCollider), spr_slopesolid, -sprite_get_xoffset(spr_slopesolid), -sprite_get_yoffset(spr_slopesolid), sprite_get_width(spr_slopesolid), sprite_get_height(spr_slopesolid), true, true, OBJECT_MODE, 0, object_get_properties("oSlopeCollider"), "Solid Slope")
	registerobj(object_get_name(oRoundedSlope1x1), spr_rslope1, -sprite_get_xoffset(spr_rslope1), -sprite_get_yoffset(spr_rslope1), sprite_get_width(spr_rslope1), sprite_get_height(spr_rslope1), true, true, OBJECT_MODE, 0, object_get_properties("oRoundedSlope1x1"), "Rounded Slope 1x1")
	registerobj(object_get_name(oRoundedSlope2x2), spr_rslope2, -sprite_get_xoffset(spr_rslope2), -sprite_get_yoffset(spr_rslope2), sprite_get_width(spr_rslope2), sprite_get_height(spr_rslope2), true, true, OBJECT_MODE, 0, object_get_properties("oRoundedSlope2x2"), "Rounded Slope 2x2")
	registerobj(object_get_name(oRoundedSlope3x3), spr_rslope3, -sprite_get_xoffset(spr_rslope3), -sprite_get_yoffset(spr_rslope3), sprite_get_width(spr_rslope3), sprite_get_height(spr_rslope3), true, true, OBJECT_MODE, 0, object_get_properties("oRoundedSlope3x3"), "Rounded Slope 3x3")
	registerobj(object_get_name(oSemilider), spr_semilider, -sprite_get_xoffset(spr_semilider), -sprite_get_yoffset(spr_semilider), sprite_get_width(spr_semilider), sprite_get_height(spr_semilider), true, true, OBJECT_MODE, 0, object_get_properties("oSemilider"), "Semisolid")
	registerobj(object_get_name(oSemiSlope), spr_slopesemi, -sprite_get_xoffset(spr_slopesemi), -sprite_get_yoffset(spr_slopesemi), sprite_get_width(spr_slopesemi), sprite_get_height(spr_slopesemi), true, true, OBJECT_MODE, 0, object_get_properties("oSemiSlope"), "Semisolid Slope")
    registerobj(object_get_name(oGrabable), spr_gobble, -sprite_get_xoffset(spr_gobble), -sprite_get_yoffset(spr_gobble), sprite_get_width(spr_gobble), sprite_get_height(spr_gobble), true, true, OBJECT_MODE, 0, object_get_properties("oGrabable"), "Grabable Object")
	registerobj(object_get_name(oPipe), spr_pipe, -sprite_get_xoffset(spr_pipe), -sprite_get_yoffset(spr_pipe), sprite_get_width(spr_pipe), sprite_get_height(spr_pipe), false, false, OBJECT_MODE, 0, object_get_properties("oPipe"), "Pipe")
	registerobj(object_get_name(oItemBox), spr_itembox, -sprite_get_xoffset(spr_itembox), -sprite_get_yoffset(spr_itembox), sprite_get_width(spr_itembox), sprite_get_height(spr_itembox), false, false, OBJECT_MODE, 0, object_get_properties("oItemBox"), "Item Box", true)
	registerobj(object_get_name(oBrick), spr_brick, -sprite_get_xoffset(spr_brick), -sprite_get_yoffset(spr_brick), sprite_get_width(spr_brick), sprite_get_height(spr_brick), false, false, OBJECT_MODE, 0, object_get_properties("oBrick"), "Brick", true)
	registerobj(object_get_name(oHardBlock), spr_hardblock, -sprite_get_xoffset(spr_hardblock), -sprite_get_yoffset(spr_hardblock), sprite_get_width(spr_hardblock), sprite_get_height(spr_hardblock), false, false, OBJECT_MODE, 0, object_get_properties("oHardBlock"), "Hard Block", true)
	registerobj(object_get_name(oDonutBlock), spr_donutblock, -sprite_get_xoffset(spr_donutblock), -sprite_get_yoffset(spr_donutblock), sprite_get_width(spr_donutblock), sprite_get_height(spr_donutblock), true, false, OBJECT_MODE, 0, object_get_properties("oDonutBlock"), "Donut Block", true)
	registerobj(object_get_name(oNoteBlock), spr_noteblock, -sprite_get_xoffset(spr_noteblock), -sprite_get_yoffset(spr_noteblock), sprite_get_width(spr_noteblock), sprite_get_height(spr_noteblock), false, false, OBJECT_MODE, 0, object_get_properties("oNoteBlock"), "Note Block", true)
	registerobj(object_get_name(oFlipblock), spr_flipblock, -sprite_get_xoffset(spr_flipblock), -sprite_get_yoffset(spr_flipblock), sprite_get_width(spr_flipblock), sprite_get_height(spr_flipblock), false, false, OBJECT_MODE, 0, object_get_properties("oFlipBlock"), "Flip Block", true)
	registerobj(object_get_name(oShootBlock), spr_shootblock, -sprite_get_xoffset(spr_shootblock), -sprite_get_yoffset(spr_shootblock), sprite_get_width(spr_shootblock), sprite_get_height(spr_shootblock), false, false, OBJECT_MODE, 0, object_get_properties("oShootBlock"), "Shoot Block", true)
	registerobj(object_get_name(oSolidSpike), spr_solidspike, -sprite_get_xoffset(spr_solidspike), -sprite_get_yoffset(spr_solidspike), sprite_get_width(spr_solidspike), sprite_get_height(spr_solidspike), true, true, OBJECT_MODE, 0, object_get_properties("oSolidSpike"), "Solid Spike", true)
	registerobj(object_get_name(oMovingPlatform), spr_movingplatform, -sprite_get_xoffset(spr_movingplatform), -sprite_get_yoffset(spr_movingplatform), sprite_get_width(spr_movingplatform), sprite_get_height(spr_movingplatform), true, false, OBJECT_MODE, 0, object_get_properties("oMovingPlatform"), "Moving Platform", true)
	registerobj(object_get_name(oSwingingPlatform), spr_movingplatform, -sprite_get_xoffset(spr_movingplatform), -sprite_get_yoffset(spr_movingplatform), sprite_get_width(spr_movingplatform), sprite_get_height(spr_movingplatform), true, false, OBJECT_MODE, 0, object_get_properties("oSwingingPlatform"), "Swinging Platform", true)
	registerobj(object_get_name(oChainsaw), spr_chainsaw, -8, -8, 16, 16, false, false, OBJECT_MODE, 0, object_get_properties("oChainsaw"), "Chainsaw", true)
	registerobj(object_get_name(oGrate), spr_grate, -sprite_get_xoffset(spr_grate), -sprite_get_yoffset(spr_grate), sprite_get_width(spr_grate), sprite_get_height(spr_grate), false, false, OBJECT_MODE, 0, object_get_properties("oGrate"))
	registerobj(object_get_name(oGrateSemi), spr_gratesemi, -sprite_get_xoffset(spr_gratesemi), -sprite_get_yoffset(spr_gratesemi), sprite_get_width(spr_gratesemi), sprite_get_height(spr_gratesemi), false, false, OBJECT_MODE, 0, object_get_properties("oGrateSemi"))
	registerobj(object_get_name(oEnemyGround), spr_enemyground, -sprite_get_xoffset(spr_enemyground), -sprite_get_yoffset(spr_enemyground), sprite_get_width(spr_enemyground), sprite_get_height(spr_enemyground), false, false, OBJECT_MODE, 0, object_get_properties("oEnemyGround"))
	registerobj(object_get_name(oEnemyGroundSemi), spr_enemygroundsemi, -sprite_get_xoffset(spr_enemygroundsemi), -sprite_get_yoffset(spr_enemygroundsemi), sprite_get_width(spr_enemygroundsemi), sprite_get_height(spr_enemygroundsemi), false, false, OBJECT_MODE, 0, object_get_properties("oEnemyGroundsemi"))
	registerobj(object_get_name(oIceBlock), spr_iceblockJADE, -sprite_get_xoffset(spr_iceblockJADE), -sprite_get_yoffset(spr_iceblockJADE), sprite_get_width(spr_iceblockJADE), sprite_get_height(spr_iceblockJADE), true, true, OBJECT_MODE, 0, object_get_properties("oIceBlock"))
	registerobj(object_get_name(oPollenFlower), spr_pollenflower, -sprite_get_xoffset(spr_pollenflower), -sprite_get_yoffset(spr_pollenflower), sprite_get_width(spr_pollenflower), sprite_get_height(spr_pollenflower), false, false, OBJECT_MODE, 0, object_get_properties("oPollenFlower"))
	registerobj(object_get_name(oWater), spr_water, 0, 0, 16, 16, true, true, OBJECT_MODE, 0, object_get_properties("oWater"), "Water", false, 0.25, 0.5)
	registerobj(object_get_name(oPolyCollider), spr_collider_poly, -sprite_get_xoffset(spr_collider_poly), -sprite_get_yoffset(spr_collider_poly), sprite_get_width(spr_collider_poly), sprite_get_height(spr_collider_poly), true, true, OBJECT_MODE, 0, object_get_properties("oPolyCollider"), "Poly Collider")
	
	registerobj(object_get_name(oTerrainSpreng), spr_yellowterrainspring, -sprite_get_xoffset(spr_yellowterrainspring), -sprite_get_yoffset(spr_yellowterrainspring), sprite_get_width(spr_yellowterrainspring), sprite_get_height(spr_yellowterrainspring), false, false, OBJECT_MODE, 3, object_get_properties("oTerrainSpreng"))
	registerobj(object_get_name(oTerrainSpring), spr_redterrainspring, -8, -16, 16, 16, false, false, OBJECT_MODE, 3, object_get_properties("oTerrainSpring"))
	registerobj(object_get_name(oTerrainSprong), spr_greenterrainspring, -8, -16, 16, 16, false, false, OBJECT_MODE, 3, object_get_properties("oTerrainSprong"))
	registerobj(object_get_name(oYellowSwitch), spr_yellowswitch, -sprite_get_xoffset(spr_yellowswitch), -sprite_get_yoffset(spr_yellowswitch), sprite_get_width(spr_yellowswitch), sprite_get_height(spr_yellowswitch), false, false, OBJECT_MODE, 3, object_get_properties("oYellowSwitch"))
	registerobj(object_get_name(oYellowSwitchBlock), spr_yellowswitchblock, -sprite_get_xoffset(spr_yellowswitchblock), -sprite_get_yoffset(spr_yellowswitchblock), sprite_get_width(spr_yellowswitchblock), sprite_get_height(spr_yellowswitchblock), false, false, OBJECT_MODE, 3, object_get_properties("oYellowSwitchBlock"))
	registerobj(object_get_name(oYellowSwitchBlockOff), spr_yellowswitchblockoff, -sprite_get_xoffset(spr_yellowswitchblockoff), -sprite_get_yoffset(spr_yellowswitchblockoff), sprite_get_width(spr_yellowswitchblockoff), sprite_get_height(spr_yellowswitchblockoff), false, false, OBJECT_MODE, 3, object_get_properties("oYellowSwitchBlockOff"))
	registerobj(object_get_name(oYellowSwitchSlope), spr_yellowswitchslope, -sprite_get_xoffset(spr_yellowswitchslope), -sprite_get_yoffset(spr_yellowswitchslope), sprite_get_width(spr_yellowswitchslope), sprite_get_height(spr_yellowswitchslope), false, false, OBJECT_MODE, 3, object_get_properties("oYellowSwitchSlope"))
	registerobj(object_get_name(oCyanSwitch), spr_cyanswitch, -sprite_get_xoffset(spr_cyanswitch), -sprite_get_yoffset(spr_cyanswitch), sprite_get_width(spr_cyanswitch), sprite_get_height(spr_cyanswitch), false, false, OBJECT_MODE, 3, object_get_properties("oCyanSwitch"))
	registerobj(object_get_name(oCyanSwitchBlock), spr_cyanswitchblock, -sprite_get_xoffset(spr_cyanswitchblock), -sprite_get_yoffset(spr_cyanswitchblock), sprite_get_width(spr_cyanswitchblock), sprite_get_height(spr_cyanswitchblock), false, false, OBJECT_MODE, 3, object_get_properties("oCyanSwitchBlock"))
	registerobj(object_get_name(oCyanSwitchBlockOff), spr_cyanswitchblockoff, -sprite_get_xoffset(spr_cyanswitchblockoff), -sprite_get_yoffset(spr_cyanswitchblockoff), sprite_get_width(spr_cyanswitchblockoff), sprite_get_height(spr_cyanswitchblockoff), false, false, OBJECT_MODE, 3, object_get_properties("oCyanSwitchBlockOff"))
	registerobj(object_get_name(oCyanSwitchSlope), spr_cyanswitchslope, -sprite_get_xoffset(spr_cyanswitchslope), -sprite_get_yoffset(spr_cyanswitchslope), sprite_get_width(spr_cyanswitchslope), sprite_get_height(spr_cyanswitchslope), false, false, OBJECT_MODE, 3, object_get_properties("oCyanSwitchSlope"))
	registerobj(object_get_name(oMagentaSwitch), spr_magentaswitch, -sprite_get_xoffset(spr_magentaswitch), -sprite_get_yoffset(spr_magentaswitch), sprite_get_width(spr_magentaswitch), sprite_get_height(spr_magentaswitch), false, false, OBJECT_MODE, 3, object_get_properties("oMagentaSwitch"))
	registerobj(object_get_name(oMagentaSwitchBlock), spr_magentaswitchblock, -sprite_get_xoffset(spr_magentaswitchblock), -sprite_get_yoffset(spr_magentaswitchblock), sprite_get_width(spr_magentaswitchblock), sprite_get_height(spr_magentaswitchblock), false, false, OBJECT_MODE, 3, object_get_properties("oMagentaSwitchBlock"))
	registerobj(object_get_name(oMagentaSwitchBlockOff), spr_magentaswitchblockoff, -sprite_get_xoffset(spr_magentaswitchblockoff), -sprite_get_yoffset(spr_magentaswitchblockoff), sprite_get_width(spr_magentaswitchblockoff), sprite_get_height(spr_magentaswitchblockoff), false, false, OBJECT_MODE, 3, object_get_properties("oMagentaSwitchBlockOff"))
	registerobj(object_get_name(oMagentaSwitchSlope), spr_magentaswitchslope, -sprite_get_xoffset(spr_magentaswitchslope), -sprite_get_yoffset(spr_magentaswitchslope), sprite_get_width(spr_magentaswitchslope), sprite_get_height(spr_magentaswitchslope), false, false, OBJECT_MODE, 3, object_get_properties("oMagentaSwitchSlope"))
	registerobj(object_get_name(oZapper), spr_zapper, -sprite_get_xoffset(spr_zapper), -sprite_get_yoffset(spr_zapper), sprite_get_width(spr_zapper), sprite_get_height(spr_zapper), false, false, OBJECT_MODE, 3, object_get_properties("oZapper"), "Zapper", true)
	
	registerobj(object_get_name(oGoomba), spr_goombawalk, -8, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oGoomba"))
	registerobj(object_get_name(oGoombrat), spr_goombratwalk, -8, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oGoombrat"))
	registerobj(object_get_name(oKoopa), spr_koopawalk_g, -8, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oKoopa"))
	registerobj(object_get_name(oKoopaRed), spr_koopawalk_r, -8, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oKoopaRed"))
	registerobj(object_get_name(oKoopaYellow), spr_koopawalk_y, -8, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oKoopaYellow"))
	registerobj(object_get_name(oAmp), spr_amp, -8, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oAmp"), "Amp", true)
	registerobj(object_get_name(oSlime), spr_slime_editor, -65, -85, 130, 85, false, false, OBJECT_MODE, 1, object_get_properties("oSlime"))
	registerobj(object_get_name(oThwomp), spr_thwomp, 0, -14, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oThwomp"))
	registerobj(object_get_name(oBobOmb), spr_bobombwalk, -8, -8, 21, 22, false, false, OBJECT_MODE, 1, object_get_properties("oBobOmb"))
	registerobj(object_get_name(oBigSteely), spr_bigsteely, -24, -24, 48, 48, false, false, OBJECT_MODE, 1, object_get_properties("oBigSteely"), "Big Steely", true)
	registerobj(object_get_name(oBillBlaster), spr_billblasterJADE, 0, 0, 16, 32, false, true, OBJECT_MODE, 1, object_get_properties("oBillBlaster"), "Bill Blaster", false)
	registerobj(object_get_name(oBanzaiBlaster), spr_banzaiblasterJADE, -32, -32, 64, 64, false, true, OBJECT_MODE, 1, object_get_properties("oBanzaiBlaster"), "Banzai Blaster", false)
	registerobj(object_get_name(oPiranhaPlant), spr_piranhaplant, 4, -6, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oPiranhaPlant"), "Piranha Plant", false)
	registerobj(object_get_name(oJumpingPiranha), spr_jumpingpiranhafall, -16, -8, 16, 16, false, false, OBJECT_MODE, 1, object_get_properties("oPiranhaPlant"), "Piranha Plant", true)
	
	registerobj(object_get_name(oCoin), spr_coin, -8, -8, 16, 16, false, false, OBJECT_MODE, 2, object_get_properties("oCoin"), "Coin", true)
	registerobj(object_get_name(oMushroom), spr_mushroom, -8, -8, 16, 16, false, false, OBJECT_MODE, 2, object_get_properties("oMushroom"), "Mushroom", true)
	registerobj(object_get_name(oFireFlower), spr_fireflower, -8, -10, 16, 16, false, false, OBJECT_MODE, 2, object_get_properties("oFireFlower"), "Fire Flower", true)
	registerobj(object_get_name(oThunderFlower), spr_thunderflowerJADE, -8, -10, 16, 16, false, false, OBJECT_MODE, 2, object_get_properties("oThunderFlower"), "Thunder Flower",true)
	registerobj(object_get_name(oStar), spr_starman, -8, -8, 16, 16, false, false, OBJECT_MODE, 2, object_get_properties("oStar"), "Star", true)
	registerobj(object_get_name(oMysteryOrb), spr_mysteryorb, -8, -8, 16, 16, false, false, OBJECT_MODE, 2, object_get_properties("oMysteryOrb"), "Mystery Orb", true)
    registerobj(object_get_name(o1up), spr_1up, -8, -8, 16, 16, false, false, OBJECT_MODE, 2, object_get_properties("o1up"), "1-UP Mushroom", true)
    registerobj(object_get_name(o3up), spr_3up, -8, -8, 16, 16, false, false, OBJECT_MODE, 2, object_get_properties("o3up"), "3-UP Moon", true)
    registerobj(object_get_name(oCheckpoint), spr_checkpoint, 21, 28, 16, 16, false, false, OBJECT_MODE, 2, object_get_properties("oCheckpoint"), "Checkpoint")
	registerobj(object_get_name(oFlagpole), spr_JADEflagpole, -8, -160, 48, 160, false, false, OBJECT_MODE, 2, object_get_properties("oFlagpole"), "Flagpole")
	registerobj(object_get_name(oSoccerBall), spr_soccerball, -8, -8, 16, 16, false, false, OBJECT_MODE, 2, object_get_properties("oSoccerBall"), "Soccer Ball", true)
	
	//NODE MODE
	registerobj(object_get_name(oCameraRegion), spr_cameraregion, -sprite_get_xoffset(spr_cameraregion), -sprite_get_yoffset(spr_cameraregion), sprite_get_width(spr_cameraregion), sprite_get_height(spr_cameraregion), true, true, NODE_MODE, 0, object_get_properties("oCameraRegion"), "Camera Region")
	registerobj(object_get_name(oCameraBoundary), spr_cameraboundary, -sprite_get_xoffset(spr_cameraboundary), -sprite_get_yoffset(spr_cameraboundary), sprite_get_width(spr_cameraboundary), sprite_get_height(spr_cameraboundary), true, true, NODE_MODE, 0, object_get_properties("oCameraBoundary"), "Camera Boundary")
	registerobj(object_get_name(oActivationRegion), spr_activationregion, -sprite_get_xoffset(spr_activationregion), -sprite_get_yoffset(spr_activationregion), sprite_get_width(spr_activationregion), sprite_get_height(spr_activationregion), true, true, NODE_MODE, 0, object_get_properties("oActivationRegion"), "Activation Region")
	registerobj(object_get_name(oDeactivationRegion), spr_deactivationregion, -sprite_get_xoffset(spr_deactivationregion), -sprite_get_yoffset(spr_deactivationregion), sprite_get_width(spr_deactivationregion), sprite_get_height(spr_deactivationregion), true, true, NODE_MODE, 0, object_get_properties("oDeactivationRegion"), "Deactivation Region")
	registerobj(object_get_name(oDeathPit), spr_deathpit, -sprite_get_xoffset(spr_deathpit), -sprite_get_yoffset(spr_deathpit), sprite_get_width(spr_deathpit), sprite_get_height(spr_deathpit), true, false, NODE_MODE, 0, object_get_properties("oDeathPit"), "Death Pit")
}

function register_array(array, category) {
	var i=0;
	repeat (array_length(array)) {
		var _name = object_get_name(array[i])
		var _sprite = object_get_sprite(array[i])
		var _properties = object_get_properties(_name)
	    registerobj(_name, _sprite, -sprite_get_xoffset(_sprite), -sprite_get_yoffset(_sprite), sprite_get_width(_sprite), sprite_get_height(_sprite), true, true, OBJECT_MODE, category, _properties, false)
		i++;
	}	
}

function registerobj(uuid,sprite,xoff,yoff,xscale,yscale,can_xscale,can_yscale,mode,category,properties,name=uuid,nodeable=false,sizex=1,sizey=1) {
	if !ds_map_exists(obj_data,uuid) {
		ds_map_add(obj_data,uuid,[sprite,xoff,yoff,xscale,yscale,can_xscale,can_yscale,mode,properties,nodeable,name,sizex,sizey])
		ds_list_add(obj_name,uuid)
		ds_list_add(jade_cats[mode][category],[uuid,name])
		show_debug_message($"Successfully registered object id: {uuid} in JADE")
	} else {
		show_debug_message($"Object ID: {uuid} is already registered in JADE! ignoring..")
	}
}

function JADE_save(file=game_save_id+"\save.jade") {
	file_delete(file)
	show_debug_message($"Saving JADE file to: {file}")
	var struct = {};
	var arrayObjects=[];
	var i;
	i=0;
	repeat(ds_list_size(object_layer_map)) {
	    array_push(arrayObjects, object_layer_map[| i])
		i++;
	}
	var arrayNodeObjects = [];
	i=0;
	repeat(ds_list_size(node_layer_map)) {
	    array_push(arrayNodeObjects, node_layer_map[| i])
		i++;
	}
	var arrayTiles=[];
	i=0;
	repeat(array_length(tile_layer_map)) {
		arrayTiles[i]=[];
		var j=0;
	    repeat(ds_list_size(tile_layer_map[i])) {
			array_push(arrayTiles[i], tile_layer_map[i][| j])
			j++;
		}
		i++;
	}
	var arrayTileLayers=[];
	i=0;
	repeat (array_length(layers)) {
	    array_push(arrayTileLayers, [layer_get_name(layers[i]), layer_get_depth(layers[i]), tileset_get_name(tilemap_get_tileset(tile_layer[i]))])
		i++;
	}
	struct[$ "version"]=JADE_VERSION
	struct[$ "objects"]=arrayObjects
	struct[$ "tiles"]=arrayTiles
	struct[$ "node_objects"]=arrayNodeObjects
	struct[$ "tile_layers"]=arrayTileLayers
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
	show_debug_message($"Loading JADE file from: {file}")
	if !is_array(level_data) && is_struct(level_data) {
		var objects = level_data[$ "objects"] //read amount of objects
		var node_objects = level_data[$ "node_objects"] //read amount of node objects
		var tiles = level_data[$ "tiles"] //read amount of tiles
		ds_list_clear(object_layer_map) //erase object map beforehand
		var i;
	
		i=0;
		repeat(array_length(objects)) { //load objects
	        var data = objects[i]
			data[5] = 0
			if array_length(data) >= 13 && array_length(data[12]) < 5 {
				data[12][5]=true
			}
			ds_list_add(object_layer_map,data)
			i++
		}
		i=0;
		repeat(array_length(tiles)) { //loading tiles
			tilemap_clear(tile_layer[i], 0) //erase tilemap beforehand
			ds_list_clear(tile_layer_map[i]) //erase tile map beforehand
			var j=0;
			repeat (array_length(tiles[i])) {
				var data = tiles[i][j]
				tilemap_set(tile_layer[i],data[0],data[1],data[2])
				ds_list_add(tile_layer_map[i], [data[0], data[1], data[2]]) //add tile to list at place
				j++;
			}
			i++
		}
		ds_list_clear(node_layer_map)
		i=0;
		repeat (array_length(node_objects)) { //load node object
			var data = node_objects[i]
			data[5] = 0
			ds_list_add(node_layer_map,data)
			i++;
		}
	} else { #region Legacy Level Loading
		var object_arr_index=1;
		var tile_arr_index=2;
		var node_arr_index=3;
		var has_version=true;
		if array_length(level_data) < 5 { //legacy conversion
			has_version=false;
			object_arr_index=0;
			tile_arr_index=1;
			node_arr_index=2;
		}
		var size = array_length(level_data[object_arr_index]) //read amount of objects
		var nodesize = array_length(level_data[node_arr_index]) //read amount of objects
		var tilesize = array_length(level_data[tile_arr_index]) //read amount of tiles
		ds_list_clear(object_layer_map) //erase object map beforehand
		var i;
	
		i=0;
		repeat(size) { //load objects
	        var data = level_data[object_arr_index][i]
			data[5] = 0
			if array_length(data) >= 13 && array_length(data[12]) < 5 {
				data[12][5]=true
			}
			ds_list_add(object_layer_map,data)
			i++
		}
		if array_length(level_data) >= 4 {
		    i=0;
			repeat(tilesize) { //loading tiles
				tilemap_clear(tile_layer[i], 0) //erase tilemap beforehand
				ds_list_clear(tile_layer_map[i]) //erase tile map beforehand
				var j=0;
				repeat (array_length(level_data[tile_arr_index][i])) {
					var data = level_data[tile_arr_index][i][j]
				    tilemap_set(tile_layer[i],data[0],data[1],data[2])
					ds_list_add(tile_layer_map[i], [data[0], data[1], data[2]]) //add tile to list at place
					j++;
				}
				i++
			}
		} else { //legacy tile conversion
			tilemap_clear(tile_layer[2], 0) //erase tilemap beforehand
			ds_list_clear(tile_layer_map[2]) //erase tile map beforehand
			var j=0;
			repeat (array_length(level_data[tile_arr_index])) {
				var data = level_data[tile_arr_index][j]
				tilemap_set(tile_layer[2],data[0],data[1],data[2])
				ds_list_add(tile_layer_map[2], [data[0], data[1], data[2]]) //add tile to list at place
				j++;
			}
		}
		ds_list_clear(node_layer_map)
		i=0;
		repeat (nodesize) { //load node objects
	        var data = level_data[node_arr_index][i]
			data[5] = 0
			ds_list_add(node_layer_map,data)
			i++;
		}
	} #endregion
	buffer_delete(loaded)
	buffer_delete(save_file)
	show_debug_message($"Successfully loaded JADE file from: {file}!")
}

function tile_layer_alpha_check() {
	//This makes the tile layer transparent if you arent in tile mode by using layer scripts
	if oJADEController.selected_mode!=TILE_MODE || layer!=oJADEController.layers[oJADEController.selected_tile_layer] {
		shader_set(shd_alpha)
		var alpha = shader_get_uniform(shd_alpha, "alpha");
		shader_set_uniform_f(alpha,0.33)
	}
}