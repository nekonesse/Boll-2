mbleftpress=mouse_check_button_pressed(mb_left)
mbleft=mouse_check_button(mb_left)
mbmiddle=mouse_check_button(mb_middle)

curs_x=mouse_x-camera_get_view_x(view_camera[0])
curs_y=mouse_y-camera_get_view_y(view_camera[0])

var guiw=display_get_gui_width()
var guih=display_get_gui_height()
var tb_length = array_length(toolbar[selected_mode])
not_on_gui=!point_in_rectangle(curs_x,curs_y,(guiw-16)-(32*14),0,(guiw-16)-(32*14)+(32*tb_length)+4,34)&&!point_in_rectangle(curs_x,curs_y,(guiw)-(32*5),0,(guiw)-(32*5)+(32*5)+4,34)&&!point_in_rectangle(curs_x,curs_y,0,(guih/4)-10,32,(guih/4)-10+(32*5)+4)


#region Camera Panning
if (not_on_gui) && (mbmiddle) {
	if !(view_grab) { //check position
		view_grab=1 
		view_grabx=curs_x
		view_graby=curs_y
		initial_viewx = camera_get_view_x(view_camera[0])
		initial_viewy = camera_get_view_y(view_camera[0])
	}
} else {
	view_grab=0
}

if (view_grab) { //update camera position
    camera_set_view_pos(view_camera[0],initial_viewx+(view_grabx-curs_x),initial_viewy+(view_graby-curs_y))
	//divide by zoom later
}
#endregion

gridx = floor(mouse_x/16)
gridy = floor(mouse_y/16)

if keyboard_check_pressed(vk_escape) room_goto(rMainMenu)

//half temp cycling object/tile behavior
switch(selected_mode) {
	case TILE_MODE:
	if mouse_wheel_down() {
		current_tile_id ++	
	}

	if mouse_wheel_up() {
		current_tile_id --
	}

	current_tile_id = wrap_val(current_tile_id, 0, 255) //todo, get tileset size lol

	selected_tile=current_tile_id
	break;
	
	case OBJECT_MODE:
	if mouse_wheel_down() {
		current_obj_id ++	
	}

	if mouse_wheel_up() {
		current_obj_id --
	}

	current_obj_id = wrap_val(current_obj_id, 0, ds_list_size(obj_name)- 1)

	selected_obj=ds_list_find_value(obj_name, current_obj_id)
	break;
}

for (var i = 0; i < 5; ++i)
{
	if (mbleftpress) && mouse_in_mode_slot(i) {
		if selected_mode != i {
			selected_toolbar=0
			selected_mode=i
		}
	}
}

//change toolbar 
var tb_length = array_length(toolbar[selected_mode])
for (var i = 0; i < tb_length; ++i)
{
	if (mbleftpress) && mouse_in_toolbar_slot(i) {
		selected_toolbar=i
		//show_message(selected_toolbar)
	}
}

selected_tool=toolbar[selected_mode][selected_toolbar]

if (mbleftpress) {
	if mouse_in_setting_slot(0) { //exit button
		room_goto(rMainMenu)
	}
	if (not_on_gui) {
		if (selected_tool == PICKER_TOOL) {
			switch(selected_mode) {
				case OBJECT_MODE:
					//todo, redo picker based on new object system
				break;
			}
		}
	
		if (selected_tool == BRUSH_TOOL) {
			switch(selected_mode) {
				case OBJECT_MODE:
					if is_string(selected_obj) {
						var obj = ds_list_find_value(object_layer_map, i)
						//var arr =ds_map_find_value(obj_data,selected_obj)
						show_debug_message("created object: {0}", selected_obj)
						ds_list_add(object_layer_map, [selected_obj, gridx, gridy, 1, 1]) //add object to list at place
					}
				break;
		}
		}
	}
}

if (mbleft && not_on_gui) {
	
		switch(selected_tool) {
		case BRUSH_TOOL:
			switch(selected_mode) {
				case OBJECT_MODE:
				break;
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y); //set tile at place
					data = tile_set_index(data, current_tile_id)
					tilemap_set(tilemap, data, gridx, gridy);
				break;
			}
		break;
		case ERASE_TOOL:
			switch(selected_mode) {
				case OBJECT_MODE:
					var size = ds_list_size(object_layer_map)
					for (var i = 0; i < size; ++i) {
						//is place matching cursor?
						var obj = ds_list_find_value(object_layer_map, i)
						if !is_undefined(obj) {
						    if obj[1] = gridx && obj[2] = gridy {
								show_debug_message("deleted object: {0}", obj[0])
								ds_list_delete(object_layer_map, i)//delete first object it finds there (probably bottom top? i don rembr)
								break;
							}
						}
				
					}
				break;
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					data = tile_set_empty(data)
					tilemap_set(tilemap, data, gridx, gridy); //delete tile at place lol
				break;
			}
		break;
		}
	
}

