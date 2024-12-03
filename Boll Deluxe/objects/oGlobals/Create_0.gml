#macro gametitle "Boll Deluxe"
#macro version "2.2"

global.save_dir=""

global.smallBoldFont=font_add_sprite_ext(spr_smallboldfont,"0123456789abcdefghijklmnopqrstuvwxyz,.'"+chr(34)+":;/"+chr(92)+"[]><*!?_-=+{}#$@%^&|`~",true,1)

global.debug=0
global.netgame = false; // top 10 boll deluxe things that will never happen:
global.nextlevel = "\save.jade"
global.jade_testing = false; // whether the current level is being tested in JADE or not

if !(instance_exists(input_controller_object)) instance_create_depth(0,0,16001,input_controller_object)

//// TXR SETUP!!! ////
#region TXR
	txr_init(); //TXR starting
	
	#region Constants
		txr_constant_add("COL_WALL",COL_WALL)
		txr_constant_add("COL_BOTTOM",COL_BOTTOM)
		txr_constant_add("COL_TOP",COL_TOP)
		txr_constant_add("COL_LINE",COL_LINE)
		txr_constant_add("COL_DOT",COL_DOT)
		txr_constant_add("CAM_SENSOR_WIDTH",CAM_SENSOR_WIDTH)
		txr_constant_add("CAM_SENSOR_HEIGHT",CAM_SENSOR_HEIGHT)
		txr_constant_add("CAM_ZOOM_TIME",CAM_ZOOM_TIME)
		txr_constant_add("CAM_ZOOM_RATE",CAM_ZOOM_RATE)
		//Objects
		txr_constant_add("oCollider",oCollider)
		txr_constant_add("oSemilider",oSemilider)
		txr_constant_add("oPolyCollider",oPolyCollider)
		txr_constant_add("oSlopeCollider",oSlopeCollider)
		txr_constant_add("oSemiSlope",oSemiSlope)
		txr_constant_add("oHittable",oHittable)
		txr_constant_add("oGrate",oGrate)
		txr_constant_add("oGrateSemi",oGrateSemi)
		txr_constant_add("oEnemyGround",oEnemyGround)
		txr_constant_add("oEnemyGroundSemi",oEnemyGroundSemi)
		txr_constant_add("oFlipblock",oFlipblock)
		txr_constant_add("oItemBox",oItemBox)
		txr_constant_add("oBrick",oBrick)
		txr_constant_add("oShootBlock",oShootBlock)
		txr_constant_add("oDonutBlock",oDonutBlock)
		txr_constant_add("oHardBlock",oHardBlock)
		txr_constant_add("oPipe",oPipe)
		txr_constant_add("oMovingPlatform",oMovingPlatform)
		txr_constant_add("oSwingingPlatform",oSwingingPlatform)
		txr_constant_add("oChainsaw",oChainsaw)
		txr_constant_add("oBillBlaster",oBillBlaster)
		txr_constant_add("oBanzaiBlaster",oBanzaiBlaster)
		txr_constant_add("oSoccerBall",oSoccerBall)
		txr_constant_add("oTerrainSpring",oTerrainSpring)
		txr_constant_add("oTerrainSprong",oTerrainSprong)
		txr_constant_add("oTerrainSpreng",oTerrainSpreng)
		txr_constant_add("oYellowSwitch",oYellowSwitch)
		txr_constant_add("oYellowSwitchBlock",oYellowSwitchBlock)
		txr_constant_add("oYellowSwitchBlockOff",oYellowSwitchBlockOff)
		txr_constant_add("oYellowSwitchSlope",oYellowSwitchSlope)
		txr_constant_add("oCyanSwitch",oCyanSwitch)
		txr_constant_add("oCyanSwitchBlock",oCyanSwitchBlock)
		txr_constant_add("oCyanSwitchBlockOff",oCyanSwitchBlockOff)
		txr_constant_add("oCyanSwitchSlope",oCyanSwitchSlope)
		txr_constant_add("oMagentaSwitch",oMagentaSwitch)
		txr_constant_add("oMagentaSwitchBlock",oMagentaSwitchBlock)
		txr_constant_add("oMagentaSwitchBlockOff",oMagentaSwitchBlockOff)
		txr_constant_add("oMagentaSwitchSlope",oMagentaSwitchSlope)
		txr_constant_add("oMushroom",oMushroom)
		txr_constant_add("oFireFlower",oFireFlower)
		txr_constant_add("oThunderFlower",oThunderFlower)
		txr_constant_add("oCoin",oCoin)
		txr_constant_add("oMysteryOrb",oMysteryOrb)
		
		//Enemies
		txr_constant_add("oEnemy",oEnemy)
		txr_constant_add("oGoomba",oGoomba)
		txr_constant_add("oGoombrat",oGoombrat)
		txr_constant_add("oKoopa",oKoopa)
		txr_constant_add("oKoopaRed",oKoopaRed)
		txr_constant_add("oKoopaYellow",oKoopaYellow)
		txr_constant_add("oPiranhaPlant",oPiranhaPlant)
		txr_constant_add("oBulletBill",oBulletBill)
		txr_constant_add("oBanzaiBill",oBanzaiBill)
		txr_constant_add("oLargeSamba",oLargeSamba)
		txr_constant_add("oPylom",oPylom)
		txr_constant_add("oThwomp",oThwomp)
		
		//Projectiles
		txr_constant_add("oFireball",oFireball)
		
		//Control
		txr_constant_add("oPlayer",oPlayer)
		txr_constant_add("oGlobals",oGlobals)
		txr_constant_add("oBackgroundManager",oBackgroundManager)
		txr_constant_add("oGameManager",oGameManager)
		txr_constant_add("oCamera",oCamera)
		txr_constant_add("oCameraRegion",oCameraRegion)
		txr_constant_add("oCameraBoundary",oCameraBoundary)
		
		//Particles
		txr_constant_add("pSmoke",pSmoke)
		txr_constant_add("pRunDust",pRunDust)
		txr_constant_add("pJumpDust",pJumpDust)
		txr_constant_add("pCoinCollected",pCoinCollected)
		txr_constant_add("pGlitter",pGlitter)
		txr_constant_add("pSparkles1UP",pSparkles1UP)
		txr_constant_add("p1UP",p1UP)
		txr_constant_add("pFireballExplosion",pFireballExplosion)
		txr_constant_add("pFireballTrail",pFireballTrail)
		txr_constant_add("pImpact",pImpact)
	#endregion
	
	#region Type
	    txr_function_add("is_string", is_string, -1);
	    txr_function_add("is_real", is_real, -1);
	    txr_function_add("is_numeric", is_numeric, -1);
	    txr_function_add("is_bool", is_bool, -1);
	    txr_function_add("is_array", is_array, -1);
	    txr_function_add("is_struct", is_struct, -1);
	    txr_function_add("is_method", is_method, -1);
	    txr_function_add("is_callable", is_callable, -1);
	    txr_function_add("is_ptr", is_ptr, -1);
	    txr_function_add("is_int32", is_int32, -1);
	    txr_function_add("is_int64", is_int64, -1);
	    txr_function_add("is_undefined", is_undefined, -1);
	    txr_function_add("is_nan", is_nan, -1);
	    txr_function_add("is_infinity", is_infinity, -1);
	    txr_function_add("typeof", typeof, -1);
	    txr_function_add("bool", bool, -1);
	    txr_function_add("ptr", ptr, -1);
	    txr_function_add("int64", int64, -1);
	    txr_function_add("string", string, -1);
	    txr_function_add("real", real, -1);
	#endregion
	
	#region Array
	    txr_function_add("array_create", array_create, -1);
	    txr_function_add("array_copy", array_copy, -1);
	    txr_function_add("array_equals", array_equals, -1);
	    txr_function_add("array_get", array_get, -1);
	    txr_function_add("array_set", array_set, -1);
	    txr_function_add("array_push", array_push, -1);
	    txr_function_add("array_pop", array_pop, -1);
	    txr_function_add("array_shift", array_shift, -1);
	    txr_function_add("array_insert", array_insert, -1);
	    txr_function_add("array_delete", array_delete, -1);
	    txr_function_add("array_get_index", array_get_index, -1);
	    txr_function_add("array_contains", array_contains, -1);
	    txr_function_add("array_contains_ext", array_contains_ext, -1);
	    txr_function_add("array_sort", array_sort, -1);
	    txr_function_add("array_reverse", array_reverse, -1);
	    txr_function_add("array_shuffle", array_shuffle, -1);
	    txr_function_add("array_length", array_length, -1);
	    txr_function_add("array_resize", array_resize, -1);
	    txr_function_add("array_first", array_first, -1);
	    txr_function_add("array_last", array_last, -1);
	    txr_function_add("array_find_index", array_find_index, -1);
	    txr_function_add("array_any", array_any, -1);
	    txr_function_add("array_all", array_all, -1);
	    txr_function_add("array_foreach", array_foreach, -1);
	    txr_function_add("array_reduce", array_reduce, -1);
	    txr_function_add("array_concat", array_concat, -1);
	    txr_function_add("array_union", array_union, -1);
	    txr_function_add("array_intersection", array_intersection, -1);
	    txr_function_add("array_filter", array_filter, -1);
	    txr_function_add("array_map", array_map, -1);
	    txr_function_add("array_unique", array_unique, -1);
	    txr_function_add("array_copy_while", array_copy_while, -1);
	    txr_function_add("array_create_ext", array_create_ext, -1);
	    txr_function_add("array_filter_ext", array_filter_ext, -1);
	    txr_function_add("array_map_ext", array_map_ext, -1);
	    txr_function_add("array_unique_ext", array_unique_ext, -1);
	    txr_function_add("array_reverse_ext", array_reverse_ext, -1);
	    txr_function_add("array_shuffle_ext", array_shuffle_ext, -1);
	#endregion
	
	#region Struct
	    txr_function_add("struct_exists", variable_struct_exists, -1);
	    txr_function_add("struct_get", variable_struct_get, -1);
	    txr_function_add("struct_set", variable_struct_set, -1);
	    txr_function_add("struct_remove", variable_struct_remove, -1);
	    txr_function_add("struct_get_names", variable_struct_get_names, -1);
	    txr_function_add("struct_names_count", variable_struct_names_count, -1);
	    txr_function_add("is_instanceof", is_instanceof, -1);
	    txr_function_add("instanceof", instanceof, -1);
	    txr_function_add("struct_foreach", struct_foreach, -1);
	#endregion
	
	#region String
	    txr_function_add("ansi_char", ansi_char, -1);
	    txr_function_add("chr", chr, -1);
	    txr_function_add("ord", ord, -1);
	    txr_function_add("string_byte_at", string_byte_at, -1);
	    txr_function_add("string_byte_length", string_byte_length, -1);
	    txr_function_add("string_set_byte_at", string_set_byte_at, -1);
	    txr_function_add("string_char_at", string_char_at, -1);
	    txr_function_add("string_ord_at", string_ord_at, -1);
	    txr_function_add("string_length", string_length, -1);
	    txr_function_add("string_pos", string_pos, -1);
	    txr_function_add("string_pos_ext", string_pos_ext, -1);
	    txr_function_add("string_last_pos", string_last_pos, -1);
	    txr_function_add("string_last_pos_ext", string_last_pos_ext, -1);
	    txr_function_add("string_starts_with", string_starts_with, -1);
	    txr_function_add("string_ends_with", string_ends_with, -1);
	    txr_function_add("string_count", string_count, -1);
	    txr_function_add("string_copy", string_copy, -1);
	    txr_function_add("string_delete", string_delete, -1);
	    txr_function_add("string_digits", string_digits, -1);
	    txr_function_add("string_format", string_format, -1);
	    txr_function_add("string_insert", string_insert, -1);
	    txr_function_add("string_letters", string_letters, -1);
	    txr_function_add("string_lettersdigits", string_lettersdigits, -1);
	    txr_function_add("string_lower", string_lower, -1);
	    txr_function_add("string_repeat", string_repeat, -1);
	    txr_function_add("string_replace", string_replace, -1);
	    txr_function_add("string_replace_all", string_replace_all, -1);
	    txr_function_add("string_upper", string_upper, -1);
	    txr_function_add("string_hash_to_newline", string_hash_to_newline, -1);
	    txr_function_add("string_trim", string_trim, -1);
	    txr_function_add("string_trim_start", string_trim_start, -1);
	    txr_function_add("string_trim_end", string_trim_end, -1);
	    txr_function_add("string_split", string_split, -1);
	    txr_function_add("string_split_ext", string_split_ext, -1);
	    txr_function_add("string_join", string_join, -1);
	    txr_function_add("string_join_ext", string_join_ext, -1);
	    txr_function_add("string_concat", string_concat, -1);
	    txr_function_add("string_concat_ext", string_concat_ext, -1);
	    txr_function_add("string_width", string_width, -1);
	    txr_function_add("string_width_ext", string_width_ext, -1);
	    txr_function_add("string_height", string_height, -1);
	    txr_function_add("string_height_ext", string_height_ext, -1);
	    txr_function_add("string_foreach", string_foreach, -1);
		//txr_function_add("string_width_scribble", string_width_scribble, -1);
		//txr_function_add("string_height_scribble", string_height_scribble, -1);
		//txr_function_add("scribble_typist", scribble_typist, -1);
	#endregion

	#region Math
	    txr_function_add("round", round, -1);
	    txr_function_add("frac", frac, -1);
	    txr_function_add("abs", abs, -1);
	    txr_function_add("sign", sign, -1);
	    txr_function_add("floor", floor, -1);
	    txr_function_add("ceil", ceil, -1);
	    txr_function_add("min", min, -1);
	    txr_function_add("max", max, -1);
	    txr_function_add("mean", mean, -1);
	    txr_function_add("median", median, -1);
	    txr_function_add("lerp", lerp, -1);
	    txr_function_add("clamp", clamp, -1);
	    txr_function_add("exp", exp, -1);
	    txr_function_add("ln", ln, -1);
	    txr_function_add("power", power, -1);
	    txr_function_add("sqr", sqr, -1);
	    txr_function_add("sqrt", sqrt, -1);
	    txr_function_add("log2", log2, -1);
	    txr_function_add("log10", log10, -1);
	    txr_function_add("logn", logn, -1);
	    txr_function_add("arccos", arccos, -1);
	    txr_function_add("arcsin", arcsin, -1);
	    txr_function_add("arctan", arctan, -1);
	    txr_function_add("arctan2", arctan2, -1);
	    txr_function_add("cos", cos, -1);
	    txr_function_add("sin", sin, -1);
	    txr_function_add("tan", tan, -1);
	    txr_function_add("dcos", dcos, -1);
	    txr_function_add("dsin", dsin, -1);
	    txr_function_add("dtan", dtan, -1);
	    txr_function_add("darccos", darccos, -1);
	    txr_function_add("darcsin", darcsin, -1);
	    txr_function_add("darctan", darctan, -1);
	    txr_function_add("darctan2", darctan2, -1);
	    txr_function_add("degtorad", degtorad, -1);
	    txr_function_add("radtodeg", radtodeg, -1);
	    txr_function_add("point_direction", point_direction, -1);
	    txr_function_add("point_distance", point_distance, -1);
	    txr_function_add("distance_to_object", distance_to_object, -1);
	    txr_function_add("distance_to_point", distance_to_point, -1);
	    txr_function_add("dot_product", dot_product, -1);
	    txr_function_add("dot_product_normalised", dot_product_normalised, -1);
		txr_function_add("dot_product_normalized", dot_product_normalized, -1);
	    txr_function_add("angle_difference", angle_difference, -1);
	    txr_function_add("lengthdir_x", lengthdir_x, -1);
	    txr_function_add("lengthdir_y", lengthdir_y, -1);
		
		txr_constant_add("pi", pi);
	#endregion
	
	#region Math 3D
	    txr_function_add("point_distance_3d", point_distance_3d, -1);
	    txr_function_add("dot_product_3d", dot_product_3d, -1);
	    txr_function_add("dot_product_3d_normalised", dot_product_3d_normalised, -1);
		txr_function_add("dot_product_3d_normalized", dot_product_3d_normalized, -1);
	    txr_function_add("matrix_build", matrix_build, -1);
	    txr_function_add("matrix_multiply", matrix_multiply, -1);
	    txr_function_add("matrix_build_identity", matrix_build_identity, -1);
	    txr_function_add("matrix_build_lookat", matrix_build_lookat, -1);
	    txr_function_add("matrix_build_projection_ortho", matrix_build_projection_ortho, -1);
	    txr_function_add("matrix_build_projection_perspective", matrix_build_projection_perspective, -1);
	    txr_function_add("matrix_build_projection_perspective_fov", matrix_build_projection_perspective_fov, -1);
	    txr_function_add("matrix_transform_vertex", matrix_transform_vertex, -1);
	#endregion
	
	#region Color
	    txr_function_add("colour_get_blue", colour_get_blue, -1);
	    txr_function_add("colour_get_green", colour_get_green, -1);
	    txr_function_add("colour_get_red", colour_get_red, -1);
	    txr_function_add("colour_get_hue", colour_get_hue, -1);
	    txr_function_add("colour_get_saturation", colour_get_saturation, -1);
	    txr_function_add("colour_get_value", colour_get_value, -1);
	    txr_function_add("make_colour_rgb", make_colour_rgb, -1);
	    txr_function_add("make_colour_hsv", make_colour_hsv, -1);
	    txr_function_add("merge_colour", merge_colour, -1);
		txr_function_add("color_get_blue", color_get_blue, -1);
	    txr_function_add("color_get_green", color_get_green, -1);
	    txr_function_add("color_get_red", color_get_red, -1);
	    txr_function_add("color_get_hue", color_get_hue, -1);
	    txr_function_add("color_get_saturation", color_get_saturation, -1);
	    txr_function_add("color_get_value", color_get_value, -1);
	    txr_function_add("make_color_rgb", make_color_rgb, -1);
	    txr_function_add("make_color_hsv", make_color_hsv, -1);
	    txr_function_add("merge_color", merge_color, -1);
	
		// CONSTANT
		txr_constant_add("c_aqua", c_aqua);
		txr_constant_add("c_black", c_black);
		txr_constant_add("c_blue", c_blue);
		txr_constant_add("c_dkgray", c_dkgray);
		txr_constant_add("c_fuchsia", c_fuchsia);
		txr_constant_add("c_grey", c_grey);
		txr_constant_add("c_green", c_green);
		txr_constant_add("c_lime", c_lime);
		txr_constant_add("c_ltgrey", c_ltgrey);
		txr_constant_add("c_maroon", c_maroon);
		txr_constant_add("c_navy", c_navy);
		txr_constant_add("c_olive", c_olive);
		txr_constant_add("c_orange", c_orange);
		txr_constant_add("c_purple", c_purple);
		txr_constant_add("c_red", c_red);
		txr_constant_add("c_silver", c_silver);
		txr_constant_add("c_teal", c_teal);
		txr_constant_add("c_white", c_white);
		txr_constant_add("c_yellow", c_yellow);
	#endregion
	
	#region Draw
		txr_function_add("gpu_set_blendmode_add", function() {gpu_set_blendmode(bm_add);}, -1);
		txr_function_add("gpu_set_blendmode_normal", function() {gpu_set_blendmode(bm_normal);}, -1);
		txr_function_add("gpu_set_blendmode_subtract", function() {gpu_set_blendmode(bm_subtract);}, -1);
		txr_function_add("gpu_set_blendmode_reverse_subtract", function() {gpu_set_blendmode(bm_reverse_subtract);}, -1);
		txr_function_add("gpu_set_blendmode_min", function() {gpu_set_blendmode(bm_min);}, -1);
		txr_function_add("gpu_set_blendmode_max", function() {gpu_set_blendmode(bm_max);}, -1);
		txr_function_add("CollageImageExists", CollageImageExists, -1);
	    txr_function_add("draw_self", draw_self, -1);
	    txr_function_add("draw_sprite", draw_sprite, -1);
	    txr_function_add("draw_sprite_pos", draw_sprite_pos, -1);
	    txr_function_add("draw_sprite_ext", draw_sprite_ext, -1);
	    txr_function_add("draw_sprite_stretched", draw_sprite_stretched, -1);
	    txr_function_add("draw_sprite_stretched_ext", draw_sprite_stretched_ext, -1);
	    txr_function_add("draw_sprite_tiled", draw_sprite_tiled, -1);
	    txr_function_add("draw_sprite_tiled_ext", draw_sprite_tiled_ext, -1);
	    txr_function_add("draw_sprite_part", draw_sprite_part, -1);
	    txr_function_add("draw_sprite_part_ext", draw_sprite_part_ext, -1);
	    txr_function_add("draw_sprite_general", draw_sprite_general, -1);
		txr_function_add("draw_image", draw_image, -1);
	    txr_function_add("draw_image_ext", draw_image_ext, -1);
	    txr_function_add("draw_image_stretched", draw_image_stretched, -1);
	    txr_function_add("draw_image_stretched_ext", draw_image_stretched_ext, -1);
	    txr_function_add("draw_image_tiled", draw_image_tiled, -1);
	    txr_function_add("draw_image_tiled_ext", draw_image_tiled_ext, -1);
	    txr_function_add("draw_image_part", draw_image_part, -1);
	    txr_function_add("draw_image_part_ext", draw_image_part_ext, -1);
	    txr_function_add("draw_image_general", draw_image_general, -1);
	    txr_function_add("draw_clear", draw_clear, -1);
	    txr_function_add("draw_clear_alpha", draw_clear_alpha, -1);
	    txr_function_add("draw_point", draw_point, -1);
	    txr_function_add("draw_line", draw_line, -1);
	    txr_function_add("draw_line_width", draw_line_width, -1);
	    txr_function_add("draw_rectangle", draw_rectangle, -1);
	    txr_function_add("draw_roundrect", draw_roundrect, -1);
	    txr_function_add("draw_roundrect_ext", draw_roundrect_ext, -1);
	    txr_function_add("draw_triangle", draw_triangle, -1);
	    txr_function_add("draw_circle", draw_circle, -1);
	    txr_function_add("draw_ellipse", draw_ellipse, -1);
	    txr_function_add("draw_set_circle_precision", draw_set_circle_precision, -1);
	    txr_function_add("draw_arrow", draw_arrow, -1);
	    txr_function_add("draw_button", draw_button, -1);
	    txr_function_add("draw_path", draw_path, -1);
	    txr_function_add("draw_healthbar", draw_healthbar, -1);
	    txr_function_add("draw_getpixel", draw_getpixel, -1);
	    txr_function_add("draw_getpixel_ext", draw_getpixel_ext, -1);
	    txr_function_add("draw_set_colour", draw_set_colour, -1);
	    txr_function_add("draw_set_color", draw_set_color, -1);
	    txr_function_add("draw_set_alpha", draw_set_alpha, -1);
	    txr_function_add("draw_get_colour", draw_get_colour, -1);
	    txr_function_add("draw_get_color", draw_get_color, -1);
	    txr_function_add("draw_get_alpha", draw_get_alpha, -1);
	    txr_function_add("draw_set_font", draw_set_font, -1);
	    txr_function_add("draw_get_font", draw_get_font, -1);
	    txr_function_add("draw_set_halign", draw_set_halign, -1);
	    txr_function_add("draw_get_halign", draw_get_halign, -1);
	    txr_function_add("draw_set_valign", draw_set_valign, -1);
	    txr_function_add("draw_get_valign", draw_get_valign, -1);
		//txr_function_add("draw_text_scribble", draw_text_scribble, -1);
	    txr_function_add("draw_text", draw_text, -1);
	    txr_function_add("draw_text_ext", draw_text_ext, -1);
	    txr_function_add("draw_text_transformed", draw_text_transformed, -1);
	    txr_function_add("draw_text_ext_transformed", draw_text_ext_transformed, -1);
	    txr_function_add("draw_text_colour", draw_text_colour, -1);
	    txr_function_add("draw_text_ext_colour", draw_text_ext_colour, -1);
	    txr_function_add("draw_text_transformed_colour", draw_text_transformed_colour, -1);
	    txr_function_add("draw_text_ext_transformed_colour", draw_text_ext_transformed_colour, -1);
	    txr_function_add("draw_text_color", draw_text_color, -1);
	    txr_function_add("draw_text_ext_color", draw_text_ext_color, -1);
	    txr_function_add("draw_text_transformed_color", draw_text_transformed_color, -1);
	    txr_function_add("draw_text_ext_transformed_color", draw_text_ext_transformed_color, -1);
	    txr_function_add("draw_point_colour", draw_point_colour, -1);
	    txr_function_add("draw_line_colour", draw_line_colour, -1);
	    txr_function_add("draw_line_width_colour", draw_line_width_colour, -1);
	    txr_function_add("draw_rectangle_colour", draw_rectangle_colour, -1);
	    txr_function_add("draw_roundrect_colour", draw_roundrect_colour, -1);
	    txr_function_add("draw_roundrect_colour_ext", draw_roundrect_colour_ext, -1);
	    txr_function_add("draw_triangle_colour", draw_triangle_colour, -1);
	    txr_function_add("draw_circle_colour", draw_circle_colour, -1);
	    txr_function_add("draw_ellipse_colour", draw_ellipse_colour, -1);
	    txr_function_add("draw_point_color", draw_point_color, -1);
	    txr_function_add("draw_line_color", draw_line_color, -1);
	    txr_function_add("draw_line_width_color", draw_line_width_color, -1);
	    txr_function_add("draw_rectangle_color", draw_rectangle_color, -1);
	    txr_function_add("draw_roundrect_color", draw_roundrect_color, -1);
	    txr_function_add("draw_roundrect_color_ext", draw_roundrect_color_ext, -1);
	    txr_function_add("draw_triangle_color", draw_triangle_color, -1);
	    txr_function_add("draw_circle_color", draw_circle_color, -1);
	    txr_function_add("draw_ellipse_color", draw_ellipse_color, -1);
	    txr_function_add("draw_primitive_begin", draw_primitive_begin, -1);
	    txr_function_add("draw_vertex", draw_vertex, -1);
	    txr_function_add("draw_vertex_colour", draw_vertex_colour, -1);
	    txr_function_add("draw_vertex_color", draw_vertex_color, -1);
	    txr_function_add("draw_primitive_end", draw_primitive_end, -1);
	    txr_function_add("draw_primitive_begin_texture", draw_primitive_begin_texture, -1);
	    txr_function_add("draw_vertex_texture", draw_vertex_texture, -1);
	    txr_function_add("draw_vertex_texture_colour", draw_vertex_texture_colour, -1);
	    txr_function_add("draw_vertex_texture_color", draw_vertex_texture_color, -1);
	    txr_function_add("draw_surface", draw_surface, -1);
	    txr_function_add("draw_surface_stretched", draw_surface_stretched, -1);
	    txr_function_add("draw_surface_tiled", draw_surface_tiled, -1);
	    txr_function_add("draw_surface_part", draw_surface_part, -1);
	    txr_function_add("draw_surface_ext", draw_surface_ext, -1);
	    txr_function_add("draw_surface_stretched_ext", draw_surface_stretched_ext, -1);
	    txr_function_add("draw_surface_tiled_ext", draw_surface_tiled_ext, -1);
	    txr_function_add("draw_surface_part_ext", draw_surface_part_ext, -1);
	    txr_function_add("draw_surface_general", draw_surface_general, -1);
	    txr_function_add("draw_enable_drawevent", draw_enable_drawevent, -1);
	    txr_function_add("draw_enable_swf_aa", draw_enable_swf_aa, -1);
	    txr_function_add("draw_set_swf_aa_level", draw_set_swf_aa_level, -1);
	    txr_function_add("draw_get_swf_aa_level", draw_get_swf_aa_level, -1);
	    txr_function_add("draw_texture_flush", draw_texture_flush, -1);
	    txr_function_add("draw_flush", draw_flush, -1);
	    txr_function_add("draw_light_define_ambient", draw_light_define_ambient, -1);
	    txr_function_add("draw_light_define_direction", draw_light_define_direction, -1);
	    txr_function_add("draw_light_define_point", draw_light_define_point, -1);
	    txr_function_add("draw_light_enable", draw_light_enable, -1);
	    txr_function_add("draw_set_lighting", draw_set_lighting, -1);
	    txr_function_add("draw_light_get_ambient", draw_light_get_ambient, -1);
	    txr_function_add("draw_light_get", draw_light_get, -1);
	    txr_function_add("draw_get_lighting", draw_get_lighting, -1);
	    txr_function_add("draw_tilemap", draw_tilemap, -1);
	    txr_function_add("draw_tile", draw_tile, -1);
		txr_function_add("draw_rect", draw_rect, -1);
	#endregion
	
	#region Vertex Buffers
	    txr_function_add("vertex_format_begin", vertex_format_begin, -1);
	    txr_function_add("vertex_format_end", vertex_format_end, -1);
	    txr_function_add("vertex_format_delete", vertex_format_delete, -1);
	    txr_function_add("vertex_format_add_position", vertex_format_add_position, -1);
	    txr_function_add("vertex_format_add_position_3d", vertex_format_add_position_3d, -1);
	    txr_function_add("vertex_format_add_colour", vertex_format_add_colour, -1);
	    txr_function_add("vertex_format_add_color", vertex_format_add_color, -1);
	    txr_function_add("vertex_format_add_normal", vertex_format_add_normal, -1);
	    txr_function_add("vertex_format_add_texcoord", vertex_format_add_texcoord, -1);
	    txr_function_add("vertex_format_add_custom", vertex_format_add_custom, -1);
	    txr_function_add("vertex_create_buffer", vertex_create_buffer, -1);
	    txr_function_add("vertex_create_buffer_ext", vertex_create_buffer_ext, -1);
	    txr_function_add("vertex_delete_buffer", vertex_delete_buffer, -1);
	    txr_function_add("vertex_begin", vertex_begin, -1);
	    txr_function_add("vertex_end", vertex_end, -1);
	    txr_function_add("vertex_position", vertex_position, -1);
	    txr_function_add("vertex_position_3d", vertex_position_3d, -1);
	    txr_function_add("vertex_colour", vertex_colour, -1);
	    txr_function_add("vertex_color", vertex_color, -1);
	    txr_function_add("vertex_argb", vertex_argb, -1);
	    txr_function_add("vertex_texcoord", vertex_texcoord, -1);
	    txr_function_add("vertex_normal", vertex_normal, -1);
	    txr_function_add("vertex_float1", vertex_float1, -1);
	    txr_function_add("vertex_float2", vertex_float2, -1);
	    txr_function_add("vertex_float3", vertex_float3, -1);
	    txr_function_add("vertex_float4", vertex_float4, -1);
	    txr_function_add("vertex_ubyte4", vertex_ubyte4, -1);
	    txr_function_add("vertex_submit", vertex_submit, -1);
	    txr_function_add("vertex_freeze", vertex_freeze, -1);
	    txr_function_add("vertex_get_number", vertex_get_number, -1);
	    txr_function_add("vertex_get_buffer_size", vertex_get_buffer_size, -1);
		
		txr_constant_add("vertex_usage_position", vertex_usage_position)
		txr_constant_add("vertex_usage_colour", vertex_usage_colour)
		txr_constant_add("vertex_usage_color", vertex_usage_color)
		txr_constant_add("vertex_usage_normal", vertex_usage_normal)
		txr_constant_add("vertex_usage_texcoord", vertex_usage_texcoord)
		txr_constant_add("vertex_usage_blendweight", vertex_usage_blendweight)
		txr_constant_add("vertex_usage_blendindices", vertex_usage_blendindices)
		txr_constant_add("vertex_usage_psize", vertex_usage_psize)
		txr_constant_add("vertex_usage_tangent", vertex_usage_tangent)
		txr_constant_add("vertex_usage_binormal", vertex_usage_binormal)
		txr_constant_add("vertex_usage_fog", vertex_usage_fog)
		txr_constant_add("vertex_usage_depth", vertex_usage_depth)
		txr_constant_add("vertex_usage_sample", vertex_usage_sample)
		txr_constant_add("vertex_type_float1", vertex_type_float1)
		txr_constant_add("vertex_type_float2", vertex_type_float2)
		txr_constant_add("vertex_type_float3", vertex_type_float3)
		txr_constant_add("vertex_type_float4", vertex_type_float4)
		txr_constant_add("vertex_type_colour", vertex_type_colour)
		txr_constant_add("vertex_type_color", vertex_type_color)
		txr_constant_add("vertex_type_ubyte4", vertex_type_ubyte4)
	#endregion
	
	#region Random
	    txr_function_add("choose", choose, -1);
	    txr_function_add("random", random, -1);
		txr_function_add("randomise", randomise, -1);
		txr_function_add("randomize", randomize, -1);
	    txr_function_add("random_range", random_range, -1);
	    txr_function_add("irandom", irandom, -1);
	    txr_function_add("irandom_range", irandom_range, -1);
	#endregion
	
	#region Assets
		txr_function_add("asset_get_index", asset_get_index, -1);
		txr_function_add("asset_get_type", asset_get_type, -1);
		txr_function_add("tag_get_asset_ids", tag_get_asset_ids, -1);
		txr_function_add("tag_get_assets", tag_get_assets, -1);
		txr_function_add("asset_get_tags", asset_get_tags, -1);
		txr_function_add("asset_add_tags", asset_add_tags, -1);
		txr_function_add("asset_remove_tags", asset_remove_tags, -1);
		txr_function_add("asset_has_tags", asset_has_tags, -1);
		txr_function_add("asset_has_any_tag", asset_has_any_tag, -1);
		txr_function_add("asset_clear_tags", asset_clear_tags, -1);
	#endregion

	#region Camera
		txr_function_add("camera_get_view_x", camera_get_view_x, -1);
		txr_function_add("camera_get_view_y", camera_get_view_y, -1);
		txr_function_add("camera_set_view_pos", camera_set_view_pos, -1);
	#endregion
	
	#region Misc
		txr_function_add("show_debug_message", show_debug_message, -1);
		txr_function_add("show_message", show_message, -1);
		txr_function_add("wave_val", wave_val, -1);
		txr_function_add("approach_val", approach_val, -1);
		txr_function_add("chance", chance, -1);
		txr_function_add("jump_in_direction", jump_in_direction, -1);
		txr_function_add("event_inherited", event_inherited, -1);
		txr_function_add("room_get_width", function() { return room_width; }, 0);
		txr_function_add("room_get_height", function() { return room_height; }, 0);
		txr_function_add("check_signs_matching", check_signs_matching, -1);
		txr_function_add("esign", esign, -1);
		txr_function_add("unreal", unreal, -1);
		txr_function_add("nozerounreal", nozerounreal, -1);
		txr_function_add("instance_valid_at_place", instance_valid_at_place, -1);
		txr_function_add("instance_valid_at_position", instance_valid_at_position, -1);
		txr_function_add("obj_get_coll", obj_get_coll, -1);
		txr_function_add("obj_place_meeting", obj_place_meeting, -1);
		txr_function_add("modulo", modulo, -1);
		txr_function_add("nearestplayer", nearestplayer, -1);
		txr_function_add("split_string", split_string, -1);
		txr_function_add("ternary", ternary, -1);
		txr_function_add("alarm_get", alarm_get, -1);
		txr_function_add("alarm_set", alarm_set, -1);
		txr_function_add("get_delta_time", function() { return delta_time; }, 0);
		txr_function_add("get_fps", function() { return fps; }, 0);
		txr_function_add("get_fps_real", function() { return fps_real; }, 0);
		txr_function_add("get_timer", get_timer, -1);
	#endregion
	
	#region Player Functions
		txr_function_add("player_movement_sonic", player_movement_sonic, -1);
		txr_function_add("player_movement", player_movement, -1);
		txr_function_add("player_poly_collision", player_poly_collision, -1);
		txr_function_add("player_collision", player_collision, -1);
		txr_function_add("player_slide", player_slide, -1);
		txr_function_add("player_slide_sonic", player_slide_sonic, -1);
		txr_function_add("player_interactions", player_interactions, -1);
		txr_function_add("post_wall", post_wall, -1);
		txr_function_add("finish_death", finish_death, -1);
	#endregion
	
	#region Audio
		txr_function_add("audio_play_sound", audio_play_sound, -1);
		txr_function_add("audio_play_sound_ext", audio_play_sound_ext, -1);
		txr_function_add("audio_play_sound_at", audio_play_sound_at, -1);
		txr_function_add("audio_stop_all", audio_stop_all, -1);
		txr_function_add("audio_stop_sound", audio_stop_sound, -1);
		txr_function_add("audio_is_playing", audio_is_playing, -1);
		txr_function_add("audio_is_paused", audio_is_paused, -1);
		txr_function_add("audio_pause_all", audio_pause_all, -1);
		txr_function_add("audio_pause_sound", audio_pause_sound, -1);
		txr_function_add("audio_resume_all", audio_resume_all, -1);
		txr_function_add("audio_resume_sound", audio_resume_sound, -1);
		txr_function_add("audio_sound_loop_start", audio_sound_loop_start, -1);
		txr_function_add("audio_sound_loop_end", audio_sound_loop_end, -1);
		txr_function_add("audio_sound_loop", audio_sound_loop, -1);
		txr_function_add("audio_sound_get_loop", audio_sound_get_loop, -1);
		txr_function_add("audio_sound_get_loop_start", audio_sound_get_loop_start, -1);
		txr_function_add("audio_sound_get_loop_end", audio_sound_get_loop_end, -1);
		txr_function_add("audio_sound_gain", audio_sound_gain, -1);
		txr_function_add("audio_sound_get_gain", audio_sound_get_gain, -1);
		txr_function_add("audio_sound_pitch", audio_sound_pitch, -1);
		txr_function_add("audio_sound_get_pitch", audio_sound_get_pitch, -1);
		txr_function_add("audio_sound_set_track_position", audio_sound_set_track_position, -1);
		txr_function_add("audio_sound_get_track_position", audio_sound_get_track_position, -1);
		txr_function_add("audio_sound_set_listener_mask", audio_sound_set_listener_mask, -1);
		txr_function_add("audio_sound_get_listener_mask", audio_sound_get_listener_mask, -1);
		txr_function_add("audio_master_gain", audio_master_gain, -1);
		txr_function_add("audio_set_master_gain", audio_set_master_gain, -1);
		txr_function_add("audio_get_master_gain", audio_get_master_gain, -1);
		txr_function_add("audio_channel_num", audio_channel_num, -1);
		txr_function_add("audio_falloff_set_model", audio_falloff_set_model, -1);
		txr_function_add("audio_system_is_available", audio_system_is_available, -1);
		txr_function_add("audio_system_is_initialised", audio_system_is_initialised, -1);
		txr_function_add("lin_to_db", lin_to_db, -1);
		txr_function_add("db_to_lin", db_to_lin, -1);
		txr_function_add("audio_create_stream", audio_create_stream, -1);
		txr_function_add("audio_destroy_stream", audio_destroy_stream, -1);
		txr_function_add("audio_emitter_create", audio_emitter_create, -1);
		txr_function_add("audio_emitter_exists", audio_emitter_exists, -1);
		txr_function_add("audio_emitter_position", audio_emitter_position, -1);
		txr_function_add("audio_emitter_velocity", audio_emitter_velocity, -1);
		txr_function_add("audio_emitter_falloff", audio_emitter_falloff, -1);
		txr_function_add("audio_emitter_gain", audio_emitter_gain, -1);
		txr_function_add("audio_emitter_pitch", audio_emitter_pitch, -1);
		txr_function_add("audio_emitter_set_listener_mask", audio_emitter_set_listener_mask, -1);
		txr_function_add("audio_emitter_free", audio_emitter_free, -1);
		txr_function_add("audio_play_sound_on", audio_play_sound_on, -1);
		txr_function_add("audio_emitter_get_gain", audio_emitter_get_gain, -1);
		txr_function_add("audio_emitter_get_pitch", audio_emitter_get_pitch, -1);
		txr_function_add("audio_emitter_get_x", audio_emitter_get_x, -1);
		txr_function_add("audio_emitter_get_y", audio_emitter_get_y, -1);
		txr_function_add("audio_emitter_get_z", audio_emitter_get_z, -1);
		txr_function_add("audio_emitter_get_vx", audio_emitter_get_vx, -1);
		txr_function_add("audio_emitter_get_vy", audio_emitter_get_vy, -1);
		txr_function_add("audio_emitter_get_vz", audio_emitter_get_vz, -1);
		txr_function_add("audio_emitter_get_listener_mask", audio_emitter_get_listener_mask, -1);
		txr_function_add("audio_emitter_bus", audio_emitter_bus, -1);
		txr_function_add("audio_emitter_get_bus", audio_emitter_get_bus, -1);
		txr_function_add("audio_exists", audio_exists, -1);
		txr_function_add("audio_listener_position", audio_listener_position, -1);
		txr_function_add("audio_listener_velocity", audio_listener_velocity, -1);
		txr_function_add("audio_listener_orientation", audio_listener_orientation, -1);
		txr_function_add("audio_listener_get_data", audio_listener_get_data, -1);
		txr_function_add("audio_listener_set_position", audio_listener_set_position, -1);
		txr_function_add("audio_listener_set_velocity", audio_listener_set_velocity, -1);
		txr_function_add("audio_listener_set_orientation", audio_listener_set_orientation, -1);
		txr_function_add("audio_get_listener_count", audio_get_listener_count, -1);
		txr_function_add("audio_get_listener_info", audio_get_listener_info, -1);
		txr_function_add("audio_bus_create", audio_bus_create, -1);
		txr_function_add("audio_effect_create", audio_effect_create, -1);
		txr_function_add("audio_emitter_bus", audio_emitter_bus, -1);
		txr_function_add("audio_emitter_get_bus", audio_emitter_get_bus, -1);
		txr_function_add("audio_bus_get_emitters", audio_bus_get_emitters, -1);
		txr_function_add("audio_bus_clear_emitters", audio_bus_clear_emitters, -1);
		txr_function_add("audio_group_name", audio_group_name, -1);
		txr_function_add("audio_group_get_assets", audio_group_get_assets, -1);
		txr_function_add("audio_sound_get_audio_group", audio_sound_get_audio_group, -1);
		txr_function_add("audio_group_load", audio_group_load, -1);
		txr_function_add("audio_group_unload", audio_group_unload, -1);
		txr_function_add("audio_group_is_loaded", audio_group_is_loaded, -1);
		txr_function_add("audio_group_load_progress", audio_group_load_progress, -1);
		txr_function_add("audio_group_stop_all", audio_group_stop_all, -1);
		txr_function_add("audio_group_set_gain", audio_group_set_gain, -1);
		txr_function_add("audio_group_get_gain", audio_group_get_gain, -1);
		txr_function_add("audio_get_name", audio_get_name, -1);
		txr_function_add("audio_get_type", audio_get_type, -1);
		txr_function_add("audio_sound_get_asset", audio_sound_get_asset, -1);
		txr_function_add("audio_sound_length", audio_sound_length, -1);
		txr_function_add("audio_sound_is_playable", audio_sound_is_playable, -1);
		txr_function_add("audio_create_buffer_sound", audio_create_buffer_sound, -1);
		txr_function_add("audio_free_buffer_sound", audio_free_buffer_sound, -1);
		txr_function_add("audio_create_play_queue", audio_create_play_queue, -1);
		txr_function_add("audio_free_play_queue", audio_free_play_queue, -1);
		txr_function_add("audio_queue_sound", audio_queue_sound, -1);
		txr_function_add("audio_start_recording", audio_start_recording, -1);
		txr_function_add("audio_stop_recording", audio_stop_recording, -1);
		txr_function_add("audio_get_recorder_info", audio_get_recorder_info, -1);
		txr_function_add("audio_get_recorder_count", audio_get_recorder_count, -1);
		txr_function_add("audio_create_sync_group", audio_create_sync_group, -1);
		txr_function_add("audio_play_in_sync_group", audio_play_in_sync_group, -1);
		txr_function_add("audio_start_sync_group", audio_start_sync_group, -1);
		txr_function_add("audio_stop_sync_group", audio_stop_sync_group, -1);
		txr_function_add("audio_pause_sync_group", audio_pause_sync_group, -1);
		txr_function_add("audio_resume_sync_group", audio_resume_sync_group, -1);
		txr_function_add("audio_sync_group_get_track_pos", audio_sync_group_get_track_pos, -1);
		txr_function_add("audio_destroy_sync_group", audio_destroy_sync_group, -1);
		txr_function_add("audio_sync_group_is_playing", audio_sync_group_is_playing, -1);
		txr_function_add("audio_sync_group_is_paused", audio_sync_group_is_paused, -1);
		txr_function_add("time_bpm_to_seconds", time_bpm_to_seconds, -1);
		txr_function_add("time_seconds_to_bpm", time_seconds_to_bpm, -1);
		txr_function_add("playsfx", playsfx, -1);
		txr_function_add("stopsfx", stopsfx, -1);
		txr_function_add("VinylPlay", VinylPlay, -1);
		txr_function_add("VinylStop", VinylStop, -1);
		
		txr_constant_add("audiogroup_default", audiogroup_default);
		txr_constant_add("AudioEffectTypeBitcrusher", AudioEffectType.Bitcrusher);
		txr_constant_add("AudioEffectTypeDelay", AudioEffectType.Delay);
		txr_constant_add("AudioEffectTypeDelay", AudioEffectType.Gain);
		txr_constant_add("AudioEffectTypeHPF2", AudioEffectType.HPF2);
		txr_constant_add("AudioEffectTypeLPF2", AudioEffectType.LPF2);
		txr_constant_add("AudioEffectTypeReverb1", AudioEffectType.Reverb1);
		txr_constant_add("AudioEffectTypeTremolo", AudioEffectType.Tremolo);
		txr_constant_add("AudioEffectTypeEQ", AudioEffectType.EQ);
		txr_constant_add("AudioEffectTypePeakEQ", AudioEffectType.PeakEQ);
		txr_constant_add("AudioEffectTypeHiShelf", AudioEffectType.HiShelf);
		txr_constant_add("AudioEffectTypeLoShelf", AudioEffectType.LoShelf);
		txr_constant_add("AudioEffectTypeCompressor", AudioEffectType.Compressor);
		txr_constant_add("AudioLFOTypeSine", AudioLFOType.Sine);
		txr_constant_add("AudioLFOTypeSquare", AudioLFOType.Square);
		txr_constant_add("AudioLFOTypeTriangle", AudioLFOType.Triangle);
		txr_constant_add("AudioLFOTypeSawtooth", AudioLFOType.Sawtooth);
		txr_constant_add("AudioLFOTypeInvSawtooth", AudioLFOType.InvSawtooth);
	#endregion

	#region Input
		txr_function_add("input_check_pressed", input_check_pressed, -1);
		txr_function_add("input_check", input_check, -1);
		txr_function_add("input_check_released", input_check_released, -1);
	#endregion
	
	#region Collision
		txr_function_add("place_empty", place_empty, -1);
		txr_function_add("place_free", place_free, -1);
		txr_function_add("place_meeting", place_meeting, -1);
		txr_function_add("position_empty", position_empty, -1);
		txr_function_add("position_meeting", position_meeting, -1);
		txr_function_add("position_change", position_change, -1);
		txr_function_add("position_destroy", position_destroy, -1);
		txr_function_add("instance_place", instance_place, -1);
		txr_function_add("instance_place_list", instance_place_list, -1);
		txr_function_add("instance_position", instance_position, -1);
		txr_function_add("instance_position_list", instance_position_list, -1);
		
		txr_function_add("collision_circle", collision_circle, -1);
		txr_function_add("collision_circle_list", collision_circle_list, -1);
		txr_function_add("collision_ellipse", collision_ellipse, -1);
		txr_function_add("collision_ellipse_list", collision_ellipse_list, -1);
		txr_function_add("collision_line", collision_line, -1);
		txr_function_add("collision_line_list", collision_line_list, -1);
		txr_function_add("collision_point", collision_point, -1);
		txr_function_add("collision_point_list", collision_point_list, -1);
		txr_function_add("collision_rectangle", collision_rectangle, -1);
		txr_function_add("collision_rectangle_list", collision_rectangle_list, -1);
		
		txr_function_add("point_in_rectangle", point_in_rectangle, -1);
		txr_function_add("point_in_triangle", point_in_triangle, -1);
		txr_function_add("point_in_circle", point_in_circle, -1)
		txr_function_add("rectangle_in_rectangle", rectangle_in_rectangle, -1);
		txr_function_add("rectangle_in_triangle", rectangle_in_triangle, -1);
		txr_function_add("rectangle_in_circle", rectangle_in_circle, -1);
		txr_function_add("check_collision_dot", check_collision_dot, -1);
		txr_function_add("check_collision_line", check_collision_line, -1);
	#endregion
	 
	#region DS Lists
		txr_function_add("ds_list_create", ds_list_create, -1);
		txr_function_add("ds_list_destroy", ds_list_destroy, -1);
		txr_function_add("ds_list_clear", ds_list_clear, -1);
		txr_function_add("ds_list_empty", ds_list_empty, -1);
		txr_function_add("ds_list_size", ds_list_size, -1);
		txr_function_add("ds_list_add", ds_list_add, -1);
		txr_function_add("ds_list_set", ds_list_set, -1);
		txr_function_add("ds_list_delete", ds_list_delete, -1);
		txr_function_add("ds_list_find_index", ds_list_find_index, -1);
		txr_function_add("ds_list_find_value", ds_list_find_value, -1);
		txr_function_add("ds_list_insert", ds_list_insert, -1);
		txr_function_add("ds_list_replace", ds_list_replace, -1);
		txr_function_add("ds_list_shuffle", ds_list_shuffle, -1);
		txr_function_add("ds_list_sort", ds_list_sort, -1);
		txr_function_add("ds_list_copy", ds_list_copy, -1);
		txr_function_add("ds_list_read", ds_list_read, -1);
		txr_function_add("ds_list_write", ds_list_write, -1);
		
		txr_function_add("ds_list_mark_as_list", ds_list_mark_as_list, -1);
		txr_function_add("ds_list_mark_as_map", ds_list_mark_as_map, -1);
		txr_function_add("ds_list_is_list", ds_list_is_list, -1);
		txr_function_add("ds_list_is_map", ds_list_is_map, -1);
		txr_function_add("ds_exists", ds_exists, -1);
		
		txr_constant_add("ds_type_map", ds_type_map)
		txr_constant_add("ds_type_list", ds_type_list)
		txr_constant_add("ds_type_stack", ds_type_stack)
		txr_constant_add("ds_type_grid", ds_type_grid)
		txr_constant_add("ds_type_priority", ds_type_priority)
		txr_constant_add("ds_type_queue", ds_type_queue)
	#endregion
	
	#region DS Grids
		txr_function_add("ds_grid_create", ds_grid_create, -1);
		txr_function_add("ds_grid_destroy", ds_grid_destroy, -1);
		txr_function_add("ds_grid_width", ds_grid_width, -1);
		txr_function_add("ds_grid_height", ds_grid_height, -1);
		txr_function_add("ds_grid_resize", ds_grid_resize, -1);
		txr_function_add("ds_grid_clear", ds_grid_clear, -1);
		txr_function_add("ds_grid_set", ds_grid_set, -1);
		txr_function_add("ds_grid_set_disk", ds_grid_set_disk, -1);
		txr_function_add("ds_grid_set_grid_region", ds_grid_set_grid_region, -1);
		txr_function_add("ds_grid_set_region", ds_grid_set_region, -1);
		txr_function_add("ds_grid_shuffle", ds_grid_shuffle, -1);
		txr_function_add("ds_grid_sort", ds_grid_sort, -1);
		txr_function_add("ds_grid_get", ds_grid_get, -1);
		txr_function_add("ds_grid_get_max", ds_grid_get_max, -1);
		txr_function_add("ds_grid_get_mean", ds_grid_get_mean, -1);
		txr_function_add("ds_grid_get_min", ds_grid_get_min, -1);
		txr_function_add("ds_grid_get_sum", ds_grid_get_sum, -1);
		txr_function_add("ds_grid_get_disk_max", ds_grid_get_disk_max, -1);
		txr_function_add("ds_grid_get_disk_mean", ds_grid_get_disk_mean, -1);
		txr_function_add("ds_grid_get_disk_min", ds_grid_get_disk_min, -1);
		txr_function_add("ds_grid_get_disk_sum", ds_grid_get_disk_sum, -1);
		txr_function_add("ds_grid_add", ds_grid_add, -1);
		txr_function_add("ds_grid_add_region", ds_grid_add_region, -1);
		txr_function_add("ds_grid_add_disk", ds_grid_add_disk, -1);
		txr_function_add("ds_grid_add_grid_region", ds_grid_add_grid_region, -1);
		txr_function_add("ds_grid_multiply", ds_grid_multiply, -1);
		txr_function_add("ds_grid_multiply_disk", ds_grid_multiply_disk, -1);
		txr_function_add("ds_grid_multiply_region", ds_grid_multiply_region, -1);
		txr_function_add("ds_grid_multiply_grid_region", ds_grid_multiply_grid_region, -1);
		txr_function_add("ds_grid_value_exists", ds_grid_value_exists, -1);
		txr_function_add("ds_grid_value_disk_exists", ds_grid_value_disk_exists, -1);
		txr_function_add("ds_grid_value_x", ds_grid_value_x, -1);
		txr_function_add("ds_grid_value_y", ds_grid_value_y, -1);
		txr_function_add("ds_grid_value_disk_x", ds_grid_value_disk_x, -1);
		txr_function_add("ds_grid_value_disk_y", ds_grid_value_disk_y, -1);
		txr_function_add("ds_grid_copy", ds_grid_copy, -1);
		txr_function_add("ds_grid_read", ds_grid_read, -1);
		txr_function_add("ds_grid_write", ds_grid_write, -1);
	#endregion
	
	#region DS Maps
		txr_function_add("ds_map_exists", ds_map_exists, -1);
		txr_function_add("ds_map_create", ds_map_create, -1);
		txr_function_add("ds_map_destroy", ds_map_destroy, -1);
		txr_function_add("ds_map_add", ds_map_add, -1);
		txr_function_add("ds_map_clear", ds_map_clear, -1);
		txr_function_add("ds_map_copy", ds_map_copy, -1);
		txr_function_add("ds_map_replace", ds_map_replace, -1);
		txr_function_add("ds_map_delete", ds_map_delete, -1);
		txr_function_add("ds_map_empty", ds_map_empty, -1);
		txr_function_add("ds_map_size", ds_map_size, -1);
		txr_function_add("ds_map_find_first", ds_map_find_first, -1);
		txr_function_add("ds_map_find_last", ds_map_find_last, -1);
		txr_function_add("ds_map_find_next", ds_map_find_next, -1);
		txr_function_add("ds_map_find_previous", ds_map_find_previous, -1);
		txr_function_add("ds_map_find_value", ds_map_find_value, -1);
		txr_function_add("ds_map_keys_to_array", ds_map_keys_to_array, -1);
		txr_function_add("ds_map_values_to_array", ds_map_values_to_array, -1);
		txr_function_add("ds_map_set", ds_map_set, -1);
		txr_function_add("ds_map_read", ds_map_read, -1);
		txr_function_add("ds_map_write", ds_map_write, -1);
		txr_function_add("ds_map_secure_save", ds_map_secure_save, -1);
		txr_function_add("ds_map_secure_save_buffer", ds_map_secure_save_buffer, -1);
		txr_function_add("ds_map_secure_load", ds_map_secure_load, -1);
		txr_function_add("ds_map_secure_load_buffer", ds_map_secure_load_buffer, -1);
		txr_function_add("ds_map_add_list", ds_map_add_list, -1);
		txr_function_add("ds_map_add_map", ds_map_add_map, -1);
		txr_function_add("ds_map_replace_list", ds_map_replace_list, -1);
		txr_function_add("ds_map_replace_map", ds_map_replace_map, -1);
		txr_function_add("ds_map_is_list", ds_map_is_list, -1);
		txr_function_add("ds_map_is_map", ds_map_is_map, -1);
	#endregion
	
	#region DS Priority Queues
		txr_function_add("ds_priority_create", ds_priority_create, -1);
		txr_function_add("ds_priority_destroy", ds_priority_destroy, -1);
		txr_function_add("ds_priority_clear", ds_priority_clear, -1);
		txr_function_add("ds_priority_empty", ds_priority_empty, -1);
		txr_function_add("ds_priority_size", ds_priority_size, -1);
		txr_function_add("ds_priority_add", ds_priority_add, -1);
		txr_function_add("ds_priority_change_priority", ds_priority_change_priority, -1);
		txr_function_add("ds_priority_delete_max", ds_priority_delete_max, -1);
		txr_function_add("ds_priority_delete_min", ds_priority_delete_min, -1);
		txr_function_add("ds_priority_delete_value", ds_priority_delete_value, -1);
		txr_function_add("ds_priority_find_max", ds_priority_find_max, -1);
		txr_function_add("ds_priority_find_min", ds_priority_find_min, -1);
		txr_function_add("ds_priority_find_priority", ds_priority_find_priority, -1);
		txr_function_add("ds_priority_copy", ds_priority_copy, -1);
		txr_function_add("ds_priority_read", ds_priority_read, -1);
		txr_function_add("ds_priority_write", ds_priority_write, -1);
	#endregion
	
	#region DS Queues
		txr_function_add("ds_queue_create", ds_queue_create, -1);
		txr_function_add("ds_queue_destroy", ds_queue_destroy, -1);
		txr_function_add("ds_queue_clear", ds_queue_clear, -1);
		txr_function_add("ds_queue_empty", ds_queue_empty, -1);
		txr_function_add("ds_queue_size", ds_queue_size, -1);
		txr_function_add("ds_queue_dequeue", ds_queue_dequeue, -1);
		txr_function_add("ds_queue_enqueue", ds_queue_enqueue, -1);
		txr_function_add("ds_queue_head", ds_queue_head, -1);
		txr_function_add("ds_queue_tail", ds_queue_tail, -1);
		txr_function_add("ds_queue_copy", ds_queue_copy, -1);
		txr_function_add("ds_queue_read", ds_queue_read, -1);
		txr_function_add("ds_queue_write", ds_queue_write, -1);
	#endregion
	
	#region DS Stacks
		txr_function_add("ds_stack_create", ds_stack_create, -1);
		txr_function_add("ds_stack_destroy", ds_stack_destroy, -1);
		txr_function_add("ds_stack_clear", ds_stack_clear, -1);
		txr_function_add("ds_stack_empty", ds_stack_empty, -1);
		txr_function_add("ds_stack_size", ds_stack_size, -1);
		txr_function_add("ds_stack_copy", ds_stack_copy, -1);
		txr_function_add("ds_stack_top", ds_stack_top, -1);
		txr_function_add("ds_stack_pop", ds_stack_pop, -1);
		txr_function_add("ds_stack_push", ds_stack_push, -1);
		txr_function_add("ds_stack_read", ds_stack_read, -1);
		txr_function_add("ds_stack_write", ds_stack_write, -1);
	#endregion
	
	#region Buffers
		txr_function_add("buffer_exists", buffer_exists, -1);
		txr_function_add("buffer_create", buffer_create, -1);
		txr_function_add("buffer_create_from_vertex_buffer", buffer_create_from_vertex_buffer, -1);
		txr_function_add("buffer_create_from_vertex_buffer_ext", buffer_create_from_vertex_buffer_ext, -1);
		txr_function_add("buffer_delete", buffer_delete, -1);
		txr_function_add("buffer_read", buffer_read, -1);
		txr_function_add("buffer_write", buffer_write, -1);
		txr_function_add("buffer_fill", buffer_fill, -1);
		txr_function_add("buffer_seek", buffer_seek, -1);
		txr_function_add("buffer_tell", buffer_tell, -1);
		txr_function_add("buffer_peek", buffer_peek, -1);
		txr_function_add("buffer_poke", buffer_poke, -1);
		txr_function_add("buffer_get_type", buffer_get_type, -1);
		txr_function_add("buffer_get_alignment", buffer_get_alignment, -1);
		txr_function_add("buffer_get_address", buffer_get_address, -1);
		txr_function_add("buffer_get_size", buffer_get_size, -1);
		txr_function_add("buffer_resize", buffer_resize, -1);
		txr_function_add("buffer_sizeof", buffer_sizeof, -1);
		txr_function_add("buffer_set_used_size", buffer_set_used_size, -1);
		txr_function_add("buffer_copy", buffer_copy, -1);
		txr_function_add("buffer_copy_stride", buffer_copy_stride, -1);
		txr_function_add("buffer_copy_from_vertex_buffer", buffer_copy_from_vertex_buffer, -1);
		txr_function_add("buffer_save", buffer_save, -1);
		txr_function_add("buffer_save_ext", buffer_save_ext, -1);
		txr_function_add("buffer_save_async", buffer_save_async, -1);
		txr_function_add("buffer_load", buffer_load, -1);
		txr_function_add("buffer_load_ext", buffer_load_ext, -1);
		txr_function_add("buffer_load_async", buffer_load_async, -1);
		txr_function_add("buffer_load_partial", buffer_load_partial, -1);
		txr_function_add("buffer_compress", buffer_compress, -1);
		txr_function_add("buffer_decompress", buffer_decompress, -1);
		txr_function_add("buffer_async_group_begin", buffer_async_group_begin, -1);
		txr_function_add("buffer_async_group_option", buffer_async_group_option, -1);
		txr_function_add("buffer_async_group_end", buffer_async_group_end, -1);
		txr_function_add("buffer_get_surface", buffer_get_surface, -1);
		txr_function_add("buffer_set_surface", buffer_set_surface, -1);
		txr_function_add("buffer_get_surface_depth", buffer_get_surface_depth, -1);
		txr_function_add("buffer_set_surface_depth", buffer_set_surface_depth, -1);
		txr_function_add("buffer_md5", buffer_md5, -1);
		txr_function_add("buffer_sha1", buffer_sha1, -1);
		txr_function_add("buffer_crc32", buffer_crc32, -1);
		txr_function_add("buffer_base64_encode", buffer_base64_encode, -1);
		txr_function_add("buffer_base64_decode", buffer_base64_decode, -1);
		txr_function_add("buffer_base64_decode_ext", buffer_base64_decode_ext, -1);
	#endregion
	
	#region Encoding and Hashing
		txr_function_add("json_stringify", json_stringify, -1);
		txr_function_add("json_parse", json_parse, -1);
		txr_function_add("json_encode", json_encode, -1);
		txr_function_add("json_decode", json_decode, -1);
		txr_function_add("base64_encode", base64_encode, -1);
		txr_function_add("base64_decode", base64_decode, -1);
		txr_function_add("md5_string_utf8", md5_string_utf8, -1);
		txr_function_add("md5_string_unicode", md5_string_unicode, -1);
		txr_function_add("md5_file", md5_file, -1);
		txr_function_add("sha1_string_utf8", sha1_string_utf8, -1);
		txr_function_add("sha1_string_unicode", sha1_string_unicode, -1);
		txr_function_add("sha1_file", sha1_file, -1);
		txr_function_add("load_csv", load_csv, -1);
	#endregion
	
	#region File Handling
		txr_function_add("ini_open", ini_open, -1);
		txr_function_add("ini_close", ini_close, -1);
		txr_function_add("ini_write_real", ini_write_real, -1);
		txr_function_add("ini_write_string", ini_write_string, -1);
		txr_function_add("ini_read_real", ini_read_real, -1);
		txr_function_add("ini_read_string", ini_read_string, -1);
		txr_function_add("ini_key_exists", ini_key_exists, -1);
		txr_function_add("ini_section_exists", ini_section_exists, -1);
		txr_function_add("ini_key_delete", ini_key_delete, -1);
		txr_function_add("ini_section_delete", ini_section_delete, -1);
		txr_function_add("ini_open_from_string", ini_open_from_string, -1);
		
		txr_function_add("file_text_open_read", file_text_open_read, -1);
		txr_function_add("file_text_open_write", file_text_open_write, -1);
		txr_function_add("file_text_open_append", file_text_open_append, -1);
		txr_function_add("file_text_open_from_string", file_text_open_from_string, -1);
		txr_function_add("file_text_read_real", file_text_read_real, -1);
		txr_function_add("file_text_read_string", file_text_read_string, -1);
		txr_function_add("file_text_readln", file_text_readln, -1);
		txr_function_add("file_text_write_real", file_text_write_real, -1);
		txr_function_add("file_text_write_string", file_text_write_string, -1);
		txr_function_add("file_text_writeln", file_text_writeln, -1);
		txr_function_add("file_text_eoln", file_text_eoln, -1);
		txr_function_add("file_text_eof", file_text_eof, -1);
		txr_function_add("file_text_close", file_text_close, -1);
		
		txr_function_add("file_exists", file_exists, -1);
		txr_function_add("file_copy", file_copy, -1);
		txr_function_add("file_find_first", file_find_first, -1);
		txr_function_add("file_find_next", file_find_next, -1);
		txr_function_add("file_find_close", file_find_close, -1);
		txr_function_add("file_attributes", file_attributes, -1);
		txr_function_add("filename_name", filename_name, -1);
		txr_function_add("file_exists", file_exists, -1);
		txr_function_add("filename_path", filename_path, -1);
		txr_function_add("filename_dir", filename_dir, -1);
		txr_function_add("filename_drive", filename_drive, -1);
		txr_function_add("filename_ext", filename_ext, -1);
		txr_function_add("filename_change_ext", filename_change_ext, -1);
		txr_function_add("get_open_filename", get_open_filename, -1);
		txr_function_add("get_open_filename_ext", get_open_filename_ext, -1);
		txr_function_add("get_save_filename", get_save_filename, -1);
		txr_function_add("get_save_filename_ext", get_save_filename_ext, -1);
		
		txr_function_add("directory_exists", directory_exists, -1);
		
		txr_constant_add("fa_readonly", fa_readonly);
		txr_constant_add("fa_hidden", fa_hidden);
		txr_constant_add("fa_volumeid", fa_volumeid);
		txr_constant_add("fa_directory", fa_directory);
		txr_constant_add("fa_archive", fa_archive);
		txr_constant_add("temp_directory", temp_directory);
		txr_constant_add("working_directory", working_directory);
		txr_constant_add("program_directory", program_directory);
		txr_constant_add("cache_directory", cache_directory);
	#endregion
	
	#region Sprites
		txr_function_add("sprite_exists", sprite_exists, -1);
		txr_function_add("sprite_get_name", sprite_get_name, -1);
		txr_function_add("sprite_get_number", sprite_get_number, -1);
		txr_function_add("sprite_get_speed", sprite_get_speed, -1);
		txr_function_add("sprite_get_speed_type", sprite_get_speed_type, -1);
		txr_function_add("sprite_get_width", sprite_get_width, -1);
		txr_function_add("sprite_get_height", sprite_get_height, -1);
		txr_function_add("sprite_get_xoffset", sprite_get_xoffset, -1);
		txr_function_add("sprite_get_yoffset", sprite_get_yoffset, -1);
		txr_function_add("sprite_get_bbox_bottom", sprite_get_bbox_bottom, -1);
		txr_function_add("sprite_get_bbox_left", sprite_get_bbox_left, -1);
		txr_function_add("sprite_get_bbox_right", sprite_get_bbox_right, -1);
		txr_function_add("sprite_get_bbox_top", sprite_get_bbox_top, -1);
		txr_function_add("sprite_get_bbox_mode", sprite_get_bbox_mode, -1);
		txr_function_add("sprite_get_nineslice", sprite_get_nineslice, -1);
		txr_function_add("sprite_get_tpe", sprite_get_tpe, -1);
		txr_function_add("sprite_get_texture", sprite_get_texture, -1);
		txr_function_add("sprite_get_uvs", sprite_get_uvs, -1);
		txr_function_add("sprite_get_info", sprite_get_info, -1);
		txr_function_add("sprite_collision_mask", sprite_collision_mask, -1);
		txr_function_add("sprite_set_offset", sprite_set_offset, -1);
		txr_function_add("sprite_set_bbox_mode", sprite_set_bbox_mode, -1);
		txr_function_add("sprite_set_bbox", sprite_set_bbox, -1);
		txr_function_add("sprite_set_speed", sprite_set_speed, -1);
		txr_function_add("sprite_set_nineslice", sprite_set_nineslice, -1);
		txr_function_add("sprite_add", sprite_add, -1);
		txr_function_add("sprite_add_ext", sprite_add_ext, -1);
		txr_function_add("sprite_delete", sprite_delete, -1);
		txr_function_add("sprite_replace", sprite_replace, -1);
		txr_function_add("sprite_assign", sprite_assign, -1);
		txr_function_add("sprite_merge", sprite_merge, -1);
		txr_function_add("sprite_set_alpha_from_sprite", sprite_set_alpha_from_sprite, -1);
		txr_function_add("sprite_nineslice_create", sprite_nineslice_create, -1);
		txr_function_add("sprite_create_from_surface", sprite_create_from_surface, -1);
		txr_function_add("sprite_add_from_surface", sprite_add_from_surface, -1);
		txr_function_add("sprite_save", sprite_save, -1);
		txr_function_add("sprite_save_strip", sprite_save_strip, -1);
		
		txr_constant_add("spritespeed_framespersecond", spritespeed_framespersecond)
		txr_constant_add("spritespeed_framespergameframe", spritespeed_framespergameframe)
	#endregion
	
	#region Date and Time
		txr_function_add("date_set_timezone", date_set_timezone, -1);
		txr_function_add("date_get_timezone", date_get_timezone, -1);
		txr_function_add("date_create_datetime", date_create_datetime, -1);
		txr_function_add("date_current_datetime", date_current_datetime, -1);
		txr_function_add("date_compare_date", date_compare_date, -1);
		txr_function_add("date_compare_datetime", date_compare_datetime, -1);
		txr_function_add("date_compare_time", date_compare_time, -1);
		txr_function_add("date_valid_datetime", date_valid_datetime, -1);
		txr_function_add("date_date_of", date_date_of, -1);
		txr_function_add("date_time_of", date_time_of, -1);
		txr_function_add("date_is_today", date_is_today, -1);
		txr_function_add("date_leap_year", date_leap_year, -1);
		txr_function_add("date_date_string", date_date_string, -1);
		txr_function_add("date_datetime_string", date_datetime_string, -1);
		txr_function_add("date_time_string", date_time_string, -1);
		txr_function_add("date_second_span", date_second_span, -1);
		txr_function_add("date_minute_span", date_minute_span, -1);
		txr_function_add("date_hour_span", date_hour_span, -1);
		txr_function_add("date_day_span", date_day_span, -1);
		txr_function_add("date_week_span", date_week_span, -1);
		txr_function_add("date_month_span", date_month_span, -1);
		txr_function_add("date_year_span", date_year_span, -1);
		txr_function_add("date_days_in_month", date_days_in_month, -1);
		txr_function_add("date_days_in_year", date_days_in_year, -1);
		txr_function_add("date_get_second", date_get_second, -1);
		txr_function_add("date_get_minute", date_get_minute, -1);
		txr_function_add("date_get_hour", date_get_hour, -1);
		txr_function_add("date_get_day", date_get_day, -1);
		txr_function_add("date_get_weekday", date_get_weekday, -1);
		txr_function_add("date_get_week", date_get_week, -1);
		txr_function_add("date_get_month", date_get_month, -1);
		txr_function_add("date_get_year", date_get_year, -1);
		txr_function_add("date_get_second_of_year", date_get_second_of_year, -1);
		txr_function_add("date_get_minute_of_year", date_get_minute_of_year, -1);
		txr_function_add("date_get_hour_of_year", date_get_hour_of_year, -1);
		txr_function_add("date_get_day_of_year", date_get_day_of_year, -1);
		txr_function_add("date_inc_second", date_inc_second, -1);
		txr_function_add("date_inc_minute", date_inc_minute, -1);
		txr_function_add("date_inc_hour", date_inc_hour, -1);
		txr_function_add("date_inc_day", date_inc_day, -1);
		txr_function_add("date_inc_week", date_inc_week, -1);
		txr_function_add("date_inc_month", date_inc_month, -1);
		txr_function_add("date_inc_year", date_inc_year, -1);
		txr_function_add("get_current_time", function() { return current_time; }, 0);
		txr_function_add("get_current_second", function() { return current_second; }, 0);
		txr_function_add("get_current_minute", function() { return current_minute; }, 0);
		txr_function_add("get_current_hour", function() { return current_hour; }, 0);
		txr_function_add("get_current_day", function() { return current_day; }, 0);
		txr_function_add("get_current_weekday", function() { return current_weekday; }, 0);
		txr_function_add("get_current_month", function() { return current_month; }, 0);
		txr_function_add("get_current_year", function() { return current_year; }, 0);
		
		txr_constant_add("timezone_utc", timezone_utc)
		txr_constant_add("timezone_local", timezone_local)
	#endregion
	
	#region Time Sources
		txr_function_add("time_source_create", time_source_create, -1);
		txr_function_add("time_source_destroy", time_source_destroy, -1);
		txr_function_add("time_source_start", time_source_start, -1);
		txr_function_add("time_source_stop", time_source_stop, -1);
		txr_function_add("time_source_pause", time_source_pause, -1);
		txr_function_add("time_source_resume", time_source_resume, -1);
		txr_function_add("time_source_reconfigure", time_source_reconfigure, -1);
		txr_function_add("time_source_reset", time_source_reset, -1);
		txr_function_add("time_source_get_children", time_source_get_children, -1);
		txr_function_add("time_source_get_parent", time_source_get_parent, -1);
		txr_function_add("time_source_get_period", time_source_get_period, -1);
		txr_function_add("time_source_get_reps_completed", time_source_get_reps_completed, -1);
		txr_function_add("time_source_get_reps_remaining", time_source_get_reps_remaining, -1);
		txr_function_add("time_source_get_state", time_source_get_state, -1);
		txr_function_add("time_source_get_time_remaining", time_source_get_time_remaining, -1);
		txr_function_add("time_source_get_units", time_source_get_units, -1);
		txr_function_add("time_source_exists", time_source_exists, -1);
		
		txr_constant_add("time_source_global", time_source_global)
		txr_constant_add("time_source_game", time_source_game)
		txr_constant_add("time_source_units_seconds", time_source_units_seconds)
		txr_constant_add("time_source_units_frames", time_source_units_frames)
		txr_constant_add("time_source_expire_nearest", time_source_expire_nearest)
		txr_constant_add("time_source_expire_after", time_source_expire_after)
		txr_constant_add("time_source_state_initial", time_source_state_initial)
		txr_constant_add("time_source_state_active", time_source_state_active)
		txr_constant_add("time_source_state_paused", time_source_state_paused)
		txr_constant_add("time_source_state_stopped", time_source_state_stopped)
	#endregion
	
	#region Particle Systems
		txr_function_add("part_system_exists", part_system_exists, -1);
		txr_function_add("part_system_create", part_system_create, -1);
		txr_function_add("part_system_create_layer", part_system_create_layer, -1);
		txr_function_add("part_system_get_layer", part_system_get_layer, -1);
		txr_function_add("part_system_layer", part_system_layer, -1);
		txr_function_add("part_system_depth", part_system_depth, -1);
		txr_function_add("part_system_position", part_system_position, -1);
		txr_function_add("part_system_angle", part_system_angle, -1);
		txr_function_add("part_system_global_space", part_system_global_space, -1);
		txr_function_add("part_system_colour", part_system_colour, -1);
		txr_function_add("part_system_clear", part_system_clear, -1);
		txr_function_add("part_system_destroy", part_system_destroy, -1);
		txr_function_add("part_particles_clear", part_particles_clear, -1);
		txr_function_add("part_particles_count", part_particles_count, -1);
		txr_function_add("part_system_automatic_update", part_system_automatic_update, -1);
		txr_function_add("part_system_automatic_draw", part_system_automatic_draw, -1);
		txr_function_add("part_system_update", part_system_update, -1);
		txr_function_add("part_system_drawit", part_system_drawit, -1);
		txr_function_add("part_system_draw_order", part_system_draw_order, -1);
		txr_function_add("part_particles_create", part_particles_create, -1);
		txr_function_add("part_particles_create_colour", part_particles_create_colour, -1);
		txr_function_add("part_particles_burst", part_particles_burst, -1);
		txr_function_add("part_type_exists", part_type_exists, -1);
		txr_function_add("part_type_create", part_type_create, -1);
		txr_function_add("part_type_destroy", part_type_destroy, -1);
		txr_function_add("part_type_clear", part_type_clear, -1);
		txr_function_add("part_type_shape", part_type_shape, -1);
		txr_function_add("part_type_sprite", part_type_sprite, -1);
		txr_function_add("part_type_subimage", part_type_subimage, -1);
		txr_function_add("part_type_size", part_type_size, -1);
		txr_function_add("part_type_size_x", part_type_size_x, -1);
		txr_function_add("part_type_size_y", part_type_size_y, -1);
		txr_function_add("part_type_scale", part_type_scale, -1);
		
	#endregion

	#region Instances
		txr_function_add("instance_create_depth", instance_create_depth, -1);
		txr_function_add("instance_create", instance_create, -1);
		txr_function_add("instance_destroy", instance_destroy, -1);
		txr_function_add("instance_exists", instance_exists, -1);
		txr_function_add("instance_change", instance_change, -1);
		txr_function_add("instance_copy", instance_copy, -1);
		txr_function_add("instance_find", instance_find, -1);
		txr_function_add("instance_furthest", instance_furthest, -1);
		txr_function_add("instance_nearest", instance_nearest, -1);
		txr_function_add("instance_number", instance_number, -1);
		txr_function_add("variable_instance_exists", variable_instance_exists, -1);
		txr_function_add("variable_instance_get_names", variable_instance_get_names, -1);
		txr_function_add("variable_instance_names_count", variable_instance_names_count, -1);
		txr_function_add("variable_instance_get", variable_instance_get, -1);
		txr_function_add("variable_instance_set", variable_instance_set, -1);
		txr_function_add("instance_id_get", instance_id_get, -1);
		txr_function_add("object_get_name", object_get_name, -1);
	#endregion
	
	#region Signals
		txr_function_add("signal_emit", function(signal, type, code_id=charmName) { signal.Emit(type, code_id) }, -1);
		txr_function_add("signal_create", signal_create, -1);
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