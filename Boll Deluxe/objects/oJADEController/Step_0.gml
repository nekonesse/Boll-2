var cam_x = camera_get_view_x(view_camera[0])
var cam_y = camera_get_view_y(view_camera[0])
var cam_w = camera_get_view_width(view_camera[0])
var cam_h = camera_get_view_height(view_camera[0])

if !surface_exists(object_list_area_surface) {
	object_list_area_surface = surface_create(object_list_area_width, object_list_area_height)
}

mbleftpress=mouse_check_button_pressed(mb_left)
mbleftrel=mouse_check_button_released(mb_left)
mbleft=mouse_check_button(mb_left)
mbrightpress=mouse_check_button_pressed(mb_right)
mbrightrel=mouse_check_button_released(mb_right)
mbright=mouse_check_button(mb_right)
mbmiddle = (mouse_check_button(mb_middle) || (keyboard_check(vk_space) && mouse_check_button(mb_left))) //this scroll wheel is Pissing me off... i'm the original        keywalker

curs_x=mouse_x-cam_x
curs_y=mouse_y-cam_y

var guiw=display_get_gui_width()
var guih=display_get_gui_height()
var tb_length = array_length(toolbar[selected_mode])
on_list_top = (point_in_rectangle(curs_x,curs_y,object_list_area_x,object_list_area_y-20,object_list_area_x+object_list_area_width/3,object_list_area_y) || point_in_rectangle(curs_x,curs_y,object_list_area_x,object_list_area_y-20,object_list_area_x+object_list_area_width/3,object_list_area_y))
on_object_list = (point_in_rectangle(curs_x,curs_y,object_list_area_x-2,object_list_area_y-24,object_list_area_x+object_list_area_width/3,object_list_area_y+object_list_area_height/3) && (show_object_list || object_list_active))
if (!on_object_list && object_list_active && show_object_list) on_object_list = keyboard_check_direct(vk_alt)

not_on_gui= !point_in_rectangle(curs_x,curs_y,(guiw-16)-(32*14),0,(guiw-16)-(32*14)+(32*tb_length)+4,34)
&&!point_in_rectangle(curs_x,curs_y,(guiw)-(32*5),0,(guiw)-(32*5)+(32*5)+4,34)
&&!point_in_rectangle(curs_x,curs_y,0,(guih/4)-10,32,(guih/4)-10+(32*5)+4)
&&!(((on_object_list && show_object_list) || on_list_top) && (selected_mode==OBJECT_MODE || selected_mode==NODE_MODE))
&&!(show_tileset && selected_mode==TILE_MODE)

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

var mwheel = mouse_wheel_down() - mouse_wheel_up();
if (mwheel == 0) {
	mwheel = keyboard_check_direct(vk_down) - keyboard_check_direct(vk_up)
}

var dir = (keyboard_check_pressed(vk_right) || mouse_check_button_pressed(mb_side1)) - (mouse_check_button_pressed(mb_side2) || keyboard_check_pressed(vk_left)) 
//peopne who dont have a fancy gaming mouse or whatever finally getting a taste of the button Not Existing

if (selected_mode==OBJECT_MODE || selected_mode==NODE_MODE) {
	#region Object List Scrolling
	if (mwheel != 0) && (on_object_list) {
		object_list_scroll_pos[selected_mode][current_cat]+=24*mwheel
	}

	object_list_scroll_pos[selected_mode][current_cat] = clamp(object_list_scroll_pos[selected_mode][current_cat], 0, (ds_list_size(jade_cats[selected_mode][current_cat])*32)-object_list_area_height)
	#endregion

	#region Category Switching
	if (dir != 0) && (on_object_list) {
		current_cat += dir
		if (current_cat < 0) {
			current_cat = (array_length(jade_cats[selected_mode]) - 1)
		} else if (current_cat >= array_length(jade_cats[selected_mode])) {
			current_cat = 0	
		}
	
		show_debug_message($"switched to category {current_cat}")
	}
	#endregion
} else if (selected_mode==TILE_MODE) {
	var layerdir=keyboard_check_pressed(vk_left) - keyboard_check_pressed(vk_right)
	if (layerdir != 0) {
		selected_tile_layer += dir
		if (selected_tile_layer < 0) {
			selected_tile_layer = (array_length(tile_layer) - 1)
		} else if (selected_tile_layer >= array_length(tile_layer)) {
			selected_tile_layer = 0	
		}
		tilemap=tile_layer[selected_tile_layer]
	}
}
#region Camera Zooming
//THIS SHIT KILLS MY COMBO!!!!!!
/*
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
			if (mwheel == 1 || keyboard_check_pressed(vk_pagedown)) {
				if !keyboard_check(vk_control)
				for (var i = 0; i <= tile_sel_width; ++i) {
						for (var j = 0; j <= tile_sel_height; ++j) {
							current_tile_id[i][j] --
						}
				}
				else
				for (var i = 0; i <= tile_sel_width; ++i) {
						for (var j = 0; j <= tile_sel_height; ++j) {
							current_tile_id[i][j] += (sprite_get_width(spr_TilesetMain)/16)
						}
				}
			}

			if (mwheel == -1 || keyboard_check_pressed(vk_pageup)) {
				if !keyboard_check(vk_control)
				for (var i = 0; i <= tile_sel_width; ++i) {
						for (var j = 0; j <= tile_sel_height; ++j) {
							current_tile_id[i][j] ++
						}
				}
				else
				for (var i = 0; i <= tile_sel_width; ++i) {
						for (var j = 0; j <= tile_sel_height; ++j) {
							current_tile_id[i][j] -= (sprite_get_width(spr_TilesetMain)/16)
						}
				}
			}
		}
		
		if keyboard_check_pressed(vk_tab) {
			show_tileset = !show_tileset
		}
	
		//current_tile_id[0][0] = wrap_val(current_tile_id[0][0], 0, 255) //todo, get tileset size lol

		selected_tile=current_tile_id[0][0]
	break;
	case NODE_MODE:
	case OBJECT_MODE:
		if keyboard_check_pressed(vk_tab) {
			show_object_list = !show_object_list
		}
		
		var switch_obj = 0;
		
		if (keyboard_check_pressed(vk_pagedown)) {
			current_obj_id[selected_mode][current_cat] ++
			switch_obj = 1;
		}

		if (keyboard_check_pressed(vk_pageup)) {
			current_obj_id[selected_mode][current_cat] --
			switch_obj = 1;
		}

		current_obj_id[selected_mode][current_cat] = wrap_val(current_obj_id[selected_mode][current_cat], 0, ds_list_size(jade_cats[selected_mode][current_cat])- 1)

		if (switch_obj) { //keeps object through category switch until you scroll through the list for convenience
			selected_obj = ds_list_find_value(jade_cats[selected_mode][current_cat], current_obj_id[selected_mode][current_cat])
		}
		
		//selection box deleting
		if keyboard_check_pressed(vk_delete) && selected_tool==SELECT_TOOL {
			if (selected_mode==OBJECT_MODE) {
				for (var i = 0; i < ds_list_size(object_layer_map); ++i) {
					var obj = ds_list_find_value(object_layer_map, i)
					var sprite = ds_map_find_value(obj_data,obj[0])
					if (sprite[7]==selected_mode) && (obj[5]) {
						ds_list_delete(object_layer_map, i)
						i-- //since ds lists push all values up when one is deleted, we have to shift accordingly
					} 
				}
			} else if (selected_mode==NODE_MODE) {
				for (var i = 0; i < ds_list_size(node_layer_map); ++i) {
					var obj = ds_list_find_value(node_layer_map, i)
					var sprite = ds_map_find_value(obj_data,obj[0])
					if (sprite[7]==selected_mode) && (obj[5]) {
						ds_list_delete(node_layer_map, i)
						i-- //since ds lists push all values up when one is deleted, we have to shift accordingly
					} 
				}
			}
		}
	break;
}

for (var i = 0; i < 5; ++i)
{
	if (mbleftpress) && mouse_in_mode_slot(i) {
		if selected_mode != i {
			selected_toolbar=0
			selected_mode=i
			selection = false
			var size = ds_list_size(object_layer_map)
			for (var i = 0; i < size; ++i) {
				var obj = ds_list_find_value(object_layer_map, i)
		
				if !is_undefined(obj) {
					obj[5]=0;
				}
			}
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
		var file = get_save_filename_ext("JADE File|*.jade", "", working_directory, "Save Level");
		if string_length(file) != 0 { 
			savetextdur=60;
			global.save_dir=file
			JADE_save(file)
		}
	}
	if mouse_in_setting_slot(2) { //loading
		var file = get_open_filename_ext("JADE File|*.jade", "", working_directory, "Load Level");
		if string_length(file) != 0 {
			global.save_dir=file
			JADE_load(file)
		}
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
					show_debug_message(data);
					tile_update_properties();
				break;
			}
		break;
		case MIRROR_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					data = tile_set_mirror(data, 1 - tile_get_mirror(data))
					tilemap_set(tilemap, data, gridx, gridy);
					tile_update_properties();
				break;
			}
		break;
		case ROTATE_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					data = tile_set_rotate(data, 1 - tile_get_rotate(data))
					tilemap_set(tilemap, data, gridx, gridy);
					tile_update_properties();
				break;
			}
		break;
		}
	} else if !(not_on_gui) && !((on_object_list && show_object_list) || on_list_top) drawing_node=-1;
}

if (selected_tool == SELECT_TOOL && not_on_gui && !keyboard_check(vk_space)) {
	var overlap = 0
	
	if (selected_mode == OBJECT_MODE) { //should probably be using a switch statement but its 3am im too lazy to do that rn
		var size = ds_list_size(object_layer_map)
	
		for (var i = 0; i < size; ++i) {
			//is place matching cursor?
			var obj = ds_list_find_value(object_layer_map, i)
		
			if !is_undefined(obj) {
				var sprite = ds_map_find_value(obj_data,obj[0])
				var red_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16) + obj[6] -2, (obj[2]*16) + obj[7] -2,(obj[1]*16) + obj[6] +2, (obj[2]*16) + obj[7] +2)
				var white_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16), (obj[2]*16),(obj[1]*16) + obj[6] - 1, (obj[2]*16) + obj[7]- 1)
				overlap=red_box+white_box
			
				if !red_box { 
					//if not selecting red box
					if (mbleftpress) && (not_on_gui) {
						open_dropmenu=0;
						if white_box{ 
							//selecting white area (kinda)
							obj[5] = 1 
						} else {
							if !keyboard_check(vk_shift) && (not_on_gui) {
								obj[5] = 0 //set all others unselected when not holding shift
							}
						}
					}
				} else break
			
				if !red_box && (selection_box) && (not_on_gui) && (mbleftrel) && !(selection_box_x == mouse_x && selection_box_y == mouse_y) {
					open_dropmenu=0;
					if rectangle_in_rectangle((obj[1]*16) , (obj[2]*16) ,(obj[1]*16) + obj[6] - 1, (obj[2]*16) + obj[7] - 1, selection_box_x, selection_box_y, selection_box_x + (mouse_x - selection_box_x), selection_box_y + (mouse_y - selection_box_y)) {
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
			var white_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16), (obj[2]*16),(obj[1]*16) + obj[6] - 1, (obj[2]*16) + obj[7]-1)
			//is object selected?
			if obj[5] {
				#region move
				if !red_box	{
					if white_box && mbleftpress && selection = 0 && !selection_box{ 
						selection = 2
						selection_id = i
						break;
					}
				}
				if selection = 2  {
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
				

						obj_other[3] = obj[6] / sprite[3] //setting scale
						obj_other[4] = obj[7] / sprite[4]
						obj_other[6] = obj[6] 
						obj_other[7] = obj[7]	
						obj_other[8] = (sprite[1] = 0) ? 0 : sprite[1] + (sprite[3]/2) * obj_other[3] //setting offset
						obj_other[9] = (sprite[2] = 0) ? 0 : sprite[2] + (sprite[4]/2) * obj_other[4]
					
				
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
	} else if (selected_mode==NODE_MODE) {
		var size = ds_list_size(node_layer_map)
	
		for (var i = 0; i < size; ++i) {
			//is place matching cursor?
			var obj = ds_list_find_value(node_layer_map, i)
		
			if !is_undefined(obj) {
				var sprite = ds_map_find_value(obj_data,obj[0])
				var red_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16) + obj[6] -2, (obj[2]*16) + obj[7] -2,(obj[1]*16) + obj[6] +2, (obj[2]*16) + obj[7] +2)
				var white_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16) - 4, (obj[2]*16) - 4,(obj[1]*16) + obj[6] + 4, (obj[2]*16) + obj[7] + 4 )
				overlap=red_box+white_box
			
				if !red_box { 
					//if not selecting red box
					if (mbleftpress) && (not_on_gui) {
						open_dropmenu=0;
						if white_box{ 
							//selecting white area (kinda)
							obj[5] = 1 
						} else {
							if !keyboard_check(vk_shift) && (not_on_gui) {
								obj[5] = 0 //set all others unselected when not holding shift
							}
						}
					}
				}
			
				if (selection_box) && (not_on_gui) {
					open_dropmenu=0;
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
			var obj = ds_list_find_value(node_layer_map, i)
			var sprite = ds_map_find_value(obj_data,obj[0])
			var red_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16) + obj[6] -2, (obj[2]*16) + obj[7] -2,(obj[1]*16) + obj[6] +2, (obj[2]*16) + obj[7] +2)
			var white_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16) - 4, (obj[2]*16) - 4,(obj[1]*16) + obj[6] + 4, (obj[2]*16) + obj[7] + 4 )
			//is object selected?
			if obj[5] {
				#region move
				if !red_box	{
					if (white_box && mbleftpress && !selection && !selection_box) { 
						selection = 2
						selection_id = i
						break;
					}
				}
			
				if (selection == 2) {
					selection_x[i] = mouse_x - (obj[1]*16)
					selection_y[i] = mouse_y - (obj[2]*16)
				}
			
				if (selection == 3) {
					obj[1] = round((mouse_x - selection_x[i]) / 16) 
					obj[2] = round((mouse_y - selection_y[i]) / 16) 
				}
			
				#endregion
				#region resize
					if (red_box && mbleftpress && selection == 0 && !selection_box) { //red box selected
							selection = 1
							selection_id = i //boxed up
					}

			
					if (selection = 1 && i = selection_id) {
							var grabx = mouse_x - (obj[1]*16)
							var graby = mouse_y - (obj[2]*16)
							obj[6] = abs(grabx) + min(grabx, 0)//box movement
							obj[7] = abs(graby) + min(graby, 0)

					}
					if (selection = 1 && mbleftrel) {
				
						obj = ds_list_find_value(node_layer_map, selection_id) //object you resized
						var obj_other = ds_list_find_value(node_layer_map, i) //every other object selected
					
						obj[6] = round(obj[6] /16) * 16 //rounding box to grid
						obj[7] = round(obj[7] /16) * 16
				

						obj_other[3] = obj[6] / sprite[3] //setting scale
						obj_other[4] = obj[7] / sprite[4]
						obj_other[6] = obj[6] 
						obj_other[7] = obj[7]	
						obj_other[8] = (sprite[1] = 0) ? 0 : sprite[1] + (sprite[3]/2) * obj_other[3] //setting offset
						obj_other[9] = (sprite[2] = 0) ? 0 : sprite[2] + (sprite[4]/2) * obj_other[4]
					
				
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
	}
	
	if (!overlap) && mbleftpress && !selection_box && (!selection) && not_on_gui {
		selection_box = true
		selection_box_x = mouse_x
		selection_box_y = mouse_y
	}
}

if (mbleftrel && selection_box) {
	selection_box = false
}

if show_tileset {
	
	if (selected_mode = TILE_MODE) {
		var tilelapmap = tileset_get_info(tTilesetMain)
		var t_width = sprite_get_width(spr_TilesetMain)
		var t_height  = sprite_get_height(spr_TilesetMain)
		var t_size = 16 * 0.33
		if (mbleftpress && !tile_drag) {
			var sel_x = clamp(device_mouse_x_to_gui(0) - tileset_picker_x, 0, t_width)
			var sel_y = clamp(device_mouse_y_to_gui(0) - tileset_picker_y, 0, t_height)
			//show_debug_message(string(floor(mouse_x / t_size)) + " : "+ string(tilelapmap.width/ 16))
			current_tile_id = -1
			current_tile_id = []
			current_tile_id[0][0] = clamp(floor(sel_x / t_size), 0, t_width/ 16) + (clamp(floor(sel_y / t_size), 0, t_height/ 16) * (t_width/16))
			tile_sel_height = 0
			tile_sel_width = 0
			tile_sel_last_x = clamp(floor(sel_x / t_size), 0, t_width/ 16)
			tile_sel_last_y = clamp(floor(sel_y / t_size), 0, t_height/ 16)
			tile_drag = true
		}
		if (mbleft && tile_drag) {
			var sel_x = clamp(device_mouse_x_to_gui(0) - tileset_picker_x, 0, t_width)
			var sel_y = clamp(device_mouse_y_to_gui(0) - tileset_picker_y, 0, t_height)
			tile_sel_width = max(clamp(floor(sel_x / t_size), 0, t_width/ 16) - tile_sel_last_x, 0 )
			tile_sel_height = max(clamp(floor(sel_y / t_size), 0, t_height/ 16) - tile_sel_last_y, 0)
		}
		
		if (mbleftrel && tile_drag) {
			var sel_x = clamp(device_mouse_x_to_gui(0) - tileset_picker_x, 0, t_width)
			var sel_y = clamp(device_mouse_y_to_gui(0) - tileset_picker_y, 0, t_height)
			//show_debug_message("{0}, {1}", tile_sel_width, tile_sel_height)
			for (var i = 0; i <= tile_sel_width; ++i) {
			    for (var j = 0; j <= tile_sel_height; ++j) {
				    current_tile_id[i][j] = (clamp(floor(sel_x / t_size), 0, t_width/ 16) + i - tile_sel_width) + ((clamp(floor(sel_y / t_size), 0, t_height/ 16) + j - tile_sel_height) * (t_width/16))
					show_debug_message("{0}, {1}: {2}", i, j, current_tile_id[i][j])
				}
			}
			tile_drag = false
		}
	}
}
	
if not_on_gui && selected_tool == FILL_TOOL && selected_mode == TILE_MODE {
	if (mbleftpress && !tile_fill) {
		fill_circle = false
		tile_fill_last_x = gridx
		tile_fill_last_y = gridy
		show_debug_message("testA")
		tile_fill = true
	}
	if (mbleftrel && tile_fill && !fill_circle) {
		show_debug_message("testB")
		var start_x = tile_fill_last_x 
		var start_y = tile_fill_last_y 
		var size_x = (gridx - tile_fill_last_x)
		var size_y = (gridy - tile_fill_last_y) 
		
		if size_x < 0 {
			start_x = gridx
			size_x = abs(size_x)
		}
		if size_y < 0 {
			start_y = gridy
			size_y = abs(size_y)
		}
		
		for (var i = 0; i < size_x; ++i) {
			for (var j = 0; j < size_y; ++j) {
				var data = tilemap_get(tilemap, tile_fill_last_x + (i *16), tile_fill_last_y+ (j *16)); //get tile to change data
				
				data = tile_set_index(data, current_tile_id[i mod (tile_sel_width + 1)][j mod (tile_sel_height + 1)])
				//set tile to a mosaic of the current tile 'brush'
				
				data = tile_set_flip(data, 0)
				data = tile_set_mirror(data, 0)
				data = tile_set_rotate(data, 0)
				tilemap_set(tilemap, data, start_x + i, start_y + j);

				var tiledata = tilemap_get(tilemap, start_x + i, start_y + j)
				ds_list_add(tile_layer_map[selected_tile_layer], [tiledata, start_x + i, start_y + j]) //add tile  to list at place
				tile_update_properties();
								
			}
		}
		tile_fill = false
						
	}
	if (mbrightpress && !tile_fill) {
		fill_circle = true
		tile_fill_last_x = gridx
		tile_fill_last_y = gridy
		show_debug_message("testA")
		tile_fill = true
	}
	if (mbrightrel && tile_fill && fill_circle) {
		var start_x = tile_fill_last_x 
		var start_y = tile_fill_last_y 
		var size_x = (gridx - tile_fill_last_x)
		var size_y = (gridy - tile_fill_last_y) 
		
		if size_x < 0 {
			start_x = gridx
			size_x = abs(size_x)
		}
		if size_y < 0 {
			start_y = gridy
			size_y = abs(size_y)
		}
		
		for (var i = 0; i < size_x; ++i) {
			for (var j = 0; j < size_y; ++j) {
				if !point_in_ellipse(((start_x + i) * 16)+8, ((start_y + j) * 16)+8, (size_x*16)-8, (size_y*16)-8, (start_x + size_x/2) * 16, (start_y + size_y/2) * 16) continue;
				
				var data = tilemap_get(tilemap, tile_fill_last_x + (i *16), tile_fill_last_y+ (j *16)); //get tile to change data
				
				data = tile_set_index(data, current_tile_id[i mod (tile_sel_width + 1)][j mod (tile_sel_height + 1)])
				//set tile to a mosaic of the current tile 'brush'
				
				data = tile_set_flip(data, 0)
				data = tile_set_mirror(data, 0)
				data = tile_set_rotate(data, 0)
				tilemap_set(tilemap, data, start_x + i, start_y + j);

				var tiledata = tilemap_get(tilemap, start_x + i, start_y + j)
				ds_list_add(tile_layer_map[selected_tile_layer], [tiledata, start_x + i, start_y + j]) //add tile  to list at place
				tile_update_properties();
								
			}
		}
		tile_fill = false
	}
}


if (mbleft && not_on_gui && !keyboard_check(vk_space)) {
		switch(selected_tool) {
		case BRUSH_TOOL:
			switch(selected_mode) {
				case OBJECT_MODE:
					if is_string(selected_obj) {
						for (var i = 0; i < ds_list_size(object_layer_map); ++i) {
							//is place matching cursor?
							var obj = ds_list_find_value(object_layer_map, i)
							if !is_undefined(obj) {
							    if obj[1] == gridx && obj[2] == gridy {
									exit;
								}
							}
						}
						if !is_undefined(selected_obj) {
							var sprite = ds_map_find_value(obj_data,selected_obj)
							if sprite[7]!=OBJECT_MODE exit;
							ds_list_add(object_layer_map, [selected_obj, gridx, gridy, 1, 1, 0])//add object to list at place
							show_debug_message("created object: {0}", selected_obj)
							var obj = ds_list_find_value(object_layer_map, ds_list_size(object_layer_map)-1)
							obj[6] = sprite[3]
							obj[7] = sprite[4]
							obj[8] = 0
							obj[9] = 0	
							obj[10] = [] //properties
							obj[11] = [] //node array
							obj[12] = [2,false,0,false,true,true] //node properties
							if is_array(sprite[8]) && array_length(sprite[8]) {
								for (var o = 0; o < array_length(sprite[8]); o++) { //god Damn.
									if is_array(sprite[8][o]) {
										obj[10][o] = array_create(1,0)
										array_copy(obj[10][o],0,sprite[8][o],0,array_length(sprite[8][o]))
										if is_array(sprite[8][o][4]) {
											obj[10][o][4] = array_create(1,0)
											array_copy(obj[10][o][4],0,sprite[8][o][4],0,array_length(sprite[8][o][4]))	
										}
									}
								}
							}
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
						 10: properties array
						*/
						
						/*SPRITE STAT LIST
						 just look in JADE_initializeobj() lol
						*/
					}
				break;
				case NODE_MODE:
					if is_string(selected_obj) {
						for (var i = 0; i < ds_list_size(node_layer_map); ++i) {
							//is place matching cursor?
							var obj = ds_list_find_value(node_layer_map, i)
							if !is_undefined(obj) {
							    if obj[1] == gridx && obj[2] == gridy {
									exit;
								}
							}
						}
						if !is_undefined(selected_obj) {
							var sprite = ds_map_find_value(obj_data,selected_obj)
							if sprite[7]!=NODE_MODE exit;
							ds_list_add(node_layer_map, [selected_obj, gridx, gridy, 1, 1, 0])//add object to list at place
							show_debug_message("created object: {0}", selected_obj)
							var obj = ds_list_find_value(node_layer_map, ds_list_size(node_layer_map)-1)
							obj[6] = sprite[3]
							obj[7] = sprite[4]
							obj[8] = 0
							obj[9] = 0	
							obj[10] = []
							obj[11] = []
							obj[12] = []
							if is_array(sprite[8]) && array_length(sprite[8]) {
								for (var o = 0; o < array_length(sprite[8]); o++) { //god Damn.
									if is_array(sprite[8][o]) {
										obj[10][o] = array_create(1,0)
										array_copy(obj[10][o],0,sprite[8][o],0,array_length(sprite[8][o]))
										if is_array(sprite[8][o][4]) {
											obj[10][o][4] = array_create(1,0)
											array_copy(obj[10][o][4],0,sprite[8][o][4],0,array_length(sprite[8][o][4]))	
										}
									}
								}
							}
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
						 10: properties array
						*/
						
						/*SPRITE STAT LIST
						 just look in JADE_initializeobj() lol
						*/
					}
				break;
				case TILE_MODE:
					if show_tileset {
						exit;	
					}
					for (var i = 0; i <= tile_sel_width; ++i) {
						for (var j = 0; j <= tile_sel_height; ++j) {
							var data = tilemap_get_at_pixel(tilemap, mouse_x + (i *16), mouse_y+ (j *16)); //set tile at place
							if tile_get_index(data) != current_tile_id[i][j] { //prevent tile overlapping (mainly a problem with the list)
								show_debug_message($"Placed tile of index {current_tile_id[i][j]} at {mouse_x + (i *16)} {mouse_y+ (j *16)}")
								data = tile_set_index(data, current_tile_id[i][j])
								data = tile_set_flip(data, 0)
								data = tile_set_mirror(data, 0)
								data = tile_set_rotate(data, 0)
								tilemap_set(tilemap, data, gridx + i, gridy + j);
								show_debug_message(data)
								var tiledata = tilemap_get(tilemap, gridx + i, gridy + j)
								ds_list_add(tile_layer_map[selected_tile_layer], [tiledata, gridx + i, gridy + j]) //add tile  to list at place
								tile_update_properties();
							}
						}
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
						    if obj[1] == gridx && obj[2] == gridy {
								show_debug_message("deleted object: {0}", obj[0])
								ds_list_delete(object_layer_map, i)//delete first object it finds there (probably bottom top? i don rembr)
								break;
							}
						}
				
					}
				break;
				case NODE_MODE:
					var size = ds_list_size(node_layer_map)
					for (var i = 0; i < size; ++i) {
						//is place matching cursor?
						var obj = ds_list_find_value(node_layer_map, i)
						if !is_undefined(obj) {
						    if obj[1] == gridx && obj[2] == gridy {
								show_debug_message("deleted object: {0}", obj[0])
								ds_list_delete(node_layer_map, i)//delete first object it finds there (probably bottom top? i don rembr)
								break;
							}
						}
				
					}
				break;
				case TILE_MODE:
					var data = tilemap_get(tilemap, gridx, gridy);
					
					if tile_get_index(data)!= 0 {
						show_debug_message($"Deleted tile of index {tile_get_index(data)} at {mouse_x} {mouse_y}")
						var array = [data, gridx, gridy]
						for (var i=0; i<ds_list_size(tile_layer_map[selected_tile_layer]); i++;) {
							if array_equals(ds_list_find_value(tile_layer_map[selected_tile_layer],i),array) {
								ds_list_delete(tile_layer_map[selected_tile_layer], i) //delete from tile map
								break;
							}
						}
						data = tile_set_empty(data)
						tilemap_set(tilemap, data, gridx, gridy); //delete tile at place lol
					}
				break;
			}
		break;
		case PICKER_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					if tile_get_index(data) != current_tile_id[0][0] && not_on_gui {
						current_tile_id = -1
						current_tile_id = []
						current_tile_id[0][0] = tile_get_index(data)
						tile_sel_height = 0
						tile_sel_width = 0
						selected_toolbar = 0
					}
				break;
			}
		break;
		case FILL_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					
				break;
			}
		}
	
}
	
if (selected_tool==NODE_TOOL) && (not_on_gui) { //drawing nodes
	if (mbleftpress) {
		if (drawing_node==-1) {
			var size = ds_list_size(object_layer_map)
	
			for (var i = 0; i < size; ++i) {
				//is place matching cursor?
				var obj = ds_list_find_value(object_layer_map, i)
		
				if !is_undefined(obj) {
					var over = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16), (obj[2]*16),(obj[1]*16) + obj[6] - 1, (obj[2]*16) + obj[7] - 1)
					
					var sprite = ds_map_find_value(obj_data,obj[0])
					var xoff = -sprite[1];
					var yoff = -sprite[2];
					
					if (over) && (sprite[9]) {
						drawing_node=i;
						if !array_length(obj[11]) {
							draw_node_x=(obj[1]*16)-((obj[6]-16)/2)+xoff
							draw_node_y=(obj[2]*16)-((obj[7]-16)/2)+yoff
						} else {
							var length = array_length(obj[11])-1;
							draw_node_x=obj[11][length][0]+((obj[6]-16)/2);
							draw_node_y=obj[11][length][1]+((obj[7]-16)/2);
						}
						break;
					}
				}
			}
		} else {
			var obj = ds_list_find_value(object_layer_map, drawing_node)
			
			var sprite = ds_map_find_value(obj_data,obj[0])
			var xoff = -sprite[1];
			var yoff = -sprite[2];
			
			array_push(obj[11], [(gridx*16)-((obj[6]-16)/2)+xoff,(gridy*16)-((obj[7]-16)/2)+yoff,false])
			show_debug_message(obj[11])
			draw_node_x=(gridx*16)+xoff
			draw_node_y=(gridy*16)+yoff
		}
	}
	
	if (mbrightpress) {
		if (drawing_node!=-1) {
			var obj = ds_list_find_value(object_layer_map, drawing_node)
			var size = array_length(obj[11])
			if (size) {
				var sprite = ds_map_find_value(obj_data,obj[0])
				var xoff = -sprite[1];
				var yoff = -sprite[2];
			
				var deleted=false;
				for (var i = 0; i < size; ++i) {
					//is place matching cursor?
				
					var over = point_in_rectangle(mouse_x, mouse_y, obj[11][i][0]+((obj[6]-16)/2)-xoff, obj[11][i][1]+((obj[7]-16)/2)-yoff, obj[11][i][0]+15+((obj[6]-16)/2)-xoff, obj[11][i][1]+15+((obj[7]-16)/2)-yoff)
					
					if (over) {
						array_delete(obj[11],i,1)
						var size = array_length(obj[11])
						if (size) {
							draw_node_x=obj[11][size-1][0]+((obj[6]-16)/2);
							draw_node_y=obj[11][size-1][1]+((obj[7]-16)/2);
						}
						deleted=true;
						break
					}
				}
				if !(deleted)
				drawing_node=-1;
			} else {
				drawing_node=-1
			}
		}
	}
}

if keyboard_check_pressed(vk_enter) && !(is_typing) { //PLAYTEST
	JADE_save();
	global._playerChars = [oGlobals._charmList[0]]

	var myChar = get_string("Choose your character", oGlobals._charmList[0]) //debug jade charm select. not sure if this is what you meant by "multi-charm loading" but it can "load" "multi" "charm"
	//gamemaker i don't CARE if its deprecated because of async you cant choose your charm while the charm is already loading

	for (var i = 0; i < array_length(oGlobals._charmList); i++) {
		if (myChar == oGlobals._charmList[i]) {
			global._playerChars = [myChar]
			break;
		}
	}
	
	global.nextlevel="\save.jade" //the level the game will load
	global.jade_testing = true;
	room_goto(rGame)
}

if (keyboard_check(vk_control)) && keyboard_check_pressed(ord("S")) { //saving
	if (global.save_dir != "") {
		savetextdur=60;
		JADE_save(global.save_dir)
	} else {
		var file = get_save_filename_ext("JADE File|*.jade", "", $"{working_directory}\mods\\level\\", "Save Level");
		if string_length(file) != 0 { 
			savetextdur=60;
			global.save_dir=file
			JADE_save(file)
		}
	}
}

#region Tool Shortcuts
//probably replace these with keybindable ones later

if !(is_typing) {

if keyboard_check_pressed(ord("1")) || keyboard_check_pressed(vk_numpad1)  {
	selected_mode=0
	selected_toolbar=0;
}

if keyboard_check_pressed(ord("2")) || keyboard_check_pressed(vk_numpad2)  {
	selected_mode=1
	selected_toolbar=0;
}

if keyboard_check_pressed(ord("3")) || keyboard_check_pressed(vk_numpad3)  {
	selected_mode=2
	selected_toolbar=0;
}

if keyboard_check_pressed(ord("4")) || keyboard_check_pressed(vk_numpad4)  {
	selected_mode=3
	selected_toolbar=0;
}

if keyboard_check_pressed(ord("5")) || keyboard_check_pressed(vk_numpad5)  {
	selected_mode=4
	selected_toolbar=0;
}

if keyboard_check_pressed(ord("D")) && !keyboard_check(vk_control) {
	switch (selected_mode) {
		case OBJECT_MODE:
		case BACKGROUND_MODE:
		case NODE_MODE: {
			selected_toolbar=1;
			break;
		}
		case TILE_MODE: {
			selected_toolbar=0;
			break;
		}
	}
}

if keyboard_check_pressed(ord("S")) && !keyboard_check(vk_control) {
	switch (selected_mode) {
		case NODE_MODE:
		case BACKGROUND_MODE:
		case REGION_MODE:
		case OBJECT_MODE: {
			selected_toolbar=0;
			break;
		}
	}
}

if keyboard_check_pressed(ord("F")) && !keyboard_check(vk_control) {
	switch (selected_mode) {
		case OBJECT_MODE: {
			selected_toolbar=2;
			break;
		}
		case TILE_MODE: {
			selected_toolbar=1;
			break;
		}
	}
}

if keyboard_check_pressed(ord("E")) && !keyboard_check(vk_control) {
	switch (selected_mode) {
		case OBJECT_MODE:
		case NODE_MODE: {
			selected_toolbar=3;
			break;
		}
		case BACKGROUND_MODE:
		case TILE_MODE:
		case REGION_MODE: {
			selected_toolbar=2;
			break;
		}
	}
}

if keyboard_check_pressed(ord("I")) && !keyboard_check(vk_control) {
	switch (selected_mode) {
		case TILE_MODE:
		case BACKGROUND_MODE: {
			selected_toolbar=3;
			break;
		}
		case OBJECT_MODE: {
			selected_toolbar=4;
			break;
		}
	}
}

}

#endregion