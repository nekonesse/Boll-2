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
on_tile_picker = (point_in_rectangle(curs_x,curs_y,tileset_picker_x-2,tileset_picker_y-6,tileset_picker_x + (sprite_get_width(tilesets[$ current_tileset][0]) / (3 / tile_zoom)), tileset_picker_y + (sprite_get_height(tilesets[$ current_tileset][0]) / (3 / tile_zoom))) && (show_tileset))
if (!on_object_list && object_list_active && show_object_list) on_object_list = keyboard_check_direct(vk_alt)

not_on_gui= !point_in_rectangle(curs_x,curs_y,(guiw-16)-(32*14),0,(guiw-16)-(32*14)+(32*tb_length)+4,34)
&&!point_in_rectangle(curs_x,curs_y,0,(guih/3)-10,32,(guih/3)-10+(32*3)+4)
&&!(((on_object_list && show_object_list) || on_list_top) && (selected_mode==OBJECT_MODE || selected_mode==NODE_MODE))
&&!(on_tile_picker && selected_mode==TILE_MODE)

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
		show_debug_message(array_length(jade_cats[selected_mode]) )
		current_cat += dir
		if (current_cat < 0) {
			current_cat = (array_length(jade_cats[selected_mode]) - 1)
		} else if (current_cat >= array_length(jade_cats[selected_mode])) {
			current_cat = 0	
		}
	
		show_debug_message($"switched to category {current_cat}")
	}
	#endregion
} else if (selected_mode == TILE_MODE) {
	var layerdir = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left)
	if (layerdir != 0) {
		ui_opacity = 10;
		selected_tile_layer += layerdir
		if (selected_tile_layer < 0) {
			selected_tile_layer = (array_length(tile_layer) - 1)
		} else if (selected_tile_layer >= array_length(tile_layer)) {
			selected_tile_layer = 0	
		}
		tilemap=tile_layer[selected_tile_layer]
		current_tileset = tileset_get_name(tilemap_get_tileset(tilemap));
		tileset_picker_x = (guiw-(sprite_get_width(tilesets[$ current_tileset][0]) / 3))
		tileset_picker_y = ((guih/2) - (sprite_get_height(tilesets[$ current_tileset][0]) / 3) /2) - 8
	}
	if (ui_opacity > 0.4) {ui_opacity -= 0.05}
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

if (floor(mouse_x)!=mouse_x_prev || floor(mouse_y)!=mouse_y_prev || selected_tool!=tool_previous) {
	var _struct = {
		type: "curs_upd",
		_x: floor(mouse_x),
		_y: floor(mouse_y),
		_tool: selected_tool,
		_name: global.username
	}
	send_struct(_struct, global.socket);
}
mouse_x_prev=mouse_x;
mouse_y_prev=mouse_y;
tool_previous=selected_tool;

gridx = floor(mouse_x/16)
gridy = floor(mouse_y/16)

//half temp cycling object/tile behavior
switch(selected_mode) {
	case TILE_MODE:
		if keyboard_check_pressed(vk_tab) {
			show_tileset = !show_tileset
		}

		selected_tile=current_tile_id
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
	break;
}
//change toolbar 

if (mbleftpress) {
	if (not_on_gui) {
		if (global.actions_left)
		switch(selected_tool) {
		case FLIP_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					if tile_get_index(data)!= 0 {
						data = tile_set_flip(data, 1 - tile_get_flip(data))
						tilemap_set(tilemap, data, gridx, gridy);
						var tiledata = tilemap_get(tilemap, gridx, gridy)
						global.actions_left=max(global.actions_left-1,0);
						var network_struct = {
							type: "tile_fl",
							_layer: selected_tile_layer,
							_x: gridx,
							_y: gridy
						}	
						send_struct(network_struct, global.socket)
					}
				break;
			}
		break;
		case MIRROR_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					if tile_get_index(data)!= 0 {
						data = tile_set_mirror(data, 1 - tile_get_mirror(data))
						tilemap_set(tilemap, data, gridx, gridy);
						var tiledata = tilemap_get(tilemap, gridx, gridy)
						global.actions_left=max(global.actions_left-1,0);
						var network_struct = {
							type: "tile_mi",
							_layer: selected_tile_layer,
							_x: gridx,
							_y: gridy
						}	
						send_struct(network_struct, global.socket)
					}
				break;
			}
		break;
		case ROTATE_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					if tile_get_index(data)!= 0 {
						data = tile_set_rotate(data, 1 - tile_get_rotate(data))
						tilemap_set(tilemap, data, gridx, gridy);
						var tiledata = tilemap_get(tilemap, gridx, gridy)
						global.actions_left=max(global.actions_left-1,0);
						var network_struct = {
							type: "tile_rot",
							_layer: selected_tile_layer,
							_x: gridx,
							_y: gridy
						}	
						send_struct(network_struct, global.socket)
					}
				break;
			}
		break;
		}
	} else if !(not_on_gui) && !((on_object_list && show_object_list) || on_list_top) {
		var tb_length = array_length(toolbar[selected_mode])
		var i=0;
		repeat(tb_length)
		{
			if mouse_in_toolbar_slot(i) {
				selected_toolbar=i
				//show_message(selected_toolbar)
			}
			i++;
		}
		i=0;
		repeat(2)
		{
			if mouse_in_mode_slot(i) {
				if selected_mode != i {
					ui_opacity = 10
					selected_toolbar=0
					selected_mode=i
					selection = false
					var size = ds_list_size(object_layer_map)
					var j=0;
					repeat(size) {
						var obj = ds_list_find_value(object_layer_map, j)
		
						if !is_undefined(obj) {
							obj[5]=0;
						}
						j++;
					}
				}
			}
			i++
		}
		
		selected_tool=toolbar[selected_mode][selected_toolbar]
		drawing_node=-1;
		drawing_rotator=-1;
	}
}

if show_tileset {
	
	if (dir != 0 && keyboard_check(vk_alt)) {
		tile_zoom = (tile_zoom == 2 ? 1 : 2)
			
		tileset_picker_x = (guiw-((sprite_get_width(tilesets[$ current_tileset][0]) / 3) * tile_zoom)) - 8
		tileset_picker_y = ((guih/2) - ((sprite_get_width(tilesets[$ current_tileset][0]) / 3) * tile_zoom) /2) - 8
	}
	
	if (selected_mode = TILE_MODE && on_tile_picker) {
		var t_width = sprite_get_width(tilesets[$ current_tileset][0])
		var t_height  = sprite_get_height(tilesets[$ current_tileset][0])
		var t_size = 16 * (0.33 * tile_zoom)
		if (mbleftpress) {
			var sel_x = clamp(device_mouse_x_to_gui(0) - tileset_picker_x, 0, t_width)
			var sel_y = clamp(device_mouse_y_to_gui(0) - tileset_picker_y, 0, t_height)
			//show_debug_message(string(floor(mouse_x / t_size)) + " : "+ string(tilelapmap.width/ 16))
			current_tile_id = -1
			current_tile_id = clamp(floor(sel_x / t_size), 0, t_width/ 16) + (clamp(floor(sel_y / t_size), 0, t_height/ 16) * (t_width/16))
			tile_sel_height = 0
			tile_sel_width = 0
			tile_sel_last_x = clamp(floor(sel_x / t_size), 0, t_width/ 16)
			tile_sel_last_y = clamp(floor(sel_y / t_size), 0, t_height/ 16)
		}
	}
}

if (mbright && not_on_gui && global.actions_left) {
	switch(selected_tool) {
		case BRUSH_TOOL: {
			switch(selected_mode) {
				case OBJECT_MODE:
					var size = ds_list_size(object_layer_map)
					var i=0;
					repeat(size) {
						//is place matching cursor?
						var obj = ds_list_find_value(object_layer_map, i)
						if !is_undefined(obj) {
						    if obj[1] == gridx && obj[2] == gridy {
								ds_list_delete(object_layer_map, i)//delete first object it finds there (probably bottom top? i don rembr)
								global.actions_left=max(global.actions_left-1,0);
								var network_struct = {
									type: "obj_del",
									_x: gridx,
									_y: gridy
								}	
								send_struct(network_struct, global.socket)
								break;
							}
						}
						i++;
					}
				break;
				case NODE_MODE:
					var size = ds_list_size(node_layer_map)
					var i=0;
					repeat(size) {
						//is place matching cursor?
						var obj = ds_list_find_value(node_layer_map, i)
						if !is_undefined(obj) {
						    if obj[1] == gridx && obj[2] == gridy {
								ds_list_delete(node_layer_map, i)//delete first object it finds there (probably bottom top? i don rembr)
								global.actions_left=max(global.actions_left-1,0);
								var network_struct = {
									type: "node_del",
									_x: gridx,
									_y: gridy
								}	
								send_struct(network_struct, global.socket)
								break;
							}
						}
						i++;
					}
				break;
				case TILE_MODE: {
					if (selected_tool==BRUSH_TOOL) {
						var data = tilemap_get(tilemap, gridx, gridy);
						if tile_get_index(data)!= 0 {
							data = tile_set_empty(data)
							tilemap_set(tilemap, data, gridx, gridy); //delete tile at place lol
							global.actions_left=max(global.actions_left-1,0);
							var network_struct = {
								type: "tile_del",
								_layer: selected_tile_layer,
								_x: gridx,
								_y: gridy
							}
							send_struct(network_struct, global.socket)
						}
					}
				} break;
			}
		}
		break;
	}
}

if (mbleftpress && not_on_gui) {
	if (selected_tool == PICKER_TOOL) {
		var i=0;
		repeat(ds_list_size(object_layer_map)) {
			//is place matching cursor?
			var obj = ds_list_find_value(object_layer_map, i)
			if !is_undefined(obj) {
				if (obj[1]==gridx && obj[2]==gridy) {
					var j=0;
					repeat (array_length(jade_cats[selected_mode])) {
						var k=0;
						repeat(ds_list_size(jade_cats[selected_mode][j])) {
							var arr=ds_list_find_value(jade_cats[selected_mode][j], k)
							if (arr[0]==obj[0]) {
								current_obj_id[selected_mode][j]=k
								selected_obj = arr[0]
								break;
							}
							k++;
						}
						j++;
					}
					break
				}
			}
			i++;
		}
	} else if (selected_tool == SELECT_TOOL) {
			switch(selected_mode) {
				case OBJECT_MODE:
					var i=0;
					repeat(ds_list_size(object_layer_map)) {
						//is place matching cursor?
						var obj = ds_list_find_value(object_layer_map, i)
						if !is_undefined(obj) {
								obj[5] = 0
						}
						i++;
					}
					if is_string(selected_obj) {
						var i=0;
						repeat(ds_list_size(object_layer_map)) {
							//is place matching cursor?
							var obj = ds_list_find_value(object_layer_map, i)
							if !is_undefined(obj) {
								var sprite = ds_map_find_value(obj_data,obj[0])
								var red_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16) + obj[6] -2, (obj[2]*16) + obj[7] -2,(obj[1]*16) + obj[6] +2, (obj[2]*16) + obj[7] +2)
								var white_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16), (obj[2]*16),(obj[1]*16) + obj[6] - 1, (obj[2]*16) + obj[7]- 1)
								if !red_box && white_box { 
									obj[5] = 1
									show_debug_message(obj[10])
									temptypingstring=""
									is_typing=0;
									open_dropmenu=0;
									object_list_active = 0
									properties_tab_active = 1
									show_object_list = 1
									break
								}
							}
							i++;
						}
					}
				break;
				case NODE_MODE:
					if is_string(selected_obj) {
						var i=0;
						repeat(ds_list_size(node_layer_map)) {
							//is place matching cursor?
							var obj = ds_list_find_value(node_layer_map, i)
							if !is_undefined(obj) {
									obj[5] = 0
							}
							i++;
						}
						repeat(ds_list_size(node_layer_map)) {
							//is place matching cursor?
							var obj = ds_list_find_value(node_layer_map, i)
							if !is_undefined(obj) {
								var sprite = ds_map_find_value(obj_data,obj[0])
								var red_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16) + obj[6] -2, (obj[2]*16) + obj[7] -2,(obj[1]*16) + obj[6] +2, (obj[2]*16) + obj[7] +2)
								var white_box = point_in_rectangle(mouse_x, mouse_y, (obj[1]*16), (obj[2]*16),(obj[1]*16) + obj[6] - 1, (obj[2]*16) + obj[7]- 1)
								if !red_box && white_box { 
									obj[5] = 1
									temptypingstring=""
									is_typing=0;
									open_dropmenu=0;
									object_list_active = 0
									properties_tab_active = 1
									show_object_list = 1
									break
								}
							}
							i++;
						}
					}
				break;
			}
	}
}

if (mbleft && not_on_gui && !keyboard_check(vk_space) && global.actions_left) {
		switch(selected_tool) {
		case BRUSH_TOOL:
			if (drawing_object==-1)
			switch(selected_mode) {
				case OBJECT_MODE:
					if is_string(selected_obj) {
						var i=0;
						repeat(ds_list_size(object_layer_map)) {
							//is place matching cursor?
							var obj = ds_list_find_value(object_layer_map, i)
							if !is_undefined(obj) {
							    if obj[1] == gridx && obj[2] == gridy {
									exit;
								}
							}
							i++;
						}
						if !is_undefined(selected_obj) {
							drawing_object=selected_obj;
							drawing_object_x=gridx;
							drawing_object_y=gridy;
						}
					}
				break;
				case NODE_MODE:
					if is_string(selected_obj) {
						var i=0;
						repeat(ds_list_size(node_layer_map)) {
							//is place matching cursor?
							var obj = ds_list_find_value(node_layer_map, i)
							if !is_undefined(obj) {
							    if obj[1] == gridx && obj[2] == gridy {
									exit;
								}
							}
							i++;
						}
						
					}
				break;
				case TILE_MODE:
					if show_tileset && on_tile_picker {
						exit;	
					}
					var data = tilemap_get(tilemap, gridx, gridy)
					if tile_get_index(data) != current_tile_id { //prevent tile overlapping (mainly a problem with the list)
						show_debug_message($"Placed tile of index {current_tile_id} at {gridx} {gridy}")
						data = tile_set_index(data, current_tile_id)
						data = tile_set_flip(data, 0)
						data = tile_set_mirror(data, 0)
						data = tile_set_rotate(data, 0)
						tilemap_set(tilemap, data, gridx, gridy);
						show_debug_message(data)
						global.actions_left=max(global.actions_left-1,0);
						var network_struct = {
							type: "tile_pl",
							uuid: current_tile_id,
							_layer: selected_tile_layer,
							_x: gridx,
							_y: gridy,
						}
						send_struct(network_struct, global.socket)
					}
				break;
			}
		break;
		case ERASE_TOOL:
			switch(selected_mode) {
				case OBJECT_MODE:
					var size = ds_list_size(object_layer_map)
					var i=0;
					repeat(size) {
						//is place matching cursor?
						var obj = ds_list_find_value(object_layer_map, i)
						if !is_undefined(obj) {
						    if obj[1] == gridx && obj[2] == gridy && obj[0]!="oPlayerSpawn" {
								show_debug_message("deleted object: {0}", obj[0])
								ds_list_delete(object_layer_map, i) //delete first object it finds there (probably bottom top? i don rembr)
								global.actions_left=max(global.actions_left-1,0);
								var network_struct = {
									type: "obj_del",
									_x: gridx,
									_y: gridy
								}	
								send_struct(network_struct, global.socket)
								break;
							}
						}
						i++;
					}
				break;
				case NODE_MODE:
					var size = ds_list_size(node_layer_map)
					var i=0;
					repeat(size){
						//is place matching cursor?
						var obj = ds_list_find_value(node_layer_map, i)
						if !is_undefined(obj) {
						    if obj[1] == gridx && obj[2] == gridy {
								show_debug_message("deleted object: {0}", obj[0])
								ds_list_delete(node_layer_map, i)//delete first object it finds there (probably bottom top? i don rembr)
								global.actions_left=max(global.actions_left-1,0);
								var network_struct = {
									type: "node_del",
									_x: gridx,
									_y: gridy
								}	
								send_struct(network_struct, global.socket)
								break;
							}
						}
						i++;
					}
				break;
				case TILE_MODE:
					var data = tilemap_get(tilemap, gridx, gridy);
					
					if tile_get_index(data)!= 0 {
						data = tile_set_empty(data)
						tilemap_set(tilemap, data, gridx, gridy); //delete tile at place lol
						global.actions_left=max(global.actions_left-1,0);
						var network_struct = {
							type: "tile_del",
							_layer: selected_tile_layer,
							_x: gridx,
							_y: gridy
						}	
						send_struct(network_struct, global.socket)
						break;
					}
				break;
			}
		break;
		case PICKER_TOOL:
			switch(selected_mode) {
				case TILE_MODE:
					var data = tilemap_get_at_pixel(tilemap, mouse_x, mouse_y);
					if tile_get_index(data) != current_tile_id && not_on_gui {
						current_tile_id = -1
						current_tile_id = tile_get_index(data)
						tile_sel_height = 0
						tile_sel_width = 0
						selected_toolbar = 0
					}
				break;
			}
		break;
		}
}

if (drawing_object!=-1) && (mbleftrel) {
	if (selected_mode==OBJECT_MODE) {
		var sprite = ds_map_find_value(obj_data, drawing_object)
		if sprite[7]!=OBJECT_MODE exit;
		var box_w, box_h;
		var x_scale, y_scale;
		if sprite[5] {
			box_w = clamp(max(floor(gridx - drawing_object_x)+1, 1),1,11)
			x_scale = ((box_w*16)/sprite[3])*sprite[11];
		} else {
			box_w = 1
			x_scale = 1
		} 
		if sprite[6] {
			box_h = clamp(max(floor(gridy - drawing_object_y)+1, 1),1,11)
			y_scale = ((box_h*16)/sprite[4])*sprite[12]
		} else {
			box_h = 1
			y_scale = 1
		}
		ds_list_add(object_layer_map, [drawing_object, drawing_object_x, drawing_object_y, x_scale,y_scale, 0])//add object to list at place
		show_debug_message("created object: {0}", drawing_object)
		var obj = ds_list_find_value(object_layer_map, ds_list_size(object_layer_map)-1)
		obj[6] = sprite[3]
		obj[7] = sprite[4]
		obj[8] = (sprite[1] = 0) ? 0 : sprite[1] + (sprite[3]/2) * obj[3] 
		obj[9] = (sprite[2] = 0) ? 0 : sprite[2] + (sprite[4]/2) * obj[4]
		obj[10] = [] //properties
		obj[11] = [] //node array
		obj[12] = [2,false,0,false,true,true] //node properties
		obj[13] = [] //rotator array
		obj[14] = [2,false,false,false] //rotator properties
		if is_array(sprite[8]) && array_length(sprite[8]) {
			var o=0;
			repeat(array_length(sprite[8])) { //god Damn.
				if is_array(sprite[8][o]) {
					obj[10][o] = array_create(1,0)
					array_copy(obj[10][o],0,sprite[8][o],0,array_length(sprite[8][o]))
					if is_array(sprite[8][o][4]) {
						obj[10][o][4] = array_create(1,0)
						array_copy(obj[10][o][4],0,sprite[8][o][4],0,array_length(sprite[8][o][4]))	
					}
				}
				o++;
			}
		}		
		global.actions_left=max(global.actions_left-1,0);
		var network_struct = {
			type: "obj_pl",
			uuid: drawing_object,
			_x: drawing_object_x,
			_y: drawing_object_y,
			_xscale: obj[3],
			_yscale: obj[4]
		}	
		send_struct(network_struct, global.socket)
		drawing_object=-1;
		drawing_object_x=0;
		drawing_object_y=0;
	} else {
		var sprite = ds_map_find_value(obj_data,drawing_object)
		if sprite[7]!=NODE_MODE exit;
		var box_w, box_h;
		var x_scale, y_scale;
		if sprite[5] {
			box_w = clamp(max(floor(gridx - drawing_object_x)+1, 1),1,11)
			x_scale = ((box_w*16)/sprite[3])*sprite[11];
		} else {
			box_w = 1
			x_scale = 1
		} 
		if sprite[6] {
			box_h = clamp(max(floor(gridy - drawing_object_y)+1, 1),1,11)
			y_scale = ((box_h*16)/sprite[4])*sprite[12]
		} else {
			box_h = 1
			y_scale = 1
		}
		ds_list_add(node_layer_map, [drawing_object, drawing_object_x, drawing_object_y, x_scale, y_scale, 0])//add object to list at place
		show_debug_message("created object: {0}", drawing_object)
		var obj = ds_list_find_value(node_layer_map, ds_list_size(node_layer_map)-1)
		obj[6] = sprite[3]
		obj[7] = sprite[4]
		obj[8] = (sprite[1] = 0) ? 0 : sprite[1] + (sprite[3]/2) * obj[3] 
		obj[9] = (sprite[2] = 0) ? 0 : sprite[2] + (sprite[4]/2) * obj[4]
		obj[10] = []
		obj[11] = []
		obj[12] = []
		obj[13] = []
		obj[14] = []
		if is_array(sprite[8]) && array_length(sprite[8]) {
			var o=0;
			repeat(array_length(sprite[8])) { //god Damn.
				if is_array(sprite[8][o]) {
					obj[10][o] = array_create(1,0)
					array_copy(obj[10][o],0,sprite[8][o],0,array_length(sprite[8][o]))
					if is_array(sprite[8][o][4]) {
						obj[10][o][4] = array_create(1,0)
						array_copy(obj[10][o][4],0,sprite[8][o][4],0,array_length(sprite[8][o][4]))	
					}
				}
				o++;
			}
		}
		global.actions_left=max(global.actions_left-1,0);
		var network_struct = {
			type: "node_pl",
			uuid: drawing_object,
			_x: drawing_object_x,
			_y: drawing_object_y,
			_xscale: x_scale,
			_yscale: y_scale //add the dragged xscale and yscale values here laters
		}	
		send_struct(network_struct, global.socket)
	}
}
	
if (selected_tool==NODE_TOOL) && (not_on_gui) && (global.actions_left) { //drawing nodes
	if (mbleftpress) {
		if (drawing_node==-1) {
			var size = ds_list_size(object_layer_map)
	
			var i=0;
			repeat(size) {
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
				i++;
			}
		} else {
			var obj = ds_list_find_value(object_layer_map, drawing_node)
			
			if is_array(obj) {
				var sprite = ds_map_find_value(obj_data,obj[0])
				var xoff = -sprite[1];
				var yoff = -sprite[2];
			
				array_push(obj[11], [(gridx*16)-((obj[6]-16)/2)+xoff,(gridy*16)-((obj[7]-16)/2)+yoff,false])
				global.actions_left=max(global.actions_left-1,0);
				var _struct = {
					type: "obj_node_make",
					uuid: obj[0],
					_x: obj[1],
					_y: obj[2],
					_slot: array_length(obj[11])-1,
					_value: [(gridx*16)-((obj[6]-16)/2)+xoff,(gridy*16)-((obj[7]-16)/2)+yoff,false]
				}
				send_struct(_struct, global.socket);
				show_debug_message(obj[11])
				draw_node_x=(gridx*16)+xoff
				draw_node_y=(gridy*16)+yoff
			} else drawing_node=-1;
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
				var i=0;
				repeat(size) {
					//is place matching cursor?
				
					var over = point_in_rectangle(mouse_x, mouse_y, obj[11][i][0]+((obj[6]-16)/2)-xoff, obj[11][i][1]+((obj[7]-16)/2)-yoff, obj[11][i][0]+15+((obj[6]-16)/2)-xoff, obj[11][i][1]+15+((obj[7]-16)/2)-yoff)
					
					if (over) {
						array_delete(obj[11],i,1)
						global.actions_left=max(global.actions_left-1,0);
						var _struct = {
							type: "obj_node_del",
							uuid: obj[0],
							_x: obj[1],
							_y: obj[2],
							_slot: i,
						}
						send_struct(_struct, global.socket);
						var size = array_length(obj[11])
						if (size) {
							draw_node_x=obj[11][size-1][0]+((obj[6]-16)/2);
							draw_node_y=obj[11][size-1][1]+((obj[7]-16)/2);
						}
						deleted=true;
						break
					}
					i++;
				}
				if !(deleted)
				drawing_node=-1;
			} else {
				drawing_node=-1
			}
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

if keyboard_check_pressed(ord("D")) && !keyboard_check(vk_control) {
	switch (selected_mode) {
		case OBJECT_MODE:
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
		case TILE_MODE: {
			selected_toolbar=2;
			break;
		}
	}
}

if keyboard_check_pressed(ord("I")) && !keyboard_check(vk_control) {
	switch (selected_mode) {
		case TILE_MODE: {
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