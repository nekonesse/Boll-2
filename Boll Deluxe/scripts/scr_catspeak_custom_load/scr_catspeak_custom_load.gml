catspeak_force_init();

Catspeak.interface.exposeAssetByTag("Catspeak");

	catspeak_preset_add("instance", function (interface, keywords) {
		interface.exposeFunction(
	        "instance_create", instance_create,
			"instance_destroy", instance_destroy,
			"instance_exists", instance_exists,
			"instance_change", instance_change,
			"instance_copy", instance_copy,
			"instance_find", instance_find,
			"instance_nearest", instance_nearest,
			"instance_furthest", instance_furthest,
			"instance_number", instance_number,
			"instance_get_id", instance_id_get,
	    );
		interface.exposeDynamicConstant(
			"instance_count", instance_count,
			"instance_id", instance_id
		);
	});
	catspeak_preset_add("collision", function (interface, keywords) {
		interface.exposeFunction(
		    "place_meeting", place_meeting,
			"position_meeting", position_meeting,
			"instance_place", instance_place,
			"instance_place_list", instance_place_list,
			"instance_position", instance_position,
			"instance_position_list", instance_position_list,
			"my_collision", my_collision,
			"position_empty", position_empty,
			"place_empty", place_empty,
			"place_free", place_free,
			"collision_circle", collision_circle,
			"collision_circle_list", collision_circle_list,
			"collision_ellipse", collision_ellipse,
			"collision_ellipse_list", collision_ellipse_list,
			"collision_handle_polygon", collision_handle_polygon,
			"collision_line", collision_line,
			"collision_line_list", collision_line_list,
			"collision_point", collision_point,
			"collision_point_list", collision_point,
			"collision_rectangle", collision_rectangle,
			"collision_rectangle_list", collision_rectangle_list,
			"collision_routine_do_semisolid", collision_routine_do_semisolid,
			"collision_routine_do_xcoll", collision_routine_do_xcoll,
			"collision_routine_do_ycoll", collision_routine_do_ycoll,
			"point_in_rectangle", point_in_rectangle,
			"point_in_triangle", point_in_triangle,
			"point_in_circle", point_in_circle,
			"rectangle_in_rectangle", rectangle_in_rectangle,
			"rectangle_in_triangle", rectangle_in_triangle,
			"rectangle_in_circle", rectangle_in_circle
		);
	});
	
	catspeak_preset_add("custom", function (interface, keywords) {
		interface.exposeFunction(
	        "my_collision", my_collision,
			"draw_player", draw_player,
			"wave_val", wave_val,
			"approach_val", approach_val,
			"jump_in_direction", jump_in_direction,
			"chance", chance,
			"inview", inview,
			"esign", esign,
			"modulo", modulo,
			"draw_text_outline", draw_text_outline,
			"obj_get_coll", obj_get_coll,
			"obj_place_meeting", obj_place_meeting
	    );
	});