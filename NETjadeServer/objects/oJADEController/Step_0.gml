var cam_x = camera_get_view_x(view_camera[0])
var cam_y = camera_get_view_y(view_camera[0])
var cam_w = camera_get_view_width(view_camera[0])
var cam_h = camera_get_view_height(view_camera[0])

curs_x=mouse_x-cam_x
curs_y=mouse_y-cam_y

mbleftpress=mouse_check_button_pressed(mb_left)
mbleftrel=mouse_check_button_released(mb_left)
mbleft=mouse_check_button(mb_left)
mbrightpress=mouse_check_button_pressed(mb_right)
mbrightrel=mouse_check_button_released(mb_right)
mbright=mouse_check_button(mb_right)
mbmiddle = (mouse_check_button(mb_middle) || (keyboard_check(vk_space) && mouse_check_button(mb_left)))

#region Camera Panning
if (mbmiddle) {
	if !(view_grab) { //check position
		view_grab=1 
		view_grabx=curs_x
		view_graby=curs_y
		initial_viewx = cam_x
		initial_viewy = cam_y
	}
} else {
	view_grab=0
}

if (view_grab) { //update camera position
    camera_set_view_pos(view_camera[0],floor(initial_viewx+(view_grabx-curs_x)),floor(initial_viewy+(view_graby-curs_y)))
	//divide by zoom later
}
#endregion

if keyboard_check_pressed(vk_f10) {
	var surf=surface_create(room_width,room_height)
	surface_set_target(surf);
	var i=0;

	repeat(ds_list_size(object_layer_map)) {
		var obj = ds_list_find_value(object_layer_map, i)
	
		var sprite = ds_map_find_value(obj_data,obj[0])
	
		var objalpha=1
	    draw_sprite_ext(sprite[0], 0, (obj[1]*16)- sprite[1] + obj[8] , (obj[2]*16)- sprite[2] + obj[9], obj[3], obj[4], 0, c_white, objalpha)
	
		i++;
	}
	i=array_length(tile_layer_map)-1;
	repeat(array_length(tile_layer_map)) {
		var list=tile_layer_map[i]
		var j=0;
		repeat(ds_list_size(list)) {
			var arr=list[| j]
			draw_tile(tilemap_get_tileset(tile_layer[i]), arr[0], 0, arr[1]*16, arr[2]*16)
			j++;
		}
		i--;
	}
	surface_reset_target();
	surface_save(surf, get_save_filename_ext("screenshot|*.png", "", working_directory, "Save a screenshot here"))
	surface_free(surf)
}