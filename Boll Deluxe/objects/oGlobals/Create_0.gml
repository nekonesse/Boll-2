#macro gametitle "Boll 2"
#macro version "0.1"

windowfocused=true;

global.save_dir=""

global.smallBoldFont=font_add_sprite_ext(spr_smallboldfont,"0123456789abcdefghijklmnopqrstuvwxyz,.'"+chr(34)+":;/"+chr(92)+"[]><*!?_-=+{}#$@%^&|`~",true,1)
ScribblejrAttachSpritefont(global.smallBoldFont,true,1)
global.omiFont=font_add_sprite_ext(spr_omifont,"0123456789:;.,<=>}%/"+chr(92)+"-_!?*+#'"+chr(34)+"~@][&abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ",true,1)
ScribblejrAttachSpritefont(global.omiFont,true,1)
global.rulerGold=font_add_sprite_ext(spr_rulergold,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!?.,:;<>'"+chr(34)+"@#$%^&*(){}[]/|"+chr(92)+"_-=+`~ ",true,1)
ScribblejrAttachSpritefont(global.rulerGold,true,1)
global.matosseFont = font_add_sprite_ext(spr_matossefont,"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!?&.,;:()"+chr(34)+"'/abcdefghijklmnopqrstuvwxyz",true,0)
ScribblejrAttachSpritefont(global.matosseFont,true,1)
global.titlesmallFont = font_add_sprite_ext(spr_titlesmallfont,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",true,0)
ScribblejrAttachSpritefont(global.matosseFont,true,1)
global.titlebigFont = font_add_sprite_ext(spr_titlebigfont,"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!?()-/&:.,'",true,0)
ScribblejrAttachSpritefont(global.matosseFont,true,1)
global.titlelivesFont = font_add_sprite_ext(spr_livesfont,"x1234567890",true,0)
ScribblejrAttachSpritefont(global.titlelivesFont,true,1)

global.debug = false;
global.show_collision = false;
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

#region GMLspeak
	
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
	#endregion
	
	#region Custom Functions
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
		GMLspeak.interface.exposeFunction("increase_combo", increase_combo);
		
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
		
		GMLspeak.interface.exposeDynamicConstant("GAME", function() {return instance_find(oGameManager, 0)})
	#endregion

	#region Input
		GMLspeak.interface.exposeFunction("input_check_pressed", input_check_pressed);
		GMLspeak.interface.exposeFunction("input_check", input_check);
		GMLspeak.interface.exposeFunction("input_check_released", input_check_released);
		GMLspeak.interface.exposeFunction("input_is_analogue", input_is_analogue);
		GMLspeak.interface.exposeFunction("input_value", input_value);
		GMLspeak.interface.exposeFunction("input_direction", input_direction);
		GMLspeak.interface.exposeFunction("input_distance", input_distance);
		GMLspeak.interface.exposeFunction("input_radial_sector", input_radial_sector);
		GMLspeak.interface.exposeFunction("input_x", input_x);
		GMLspeak.interface.exposeFunction("input_y", input_y);
		GMLspeak.interface.exposeFunction("input_xy", input_xy);
		GMLspeak.interface.exposeFunction("input_keyboard_check", input_keyboard_check);
		GMLspeak.interface.exposeFunction("input_keyboard_check_pressed", input_keyboard_check_pressed);
		GMLspeak.interface.exposeFunction("input_keyboard_check_released", input_keyboard_check_released);
		GMLspeak.interface.exposeFunction("input_gamepad_check", input_gamepad_check);
		GMLspeak.interface.exposeFunction("input_gamepad_check_pressed", input_gamepad_check_pressed);
		GMLspeak.interface.exposeFunction("input_gamepad_check_released", input_gamepad_check_released);
		GMLspeak.interface.exposeFunction("input_gamepad_value", input_gamepad_value);
	#endregion
	
	#region Vinyl
		GMLspeak.interface.exposeFunction("VinylCallbackOnStop", VinylCallbackOnStop);
		GMLspeak.interface.exposeFunction("VinylFadeOut", VinylFadeOut);
		GMLspeak.interface.exposeFunction("VinylGetLoop", VinylGetLoop);
		GMLspeak.interface.exposeFunction("VinylIsPaused", VinylIsPaused);
		GMLspeak.interface.exposeFunction("VinylIsPlaying", VinylIsPlaying);
		GMLspeak.interface.exposeFunction("VinylPlay", VinylPlay);
		GMLspeak.interface.exposeFunction("VinylPlayFadeIn", VinylPlayFadeIn);
		GMLspeak.interface.exposeFunction("VinylPlayOn", VinylPlayOn);
		GMLspeak.interface.exposeFunction("VinylResume", VinylResume);
		GMLspeak.interface.exposeFunction("VinylSetLoop", VinylSetLoop);
		GMLspeak.interface.exposeFunction("VinylSetPause", VinylSetPause);
		GMLspeak.interface.exposeFunction("VinylStop", VinylStop);
		GMLspeak.interface.exposeFunction("VinylStopAll", VinylStopAll);
		GMLspeak.interface.exposeFunction("VinylWillStop", VinylWillStop);
		GMLspeak.interface.exposeFunction("VinylSetupSound", VinylSetupSound);
		GMLspeak.interface.exposeFunction("VinylSetupExternal", VinylSetupExternal);
		GMLspeak.interface.exposeFunction("VinylUnloadExternal", VinylUnloadExternal);
		
		GMLspeak.interface.exposeConstant("VINYL_DEFAULT_FADE_IN_RATE", VINYL_DEFAULT_FADE_IN_RATE);
		GMLspeak.interface.exposeConstant("VINYL_DEFAULT_FADE_OUT_RATE", VINYL_DEFAULT_FADE_OUT_RATE);
		GMLspeak.interface.exposeConstant("VINYL_DEFAULT_MIX", VINYL_DEFAULT_MIX);
		GMLspeak.interface.exposeConstant("VINYL_NO_MIX", VINYL_NO_MIX);
	#endregion

	#region Scribble & Scribble Jr
		GMLspeak.interface.exposeFunction("ScribblejrAttachSpritefont", ScribblejrAttachSpritefont);
		GMLspeak.interface.exposeFunction("ScribblejrCacheFontInfo", ScribblejrCacheFontInfo);
		GMLspeak.interface.exposeFunction("ScribblejrGetDefaultFont", ScribblejrGetDefaultFont);
		GMLspeak.interface.exposeFunction("ScribblejrSetDefaultFont", ScribblejrSetDefaultFont);
		GMLspeak.interface.exposeFunction("ScribblejrAddColor", ScribblejrAddColor);
		GMLspeak.interface.exposeFunction("ScribblejrDeleteColor", ScribblejrDeleteColor);
		GMLspeak.interface.exposeFunction("ScribblejrGetColor", ScribblejrGetColor);
		GMLspeak.interface.exposeFunction("ScribblejrGetCharacterWrap", ScribblejrGetCharacterWrap);
		GMLspeak.interface.exposeFunction("ScribblejrSetCharacterWrap", ScribblejrSetCharacterWrap);
		GMLspeak.interface.exposeFunction("Scribblejr", Scribblejr);
		GMLspeak.interface.exposeFunction("ScribblejrDrawNative", ScribblejrDrawNative);
		GMLspeak.interface.exposeFunction("ScribblejrExt", ScribblejrExt);
		GMLspeak.interface.exposeFunction("ScribblejrFit", ScribblejrFit);
		GMLspeak.interface.exposeFunction("ScribblejrFitExt", ScribblejrFitExt);
		GMLspeak.interface.exposeFunction("ScribblejrResetDrawState", ScribblejrResetDrawState);
		GMLspeak.interface.exposeFunction("ScribblejrShrink", ScribblejrShrink);
		GMLspeak.interface.exposeFunction("ScribblejrShrinkExt", ScribblejrShrinkExt);
		
		GMLspeak.interface.exposeFunction("scribble", scribble);
		GMLspeak.interface.exposeFunction("scribble_typist", scribble_typist);
		GMLspeak.interface.exposeFunction("scribble_anim_blink", scribble_anim_blink);
		GMLspeak.interface.exposeFunction("scribble_anim_cycle", scribble_anim_cycle);
		GMLspeak.interface.exposeFunction("scribble_anim_disabled", scribble_anim_disabled);
		GMLspeak.interface.exposeFunction("scribble_anim_get_disabled", scribble_anim_get_disabled);
		GMLspeak.interface.exposeFunction("scribble_anim_jitter", scribble_anim_jitter);
		GMLspeak.interface.exposeFunction("scribble_anim_pulse", scribble_anim_pulse);
		GMLspeak.interface.exposeFunction("scribble_anim_rainbow", scribble_anim_rainbow);
		GMLspeak.interface.exposeFunction("scribble_anim_reset", scribble_anim_reset);
		GMLspeak.interface.exposeFunction("scribble_anim_shake", scribble_anim_shake);
		GMLspeak.interface.exposeFunction("scribble_anim_wave", scribble_anim_wave);
		GMLspeak.interface.exposeFunction("scribble_anim_wheel", scribble_anim_wheel);
		GMLspeak.interface.exposeFunction("scribble_anim_wobble", scribble_anim_wobble);
		GMLspeak.interface.exposeFunction("scribble_color_get", scribble_color_get);
		GMLspeak.interface.exposeFunction("scribble_color_set", scribble_color_set);
		GMLspeak.interface.exposeFunction("scribble_external_sound_add", scribble_external_sound_add);
		GMLspeak.interface.exposeFunction("scribble_external_sound_exists", scribble_external_sound_exists);
		GMLspeak.interface.exposeFunction("scribble_external_sound_remove", scribble_external_sound_remove);
		GMLspeak.interface.exposeFunction("scribble_font_bake_outline_and_shadow", scribble_font_bake_outline_and_shadow);
		GMLspeak.interface.exposeFunction("scribble_font_bake_shader", scribble_font_bake_shader);
		GMLspeak.interface.exposeFunction("scribble_font_delete", scribble_font_delete);
		GMLspeak.interface.exposeFunction("scribble_font_duplicate", scribble_font_duplicate);
		GMLspeak.interface.exposeFunction("scribble_font_exists", scribble_font_exists);
		GMLspeak.interface.exposeFunction("scribble_font_get_default", scribble_font_get_default);
		GMLspeak.interface.exposeFunction("scribble_font_get_glyph_ranges", scribble_font_get_glyph_ranges);
		GMLspeak.interface.exposeFunction("scribble_font_has_character", scribble_font_has_character);
		GMLspeak.interface.exposeFunction("scribble_font_rename", scribble_font_rename);
		GMLspeak.interface.exposeFunction("scribble_font_scale", scribble_font_scale);
		GMLspeak.interface.exposeFunction("scribble_font_set_default", scribble_font_set_default);
		GMLspeak.interface.exposeFunction("scribble_font_set_halign_offset", scribble_font_set_halign_offset);
		GMLspeak.interface.exposeFunction("scribble_font_set_style_family", scribble_font_set_style_family);
		GMLspeak.interface.exposeFunction("scribble_font_set_valign_offset", scribble_font_set_valign_offset);
		GMLspeak.interface.exposeFunction("scribble_glyph_get", scribble_glyph_get);
		GMLspeak.interface.exposeFunction("scribble_glyph_set", scribble_glyph_set);
		GMLspeak.interface.exposeFunction("scribble_kerning_pair_get", scribble_kerning_pair_get);
		GMLspeak.interface.exposeFunction("scribble_kerning_pair_set", scribble_kerning_pair_set);
		GMLspeak.interface.exposeFunction("draw_text_scribble", draw_text_scribble);
		GMLspeak.interface.exposeFunction("draw_text_scribble_ext", draw_text_scribble_ext);
		GMLspeak.interface.exposeFunction("string_height_scribble", string_height_scribble);
		GMLspeak.interface.exposeFunction("string_height_scribble_ext", string_height_scribble_ext);
		GMLspeak.interface.exposeFunction("string_length_scribble", string_length_scribble);
		GMLspeak.interface.exposeFunction("string_width_scribble", string_width_scribble);
		GMLspeak.interface.exposeFunction("draw_text_scribble", draw_text_scribble);
		GMLspeak.interface.exposeFunction("string_width_scribble_ext", string_width_scribble_ext);
		GMLspeak.interface.exposeFunction("scribble_whitelist_sound", scribble_whitelist_sound);
		GMLspeak.interface.exposeFunction("scribble_whitelist_sprite", scribble_whitelist_sprite);
		
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_NONE", SCRIBBLE_EASE.NONE);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_LINEAR", SCRIBBLE_EASE.LINEAR);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_QUAD", SCRIBBLE_EASE.QUAD);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_CUBIC", SCRIBBLE_EASE.CUBIC);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_QUART", SCRIBBLE_EASE.QUART);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_QUINT", SCRIBBLE_EASE.QUINT);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_SINE", SCRIBBLE_EASE.SINE);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_EXPO", SCRIBBLE_EASE.EXPO);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_CIRC", SCRIBBLE_EASE.CIRC);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_BACK", SCRIBBLE_EASE.BACK);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_ELASTIC", SCRIBBLE_EASE.ELASTIC);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_BOUNCE", SCRIBBLE_EASE.BOUNCE);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_CUSTOM_1", SCRIBBLE_EASE.CUSTOM_1);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_CUSTOM_2", SCRIBBLE_EASE.CUSTOM_2);
		GMLspeak.interface.exposeConstant("SCRIBBLE_EASE_CUSTOM_3", SCRIBBLE_EASE.CUSTOM_3);
		
		GMLspeak.interface.exposeConstant("SCRIBBLE_OUTLINE_NO_OUTLINE", SCRIBBLE_OUTLINE.NO_OUTLINE);
		GMLspeak.interface.exposeConstant("SCRIBBLE_OUTLINE_FOUR_DIR", SCRIBBLE_OUTLINE.FOUR_DIR);
		GMLspeak.interface.exposeConstant("SCRIBBLE_OUTLINE_EIGHT_DIR", SCRIBBLE_OUTLINE.EIGHT_DIR);
		GMLspeak.interface.exposeConstant("SCRIBBLE_OUTLINE_EIGHT_DIR_THICK", SCRIBBLE_OUTLINE.EIGHT_DIR_THICK);
	#endregion
	
	#region Collage
		GMLspeak.interface.exposeFunction("CollageDrawImage", CollageDrawImage);
		GMLspeak.interface.exposeFunction("CollageDrawImageExt", CollageDrawImageExt);
		GMLspeak.interface.exposeFunction("CollageDrawImageGeneral", CollageDrawImageGeneral);
		GMLspeak.interface.exposeFunction("CollageDrawImagePart", CollageDrawImagePart);
		GMLspeak.interface.exposeFunction("CollageDrawImagePartExt", CollageDrawImagePartExt);
		GMLspeak.interface.exposeFunction("CollageDrawImageStretched", CollageDrawImageStretched);
		GMLspeak.interface.exposeFunction("CollageDrawImageStretchedExt", CollageDrawImageStretchedExt);
		GMLspeak.interface.exposeFunction("CollageDrawImageTiled", CollageDrawImageTiled);
		GMLspeak.interface.exposeFunction("CollageDrawImageTiledExt", CollageDrawImageTiledExt);
		GMLspeak.interface.exposeFunction("CollageGet", CollageGet);
		GMLspeak.interface.exposeFunction("CollageGetImageSurface", CollageGetImageSurface);
		GMLspeak.interface.exposeFunction("CollageGetImageTexture", CollageGetImageTexture);
		GMLspeak.interface.exposeFunction("CollageGetImageTexturePage", CollageGetImageTexturePage);
		GMLspeak.interface.exposeFunction("CollageGetImageUVs", CollageGetImageUVs);
		GMLspeak.interface.exposeFunction("CollageImageExists", CollageImageExists);
		GMLspeak.interface.exposeFunction("CollageImageGetInfo", CollageImageGetInfo);
		GMLspeak.interface.exposeFunction("CollageImageGetUVsArray", CollageImageGetUVsArray);
		GMLspeak.interface.exposeFunction("CollageImageIsLoaded", CollageImageIsLoaded);
		GMLspeak.interface.exposeFunction("CollageImageLoad", CollageImageLoad);
		GMLspeak.interface.exposeFunction("CollageImagesNamesToArray", CollageImagesNamesToArray);
		GMLspeak.interface.exposeFunction("CollageImageGetSurface", CollageImageGetSurface);
		GMLspeak.interface.exposeFunction("CollageImageGetTexture", CollageImageGetTexture);
		GMLspeak.interface.exposeFunction("CollageImageGetTexturePage", CollageImageGetTexturePage);
		GMLspeak.interface.exposeFunction("CollageImageGetUVs", CollageImageGetUVs);
		GMLspeak.interface.exposeFunction("Collage", Collage);
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

//// Level Loading ////
global.levellist=0;
global.sounds=ds_map_create();
load_levels();
global.zoom_on_start = false; // does this level have the starting zoom-in?

//// General data ////
global._playerChars = [];


//global.touchscreen = 1
global.touchscreen = os_android