var cam_x = camera_get_view_x(view_camera[0])
var cam_y = camera_get_view_y(view_camera[0])
var cam_w = camera_get_view_width(view_camera[0])
var cam_h = camera_get_view_height(view_camera[0])

mbleftpress=mouse_check_button_pressed(mb_left)
mbleftrel=mouse_check_button_released(mb_left)
mbleft=mouse_check_button(mb_left)
mbmiddle=mouse_check_button(mb_middle)

curs_x=mouse_x-cam_x
curs_y=mouse_y-cam_y

var guiw=display_get_gui_width()
var guih=display_get_gui_height()
var tb_length = array_length(toolbar[selected_mode])
not_on_gui= !point_in_rectangle(curs_x,curs_y,(guiw-16)-(32*14),0,(guiw-16)-(32*14)+(32*tb_length)+4,34)
&&!point_in_rectangle(curs_x,curs_y,(guiw)-(32*5),0,(guiw)-(32*5)+(32*5)+4,34)
&&!point_in_rectangle(curs_x,curs_y,0,(guih/4)-10,32,(guih/4)-10+(32*5)+4)
	
if (show_tileset) {
	not_on_gui = false	
}



#region Camera Panning
if (not_on_gui) && (mbmiddle) {
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

#region Camera Zooming
//THIS SHIT KILLS MY COMBO!!!!!!
/*var mwheel = mouse_wheel_down() - mouse_wheel_up();

if (mwheel != 0) {
	zoom_level += 0.125*mwheel
	
	cam_x -= floor(cam_w/2);
	cam_y -= floor(cam_h/2);
}
zoom_level=clamp(zoom_level,0.125, 5)

camera_set_view_size(view_camera[0], floor(480*zoom_level), floor(270*zoom_level))*/
#endregion

gridx = floor(mouse_x/16)
gridy = floor(mouse_y/16)

if keyboard_check_pressed(vk_escape) room_goto(rMainMenu)

//half temp cycling object/tile behavior
switch(selected_mode) {
	case TILE_MODE:
	if selected_tool = BRUSH_TOOL {
		if mouse_wheel_down() {
			current_tile_id ++	
		}

		if mouse_wheel_up() {
			current_tile_id --
		}
	
		if keyboard_check_pressed(vk_apostrophe) {
			show_tileset = 1 - show_tileset 	
		}
	} else {
		show_tileset = false
	}
	
	//current_tile_id = wrap_val(current_tile_id, 0, 255) //todo, get tileset size lol

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
	if mouse_in_setting_slot(3) { //saving
		JADE_save()
	}
	if mouse_in_setting_slot(2) { //loading
		JADE_load()
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
						//var arr =ds_map_find_value(obj_data,selected_obj)
						show_debug_message("created object: {0}", selected_obj)
						ds_list_add(object_layer_map, [selected_obj, gridx, gridy, 1, 1, 0])//add object to list at place
						var obj = ds_list_find_value(object_layer_map, ds_list_size(object_layer_map)-1)
						var sprite = ds_map_find_value(obj_data,obj[0])
						if !is_undefined(obj) {
							obj[6] = sprite[4]	
							obj[7] = sprite[5]	
							obj[8] = 0
							obj[9] = 0	
						}
						
						/*OBJECT STAT LIST
						 0: name
						 1: grid x
						 2: grid y
						 3: scale x
						 4: scale y
						 5: selected
						 6: box x
						 7: box y
						 8: offset x
						 9: offset y
						*/
						
						/*SPRITE STAT LIST
						 just look in JADE_intializeobj() lol
						*/
					}
				break;
			}
		}
		switch(selected_tool) {
		case FLIP_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					data = tile_set_flip(data, 1 - tile_get_flip(data))
					tilemap_set(tilemap, data, gridx, gridy);
				break;
			}
		break;
		case MIRROR_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					data = tile_set_mirror(data, 1 - tile_get_mirror(data))
					tilemap_set(tilemap, data, gridx, gridy);
				break;
			}
		break;
		case ROTATE_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					data = tile_set_rotate(data, 1 - tile_get_rotate(data))
					tilemap_set(tilemap, data, gridx, gridy);
				break;
			}
		break;
		}
	}
}

if (selected_tool == SELECT_TOOL && not_on_gui) {
	
	var size = ds_list_size(object_layer_map)
	var overlap = 0
	var 
	
	
	
	for (var i = 0; i < size; ++i) {
		//is place matching cursor?
		var obj = ds_list_find_value(object_layer_map, i)
		var sprite = ds_map_find_value(obj_data,obj[0])
		var red_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16) + obj[6] -2, (obj[2]*16) + obj[7] -2,(obj[1]*16) + obj[6] +2, (obj[2]*16) + obj[7] +2)
		var white_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16) - 4, (obj[2]*16) - 4,(obj[1]*16) + obj[6] + 4, (obj[2]*16) + obj[7] + 4 )
		overlap=red_box+white_box
		
		if !is_undefined(obj) {
			if !red_box { 
				//if not selecting red box
				if (mbleftpress) {
					if white_box{ 
						//selecting white area (kinda)
						obj[5] = 1 
					} else {
						if !keyboard_check(vk_shift) {
							obj[5] = 0 //set all others unselected when not holding shift
						}
					}
				}
			}
			
			if selection_box {
				if rectangle_in_rectangle((obj[1]*16) , (obj[2]*16) ,(obj[1]*16) + obj[6] , (obj[2]*16) + obj[7], selection_box_x, selection_box_y, selection_box_x + (mouse_x - selection_box_x), selection_box_y + (mouse_y - selection_box_y)) {
					obj[5] = 1 
				} else {
					if !keyboard_check(vk_shift) {
							obj[5] = 0 //set all others unselected when not holding shift
					}
				}
			}
			
		
		}
	}
	
	for (var i = 0; i < size; ++i) {
		var obj = ds_list_find_value(object_layer_map, i)
		var sprite = ds_map_find_value(obj_data,obj[0])
		var red_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16) + obj[6] -2, (obj[2]*16) + obj[7] -2,(obj[1]*16) + obj[6] +2, (obj[2]*16) + obj[7] +2)
		var white_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16) - 4, (obj[2]*16) - 4,(obj[1]*16) + obj[6] + 4, (obj[2]*16) + obj[7] + 4 )
		//is object selected?
		if obj[5] = 1 {
			#region move
			if !red_box	{
				if white_box && mbleftpress && selection = 0 && !selection_box{ 
					selection = 2
					selection_id = i
					break;
				}
			}
			
			if selection = 2 {
				selection_x[i] = mouse_x - (obj[1]*16)
				selection_y[i] = mouse_y - (obj[2]*16)
			}
			
			if selection = 3 {
				obj[1] = round((mouse_x - selection_x[i]) / 16) 
				obj[2] = round((mouse_y - selection_y[i]) / 16) 
			}
			
			#endregion
			#region resize
				if red_box && mbleftpress && selection = 0 && !selection_box{ //red box selected
						selection = 1
						selection_id = i //boxed up
				}

			
				if selection = 1 && i = selection_id {
						var grabx = mouse_x - (obj[1]*16)
						var graby = mouse_y - (obj[2]*16)
						obj[6] = abs(grabx) + min(grabx, 0)//box movement
						obj[7] = abs(graby) + min(graby, 0)

				}
				if selection = 1 && mbleftrel {
				
					obj = ds_list_find_value(object_layer_map, selection_id) //object you resized
					var obj_other = ds_list_find_value(object_layer_map, i) //every other object selected
					
					obj[6] = round(obj[6] /16) * 16 //rounding box to grid
					obj[7] = round(obj[7] /16) * 16
				

					obj_other[3] = obj[6] / sprite[4] //setting scale
					obj_other[4] = obj[7] / sprite[5]
					obj_other[6] = obj[6] 
					obj_other[7] = obj[7]	
					obj_other[8] = (sprite[2] = 0) ? 0 : sprite[2] + (sprite[4]/2) * obj_other[3] //setting offset
					obj_other[9] = (sprite[3] = 0) ? 0 : sprite[3] + (sprite[5]/2) * obj_other[4]
					
				
				}
			#endregion
			
		} 

			if (i = size - 1) && selection > 0 {
				switch selection {
					case 2:
						selection = 3
					break;
					default:
						if mbleftrel {
							selection = 0
							selection_id = NaN
						}
					break;
				}
			}
			
			if mbleftrel && selection_box && (i == size - 1) {
					selection_box = false	
			}
	}
		
	if (!overlap) && mbleftpress && !selection_box && (!selection) {
		selection_box = true
		selection_box_x = mouse_x
		selection_box_y = mouse_y
	}
	
	if mbleftrel && selection_box {
		selection_box = false
	}
}

if show_tileset && mbleft {
	if (selected_mode = TILE_MODE) && (selected_tool = BRUSH_TOOL) {
		var tilelapmap = tileset_get_info(tTilesetMain)
		var t_width = sprite_get_width(spr_TilesetMain)
		var t_height  = sprite_get_height(spr_TilesetMain)
		var t_size = 16 * 0.33
		var sel_x = max(device_mouse_x_to_gui(0) - 50, 0)
		var sel_y = max(device_mouse_y_to_gui(0) - 50, 0)
		//show_debug_message(string(floor(mouse_x / t_size)) + " : "+ string(tilelapmap.width/ 16))
		current_tile_id = clamp(floor(sel_x / t_size), 0, t_width/ 16) + (clamp(floor(sel_y / t_size), 0, t_height/ 16) * (t_width/16))
		
	}
}



if (mbleft && not_on_gui) {
	
		switch(selected_tool) {
		case BRUSH_TOOL:
			switch(selected_mode) {
				case OBJECT_MODE:
				break;
				case TILE_MODE:
					if show_tileset {
						exit;	
					}
					
					var data = tilemap_get_at_pixel(tilemap, gridx, gridy); //set tile at place
					if tile_get_index(data) != current_tile_id { //prevent tile overlapping (mainly a problem with the list)
						show_debug_message($"Placed tile of index {current_tile_id} at {mouse_x} {mouse_y}")
						ds_list_add(tile_layer_map, [current_tile_id, gridx, gridy])//add tile  to list at place
						data = tile_set_index(data, current_tile_id)
						tilemap_set(tilemap, data, gridx, gridy);
					}
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
		case PICKER_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					if tile_get_index(data) != current_tile_id && not_on_gui {
						current_tile_id = tile_get_index(data)
						selected_toolbar = 0
					}
				break;
			}
		break;
		
		
		}
	
}

