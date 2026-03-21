cam_x = camera_get_view_x(camera)
cam_y = camera_get_view_y(camera)
cam_w = camera_get_view_width(camera)
cam_h = camera_get_view_height(camera)
guiw = window_get_width();
guih = window_get_height();

if !os_is_paused() && guiw>0 && guih>0 {
	if !surface_exists(GUIcanvas) {
		GUIcanvas=surface_create(guiw,guih);
	} else {
		if (guiw!=surface_get_width(GUIcanvas) || guih!=surface_get_height(GUIcanvas)) {
			surface_resize(GUIcanvas,guiw,guih);
		}
	}
}

curs_x = window_mouse_get_x()
curs_y = window_mouse_get_y()

gridx = floor(mouse_x/current_grid_size) 
gridy = floor(mouse_y/current_grid_size)

autosave_time = max(autosave_time-1,0);
	
if (!autosave_time) {
	autosave_time = (60*30)
	JADE_save(game_save_id+"\\autosave.jade");
	displaytextdur=120;
	displaytext="Successfully autosaved!";
}

#region GUI Input Handler
var on_dropdown = false;
with(oJADEGUIpar) {
	if (point_in_rectangle(window_mouse_get_x(),window_mouse_get_y(),bbox_left,bbox_top,bbox_right-1,bbox_bottom-1))
	on_dropdown = true;
}

not_on_gui=
!point_in_rectangle(curs_x,curs_y,0,0,guiw,32+24)&&
!point_in_rectangle(curs_x,curs_y,0,24,guiw,32)&&
!point_in_rectangle(curs_x,curs_y,guiw-240,24,guiw,guih)&&
!point_in_rectangle(curs_x,curs_y,0,56,192,guih)&&
!playtestbutton.checkoverlap()&&
!on_dropdown

if (mbleftpress) {
	topbuttons.update();
	modebuttons.update();
	toolbarbuttons.update();
	list_tabbuttons.update();
	playtestbutton.update();
	objectvisibility.update();
	gizmovisibility.update();
	tilelayervisibility.update();
	assetlayervisibility.update();
	bglayervisibility.update();
	if selected_mode==DECO_MODE {
		layeraddbutton.update();
		layereditbutton.update();
		layerdeletebutton.update();
		if (deco_mode_type == "bg") {
			bgalignbuttons.update();
		}
	}
}

if (selected_mode == DECO_MODE) {
	switch(deco_mode_type) {
		case "tile":
			tilepicker.update();
		break;
	}
}
#endregion

#region Camera Panning
if (not_on_gui) && (mbmiddlepress) {
	view_grab=1 
	view_grabx=curs_x
	view_graby=curs_y
	initial_viewx = cam_x
	initial_viewy = cam_y
} else if (mbmiddlerel) {
	view_grab=0
}

if (view_grab) { //update camera position
    camera_set_view_pos(camera,floor(initial_viewx+(view_grabx-curs_x)*zoom_level),floor(initial_viewy+(view_graby-curs_y)*zoom_level))
}
#endregion

var mwheel = mouse_wheel_down() - mouse_wheel_up();
if (mwheel == 0) {
	mwheel = keyboard_check(vk_down) - keyboard_check(vk_up)
}

#region Camera Zooming
if (mwheel != 0) && keyboard_check(vk_control) && (not_on_gui) {
	zoom_goto += 0.125*mwheel
	zoom_x = curs_x
    zoom_y = curs_y;
}
zoom_goto=clamp(zoom_goto,0.125, 5)
var oldzoom=zoom_level
zoom_level=approach_val(zoom_level,zoom_goto,0.025)
camera_set_view_size(camera, floor(guiw*zoom_level), floor(guih*zoom_level))

if (zoom_level!=oldzoom) {
	cam_x = camera_get_view_x(camera)
	cam_y = camera_get_view_y(camera)
	cam_w = camera_get_view_width(camera)
	cam_h = camera_get_view_height(camera)
	
	var old_cam_w = floor(guiw*oldzoom)
	var old_cam_h = floor(guih*oldzoom)
	cam_x += floor(old_cam_w/2 - cam_w/2) //+ ((zoom_x-guiw/2)/(zoom_level/(zoom_goto-zoom_level)))*mwheel
	cam_y += floor(old_cam_h/2 - cam_h/2) //+ ((zoom_y-guih/2)/(zoom_level/(zoom_goto-zoom_level)))*mwheel
	
	camera_set_view_pos(camera,cam_x,cam_y)
}
#endregion

var prevgrid = current_grid_size

if keyboard_check(vk_control) && (selected_mode != DECO_MODE || (selected_mode == DECO_MODE && deco_mode_type != "tile")) {
	current_grid_size=1;
} else current_grid_size=default_grid_size

if (current_grid_size!=prevgrid) changed_grid_size=true

droppedfiles=file_dropper_get_files(".jade")

if array_length(droppedfiles) {
	if ((filename_ext(droppedfiles[0]) == ".jade") ) {
		global.save_dir=droppedfiles[0]
		JADE_load(droppedfiles[0])
		autosave_time = (60*30)
	}
}

if keyboard_check(vk_control) {
	if (keyboard_check_pressed(ord("S"))) {
		if (global.save_dir != "") {
			displaytextdur=120;
			JADE_save(global.save_dir)
			displaytext=$"Successfully saved JADE file!"
		} else {
			var file = get_save_filename_ext("JADE File|*.jade", "", $"{working_directory}\mods\\level\\", "Save Level");
			if string_length(file) != 0 { 
				displaytextdur=120;
				global.save_dir=file
				JADE_save(file)
				displaytext=$"Successfully saved JADE file as {filename_name(global.save_dir)}!"
			}
		}
	}
	
	if (keyboard_check_pressed(ord("Z"))) {
		jade_undo();
	}
	
	if (keyboard_check_pressed(ord("Y"))) {
		jade_redo();
	}
}

if (keyboard_check_pressed(vk_escape)) {
	room_goto(rMainMenu);
	global.jade_testing = false;
}

if keyboard_check_pressed(vk_delete) {
	switch(selected_mode) {
		case OBJECT_MODE:
		case NODE_MODE:
			array_sort(selected_array,false)
			var i=0;
			repeat(array_length(selected_array)) {
				ds_list_delete(object_map, selected_array[i])
				i++;
			}
			selected_array=[];
		break;
		case DECO_MODE:
			if deco_mode_type == "tile" {
				if !ds_exists(tilemap,ds_type_list) break;
				
				array_sort(selected_array,false)
				var i=0;
				repeat(array_length(selected_array)) {
					if !(selection_grab) {
						var data=tilemap[| selected_array[i]]
						data[0]=tile_set_empty(data[0])
						tilemap_set(tilemap_layer,data[0],data[1],data[2])
					}
					ds_list_delete(tilemap, selected_array[i])
					i++;
				}
				selected_array=[];
				tile_update_properties();
			} else if deco_mode_type == "asset" {
				if selected_layer == noone break;
				if !ds_exists(selected_layer.assetmap,ds_type_list) break;
				
				array_sort(selected_array,false)
				var i=0;
				repeat(array_length(selected_array)) {
					if !(selection_grab) {
						var data=selected_layer.assetmap[| selected_array[i]]
						layer_sprite_destroy(data[1])
					}
					ds_list_delete(selected_layer.assetmap, selected_array[i])
					i++;
				}
				selected_array=[];
			}
		break;
	}
}

if keyboard_check(vk_control) && keyboard_check_pressed(ord("C")) {
	switch(selected_mode) {
		case OBJECT_MODE:
		case NODE_MODE:
			array_sort(selected_array,false)
			var i=0;
			repeat(array_length(selected_array)) {
				var temparr = [];
				array_push(temparr,object_map[| i])
				i++;
			}
			clipboard.contents = temparr;
			if (selected_mode == OBJECT_MODE)
			clipboard.type = "obj"
			else clipboard.type = "gizmo"
			selected_array=[];
		break;
		case DECO_MODE:
			if deco_mode_type == "tile" {
				if !ds_exists(tilemap,ds_type_list) break;
				
				array_sort(selected_array,false)
				var i=0;
				repeat(array_length(selected_array)) {
					if !(selection_grab) {
						var data=tilemap[| selected_array[i]]
						data[0]=tile_set_empty(data[0])
						tilemap_set(tilemap_layer,data[0],data[1],data[2])
					}
					ds_list_delete(tilemap, selected_array[i])
					i++;
				}
				selected_array=[];
				tile_update_properties();
			} else if deco_mode_type == "asset" {
				if selected_layer == noone break;
				if !ds_exists(selected_layer.assetmap,ds_type_list) break;
				
				array_sort(selected_array,false)
				var i=0;
				repeat(array_length(selected_array)) {
					if !(selection_grab) {
						var data=selected_layer.assetmap[| selected_array[i]]
						layer_sprite_destroy(data[1])
					}
					ds_list_delete(selected_layer.assetmap, selected_array[i])
					i++;
				}
				selected_array=[];
			}
		break;
	}
}

if (mbleft && not_on_gui && !disable_tool) {
	switch(selected_tool) {
		case BRUSH_TOOL:
			switch(selected_mode) {
				case OBJECT_MODE:
				case NODE_MODE:
					if is_struct(selected_obj) && !check_colliding_object(mouse_x,mouse_y) {
						if (mbleftpress) {
							redoarray = [];
							array_push(undoarray,[object_map, ds_list_write(object_map)]);
						}
						
						object_place(selected_obj.uuid,gridx*current_grid_size,gridy*current_grid_size,1,1);
					}
				break;
				case DECO_MODE:
					switch(deco_mode_type) {
						case "tile":
							if !ds_exists(tilemap,ds_type_list) break;
							
							if (mbleftpress) {
								redoarray = [];
								array_push(undoarray,[selected_layer, selected_layer.export_contents()])
							}
							var i=0;
							repeat(tile_sel_width+1) {
								var j=0;
								repeat(tile_sel_height+1) {
									//prevent trying to place out of bounds
									if ((gridx + i) < tilemap_get_width(tilemap_layer)) && ((gridy + j) < tilemap_get_height(tilemap_layer)) && ((gridx + i) >= 0) && ((gridy + j) >= 0) {
										var data = tilemap_get_at_pixel(tilemap_layer, mouse_x+(i *16), mouse_y+(j *16)); //set tile at place
										if tile_get_index(data) != current_tile_id[i][j] {
											data = tile_set_index(data, current_tile_id[i][j])
											data = tile_set_flip(data, 0)
											data = tile_set_mirror(data, 0)
											data = tile_set_rotate(data, 0)
											tilemap_set(tilemap_layer, data, gridx + i, gridy + j);
											ds_list_add(tilemap,[data,gridx+i,gridy+j]) //add tile  to list at place
										}
									}
									j++;
								}
								i++;
							}
						break;
						case "asset":
							if (mbleftpress) && is_struct(selected_deco_obj) {
								redoarray = [];
								array_push(undoarray,[selected_layer, selected_layer.export_contents()])
								asset_place(selected_deco_obj.uuid,gridx*current_grid_size,gridy*current_grid_size,1,1)
							}
						break;
					}
				break;
			}
		break;
		case ERASE_TOOL:
			switch(selected_mode) {
				case OBJECT_MODE:
				case NODE_MODE:
					var obj = check_colliding_object(mouse_x,mouse_y)
					if (obj) {
						ds_list_delete(object_map, obj-1)
						i_did_a_thing = true;
					}
				break;
				case DECO_MODE:
					switch(deco_mode_type) {
						case "tile":
							var obj = check_colliding_tile(mouse_x,mouse_y)
							if (obj) {
								var tile = ds_list_find_value(tilemap,obj-1);
								var data = tilemap_get(tilemap_layer, tile[1], tile[2]);
								if tile_get_index(data)!= 0 {
									data = tile_set_empty(data)
									tilemap_set(tilemap_layer, data,  tile[1], tile[2]); //delete tile at place lol
								}
								ds_list_delete(tilemap, obj-1)
							}
							tile_update_properties();
							i_did_a_thing = true;
						break;
						case "asset":
						var obj = check_colliding_asset(mouse_x,mouse_y)
						if (obj) {
							layer_sprite_destroy(selected_layer.assetmap[| obj-1][1])
							ds_list_delete(selected_layer.assetmap, obj-1)
							i_did_a_thing = true;
						}
						break;
					}
				break;
			}
		break;
		case SELECT_TOOL:
			if (selected_mode == OBJECT_MODE || selected_mode == NODE_MODE) {
				#region object selection
				if (mbleftpress) && !(resizing) {
					//resizing
					if array_length(selected_array)==1 {
						var obj=object_map[| selected_array[0]]
						var data=obj_data[$ obj[0]]
						//top left
						if point_in_rectangle(mouse_x,mouse_y,obj[1]-4,obj[2]-4,obj[1]+2,obj[2]+2) {
							resizing = 1;
							resizing_x = mouse_x;
							resizing_y = mouse_y;
							resizing_x2 = obj[1]
							resizing_y2 = obj[2]
							resizing_initial_w = obj[3];
							resizing_initial_h = obj[4];
							break;
						}
						//top right
						if point_in_rectangle(mouse_x,mouse_y,obj[1]+(data.width*obj[3])-2,obj[2]-4,obj[1]+(data.width*obj[3])+4,obj[2]+2) {
							resizing = 2;
							resizing_x = mouse_x;
							resizing_y = mouse_y;
							resizing_x2 = obj[1]
							resizing_y2 = obj[2]
							resizing_initial_w = obj[3];
							resizing_initial_h = obj[4];
							break;
						}
						//bottom left
						if point_in_rectangle(mouse_x,mouse_y,obj[1]-4,obj[2]+(data.height*obj[4])-2,obj[1]+4,obj[2]+(data.height*obj[4])+2) {
							resizing = 3;
							resizing_x = mouse_x;
							resizing_y = mouse_y;
							resizing_x2 = obj[1]
							resizing_y2 = obj[2]
							resizing_initial_w = obj[3];
							resizing_initial_h = obj[4];
							break;
						}
						//bottom right
						if point_in_rectangle(mouse_x,mouse_y,obj[1]+(data.width*obj[3])-2,obj[2]+(data.height*obj[4])-2,obj[1]+(data.width*obj[3])+4,obj[2]+(data.height*obj[4])+4) {
							resizing = 4;
							resizing_x = mouse_x;
							resizing_y = mouse_y;
							resizing_x2 = obj[1]
							resizing_y2 = obj[2]
							resizing_initial_w = obj[3];
							resizing_initial_h = obj[4];
							break;
						}
					}
				
					var draggingobject=false;
					//select single object
					var col = check_colliding_object(mouse_x,mouse_y)
					if (col) {
						//TODO: move this to the mbrel section so you can drag select over unselected objects
						if array_get_index(selected_array,col-1)==-1 {
							if !keyboard_check(vk_shift) {
								selected_array=[];
							}
							array_push(selected_array,col-1)
							break;
						} else if !keyboard_check(vk_shift) {
							draggingobject = true;
							selection_grab = true;
							selection_grab_x = gridx*current_grid_size;
							selection_grab_y = gridy*current_grid_size;
							break;
						}
					}
				
					//unselect all objects unless shift is held
					if !keyboard_check(vk_shift) && !draggingobject {
						selected_array=[];
					}
					selection_box=true
					selection_box_x=mouse_x;
					selection_box_y=mouse_y;
				}
			
				if (selection_grab) {
					var x_diff = (selection_grab_x-(gridx*current_grid_size));
					var y_diff = (selection_grab_y-(gridy*current_grid_size));
					if (x_diff!=0) || (y_diff!=0) {
						var i=0;
						repeat(array_length(selected_array)) {
							var obj = object_map[| selected_array[i]]
							obj[1]-=x_diff;
							obj[2]-=y_diff
							i++;
						}
						selection_grab_x = gridx*current_grid_size;
						selection_grab_y = gridy*current_grid_size;
					}
				}
			
				if (resizing) {
					if array_length(selected_array)==1 {
						var obj = object_map[| selected_array[0]]
						var data = obj_data[$ obj[0]]
						var x_diff = (resizing_x-(gridx*current_grid_size));
						var y_diff = (resizing_y-(gridy*current_grid_size));
						var scale_diff_x = data.width/current_grid_size;
						var scale_diff_y = data.height/current_grid_size;
						if (x_diff!=0) || (y_diff!=0) {
							switch(resizing) {
								case 1: //top left
									obj[3] += floor(x_diff/current_grid_size)/scale_diff_x;
									obj[4] += floor(y_diff/current_grid_size)/scale_diff_y;
									obj[3] = max(obj[3],1)
									obj[4] = max(obj[4],1)
									obj[1] = resizing_x2+round(((resizing_initial_w-obj[3])*current_grid_size)*scale_diff_x)
									obj[2] = resizing_y2+round(((resizing_initial_h-obj[4])*current_grid_size)*scale_diff_y)
									resizing_x = gridx*current_grid_size;
									resizing_y = gridy*current_grid_size;
								break;
								case 2: //top right
									obj[3] += ceil(-x_diff/current_grid_size)/scale_diff_x;
									obj[4] += floor(y_diff/current_grid_size)/scale_diff_y;
									obj[3] = max(obj[3],1)
									obj[4] = max(obj[4],1)
									obj[2] = resizing_y2+round(((resizing_initial_h-obj[4])*current_grid_size)*scale_diff_y)
									resizing_x = gridx*current_grid_size;
									resizing_y = gridy*current_grid_size;
								break;
								case 3: //bottom left
									obj[3] += floor(x_diff/current_grid_size)/scale_diff_x;
									obj[4] += ceil(-y_diff/current_grid_size)/scale_diff_y;
									obj[3] = max(obj[3],1)
									obj[4] = max(obj[4],1)
									obj[1] = resizing_x2+round(((resizing_initial_w-obj[3])*current_grid_size)*scale_diff_x)
									resizing_x = gridx*current_grid_size;
									resizing_y = gridy*current_grid_size;
								break; 
								case 4: //bottom right
									obj[3] += ceil(-x_diff/current_grid_size)/scale_diff_x;
									obj[4] += ceil(-y_diff/current_grid_size)/scale_diff_y;
									obj[3] = max(obj[3],1)
									obj[4] = max(obj[4],1)
									resizing_x = gridx*current_grid_size;
									resizing_y = gridy*current_grid_size;
								break;
							}
						}
					}
				}
			#endregion
			} else if selected_mode == DECO_MODE {
				#region tile selection 
				if (mbleftpress) && (deco_mode_type != "") && !(resizing) {
					switch(deco_mode_type) {
						case "tile": 
							var draggingobject=false;
							//select single object
							var col = check_colliding_tile(mouse_x,mouse_y)
							if (col) {
								//TODO: move this to the mbrel section so you can drag select over unselected objects
								if array_get_index(selected_array,col-1)==-1 {
									if !keyboard_check(vk_shift) {
										selected_array=[];
									}
									array_push(selected_array,col-1)
									break;
								} else if !keyboard_check(vk_shift) {
									if !ds_exists(tilemap,ds_type_list) break;
							
									draggingobject = true;
									selection_grab = true;
									var i=0
									repeat(array_length(selected_array)) {
										var tile = ds_list_find_value(tilemap,selected_array[i]);
										var data = tilemap_get(tilemap_layer, tile[1], tile[2]);
										if tile_get_index(data)!= 0 {
											data = tile_set_empty(data)
											tilemap_set(tilemap_layer, data,  tile[1], tile[2]); //delete tile at place lol
										}
										i++;
									}
									selection_grab_x = gridx*current_grid_size;
									selection_grab_y = gridy*current_grid_size;
									break;
								}
							}
				
							//unselect all objects unless shift is held
							if !keyboard_check(vk_shift) && !draggingobject {
								selected_array=[];
							}
							selection_box=true
							selection_box_x=mouse_x;
							selection_box_y=mouse_y;
						break;
						case "asset":
							if array_length(selected_array)==1 {
								var asset=selected_layer.assetmap[| selected_array[0]]
								var data = obj_data[$ asset[0]]
								var _sprite = asset_get_index(asset[0])
								var _xsc = layer_sprite_get_xscale(asset[1]);
								var _ysc = layer_sprite_get_yscale(asset[1]);
								var _ax = layer_sprite_get_x(asset[1]) - (sprite_get_xoffset(_sprite) * _xsc);
								var _ay = layer_sprite_get_y(asset[1]) - (sprite_get_yoffset(_sprite) * _ysc);
								var _width = data.width * _xsc
								var _height = data.height * _ysc
								//top left
								if point_in_rectangle(mouse_x,mouse_y,_ax-4,_ay-4,_ax+2,_ay+2) {
									resizing = 1;
									resizing_x = mouse_x;
									resizing_y = mouse_y;
									resizing_x2 = layer_sprite_get_x(asset[1])
									resizing_y2 = layer_sprite_get_y(asset[1])
									resizing_initial_w = layer_sprite_get_xscale(asset[1]);
									resizing_initial_h = layer_sprite_get_yscale(asset[1]);
									break;
								}
								//top right
								if point_in_rectangle(mouse_x,mouse_y,_ax+_width-2,_ay-4,_ax+_width+4,_ay+2) {
									resizing = 2;
									resizing_x = mouse_x;
									resizing_y = mouse_y;
									resizing_x2 = layer_sprite_get_x(asset[1])
									resizing_y2 = layer_sprite_get_y(asset[1])
									resizing_initial_w = layer_sprite_get_xscale(asset[1]);
									resizing_initial_h = layer_sprite_get_yscale(asset[1]);
									break;
								}
								//bottom left
								if point_in_rectangle(mouse_x,mouse_y,_ax-4,_ay+_height-2,_ax+4,_ay+_height+2) {
									resizing = 3;
									resizing_x = mouse_x;
									resizing_y = mouse_y;
									resizing_x2 = layer_sprite_get_x(asset[1])
									resizing_y2 = layer_sprite_get_y(asset[1])
									resizing_initial_w = layer_sprite_get_xscale(asset[1]);
									resizing_initial_h = layer_sprite_get_yscale(asset[1]);
									break;
								}
								//bottom right
								if point_in_rectangle(mouse_x,mouse_y,_ax+_width-2,_ay+_height-2,_ax+_width+4,_ay+_height+4) {
									resizing = 4;
									resizing_x = mouse_x;
									resizing_y = mouse_y;
									resizing_x2 = layer_sprite_get_x(asset[1])
									resizing_y2 = layer_sprite_get_y(asset[1])
									resizing_initial_w = layer_sprite_get_xscale(asset[1]);
									resizing_initial_h = layer_sprite_get_yscale(asset[1]);
									break;
								}
							}
						
							var draggingobject=false;
							//select single object
							var col = check_colliding_asset(mouse_x,mouse_y)
							if (col) {
								//TODO: move this to the mbrel section so you can drag select over unselected objects
								if array_get_index(selected_array,col-1)==-1 {
									if !keyboard_check(vk_shift) {
										selected_array=[];
									}
									array_push(selected_array,col-1)
									break;
								} else if !keyboard_check(vk_shift) {
									if selected_layer == noone break;
									if !ds_exists(selected_layer.assetmap,ds_type_list) break;
							
									draggingobject = true;
									selection_grab = true;
									selection_grab_x = gridx*current_grid_size;
									selection_grab_y = gridy*current_grid_size;
									break;
								}
							}
				
							//unselect all objects unless shift is held
							if !keyboard_check(vk_shift) && !draggingobject {
								selected_array=[];
							}
							selection_box=true
							selection_box_x=mouse_x;
							selection_box_y=mouse_y;
						break;
						case "bg":
							selected_array=[];
							var draggingobject=false;
							//select single object
							var bg = selected_layer.selected_bg;
							var _sprite = selected_layer.sprite;
							var _width = sprite_get_width(_sprite);
							var _height = sprite_get_height(_sprite);
							var _x = selected_layer.off_x-sprite_get_xoffset(_sprite);
							var _y = selected_layer.off_y-sprite_get_yoffset(_sprite);
							if point_in_rectangle(mouse_x,mouse_y,_x,_y,_x+_width,_y+_height) {
								//TODO: move this to the mbrel section so you can drag select over unselected objects
								array_push(selected_array,selected_layer)
								draggingobject = true;
								selection_grab = true;
								selection_grab_x = gridx*current_grid_size;
								selection_grab_y = gridy*current_grid_size;
							}
							
							if !(draggingobject) {
								selection_box=true
								selection_box_x=mouse_x;
								selection_box_y=mouse_y;
							}
						break;
					}
				}
				#endregion
				
				if (deco_mode_type == "asset") {
					if (resizing) {
						if array_length(selected_array)==1 {
							var asset=selected_layer.assetmap[| selected_array[0]]
							var data = obj_data[$ asset[0]]
							var _sprite = asset_get_index(asset[0])
							var _xsc = layer_sprite_get_xscale(asset[1]);
							var _ysc = layer_sprite_get_yscale(asset[1]);
							var _ax = layer_sprite_get_x(asset[1]) - (sprite_get_xoffset(_sprite) * _xsc);
							var _ay = layer_sprite_get_y(asset[1]) - (sprite_get_yoffset(_sprite) * _ysc);
							var _width = _xsc
							var _height = _ysc
							var x_diff = (resizing_x-(gridx*current_grid_size));
							var y_diff = (resizing_y-(gridy*current_grid_size));
							var scale_diff_x = data.width/current_grid_size;
							var scale_diff_y = data.height/current_grid_size;
							if (x_diff!=0) || (y_diff!=0) {
								switch(resizing) {
									case 1: //top left
										layer_sprite_xscale(asset[1],max(_width+floor(x_diff/current_grid_size)/scale_diff_x,1));
										layer_sprite_yscale(asset[1],max(_height+floor(y_diff/current_grid_size)/scale_diff_y,1));
										_width = sprite_get_width(_sprite);
										_height = sprite_get_height(_sprite);
										//layer_sprite_x(asset[1],resizing_x2+round(((resizing_initial_w-_width)*current_grid_size)*scale_diff_x))
										//layer_sprite_y(asset[1],resizing_y2+round(((resizing_initial_h-_height)*current_grid_size)*scale_diff_y))
										resizing_x = gridx*current_grid_size;
										resizing_y = gridy*current_grid_size;
									break;
									case 2: //top right
										layer_sprite_xscale(asset[1],max(_width+ceil(-x_diff/current_grid_size)/scale_diff_x,1));
										layer_sprite_yscale(asset[1],max(_height+floor(y_diff/current_grid_size)/scale_diff_y,1));
										_width = sprite_get_width(_sprite);
										_height = sprite_get_height(_sprite);
										//layer_sprite_y(asset[1],resizing_y2+round(((resizing_initial_h-_height)*current_grid_size)*scale_diff_y))
										resizing_x = gridx*current_grid_size;
										resizing_y = gridy*current_grid_size;
									break;
									case 3: //bottom left
										layer_sprite_xscale(asset[1],max(_width+floor(x_diff/current_grid_size)/scale_diff_x,1));
										layer_sprite_yscale(asset[1],max(_height+ceil(-y_diff/current_grid_size)/scale_diff_y,1));
										_width = sprite_get_width(_sprite);
										_height = sprite_get_height(_sprite);
										//layer_sprite_x(asset[1],resizing_x2+round(((resizing_initial_w-_width)*current_grid_size)*scale_diff_x))
										resizing_x = gridx*current_grid_size;
										resizing_y = gridy*current_grid_size;
									break; 
									case 4: //bottom right
										layer_sprite_xscale(asset[1],max(_width+ceil(-x_diff/current_grid_size)/scale_diff_x,1));
										layer_sprite_yscale(asset[1],max(_height+ceil(-y_diff/current_grid_size)/scale_diff_y,1));
										_width = sprite_get_width(_sprite);
										_height = sprite_get_height(_sprite);
										resizing_x = gridx*current_grid_size;
										resizing_y = gridy*current_grid_size;
									break;
								}
							}
						}
					}
					
					if (selection_grab) {
						var x_diff = (selection_grab_x-(gridx*current_grid_size));
						var y_diff = (selection_grab_y-(gridy*current_grid_size));
						if (x_diff!=0) || (y_diff!=0) {
							var i=0;
							repeat(array_length(selected_array)) {
								var obj = selected_layer.assetmap[| selected_array[i]]
								var objx = layer_sprite_get_x(obj[1])
								var objy = layer_sprite_get_y(obj[1])
								layer_sprite_x(obj[1],objx-x_diff)
								layer_sprite_y(obj[1],objy-y_diff)
								i++;
							}
							selection_grab_x = gridx*current_grid_size;
							selection_grab_y = gridy*current_grid_size;
						}
					}
				} else if (deco_mode_type == "bg") && (selection_grab) {
					var x_diff = (selection_grab_x-(gridx*current_grid_size));
					var y_diff = (selection_grab_y-(gridy*current_grid_size));
					if (x_diff!=0) || (y_diff!=0) {
						var obj = selected_layer.my_layer
						selected_layer.off_x-=x_diff;
						selected_layer.off_y-=y_diff;
						layer_x(obj,selected_layer.off_x)
						layer_y(obj,selected_layer.off_y)
						selection_grab_x = gridx*current_grid_size;
						selection_grab_y = gridy*current_grid_size;
					}
				}
			}
		break;
		case MIRROR_TOOL:
			if (mbleftpress) || (prevgridx!=gridx || prevgridy!=gridy) {
				switch(deco_mode_type) {
					case "tile":
						var data = tilemap_get_at_pixel(tilemap_layer, mouse_x, mouse_y);
						data = tile_set_mirror(data, 1 - tile_get_mirror(data))
						tilemap_set(tilemap_layer, data, gridx, gridy);
						var tiledata = tilemap_get(tilemap_layer, gridx, gridy)
						ds_list_add(tilemap,[tiledata,gridx,gridy]) //add tile  to list at place
						tile_update_properties();
					break;
				}
			}
		break;
		case FLIP_TOOL:
			if (mbleftpress) || (prevgridx!=gridx || prevgridy!=gridy) {
				switch(deco_mode_type) {
					case "tile":
						var data = tilemap_get_at_pixel(tilemap_layer, mouse_x, mouse_y);
						data = tile_set_flip(data, 1 - tile_get_flip(data))
						tilemap_set(tilemap_layer, data, gridx, gridy);
						var tiledata = tilemap_get(tilemap_layer, gridx, gridy)
						ds_list_add(tilemap,[tiledata,gridx,gridy]) //add tile  to list at place
						tile_update_properties();
					break;
					case "asset":
					break;
				}
			}
		break;
		case ROTATE_TOOL:
			if (mbleftpress) || (prevgridx!=gridx || prevgridy!=gridy) {
				switch(deco_mode_type) {
					case "tile":
						var data = tilemap_get_at_pixel(tilemap_layer, mouse_x, mouse_y);
						data = tile_set_rotate(data, 1 - tile_get_rotate(data))
						tilemap_set(tilemap_layer, data, gridx, gridy);
						var tiledata = tilemap_get(tilemap_layer, gridx, gridy)
						ds_list_add(tilemap,[tiledata,gridx,gridy]) //add tile  to list at place
						tile_update_properties();
					break;
				}
			}
		break;
		case PICKER_TOOL:
			if (mbleftpress) {
				switch(selected_mode) {
					case OBJECT_MODE:
					case NODE_MODE:
						var col = check_colliding_object(mouse_x,mouse_y)
						if (col) {
							var obj = object_map[| col-1]
							selected_obj = obj_data[$ obj[0]]
							selected_tool = BRUSH_TOOL
						}
					break;
					case DECO_MODE:
						switch(deco_mode_type) {
							case "tile":
								var col = check_colliding_tile(mouse_x,mouse_y)
								if (col) {
									var obj = tilemap[| col-1]
									current_tile_id = -1
									current_tile_id = []
									current_tile_id[0][0] = tile_get_index(obj[0])
									tile_sel_height = 0
									tile_sel_width = 0
								}
							break;
							case "asset":
								var col = check_colliding_asset(mouse_x,mouse_y)
								if (col) {
									var obj = selected_layer.assetmap[| col-1]
									selected_deco_obj = obj_data[$ obj[0]]
									selected_tool = BRUSH_TOOL
								}
							break;
						}
					break;
				}
			}
		break;
		case FILL_TOOL:
			if (mbleftpress && !tile_fill) {
				tile_fill_last_x = gridx
				tile_fill_last_y = gridy
				tile_fill = true
			}
		break;
		case NODE_TOOL:
			if (mbleftpress) {
				if (drawing_node==-1) {
					var col = check_colliding_object(mouse_x,mouse_y,object_layer_map)
					if (col) {
						var obj = object_layer_map[| col-1]
						draw_node_x = obj[1];
						draw_node_y = obj[2];
						drawing_node = col-1;
					}
				} else {
					var obj = object_layer_map[| drawing_node]
					var rounded_x = (ceil((gridx*current_grid_size-8)/current_grid_size)*current_grid_size)+8;
					var rounded_y = (ceil((gridy*current_grid_size-8)/current_grid_size)*current_grid_size)+8;
					array_push(obj[10],[rounded_x,rounded_y])
				}
			}
		break;
		case ROTATOR_TOOL:
			if (mbleftpress) {
				if (drawing_rotator==-1) {
					var col = check_colliding_object(mouse_x,mouse_y,object_layer_map)
					if (col) {
						var obj = object_layer_map[| col-1]
						draw_node_x = obj[1];
						draw_node_y = obj[2];
						drawing_rotator = col-1;
					}
				} else {
					var obj = object_layer_map[| drawing_rotator]
					var rounded_x = (ceil((gridx*current_grid_size-8)/current_grid_size)*current_grid_size)+8;
					var rounded_y = (ceil((gridy*current_grid_size-8)/current_grid_size)*current_grid_size)+8;
					array_push(obj[12],[rounded_x,rounded_y])
				}
			}
		break;
		case REFERENCE_TOOL:
			if (mbleftpress) {
				if (reference_sprite == -1) {
					var file = get_open_filename_ext("PNG File|*.png", "", working_directory, "Load Reference Image");
					if string_length(file) != 0 {
						reference_sprite = sprite_add(file,0,false,false,0,0);
						selection_grab = false;
						var width = sprite_get_width(reference_sprite)
						var height = sprite_get_height(reference_sprite)
						//16384x16384 is the max texture page size, and higher and the sprite will glitch out
						if (width > 16384) || (height > 16384) {
							show_message($"WARNING:\nReference Image width or height is greater than max texture page size (16384)! Glitches may occur.\n(Width: {width}, Height: {height})")
						}
						reference_sprite_x = cam_x+(cam_w/2)-(width/2);
						reference_sprite_y = cam_y+(cam_h/2)-(height/2);
						reference_sprite_element = layer_sprite_create(reference_sprite_layer,reference_sprite_x,reference_sprite_y,reference_sprite)
					}
				} else {
					var width = sprite_get_width(reference_sprite)
					var height = sprite_get_height(reference_sprite)
					if (point_in_rectangle(mouse_x,mouse_y,reference_sprite_x,reference_sprite_y,reference_sprite_x+width,reference_sprite_y+height)) {
						selection_grab = true;
						selection_grab_x = gridx*current_grid_size;
						selection_grab_y = gridy*current_grid_size;
					}
				}
			}
			
			if (selection_grab) && (sprite_exists(reference_sprite)) {
				var x_diff = (selection_grab_x-(gridx*current_grid_size));
				var y_diff = (selection_grab_y-(gridy*current_grid_size));
				if (x_diff!=0) || (y_diff!=0) {
					reference_sprite_x-=x_diff;
					reference_sprite_y-=y_diff
					selection_grab_x = gridx*current_grid_size;
					selection_grab_y = gridy*current_grid_size;
					layer_sprite_x(reference_sprite_element,reference_sprite_x)
					layer_sprite_y(reference_sprite_element,reference_sprite_y)
				}
			}
		break;
		case SPAWN_TOOL:
			if (selected_mode == OBJECT_MODE) {
				if (mbleftpress) {
					spawnpoint_x = gridx*current_grid_size
					spawnpoint_y = gridy*current_grid_size
				}
			}
		break;
	}
}

if (mbleftrel) {
	if (selected_mode == OBJECT_MODE || selected_mode == NODE_MODE) {
		
		if (selection_box) {
			var box_w = (mouse_x - selection_box_x)
			var box_h = (mouse_y - selection_box_y)
			var box_x1 = floor(selection_box_x+min(box_w, 0))
			var box_y1 = floor(selection_box_y+min(box_h, 0))
			var box_x2 = floor(selection_box_x+min(box_w, 0)+abs(box_w))
			var box_y2 = floor(selection_box_y+min(box_h, 0)+abs(box_h))
			var i=0;
			repeat(ds_list_size(object_map)) {
				var obj = object_map[| i]
				var data = obj_data[$ obj[0]]
				if rectangle_in_rectangle(box_x1,box_y1,box_x2,box_y2,obj[1],obj[2],obj[1]+data.width*obj[3],obj[2]+data.height*obj[4]) {
					if array_get_index(selected_array,i)==-1 {
						array_push(selected_array,i)
					}
				}
				i++;
			}
		}
		selection_box = false;
		selection_grab = false;
		resizing = false;
	} else if selected_mode == DECO_MODE {
		switch(deco_mode_type) {
			case "tile":
				if (selection_box) {
					if !ds_exists(tilemap,ds_type_list) exit;
			
					var box_w = (mouse_x - selection_box_x)
					var box_h = (mouse_y - selection_box_y)
					var box_x1 = floor(selection_box_x+min(box_w, 0))
					var box_y1 = floor(selection_box_y+min(box_h, 0))
					var box_x2 = floor(selection_box_x+min(box_w, 0)+abs(box_w))
					var box_y2 = floor(selection_box_y+min(box_h, 0)+abs(box_h))
					var i=0;
					repeat(ds_list_size(tilemap)) {
						var tile = tilemap[| i]
						if rectangle_in_rectangle(box_x1,box_y1,box_x2,box_y2,tile[1]*16,tile[2]*16,tile[1]*16+16,tile[2]*16+16) {
							if array_get_index(selected_array,i)==-1 {
								array_push(selected_array,i)
							}
						}
						i++;
					}
				} else if (selection_grab) {
					if !ds_exists(tilemap,ds_type_list) exit;
			
					var i=0
					var temp_select_array=[];
					repeat(array_length(selected_array)) {
						var tile = ds_list_find_value(tilemap,selected_array[i])
						var x_diff = (tile[1]*16 - selection_grab_x)
						var y_diff = (tile[2]*16 - selection_grab_y)
						var new_y = floor((mouse_y+y_diff)/16)
						var new_x = floor((mouse_x+x_diff)/16)
						if (new_x < tilemap_get_width(tilemap_layer)) && (new_y < tilemap_get_height(tilemap_layer)) && (new_x >= 0) && (new_y >= 0) {
							array_push(temp_select_array,[tile[0],new_x,new_y])
							ds_list_set(tilemap,selected_array[i],[tile[0],new_x,new_y])
							tilemap_set(tilemap_layer, tile[0], new_x, new_y);
						}
						i++;
					}
				}
				
				if (selected_tool == FILL_TOOL) && (tile_fill) {
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
					
					var i=0;
					repeat(size_x) {
						var j=0;
						repeat(size_y) {
							//prevent trying to place out of bounds
							if ((start_x + i) < tilemap_get_width(tilemap_layer)) && ((start_y + j) < tilemap_get_height(tilemap_layer)) && ((start_x + i) >= 0) && ((start_y + j) >= 0) {
								var data = tilemap_get(tilemap_layer, start_x+i, start_y+j); //set tile at place
								data = tile_set_index(data, current_tile_id[i mod (tile_sel_width+1)][j mod (tile_sel_height+1)])
								data = tile_set_flip(data, 0);
								data = tile_set_mirror(data, 0);
								data = tile_set_rotate(data, 0);
								tilemap_set(tilemap_layer, data, start_x + i, start_y + j);
								if current_tile_id[i mod (tile_sel_width+1)][j mod (tile_sel_height+1)] != 0
								ds_list_add(tilemap,[data, start_x+i, start_y+j]) //add tile  to list at place
							}
							j++;
						}
						i++;
					}
					tile_update_properties();
					show_debug_message(ds_list_size(tilemap))
					tile_fill = false
				}
			break;
			case "asset":
				if (selection_box) {
					if selected_layer == noone exit;
					if !ds_exists(selected_layer.assetmap,ds_type_list) exit;
					
					var box_w = (mouse_x - selection_box_x)
					var box_h = (mouse_y - selection_box_y)
					var box_x1 = floor(selection_box_x+min(box_w, 0))
					var box_y1 = floor(selection_box_y+min(box_h, 0))
					var box_x2 = floor(selection_box_x+min(box_w, 0)+abs(box_w))
					var box_y2 = floor(selection_box_y+min(box_h, 0)+abs(box_h))
	
					var i=0;
					repeat(ds_list_size(selected_layer.assetmap)) {
						var asset=selected_layer.assetmap[| i]
						var data = obj_data[$ asset[0]]
						var _sprite = asset_get_index(asset[0])
						var _xsc = layer_sprite_get_xscale(asset[1]);
						var _ysc = layer_sprite_get_yscale(asset[1]);
						var _ax = layer_sprite_get_x(asset[1]) - (sprite_get_xoffset(_sprite) * _xsc);
						var _ay = layer_sprite_get_y(asset[1]) - (sprite_get_yoffset(_sprite) * _ysc);
						var _width = data.width * _xsc
						var _height = data.height * _ysc
						if rectangle_in_rectangle(box_x1,box_y1,box_x2,box_y2,_ax,_ay,_ax+_width,_ay+_height) {
							if array_get_index(selected_array,i)==-1 {
								array_push(selected_array,i)
							}
						}
						i++;
					}
				}
				selection_box = false;
				selection_grab = false;
				resizing = false;
			break;
		}
		selection_box = false;
		selection_grab = false;
		resizing = false;
	} 
	
	if (selected_tool == REFERENCE_TOOL) {
		selection_grab = false;
	}
}

if (mbright) {
	selected_array = [];
	switch(selected_tool) {
		case BRUSH_TOOL:
			switch(selected_mode) {
				case OBJECT_MODE:
				case NODE_MODE:
					var obj = check_colliding_object(mouse_x,mouse_y)
					if (obj) {
						ds_list_delete(object_map, obj-1)
					}
				break;
				case DECO_MODE:
					switch(deco_mode_type) {
						case "tile":
							var i=0;
							repeat(tile_sel_width+1) {
								var j=0;
								repeat(tile_sel_height+1) {
									//prevent trying to place out of bounds
									if ((gridx + i) < tilemap_get_width(tilemap_layer)) && ((gridy + j) < tilemap_get_height(tilemap_layer)) && ((gridx + i) >= 0) && ((gridy + j) >= 0) {
										var data = tilemap_get_at_pixel(tilemap_layer, mouse_x+(i *16), mouse_y+(j *16)); //set tile at place
										if tile_get_index(data) != 0 {
											data = tile_set_empty(data)
											tilemap_set(tilemap_layer, data, gridx + i, gridy + j);
											ds_list_add(tilemap,[data, gridx+i, gridy+j]) //add tile  to list at place
										}
									}
									j++;
								}
								i++;
							}
							tile_update_properties();
						break;
						case "asset":
						var obj = check_colliding_asset(mouse_x,mouse_y)
						if (obj) {
							layer_sprite_destroy(selected_layer.assetmap[| obj-1][1])
							ds_list_delete(selected_layer.assetmap, obj-1)
						}
						break;
					}
				break;
			}
		break;
		case SELECT_TOOL:
			if (mbrightpress) && (selected_mode == OBJECT_MODE || selected_mode == NODE_MODE) {
				selected_array=[];
				var col = check_colliding_object(mouse_x,mouse_y)
				if (col) {
					if array_get_index(selected_array,col-1)==-1 {
						if !keyboard_check(vk_shift) {
							selected_array=[];
						}
						array_push(selected_array,col-1)
					}
				}
				list_tabbuttons.selected_button=1;
				properties_tab_active=true;
			}
		break;
		case NODE_TOOL:
			if (mbrightpress) && (drawing_node!=-1) {
				var obj = object_layer_map[| drawing_node]
				var i=0;
				var len = array_length(obj[10])
				var deleted_node = false;
				repeat(len) {
					var node = obj[10][i]
					if point_in_rectangle(mouse_x,mouse_y,node[0]-8,node[1]-8,node[0]+8,node[1]+8) {
						array_delete(obj[10],i,1);
						deleted_node = true;
					}
					i++;
				}
				
				if !(deleted_node)
				drawing_node = -1;
			}
		break;
		case REFERENCE_TOOL:
			if (layer_sprite_exists(reference_sprite_layer,reference_sprite_element)) layer_sprite_destroy(reference_sprite_element);
			if (sprite_exists(reference_sprite)) sprite_delete(reference_sprite);
			reference_sprite = -1;
			selection_grab = false;
		break;
		case SPAWN_TOOL:
			if (selected_mode == OBJECT_MODE) {
				if (mbrightpress) {
					testpoint_x = gridx*current_grid_size
					testpoint_y = gridy*current_grid_size
				}
			}
		break;
	}
}