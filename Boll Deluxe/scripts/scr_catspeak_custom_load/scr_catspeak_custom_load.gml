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
			"position_empty", position_empty,
			"place_empty", place_empty,
			"place_free", place_free,
			"collision_circle", collision_circle,
			"collision_circle_list", collision_circle_list,
			"collision_ellipse", collision_ellipse,
			"collision_ellipse_list", collision_ellipse_list,
			"collision_line", collision_line,
			"collision_line_list", collision_line_list,
			"collision_point", collision_point,
			"collision_point_list", collision_point,
			"collision_rectangle", collision_rectangle,
			"collision_rectangle_list", collision_rectangle_list,
			"point_in_rectangle", point_in_rectangle,
			"point_in_triangle", point_in_triangle,
			"point_in_circle", point_in_circle,
			"rectangle_in_rectangle", rectangle_in_rectangle,
			"rectangle_in_triangle", rectangle_in_triangle,
			"rectangle_in_circle", rectangle_in_circle
		);
	});