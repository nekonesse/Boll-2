#macro gametitle "Boll Deluxe"
#macro version "2.2"

global.debug=0
global.netgame = false; // top 10 boll deluxe things that will never happen:

//scr = NaN


if !(instance_exists) instance_create_depth(0,0,16001,input_controller_object)

//// TXR SETUP!!! ////
#region TXR
	txr_init(); //TXR starting
	
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
		txr_function_add("string_width_scribble", string_width_scribble, -1);
		txr_function_add("string_height_scribble", string_height_scribble, -1);
		txr_function_add("scribble_typist", scribble_typist, -1);
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
	    txr_function_add("angle_difference", angle_difference, -1);
	    txr_function_add("lengthdir_x", lengthdir_x, -1);
	    txr_function_add("lengthdir_y", lengthdir_y, -1);
		
		txr_constant_add("pi", pi);
	#endregion
	
	#region Math 3D
	    txr_function_add("point_distance_3d", point_distance_3d, -1);
	    txr_function_add("dot_product_3d", dot_product_3d, -1);
	    txr_function_add("dot_product_3d_normalised", dot_product_3d_normalised, -1);
	    txr_function_add("matrix_build", matrix_build, -1);
	    txr_function_add("matrix_multiply", matrix_multiply, -1);
	    txr_function_add("matrix_build_identity", matrix_build_identity, -1);
	    txr_function_add("matrix_build_lookat", matrix_build_lookat, -1);
	    txr_function_add("matrix_build_projection_ortho", matrix_build_projection_ortho, -1);
	    txr_function_add("matrix_build_projection_perspective", matrix_build_projection_perspective, -1);
	    txr_function_add("matrix_build_projection_perspective_fov", matrix_build_projection_perspective_fov, -1);
	    txr_function_add("matrix_transform_vertex", matrix_transform_vertex, -1);
	#endregion
	
	#region Colour
	    txr_function_add("colour_get_blue", colour_get_blue, -1);
	    txr_function_add("colour_get_green", colour_get_green, -1);
	    txr_function_add("colour_get_red", colour_get_red, -1);
	    txr_function_add("colour_get_hue", colour_get_hue, -1);
	    txr_function_add("colour_get_saturation", colour_get_saturation, -1);
	    txr_function_add("colour_get_value", colour_get_value, -1);
	    txr_function_add("make_colour_rgb", make_colour_rgb, -1);
	    txr_function_add("make_colour_hsv", make_colour_hsv, -1);
	    txr_function_add("merge_colour", merge_colour, -1);
		
	
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
		txr_function_add("draw_text_scribble", draw_text_scribble, -1);
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
	    txr_function_add("draw_highscore", draw_highscore, -1);
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
	    txr_function_add("vertex_format_add_textcoord", vertex_format_add_texcoord, -1);
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

		// CONSTANT ADD!!
	    //"vertex_usage_position", vertex_usage_position,
	    //"vertex_usage_colour", vertex_usage_colour,
	    //"vertex_usage_color", vertex_usage_color,
	    //"vertex_usage_normal", vertex_usage_normal,
	    //"vertex_usage_texcoord", vertex_usage_texcoord,
	    //"vertex_usage_textcoord", vertex_usage_texcoord,
	    //"vertex_usage_blendweight", vertex_usage_blendweight,
	    //"vertex_usage_blendindices", vertex_usage_blendindices,
	    //"vertex_usage_psize", vertex_usage_psize,
	    //"vertex_usage_tangent", vertex_usage_tangent,
	    //"vertex_usage_binormal", vertex_usage_binormal,
	    //"vertex_usage_fog", vertex_usage_fog,
	    //"vertex_usage_depth", vertex_usage_depth,
	    //"vertex_usage_sample", vertex_usage_sample,
	    //"vertex_type_float1", vertex_type_float1,
	    //"vertex_type_float2", vertex_type_float2,
	    //"vertex_type_float3", vertex_type_float3,
	    //"vertex_type_float4", vertex_type_float4,
	    //"vertex_type_colour", vertex_type_colour,
	    //"vertex_type_color", vertex_type_color,
	    //"vertex_type_ubyte4", vertex_type_ubyte4,
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
	
	#region Unsafe (nekonesse: these are actually pretty good to have tbh)
		if (debug_mode) {
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
		}
	#endregion

	#region Camera
		txr_function_add("camera_set_view_pos", camera_set_view_pos, -1);
	#endregion
	
	#region Misc
		txr_function_add("show_debug_message", show_debug_message, -1);
		txr_function_add("show_message", show_message, -1);
		txr_function_add("wave_val", wave_val, -1);
		txr_function_add("approach_val", approach_val, -1);
		txr_function_add("chance", chance, -1);
		txr_function_add("jump_in_direction", jump_in_direction, -1);
		txr_function_add("camera_get_view_x", camera_get_view_x, -1);
		txr_function_add("camera_get_view_y", camera_get_view_y, -1);
		txr_function_add("camera_set_view_pos", camera_set_view_pos, -1);
		txr_function_add("event_inherited", event_inherited, -1);
		txr_function_add("room_get_width", function() { return room_width; }, -1);
		txr_function_add("room_get_height", function() { return room_height; }, -1);
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
	#endregion
	
	#region Player Functions
		txr_function_add("player_movement_sonic", player_movement_sonic, -1);
		txr_function_add("player_movement", player_movement, -1);
		txr_function_add("player_collision", player_collision, -1);
		txr_function_add("player_slide", player_slide, -1);
		txr_function_add("post_wall", post_wall, -1);
	#endregion
	
	#region Audio
		txr_function_add("audio_play_sound", audio_play_sound, -1);
		txr_function_add("audio_stop_all", audio_stop_all, -1);
		txr_function_add("audio_stop_sound", audio_stop_sound, -1);
		txr_function_add("audio_is_playing", audio_is_playing, -1);
		txr_function_add("audio_is_paused", audio_is_paused, -1);
		txr_function_add("audio_pause_all", audio_pause_all, -1);
		txr_function_add("audio_pause_sound", audio_pause_sound, -1);
		txr_function_add("audio_sound_loop_start", audio_sound_loop_start, -1);
		txr_function_add("audio_sound_loop_end", audio_sound_loop_end, -1);
		txr_function_add("time_bpm_to_seconds", time_bpm_to_seconds, -1);
		txr_function_add("playsfx", playsfx, -1);
		txr_function_add("stopsfx", stopsfx, -1);
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
		txr_function_add("point_in_circle", point_in_circle, -1);
		txr_function_add("rectangle_in_rectangle", rectangle_in_rectangle, -1);
		txr_function_add("rectangle_in_triangle", rectangle_in_triangle, -1);
		txr_function_add("rectangle_in_circle", rectangle_in_circle, -1);
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
		txr_function_add("SigConnector", SigConnector, -1);
		txr_function_add("SigDisconnect", SigDisconnect, -1);
		txr_function_add("Signal", Signal, -1);
	#endregion

#endregion

//// Charm Loading ////
#region Charm Loading
	_charmList = []; //Names of all charms
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