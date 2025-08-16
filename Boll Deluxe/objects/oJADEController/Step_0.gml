cam_x = camera_get_view_x(view_camera[0])
cam_y = camera_get_view_y(view_camera[0])
cam_w = camera_get_view_width(view_camera[0])
cam_h = camera_get_view_height(view_camera[0])
guiw = display_get_gui_width();
guih = display_get_gui_height();

if !os_is_paused() && guiw>0 && guih>0 {
	if !surface_exists(GUIcanvas) {
		GUIcanvas=surface_create(guiw,guih);
	} else {
		if (guiw!=surface_get_width(GUIcanvas) || guih!=surface_get_height(GUIcanvas)) {
			surface_resize(GUIcanvas,guiw,guih);
		}
	}
}

mbleftpress=mouse_check_button_pressed(mb_left)
mbleftrel=mouse_check_button_released(mb_left)
mbleft=mouse_check_button(mb_left)
mbrightpress=mouse_check_button_pressed(mb_right)
mbrightrel=mouse_check_button_released(mb_right)
mbright=mouse_check_button(mb_right)
mbmiddle = (mouse_check_button(mb_middle) || (keyboard_check(vk_space) && mouse_check_button(mb_left))) //this scroll wheel is Pissing me off... i'm the original        keywalker

#region GUI Input Handler
if (mbleftpress) {
	topbuttons.update();
	modebuttons.update();
	toolbarbuttons.update();
	list_tabbuttons.update();
	if selected_mode==DECO_MODE {
		layeraddbutton.update();
	}
}

if (selected_mode == DECO_MODE && deco_mode_type == "tile") {
	tilepicker.update();
}
#endregion

curs_x=window_mouse_get_x()
curs_y=window_mouse_get_y()

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
    camera_set_view_pos(view_camera[0],floor(initial_viewx+(view_grabx-curs_x)*zoom_level),floor(initial_viewy+(view_graby-curs_y)*zoom_level))
}
#endregion

var mwheel = mouse_wheel_down() - mouse_wheel_up();
if (mwheel == 0) {
	mwheel = keyboard_check_direct(vk_down) - keyboard_check_direct(vk_up)
}

//var dir = (keyboard_check_pressed(vk_right) || mouse_check_button_pressed(mb_side1)) - (mouse_check_button_pressed(mb_side2) || keyboard_check_pressed(vk_left)) 

//object_list_scroll_pos[selected_mode][current_cat]+=24*mwheel

//object_list_scroll_pos[selected_mode][current_cat] = clamp(object_list_scroll_pos[selected_mode][current_cat], 0, (ds_list_size(jade_cats[selected_mode][current_cat])*32)-object_list_area_height)

#region Camera Zooming
if (mwheel != 0) && keyboard_check(vk_control) && (not_on_gui) {
	zoom_goto += 0.125*mwheel
	zoom_x = curs_x
    zoom_y = curs_y;
}
zoom_goto=clamp(zoom_goto,0.125, 5)
var oldzoom=zoom_level
zoom_level=approach_val(zoom_level,zoom_goto,0.025)
camera_set_view_size(camera, floor(1440*zoom_level), floor(810*zoom_level))

if (zoom_level!=oldzoom) {
	cam_x = camera_get_view_x(view_camera[0])
	cam_y = camera_get_view_y(view_camera[0])
	cam_w = camera_get_view_width(view_camera[0])
	cam_h = camera_get_view_height(view_camera[0])
	
	var old_cam_w = floor(1440*oldzoom)
	var old_cam_h = floor(810*oldzoom)
	cam_x += floor(old_cam_w/2 - cam_w/2) //+ ((zoom_x-guiw/2)/(zoom_level/(zoom_goto-zoom_level)))*mwheel
	cam_y += floor(old_cam_h/2 - cam_h/2) //+ ((zoom_y-guih/2)/(zoom_level/(zoom_goto-zoom_level)))*mwheel
	
	camera_set_view_pos(camera,cam_x,cam_y)
}
#endregion

if keyboard_check(vk_control) {
	current_grid_size=1;
} else current_grid_size=default_grid_size

gridx = floor(mouse_x/current_grid_size) 
gridy = floor(mouse_y/current_grid_size)

droppedfiles=file_dropper_get_files(".jade")

if array_length(droppedfiles) {
	global.save_dir=droppedfiles[0]
	JADE_load(droppedfiles[0])
}

if (mbleft && not_on_gui) {
	switch(selected_tool) {
		case BRUSH_TOOL:
			switch(selected_mode) {
				case OBJECT_MODE:
					if is_struct(selected_obj) && !check_colliding_object(mouse_x,mouse_y) {
						object_place(selected_obj.uuid,gridx*current_grid_size,gridy*current_grid_size,1,1);
					}
				break;
			}
		break;
		case ERASE_TOOL:
			switch(selected_mode) {
				case OBJECT_MODE:
					var obj = check_colliding_object(mouse_x,mouse_y)
					if (obj) {
						ds_list_delete(object_layer_map[selected_region], obj-1)
					}
				break;
			}
		break;
		case SELECT_TOOL:
			#region object selection
			if (mbleftpress) && !(resizing) {
				//resizing
				if array_length(selected_array)==1 {
					var obj=object_layer_map[selected_region][| selected_array[0]]
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
						var obj = object_layer_map[selected_region][| selected_array[i]]
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
					var obj = object_layer_map[selected_region][| selected_array[0]]
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
		break;
	}
}

if (mbleftrel) {
	if (selection_box) {
		var box_w = (mouse_x - selection_box_x)
		var box_h = (mouse_y - selection_box_y)
		var box_x1 = floor(selection_box_x+min(box_w, 0))
		var box_y1 = floor(selection_box_y+min(box_h, 0))
		var box_x2 = floor(selection_box_x+min(box_w, 0)+abs(box_w))
		var box_y2 = floor(selection_box_y+min(box_h, 0)+abs(box_h))
		var i=0;
		repeat(ds_list_size(object_layer_map[selected_region])) {
			var obj = object_layer_map[selected_region][| i]
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
}