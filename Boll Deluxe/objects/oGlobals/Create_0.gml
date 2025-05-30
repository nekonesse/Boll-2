#macro gametitle "Boll 2"
#macro version "0.1"

global.save_dir=""

global.smallBoldFont=font_add_sprite_ext(spr_smallboldfont,"0123456789abcdefghijklmnopqrstuvwxyz,.'"+chr(34)+":;/"+chr(92)+"[]><*!?_-=+{}#$@%^&|`~",true,1)
ScribblejrAttachSpritefont(global.smallBoldFont,true,1)
global.omiFont=font_add_sprite_ext(spr_omifont,"0123456789:;.,<=>}%/"+chr(92)+"-_!?*+#'"+chr(34)+"~@][&abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ",true,1)
ScribblejrAttachSpritefont(global.omiFont,true,1)

global.debug=0
global.fps_display = 0;
global.netgame = false; // top 10 boll deluxe things that will never happen:
global.nextlevel = game_save_id+"\save.jade"
global.jade_testing = false; // whether the current level is being tested in JADE or not

#macro no_checkpoint -51781 // silver the hedgehogs do NOT turn this upside down.....

global.checkpointX = no_checkpoint;
global.checkpointY = no_checkpoint;
global.checkpointDir = 0;

if !(instance_exists(input_controller_object)) instance_create_depth(0,0,16001,input_controller_object)

GMLspeak.interface.exposeEverythingIDontCareIfModdersCanEditUsersSaveFilesJustLetMeDoThis = true
GMLspeak.enableWritingIOProperties(true)
GMLspeak.interface.compileFlags.checkForVariables = true;

//// TXR SETUP!!! ////
#region TXR
	txr_init(); //TXR starting
	
	#region Constants
		GMLspeak.interface.exposeConstant("COL_WALL",COL_WALL)
		GMLspeak.interface.exposeConstant("COL_BOTTOM",COL_BOTTOM)
		GMLspeak.interface.exposeConstant("COL_TOP",COL_TOP)
		GMLspeak.interface.exposeConstant("COL_LINE",COL_LINE)
		GMLspeak.interface.exposeConstant("COL_DOT",COL_DOT)
		GMLspeak.interface.exposeConstant("CAM_SENSOR_WIDTH",CAM_SENSOR_WIDTH)
		GMLspeak.interface.exposeConstant("CAM_SENSOR_HEIGHT",CAM_SENSOR_HEIGHT)
		GMLspeak.interface.exposeConstant("CAM_ZOOM_TIME",CAM_ZOOM_TIME)
		GMLspeak.interface.exposeConstant("CAM_ZOOM_RATE",CAM_ZOOM_RATE)
		//Objects
		GMLspeak.interface.exposeAsset("oCollider")
		GMLspeak.interface.exposeAsset("oSemilider")
		GMLspeak.interface.exposeAsset("oPolyCollider")
		GMLspeak.interface.exposeAsset("oSlopeCollider")
		GMLspeak.interface.exposeAsset("oSemiSlope")
		GMLspeak.interface.exposeAsset("oHittable")
		GMLspeak.interface.exposeAsset("oGrate")
		GMLspeak.interface.exposeAsset("oGrateSemi")
		GMLspeak.interface.exposeAsset("oEnemyGround")
		GMLspeak.interface.exposeAsset("oEnemyGroundSemi")
		GMLspeak.interface.exposeAsset("oFlipblock")
		GMLspeak.interface.exposeAsset("oItemBox")
		GMLspeak.interface.exposeAsset("oBrick")
		GMLspeak.interface.exposeAsset("oShootBlock")
		GMLspeak.interface.exposeAsset("oDonutBlock")
		GMLspeak.interface.exposeAsset("oHardBlock")
		GMLspeak.interface.exposeAsset("oPipe")
		GMLspeak.interface.exposeAsset("oMovingPlatform")
		GMLspeak.interface.exposeAsset("oSwingingPlatform")
		GMLspeak.interface.exposeAsset("oChainsaw")
		GMLspeak.interface.exposeAsset("oBillBlaster")
		GMLspeak.interface.exposeAsset("oBanzaiBlaster")
		GMLspeak.interface.exposeAsset("oSoccerBall")
		GMLspeak.interface.exposeAsset("oTerrainSpring")
		GMLspeak.interface.exposeAsset("oTerrainSprong")
		GMLspeak.interface.exposeAsset("oTerrainSpreng")
		GMLspeak.interface.exposeAsset("oYellowSwitch")
		GMLspeak.interface.exposeAsset("oYellowSwitchBlock")
		GMLspeak.interface.exposeAsset("oYellowSwitchBlockOff")
		GMLspeak.interface.exposeAsset("oYellowSwitchSlope")
		GMLspeak.interface.exposeAsset("oCyanSwitch")
		GMLspeak.interface.exposeAsset("oCyanSwitchBlock")
		GMLspeak.interface.exposeAsset("oCyanSwitchBlockOff")
		GMLspeak.interface.exposeAsset("oCyanSwitchSlope")
		GMLspeak.interface.exposeAsset("oMagentaSwitch")
		GMLspeak.interface.exposeAsset("oMagentaSwitchBlock")
		GMLspeak.interface.exposeAsset("oMagentaSwitchBlockOff")
		GMLspeak.interface.exposeAsset("oMagentaSwitchSlope")
        GMLspeak.interface.exposeAsset("oMushroom")
		GMLspeak.interface.exposeAsset("oFireFlower")
		GMLspeak.interface.exposeAsset("oThunderFlower")
        GMLspeak.interface.exposeAsset("o1up")
        GMLspeak.interface.exposeAsset("o3up")
        GMLspeak.interface.exposeAsset("oPoisonShroom")
		GMLspeak.interface.exposeAsset("oCoin")
		GMLspeak.interface.exposeAsset("oMysteryOrb")
		
		//Enemies
		GMLspeak.interface.exposeAsset("oEnemy")
		GMLspeak.interface.exposeAsset("oGoomba")
		GMLspeak.interface.exposeAsset("oGoombrat")
		GMLspeak.interface.exposeAsset("oKoopa")
		GMLspeak.interface.exposeAsset("oKoopaRed")
		GMLspeak.interface.exposeAsset("oKoopaYellow")
		GMLspeak.interface.exposeAsset("oPiranhaPlant")
		GMLspeak.interface.exposeAsset("oBulletBill")
		GMLspeak.interface.exposeAsset("oBanzaiBill")
		GMLspeak.interface.exposeAsset("oLargeSamba")
		GMLspeak.interface.exposeAsset("oPylom")
		GMLspeak.interface.exposeAsset("oThwomp")
		
		//Projectiles
		GMLspeak.interface.exposeAsset("oFireball")
		
		//Control
		GMLspeak.interface.exposeAsset("oPlayer")
		GMLspeak.interface.exposeAsset("oGlobals")
		GMLspeak.interface.exposeAsset("oBackgroundManager")
		GMLspeak.interface.exposeAsset("oGameManager")
		GMLspeak.interface.exposeAsset("oCamera")
		GMLspeak.interface.exposeAsset("oCameraRegion")
		GMLspeak.interface.exposeAsset("oCameraBoundary")
		
		//Particles
		GMLspeak.interface.exposeAsset("pSmoke")
		GMLspeak.interface.exposeAsset("pRunDust")
		GMLspeak.interface.exposeAsset("pSkidDust")
		GMLspeak.interface.exposeAsset("pJumpDust")
		GMLspeak.interface.exposeAsset("pCoinCollected")
		GMLspeak.interface.exposeAsset("pGlitter")
		GMLspeak.interface.exposeAsset("pSparkles1UP")
		GMLspeak.interface.exposeAsset("p1UP")
		GMLspeak.interface.exposeAsset("p3UP")
		GMLspeak.interface.exposeAsset("pFireballExplosion")
		GMLspeak.interface.exposeAsset("pFireballTrail")
		GMLspeak.interface.exposeAsset("pImpact")
	#endregion
	
	#region Custom Functions
		GMLspeak.interface.exposeFunction("CollageImageExists", CollageImageExists);
		GMLspeak.interface.exposeFunction("draw_rect", draw_rect);
		GMLspeak.interface.exposeFunction("wave_val", wave_val);
		GMLspeak.interface.exposeFunction("approach_val", approach_val);
		GMLspeak.interface.exposeFunction("chance", chance);
		GMLspeak.interface.exposeFunction("jump_in_direction", jump_in_direction);
		GMLspeak.interface.exposeFunction("check_signs_matching", check_signs_matching);
		GMLspeak.interface.exposeFunction("esign", esign);
		GMLspeak.interface.exposeFunction("unreal", unreal);
		GMLspeak.interface.exposeFunction("nozerounreal", nozerounreal);
		GMLspeak.interface.exposeFunction("modulo", modulo);
		GMLspeak.interface.exposeFunction("nearestplayer", nearestplayer);
		GMLspeak.interface.exposeFunction("split_string", split_string);
		GMLspeak.interface.exposeFunction("ternary", ternary);
		GMLspeak.interface.exposeFunction("get_spriteindex", get_spriteindex);
		GMLspeak.interface.exposeFunction("sprite_arrposition", sprite_arrposition);
		GMLspeak.interface.exposeFunction("in_water", in_water);
        GMLspeak.interface.exposeFunction("give_lives", give_lives);
		
		GMLspeak.interface.exposeFunction("player_movement_sonic", player_movement_sonic);
		GMLspeak.interface.exposeFunction("player_movement", player_movement);
		GMLspeak.interface.exposeFunction("player_poly_collision", player_poly_collision);
		GMLspeak.interface.exposeFunction("player_collision", player_collision);
		GMLspeak.interface.exposeFunction("player_slide", player_slide);
		GMLspeak.interface.exposeFunction("player_slide_sonic", player_slide_sonic);
		GMLspeak.interface.exposeFunction("player_interactions", player_interactions);
        GMLspeak.interface.exposeFunction("basic_step_move", basic_step_move);
		GMLspeak.interface.exposeFunction("post_wall", post_wall);
        GMLspeak.interface.exposeFunction("player_grab", player_grab);
		GMLspeak.interface.exposeFunction("finish_death", finish_death);
		GMLspeak.interface.exposeFunction("hit_block", hit_block);
		GMLspeak.interface.exposeFunction("make_particle", make_particle);
		
		GMLspeak.interface.exposeFunction("component_common_timer_values", component_common_timer_values);
		GMLspeak.interface.exposeFunction("component_get_ground_friction", component_get_ground_friction);
		GMLspeak.interface.exposeFunction("component_gravity_coneyor", component_gravity_coneyor);
		GMLspeak.interface.exposeFunction("component_mario_crouch", component_mario_crouch);
		GMLspeak.interface.exposeFunction("component_mario_skid", component_mario_skid);
		GMLspeak.interface.exposeFunction("component_mario_skidding_fx", component_mario_skidding_fx);
		GMLspeak.interface.exposeFunction("component_mario_start_groundpound", component_mario_start_groundpound);
		GMLspeak.interface.exposeFunction("component_sonic_roll", component_sonic_roll);
		GMLspeak.interface.exposeFunction("component_sonic_spindash", component_sonic_spindash);
		GMLspeak.interface.exposeFunction("component_sonic_start_spindash", component_sonic_start_spindash);
		
		GMLspeak.interface.exposeFunction("component_sonic_start_jump", component_sonic_start_jump);
		GMLspeak.interface.exposeFunction("component_mario_groundpound", component_mario_groundpound);
		GMLspeak.interface.exposeFunction("component_mario_start_dive", component_mario_start_dive);
		//GMLspeak.interface.exposeFunction("component_mario_start_jump", component_mario_start_jump);
		GMLspeak.interface.exposeFunction("component_mario_start_spinjump", component_mario_start_spinjump);
		GMLspeak.interface.exposeFunction("component_mario_wallslide", component_mario_wallslide);

		GMLspeak.interface.exposeFunction("playsfx", playsfx);
		GMLspeak.interface.exposeFunction("stopsfx", stopsfx);
		GMLspeak.interface.exposeFunction("VinylPlay", VinylPlay);
		GMLspeak.interface.exposeFunction("VinylStop", VinylStop);
	#endregion

	#region Input
		GMLspeak.interface.exposeFunction("input_check_pressed", input_check_pressed);
		GMLspeak.interface.exposeFunction("input_check", input_check);
		GMLspeak.interface.exposeFunction("input_check_released", input_check_released);
	#endregion
	
	#region Signals
		GMLspeak.interface.exposeFunction("signal_emit", function(signal, type, code_id=charmName) { signal.Emit(type, code_id) });
		GMLspeak.interface.exposeFunction("signal_create", signal_create);
	#endregion

#endregion

//// Charm Loading ////
#region Charm Loading
	_charmList = []; //Names of all charmsa
	var _chCharm = file_find_first($"{working_directory}\\_vanilla\\character\\*", fa_directory);
	var _chIndex = 0;

	// Find/load all the charms
	if (_chCharm != "" && _chCharm != "<null>")
	{
		while(_chCharm != "" && _chCharm != "<null>")
		{
			array_push(_charmList,_chCharm);
			_chCharm  = file_find_next();
			_chIndex++;
		}
	}
#endregion

show_debug_message($"The {_charmList}: WE AGREE!");

//// Level Loading ////
global.levellist=0;
global.sounds=ds_map_create();
load_levels();
global.zoom_on_start = false; // does this level have the starting zoom-in?

//// General data ////
global._playerChars = [];

//global.touchscreen = 1
global.touchscreen = os_android