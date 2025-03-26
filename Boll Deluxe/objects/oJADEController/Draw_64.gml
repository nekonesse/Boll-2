var guiw=display_get_gui_width()
var guih=display_get_gui_height()

//i am so sorry for this random math its just trial and error honestly
#region Mode Icons
draw_sprite_stretched(spr_JADEtab_left,0,0,(guih/4)-10,32,(32*5)+4)
var i;

i=0;
repeat(3) //draw Mode icons
{
	draw_sprite(spr_JADEicon_bg,0,0,((guih/4)-8)+32*i) //bg square
   
	draw_sprite(spr_JADEicons,18+i,4,((guih/4)-4)+32*i) //icon
   
	if (selected_mode == i) { //selection overlay
		draw_sprite(spr_JADEicon_bg,1,0,((guih/4)-8)+32*i)
	} else if mouse_in_mode_slot(i) {
		draw_sprite(spr_JADEicon_bg,2,0,((guih/4)-8)+32*i) //hover overlay
	}
	i++;
}
#endregion

#region Toolbar Icons
var tb_length = array_length(toolbar[selected_mode])
draw_sprite_stretched(spr_JADEtab_top,0,(guiw-16)-(32*14)-2,0,(32*tb_length)+4,34)

i=0;
repeat(tb_length) //draw Editor icons
{
	if toolbar[selected_mode][i] != EMPTY_SLOT {
		draw_sprite(spr_JADEicon_bg,0,(guiw-16)-(32*14)+(32*i),0) //bg square
   
		draw_sprite(spr_JADEicons,toolbar[selected_mode][i]-1,(guiw-12)-(32*14)+(32*i),4) //icon
		
		if (selected_toolbar == i) { //selection overlay
			draw_sprite(spr_JADEicon_bg,1,(guiw-16)-(32*14)+(32*i),0)
		} else if mouse_in_toolbar_slot(i) {
			draw_sprite(spr_JADEicon_bg,2,(guiw-16)-(32*14)+(32*i),0) //hover overlay
		}
	}
	i++;
}
#endregion

#region Tile Picker
if selected_mode = TILE_MODE {
	if show_tileset && surface_exists(object_list_area_surface) {
		//window
		var t_width = sprite_get_width(tilesets[$ current_tileset][0])
		var t_height = sprite_get_height(tilesets[$ current_tileset][0])
		draw_sprite_stretched(spr_JADEwindow,0,tileset_picker_x-2,tileset_picker_y-6,(t_width/(3 / tile_zoom))+2,(t_height/(3 / tile_zoom))+8)
		draw_set_font(global.omiFont)
		//window text
		draw_set_halign(fa_left)
		draw_text_transformed(tileset_picker_x+2,tileset_picker_y-4,$"{tilesets[$ current_tileset][2]} - {layer_get_name(layers[selected_tile_layer])}",0.66,0.66,0)
		
		surface_set_target(object_list_area_surface)
		draw_clear_alpha(c_black, 0)
		draw_set_halign(fa_right)
		
		surface_reset_target();
		
		//tile picker
		draw_sprite_ext(tilesets[$ current_tileset][0], 0, tileset_picker_x,tileset_picker_y, 0.33 * tile_zoom, 0.33 * tile_zoom, 0, c_white, 1)	
		var t_x,t_y,t_w,t_h;
		t_x = tileset_picker_x+((current_tile_id mod (t_width / 16))* (16*(0.33 * tile_zoom)))
		t_y = tileset_picker_y+(floor(current_tile_id / (t_width/16))* (16*(0.33 * tile_zoom)))
		t_w = 16 * (0.33 * tile_zoom)
		t_h = 16 * (0.33 * tile_zoom)
		
		draw_rectangle(t_x,t_y,t_x + t_w-1,t_y + t_h-1,true)
	}
}
#endregion

#region Object List
if selected_mode == OBJECT_MODE {
	#region Object Mode List
	var over_tab=point_in_rectangle(curs_x,curs_y,object_list_area_x-1,object_list_area_y-24, object_list_area_x + ((object_list_area_width/3)/2),object_list_area_y)
	
	//open object list
	if (over_tab && mbleftpress) {
		if !(object_list_active) {
			temptypingstring=""
			is_typing=0;
			open_dropmenu=0;
			object_list_active = 1
			properties_tab_active = 0
			show_object_list = 1
		}
	}
	
	over_tab=point_in_rectangle(curs_x,curs_y,object_list_area_x + 1 + ((object_list_area_width/3)/2),object_list_area_y-24, object_list_area_x + (((object_list_area_width/3)/2)*3),object_list_area_y)
	
	//open properties tab
	if (over_tab && mbleftpress) {
		if !(properties_tab_active) {
			temptypingstring=""
			is_typing=0;
			open_dropmenu=0;
			object_list_active = 0
			properties_tab_active = 1
			show_object_list = 1
		}
	}
	
	if show_object_list && surface_exists(object_list_area_surface) {
		if object_list_active {
			//window tab top buttons
			//Object List Tab
			draw_sprite_stretched(spr_JADEwindowtab,0,object_list_area_x-1,object_list_area_y-20, -1 + ((object_list_area_width/3)/2),16)
			//Properties Tab
			draw_sprite_stretched(spr_JADEwindowtab,1,(object_list_area_x + 1 + ((object_list_area_width/3)/2)),object_list_area_y-16, -2 + ((object_list_area_width/3)/2),12)

			//window
			draw_sprite_stretched(spr_JADEwindow,0,object_list_area_x-2,object_list_area_y-6,(object_list_area_width/3)+2,(object_list_area_height/3)+8)
			draw_set_font(global.omiFont)
			//window text
			var window_name = ["blocks", "baddies", "items", "tech"]
			draw_set_halign(fa_left)
			draw_text_transformed(object_list_area_x+2,object_list_area_y-4,$"object list - {window_name[current_cat]}",0.66,0.66,0)
		
			//tab text
			draw_set_halign(fa_center)
			draw_text_transformed((object_list_area_x - 1 + (object_list_area_width/3)/4),object_list_area_y-16,"Object List",0.66,0.66,0)
			draw_text_transformed((object_list_area_x + 1 + ((object_list_area_width/3)/4)*3),object_list_area_y-12,"Properties",0.66,0.66,0)
		
			surface_set_target(object_list_area_surface)
			draw_clear_alpha(c_black, 0)
			draw_set_halign(fa_right)
	
			var _str = ["null", "null"]
			//object list
			i=0;
			repeat(ds_list_size(jade_cats[selected_mode][current_cat])) {
				
				_str = ds_list_find_value(jade_cats[selected_mode][current_cat], i)
					
				if is_array(_str) 
				&&	//upward culling								//downwards culling
				!(32*i < object_list_scroll_pos[selected_mode][current_cat]-24) && !(32*i > object_list_scroll_pos[selected_mode][current_cat]+object_list_area_height) {
				
				var overlapping=point_in_rectangle(curs_x,curs_y,object_list_area_x,object_list_area_y+((32/3)*i)-object_list_scroll_pos[selected_mode][current_cat]/3,object_list_area_x+object_list_area_width-6,object_list_area_y+(((32/3)*i)+10)-object_list_scroll_pos[selected_mode][current_cat]/3)
		
				if (overlapping && mbleftpress) {
					current_obj_id[selected_mode][current_cat]=i
					selected_obj = _str[0]
				}
		
				var color = c_black
				if (selected_obj == _str[0]) color = c_white
				else if (current_obj_id[selected_mode][current_cat] == i) color=c_blue
				else if (overlapping) color=c_yellow
				else color=c_black
		
				//draw background rectangle
				draw_rect(2,(32*i)+2-object_list_scroll_pos[selected_mode][current_cat],object_list_area_width-8,28, color,0.5)
				//draw object name
				ScribblejrFit(_str[1], fa_right, fa_middle, global.omiFont, 3, object_list_area_width-44, 32).Draw(object_list_area_width-6,(32*i)+15-object_list_scroll_pos[selected_mode][current_cat])
		
				//draw object sprite
				var arr=ds_map_find_value(obj_data,_str[0])
				var sprite=arr[0]
				var ysize=32
				if sprite_get_height(sprite)*2 < 32
				ysize=sprite_get_height(sprite)
		
				//draw object icon
				draw_sprite_stretched(sprite,0,4,(32*i)-object_list_scroll_pos[selected_mode][current_cat],32,ysize)
				draw_set_halign(fa_left)
				
				}
				
				i++;
			}
	
			surface_reset_target();
		} else if properties_tab_active {
			//Properties Tab
			draw_sprite_stretched(spr_JADEwindowtab,0,(object_list_area_x + 1 + ((object_list_area_width/3)/2)),object_list_area_y-20, -2 + ((object_list_area_width/3)/2),16)
			//Object List Tab
			draw_sprite_stretched(spr_JADEwindowtab,1,object_list_area_x-1,object_list_area_y-16, -1 + ((object_list_area_width/3)/2),12)
		
			//window
			draw_sprite_stretched(spr_JADEwindow,0,object_list_area_x-2,object_list_area_y-6,(object_list_area_width/3)+2,(object_list_area_height/3)+8)
			draw_set_font(global.omiFont)
		
			//tab text
			draw_set_halign(fa_center)
			draw_text_transformed((object_list_area_x - 1 + (object_list_area_width/3)/4),object_list_area_y-12,"Object List",0.66,0.66,0)
			draw_text_transformed((object_list_area_x + 1 + ((object_list_area_width/3)/4)*3),object_list_area_y-16,"Properties",0.66,0.66,0)
			
			surface_set_target(object_list_area_surface)
			draw_clear_alpha(c_black, 0)
			draw_set_halign(fa_left)
			
			var size = ds_list_size(object_layer_map)
			var properties_group = [-4];
			
			i=0;
			repeat(size) {
				var obj = ds_list_find_value(object_layer_map, i)
				var sprite = ds_map_find_value(obj_data,obj[0])
				if (obj[5] = 1) {
					if (properties_group[0] = -4) {
						properties_group[0] = obj
					} else if (properties_group[0][0] == obj[0]) {
						array_push(properties_group,obj)
					}
				}
				i++;
			}
			
			var objname=""
			if (properties_group[0] != -4) {
				var proparr=properties_group[0]
				
				var arr=ds_map_find_value(obj_data,proparr[0])
				var sprite=arr[0]
				objname=arr[10]
				var ysize=64
				if sprite_get_height(sprite)*4 < 64
				ysize=sprite_get_height(sprite)
				
				//icon border
				draw_rect(13,13,70,70,$65555c,1,true)
				draw_rect(14,14,68,68,$65555c,1,true)
				draw_rect(15,15,66,66,$65555c,1,true)
				//draw object icon
				draw_sprite_stretched(sprite,0,16,16,64,ysize)
				//draw object name
				ScribblejrFit(objname, fa_left, fa_middle, global.omiFont, 3, object_list_area_width-104, 32).Draw(96,48)
				//draw divider
				draw_rect(12,96,object_list_area_width-24,3,$65555c,1,false)
				//we're doing a reverse loop, starting from the bottom to the top so that things like drop down menus can overlay the buttons below
				var i=array_length(proparr[10])-1;
				repeat(array_length(proparr[10])) {
					if is_array(proparr[10][i]) { 
						//draw variable name
					    ScribblejrFit($"{string(proparr[10][i][1])}:", fa_left, fa_middle, global.omiFont, 3, 96, 32).Draw(16,112+32*i)
						switch(string(proparr[10][i][3])) {
							case "checkbox": {
								if !open_dropmenu {
									draw_sprite_stretched(spr_JADEcheckbox,bool(proparr[10][i][2]),96+16,(112+32*i)-12,8*3,8*3)
								
									//toggle variable
									var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*i,object_list_area_x+44,object_list_area_y+40+(32/3)*i)&&(!open_dropmenu||open_dropmenu-1==i)
								
									if (mbleftpress) {
										if (incheck) {
											show_debug_message(proparr[10][i][2])
											proparr[10][i][2]=!bool(proparr[10][i][2])
											var k=1
											repeat (array_length(properties_group)-1) {
												properties_group[k][10][i][2]=proparr[10][i][2]
												k++
											}
										}
									}
								} else break
								break
							}
							case "dropdown": {
								draw_sprite_stretched(spr_JADEdropdown,0,96+16,(112+32*i)-12,8*20,8*3)
								//draw selected variable
								ScribblejrFit(string(proparr[10][i][2]), fa_left, fa_top, global.omiFont, 2, 160-8, 20).Draw(96+24,(112+32*i)-6)

								//toggle variable
								var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*i,object_list_area_x+34+56,object_list_area_y+40+(32/3)*i)&&(!open_dropmenu||open_dropmenu-1==i)
								
								if (incheck) && (mbleftpress) {
									if !(open_dropmenu) {
										open_dropmenu=i+1;
									} else {
										open_dropmenu=0;
									}
								}
								
								if (open_dropmenu-1 == i) {
									var menuarr=proparr[10][i][4]
									if !is_array(menuarr) break;
									
									var j=0;
									repeat(array_length(menuarr)) {
									    //draw dropdown menus
										draw_sprite_stretched(spr_JADEdropdown,j == array_length(menuarr)-1 ? 2 : 1,96+16,(112+32*i+24*j)+12,8*20,8*3)
										//draw list of variables
										ScribblejrFit(string(menuarr[j]), fa_left, fa_top, global.omiFont, 2, 160-8, 20).Draw(96+24,(112+32*i+24*j)+18)
										
										var insubcheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+40+(32/3)*i+8*j,object_list_area_x+34+56,object_list_area_y+48+(32/3)*i+8*j)&&(!open_dropmenu||open_dropmenu-1==i)
								
										if (insubcheck) && (mbleftpress) {
											//set selected object to selected variable
											var k=0
											repeat (array_length(properties_group)) {
											    properties_group[k][10][i][2]=menuarr[j];
												k++
											}
											open_dropmenu=0;
										}
										j++;
									}
								}
								break
							}
							case "number_input": {
								if !open_dropmenu {
									draw_sprite_stretched(spr_JADEnumberinput,0,96+16,(112+32*i)-12,8*3,8*3)
									if !(is_typing-1==i)
									ScribblejrFit(string(proparr[10][i][2]), fa_middle, fa_top, global.omiFont, 2, 19, 19).Draw(96+29,(112+32*i)-6)
									else
									ScribblejrFit(temptypingstring, fa_middle, fa_top, global.omiFont, 2, 19, 19).Draw(96+29,(112+32*i)-6)
									
									//check if clicking on box
									var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*i,object_list_area_x+44,object_list_area_y+40+(32/3)*i)&&(!open_dropmenu||open_dropmenu-1==i)
									
									if (mbleftpress) {
										//start typing
										if (incheck) && !is_typing {
											is_typing=i+1
										}
										
										//if clicking off of the box, finish typing
										if !(incheck) && (is_typing-1==i) {
											//set the variable to our typed number, if its blank reset back to the value it was before
											var k=0
											repeat (array_length(properties_group)) {
											    properties_group[k][10][i][2]=unreal(temptypingstring,properties_group[k][10][i][2])
												k++
											}
											temptypingstring=""
											is_typing=0;
										}
									}
									
									//if pressed enter and typing, finish typing aswell
									if keyboard_check_pressed(vk_enter) && (is_typing-1==i) {
										var k=0
										repeat (array_length(properties_group)) {
											properties_group[k][10][i][2]=unreal(temptypingstring,properties_group[k][10][i][2])
											k++
										}
										temptypingstring=""
										is_typing=0;
									}
									
									if (is_typing-1==i) {
										//simple typing script
										if string_length(keyboard_lastchar) && keyboard_check_pressed(vk_anykey) {
											switch (keyboard_lastkey) { //forbidden keys, these can create unnessecary letters that are unwanted
												case ord("0"):
												case ord("1"):
												case ord("2"): 
												case ord("3"): 
												case ord("4"): 
												case ord("5"): 
												case ord("6"): 
												case ord("7"): 
												case ord("8"): 
												case ord("9"): 
												case 190: 
												case 189: {
													temptypingstring+=keyboard_lastchar;
													break;
												}
												default: {
													break;
												}
											}
										}
										if keyboard_check_pressed(vk_backspace) {
											temptypingstring=string_copy(temptypingstring,0,string_length(temptypingstring)-1)
										}
									}
								} else break
								break
							}
							case "string_input": {
								if !open_dropmenu {
									draw_sprite_stretched(spr_JADEstringinput,0,96+16,(112+32*i)-12,96,24)
									if !(is_typing-1==i)
									ScribblejrFit(string(proparr[10][i][2]), fa_left, fa_top, global.omiFont, 2, 82, 19).Draw(96+24,(112+32*i)-6)
									else
									ScribblejrFit(temptypingstring, fa_left, fa_top, global.omiFont, 2, 82, 19).Draw(96+24,(112+32*i)-6)
									
									//check if clicking on box
									var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+11*i,object_list_area_x+133,object_list_area_y+40+11*i)&&(!open_dropmenu||open_dropmenu-1==i)
									
									if (mbleftpress) {
										//start typing
										if (incheck) && !is_typing {
											is_typing=i+1
										}
										
										//if clicking off of the box, finish typing
										if !(incheck) && (is_typing-1==i) {
											var k=0
											repeat (array_length(properties_group)) {
												properties_group[k][10][i][2]=string(temptypingstring)
												k++
											}
											temptypingstring=""
											is_typing=0;
										}
									}
									
									//if pressed enter and typing, finish typing aswell
									if keyboard_check_pressed(vk_enter) && (is_typing-1==i) {
										var k=0
										repeat (array_length(properties_group)) {
											properties_group[k][10][i][2]=string(temptypingstring)
											k++
										}
										temptypingstring=""
										is_typing=0;
									}
									
									if (is_typing-1==i) {
										//simple typing script
										if string_length(keyboard_lastchar) && keyboard_check_pressed(vk_anykey) {
											switch (keyboard_lastkey) {
												case vk_tab: //forbidden keys, these can create unnessecary letters that are unwanted
												case vk_backspace:
												case vk_capslock:
												case vk_control:
												case vk_rcontrol:
												case vk_shift:
												case vk_rshift:
												case vk_enter:
												case ord(chr(34)): //quote
												case ord(chr(92)): { //backslash
													break;
												}
												default: {
													temptypingstring+=keyboard_lastchar
													break;
												}
											}
										}
										if keyboard_check_pressed(vk_backspace) {
											temptypingstring=string_copy(temptypingstring,0,string_length(temptypingstring)-1)
										}
									}
								} else break
								break
							}
						}
					}
					i--;
				}
			} else {
				temptypingstring=""
				is_typing=0;
			}
			
			surface_reset_target();
			
			//window text
			draw_set_font(global.omiFont)
			draw_text_transformed(object_list_area_x+2,object_list_area_y-4,$"properties - {objname}",0.66,0.66,0)
		}
		
		draw_surface_stretched(object_list_area_surface, object_list_area_x, object_list_area_y, object_list_area_width/3, object_list_area_height/3)
	} else {
		//Properties Tab
		draw_sprite_stretched(spr_JADEwindowtab,1,(object_list_area_x + 1 + ((object_list_area_width/3)/2)),object_list_area_y-16, -2 + ((object_list_area_width/3)/2),12)
		//Object List Tab
		draw_sprite_stretched(spr_JADEwindowtab,1,object_list_area_x-1,object_list_area_y-16, -1 + ((object_list_area_width/3)/2),12)
		//window
		draw_sprite_stretched(spr_JADEwindow,0,object_list_area_x-2,object_list_area_y-6,(object_list_area_width/3)+2,8)
		
		draw_set_font(global.omiFont)
		draw_set_halign(fa_left)
		
		//window text
		draw_text_transformed(object_list_area_x+2,object_list_area_y-4,"jade - select a tab",0.66,0.66,0)
		
		//tab text
		draw_set_halign(fa_center)
		draw_text_transformed((object_list_area_x - 1 + (object_list_area_width/3)/4),object_list_area_y-12,"Object List",0.66,0.66,0)
		draw_text_transformed((object_list_area_x + 1 + ((object_list_area_width/3)/4)*3),object_list_area_y-12,"Properties",0.66,0.66,0)		
		
		draw_set_halign(fa_left)
	}
	
	#endregion
} else if selected_mode==NODE_MODE {
	var over_tab=point_in_rectangle(curs_x,curs_y,object_list_area_x-1,object_list_area_y-24, object_list_area_x + ((object_list_area_width/3)/2),object_list_area_y)
	
	//open object list
	if (over_tab && mbleftpress) {
		if !(object_list_active) {
			temptypingstring=""
			is_typing=0;
			open_dropmenu=0;
			object_list_active = 1
			properties_tab_active = 0
			show_object_list = 1
		}
	}
	
	over_tab=point_in_rectangle(curs_x,curs_y,object_list_area_x + 1 + ((object_list_area_width/3)/2),object_list_area_y-24, object_list_area_x + (((object_list_area_width/3)/2)*3),object_list_area_y)
	
	//open properties tab
	if (over_tab && mbleftpress) {
		if !(properties_tab_active) {
			temptypingstring=""
			is_typing=0;
			open_dropmenu=0;
			object_list_active = 0
			properties_tab_active = 1
			show_object_list = 1
		}
	}
	
	if show_object_list && surface_exists(object_list_area_surface) {
		if object_list_active {
			//window tab top buttons
			//Object List Tab
			draw_sprite_stretched(spr_JADEwindowtab,0,object_list_area_x-1,object_list_area_y-20, -1 + ((object_list_area_width/3)/2),16)
			//Properties Tab
			draw_sprite_stretched(spr_JADEwindowtab,1,(object_list_area_x + 1 + ((object_list_area_width/3)/2)),object_list_area_y-16, -2 + ((object_list_area_width/3)/2),12)

			//window
			draw_sprite_stretched(spr_JADEwindow,0,object_list_area_x-2,object_list_area_y-6,(object_list_area_width/3)+2,(object_list_area_height/3)+8)
			draw_set_font(global.omiFont)
			
			//window text
			draw_set_halign(fa_left)
			draw_text_transformed(object_list_area_x+2,object_list_area_y-4,$"gizmo list",0.66,0.66,0)
		
			//tab text
			draw_set_halign(fa_center)
			draw_text_transformed((object_list_area_x - 1 + (object_list_area_width/3)/4),object_list_area_y-16,"Object List",0.66,0.66,0)
			draw_text_transformed((object_list_area_x + 1 + ((object_list_area_width/3)/4)*3),object_list_area_y-12,"Properties",0.66,0.66,0)
		
			surface_set_target(object_list_area_surface)
			draw_clear_alpha(c_black, 0)
			draw_set_halign(fa_right)
	
			var _str = "null"
			current_cat=0;
			//object list
			var i=0;
			var _str = ["null", "null"]
			repeat(ds_list_size(jade_cats[selected_mode][current_cat])) {
				
				_str = ds_list_find_value(jade_cats[selected_mode][current_cat], i)
				
				var overlapping=point_in_rectangle(curs_x,curs_y,object_list_area_x,object_list_area_y+((32/3)*i)-object_list_scroll_pos[selected_mode][current_cat]/3,object_list_area_x+object_list_area_width-6,object_list_area_y+(((32/3)*i)+10)-object_list_scroll_pos[selected_mode][current_cat]/3)
				
				if is_array(_str) 
				&&	//upward culling								//downwards culling
				!(32*i < object_list_scroll_pos[selected_mode][current_cat]-24) && !(32*i > object_list_scroll_pos[selected_mode][current_cat]+object_list_area_height) {
				
		
				if (overlapping && mbleftpress) {
					current_obj_id[selected_mode][current_cat]=i
					selected_obj = _str[0]
				}
		
				var color = c_black
				if (selected_obj == _str[0]) color = c_white
				else if (current_obj_id[selected_mode][current_cat] == i) color=c_blue
				else if (overlapping) color=c_yellow
				else color=c_black
		
				//draw background rectangle
				draw_rect(2,(32*i)+2-object_list_scroll_pos[selected_mode][current_cat],object_list_area_width-8,28, color,0.5)
				//draw object name
				ScribblejrFit(_str[1], fa_right, fa_middle, global.omiFont, 3, object_list_area_width-44, 32).Draw(object_list_area_width-6,(32*i)+15-object_list_scroll_pos[selected_mode][current_cat])
		
				//draw object sprite
				var arr=ds_map_find_value(obj_data,_str[0])
				var sprite=arr[0]
				var ysize=32
				if sprite_get_height(sprite)*2 < 32
				ysize=sprite_get_height(sprite)
		
				//draw object icon
				draw_sprite_stretched(sprite,0,4,(32*i)-object_list_scroll_pos[selected_mode][current_cat],32,ysize)
				draw_set_halign(fa_left)
				}
				i++;
			}
	
			surface_reset_target();
		} else if properties_tab_active {
			//Properties Tab
			draw_sprite_stretched(spr_JADEwindowtab,0,(object_list_area_x + 1 + ((object_list_area_width/3)/2)),object_list_area_y-20, -2 + ((object_list_area_width/3)/2),16)
			//Object List Tab
			draw_sprite_stretched(spr_JADEwindowtab,1,object_list_area_x-1,object_list_area_y-16, -1 + ((object_list_area_width/3)/2),12)
		
			//window
			draw_sprite_stretched(spr_JADEwindow,0,object_list_area_x-2,object_list_area_y-6,(object_list_area_width/3)+2,(object_list_area_height/3)+8)
			draw_set_font(global.omiFont)
		
			//tab text
			draw_set_halign(fa_center)
			draw_text_transformed((object_list_area_x - 1 + (object_list_area_width/3)/4),object_list_area_y-12,"Object List",0.66,0.66,0)
			draw_text_transformed((object_list_area_x + 1 + ((object_list_area_width/3)/4)*3),object_list_area_y-16,"Properties",0.66,0.66,0)
			
			surface_set_target(object_list_area_surface)
			draw_clear_alpha(c_black, 0)
			draw_set_halign(fa_left)
			
			var objname=""
			if selected_tool!=NODE_TOOL {
			
			var size = ds_list_size(node_layer_map)
			var properties_group = [-4];
			
			var i=0;
			repeat(size) {
				var obj = ds_list_find_value(node_layer_map, i)
				var sprite = ds_map_find_value(obj_data,obj[0])
				if (obj[5] = 1) {
					if (properties_group[0] = -4) {
						properties_group[0] = obj
					} else if (properties_group[0][0] == obj[0]) {
						array_push(properties_group,obj)
					}
				}
				i++;
			}
			
			if (properties_group[0] != -4) {
				var proparr=properties_group[0]
				objname=proparr[0]
				
				var arr=ds_map_find_value(obj_data,proparr[0])
				var sprite=arr[0]
				var ysize=64
				if sprite_get_height(sprite)*4 < 64
				ysize=sprite_get_height(sprite)
				
				//icon border
				draw_rect(13,13,70,70,$65555c,1,true)
				draw_rect(14,14,68,68,$65555c,1,true)
				draw_rect(15,15,66,66,$65555c,1,true)
				//draw object icon
				draw_sprite_stretched(sprite,0,16,16,64,ysize)
				//draw object name
				ScribblejrFit(objname, fa_left, fa_middle, global.omiFont, 3, object_list_area_width-104, 32).Draw(96,48)
				//draw divider
				draw_rect(12,96,object_list_area_width-24,3,$65555c,1,false)
				//we're doing a reverse loop, starting from the bottom to the top so that things like drop down menus can overlay the buttons below
				var i=array_length(proparr[10])-1;
				repeat(array_length(proparr[10])) {
					if is_array(proparr[10][i]) { 
						//draw variable name
					    ScribblejrFit($"{string(proparr[10][i][1])}:", fa_left, fa_middle, global.omiFont, 3, 96, 32).Draw(16,112+32*i)
						switch(string(proparr[10][i][3])) {
							case "checkbox": {
								if !open_dropmenu {
									draw_sprite_stretched(spr_JADEcheckbox,bool(proparr[10][i][2]),96+16,(112+32*i)-12,8*3,8*3)
								
									//toggle variable
									var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*i,object_list_area_x+44,object_list_area_y+40+(32/3)*i)&&(!open_dropmenu||open_dropmenu-1==i)
								
									if (mbleftpress) {
										if (incheck) {
											show_debug_message(proparr[10][i][2])
											proparr[10][i][2]=!bool(proparr[10][i][2])
											var k=1
											repeat (array_length(properties_group)-1) {
												properties_group[k][10][i][2]=proparr[10][i][2]
												k++
											}
										}
									}
								} else break
								break
							}
							case "dropdown": {
								draw_sprite_stretched(spr_JADEdropdown,0,96+16,(112+32*i)-12,8*20,8*3)
								//draw selected variable
								ScribblejrFit(string(proparr[10][i][2]), fa_left, fa_top, global.omiFont, 2, 160-8, 20).Draw(96+24,(112+32*i)-6)

								//toggle variable
								var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*i,object_list_area_x+34+56,object_list_area_y+40+(32/3)*i)&&(!open_dropmenu||open_dropmenu-1==i)
								
								if (incheck) && (mbleftpress) {
									if !(open_dropmenu) {
										open_dropmenu=i+1;
									} else {
										open_dropmenu=0;
									}
								}
								
								if (open_dropmenu-1 == i) {
									var menuarr=proparr[10][i][4]
									if !is_array(menuarr) break;
									
									var j=0;
									repeat(array_length(menuarr)) {
									    //draw dropdown menus
										draw_sprite_stretched(spr_JADEdropdown,j == array_length(menuarr)-1 ? 2 : 1,96+16,(112+32*i+24*j)+12,8*20,8*3)
										//draw list of variables
										ScribblejrFit(string(menuarr[j]), fa_left, fa_top, global.omiFont, 2, 160-8, 20).Draw(96+24,(112+32*i+24*j)+18)
										
										var insubcheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+40+(32/3)*i+8*j,object_list_area_x+34+56,object_list_area_y+48+(32/3)*i+8*j)&&(!open_dropmenu||open_dropmenu-1==i)
								
										if (insubcheck) && (mbleftpress) {
											//set selected object to selected variable
											var k=0
											repeat (array_length(properties_group)) {
											    properties_group[k][10][i][2]=menuarr[j];
												k++
											}
											open_dropmenu=0;
										}
										j++;
									}
								}
								break
							}
							case "number_input": {
								if !open_dropmenu {
									draw_sprite_stretched(spr_JADEnumberinput,0,96+16,(112+32*i)-12,8*3,8*3)
									if !(is_typing-1==i)
									ScribblejrFit(string(proparr[10][i][2]), fa_middle, fa_top, global.omiFont, 2, 19, 19).Draw(96+29,(112+32*i)-6)
									else
									ScribblejrFit(temptypingstring, fa_middle, fa_top, global.omiFont, 2, 19, 19).Draw(96+29,(112+32*i)-6)
									
									//check if clicking on box
									var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*i,object_list_area_x+44,object_list_area_y+40+(32/3)*i)&&(!open_dropmenu||open_dropmenu-1==i)
									
									if (mbleftpress) {
										//start typing
										if (incheck) && !is_typing {
											is_typing=i+1
										}
										
										//if clicking off of the box, finish typing
										if !(incheck) && (is_typing-1==i) {
											//set the variable to our typed number, if its blank reset back to the value it was before
											var k=0
											repeat (array_length(properties_group)) {
											    properties_group[k][10][i][2]=unreal(temptypingstring,properties_group[k][10][i][2])
												k++
											}
											temptypingstring=""
											is_typing=0;
										}
									}
									
									//if pressed enter and typing, finish typing aswell
									if keyboard_check_pressed(vk_enter) && (is_typing-1==i) {
										var k=0
										repeat (array_length(properties_group)) {
											properties_group[k][10][i][2]=unreal(temptypingstring,properties_group[k][10][i][2])
											k++
										}
										temptypingstring=""
										is_typing=0;
									}
									
									if (is_typing-1==i) {
										//simple typing script
										if string_length(keyboard_lastchar) && keyboard_check_pressed(vk_anykey) {
											switch (keyboard_lastkey) { //forbidden keys, these can create unnessecary letters that are unwanted
												case ord("0"):
												case ord("1"):
												case ord("2"): 
												case ord("3"): 
												case ord("4"): 
												case ord("5"): 
												case ord("6"): 
												case ord("7"): 
												case ord("8"): 
												case ord("9"): 
												case 190: 
												case 189: {
													temptypingstring+=keyboard_lastchar;
													break;
												}
												default: {
													break;
												}
											}
										}
										if keyboard_check_pressed(vk_backspace) {
											temptypingstring=string_copy(temptypingstring,0,string_length(temptypingstring)-1)
										}
									}
								} else break
								break
							}
							case "string_input": {
								if !open_dropmenu {
									draw_sprite_stretched(spr_JADEstringinput,0,96+16,(112+32*i)-12,96,24)
									if !(is_typing-1==i)
									ScribblejrFit(string(proparr[10][i][2]), fa_left, fa_top, global.omiFont, 2, 82, 19).Draw(96+24,(112+32*i)-6)
									else
									ScribblejrFit(temptypingstring, fa_left, fa_top, global.omiFont, 2, 82, 19).Draw(96+24,(112+32*i)-6)
									
									//check if clicking on box
									var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+11*i,object_list_area_x+133,object_list_area_y+40+11*i)&&(!open_dropmenu||open_dropmenu-1==i)
									
									if (mbleftpress) {
										//start typing
										if (incheck) && !is_typing {
											is_typing=i+1
										}
										
										//if clicking off of the box, finish typing
										if !(incheck) && (is_typing-1==i) {
											var k=0
											repeat (array_length(properties_group)) {
												properties_group[k][10][i][2]=string(temptypingstring)
												k++
											}
											temptypingstring=""
											is_typing=0;
										}
									}
									
									//if pressed enter and typing, finish typing aswell
									if keyboard_check_pressed(vk_enter) && (is_typing-1==i) {
										var k=0
										repeat (array_length(properties_group)) {
											properties_group[k][10][i][2]=string(temptypingstring)
											k++
										}
										temptypingstring=""
										is_typing=0;
									}
									
									if (is_typing-1==i) {
										//simple typing script
										if string_length(keyboard_lastchar) && keyboard_check_pressed(vk_anykey) {
											switch (keyboard_lastkey) {
												case vk_tab: //forbidden keys, these can create unnessecary letters that are unwanted
												case vk_backspace:
												case vk_capslock:
												case vk_control:
												case vk_rcontrol:
												case vk_shift:
												case vk_rshift:
												case vk_enter:
												case ord(chr(34)): //quote
												case ord(chr(92)): { //backslash
													break;
												}
												default: {
													temptypingstring+=keyboard_lastchar
													break;
												}
											}
										}
										if keyboard_check_pressed(vk_backspace) {
											temptypingstring=string_copy(temptypingstring,0,string_length(temptypingstring)-1)
										}
									}
								} else break
								break
							}
						}
					}
					i--;
				}
			} else if selected_tool==NODE_TOOL && drawing_node!=-1 {
				var obj=ds_list_find_value(object_layer_map, drawing_node)
				var proparr=obj[12]
				var objname=string(obj[0])
				
				var sprite=ds_map_find_value(obj_data,obj[0])
				var ysize=64
				if sprite_get_height(sprite[0])*4 < 64
				ysize=sprite_get_height(sprite[0])
				
				//icon border
				draw_rect(13,13,70,70,$65555c,1,true)
				draw_rect(14,14,68,68,$65555c,1,true)
				draw_rect(15,15,66,66,$65555c,1,true)
				//draw object icon
				draw_sprite_stretched(sprite[0],0,16,16,64,ysize)
				//draw object name
				ScribblejrFit(objname, fa_left, fa_middle, global.omiFont, 3, object_list_area_width-104, 32).Draw(96,48)
				//draw divider
				draw_rect(12,96,object_list_area_width-24,3,$65555c,1,false)
					if is_array(proparr) { 
						ScribblejrFit($"Reverse on End:", fa_left, fa_middle, global.omiFont, 3, 96, 32).Draw(16,112+32*1)
						draw_sprite_stretched(spr_JADEcheckbox,bool(proparr[1]),96+16,(112+32*1)-12,8*3,8*3)
								
						//toggle variable
						var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*1,object_list_area_x+44,object_list_area_y+40+(32/3)*1)&&(!open_dropmenu||open_dropmenu-1==1)
								
						if (mbleftpress) {
							if (incheck) {
								proparr[1]=!proparr[1]
							}
						}
						
						//number inputs
						ScribblejrFit($"Path Speed:", fa_left, fa_middle, global.omiFont, 3, 96, 32).Draw(16,112)
						
						draw_sprite_stretched(spr_JADEnumberinput,0,96+16,(112)-12,8*3,8*3)
						if !(is_typing-1==0)
						ScribblejrFit(string(proparr[0]), fa_middle, fa_top, global.omiFont, 2, 19, 19).Draw(96+29,(112)-6)
						else
						ScribblejrFit(temptypingstring, fa_middle, fa_top, global.omiFont, 2, 19, 19).Draw(96+29,(112)-6)
						
						//check if clicking on box
						var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34,object_list_area_x+44,object_list_area_y+40)&&(!open_dropmenu||open_dropmenu-1==0)
									
						if (mbleftpress) {
							//start typing
							if (incheck) && !is_typing {
								is_typing=1
							}
										
							//if clicking off of the box, finish typing
							if !(incheck) && (is_typing-1==0) {
								//set the variable to our typed number, if its blank reset back to the value it was before
								proparr[0]=unreal(temptypingstring,proparr[0])
								temptypingstring=""
								is_typing=0;
							}
						}
									
						//if pressed enter and typing, finish typing aswell
						if keyboard_check_pressed(vk_enter) && (is_typing-1==0) {
							proparr[0]=unreal(temptypingstring,proparr[0])
							temptypingstring=""
							is_typing=0;
						}
						
						//number inputs
						ScribblejrFit($"Starting Node:", fa_left, fa_middle, global.omiFont, 3, 96, 32).Draw(16,112+32*2)
						
						draw_sprite_stretched(spr_JADEnumberinput,0,96+16,(112+32*2)-12,8*3,8*3)
						if !(is_typing-1==2)
						ScribblejrFit(string(proparr[2]), fa_middle, fa_top, global.omiFont, 2, 19, 19).Draw(96+29,(112+32*2)-6)
						else
						ScribblejrFit(temptypingstring, fa_middle, fa_top, global.omiFont, 2, 19, 19).Draw(96+29,(112+32*2)-6)
						
						//check if clicking on box
						var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*2,object_list_area_x+44,object_list_area_y+40+(32/3)*2)&&(!open_dropmenu||open_dropmenu-1==2)
									
						if (mbleftpress) {
							//start typing
							if (incheck) && !is_typing {
								is_typing=3
							}
										
							//if clicking off of the box, finish typing
							if !(incheck) && (is_typing-1==2) {
								//set the variable to our typed number, if its blank reset back to the value it was before
								proparr[0]=unreal(temptypingstring,proparr[2])
								temptypingstring=""
								is_typing=0;
							}
						}
									
						//if pressed enter and typing, finish typing aswell
						if keyboard_check_pressed(vk_enter) && (is_typing-1==2) {
							proparr[2]=floor(unreal(temptypingstring,proparr[2]))
							temptypingstring=""
							is_typing=0;
						}
									
						if (is_typing) {
							//simple typing script
							if string_length(keyboard_lastchar) && keyboard_check_pressed(vk_anykey) {
								switch (keyboard_lastkey) { //forbidden keys, these can create unnessecary letters that are unwanted
									case ord("0"):
									case ord("1"):
									case ord("2"): 
									case ord("3"): 
									case ord("4"): 
									case ord("5"): 
									case ord("6"): 
									case ord("7"): 
									case ord("8"): 
									case ord("9"): 
									case 190: {
										temptypingstring+=keyboard_lastchar;
										break;
									}
									default: {
										break;
									}
								}
							}
							if keyboard_check_pressed(vk_backspace) {
								temptypingstring=string_copy(temptypingstring,0,string_length(temptypingstring)-1)
							}
						}
						
						ScribblejrFit($"Fall on End:", fa_left, fa_middle, global.omiFont, 3, 96, 32).Draw(16,112+32*3)
						draw_sprite_stretched(spr_JADEcheckbox,bool(proparr[3]),96+16,(112+32*3)-12,8*3,8*3)
								
						//toggle variable
						var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*3,object_list_area_x+44,object_list_area_y+40+(32/3)*3)&&(!open_dropmenu||open_dropmenu-1==3)
								
						if (mbleftpress) {
							if (incheck) {
								proparr[3]=!proparr[3]
							}
						}
						
						ScribblejrFit($"Draw Track:", fa_left, fa_middle, global.omiFont, 3, 96, 32).Draw(16,112+32*4)
						draw_sprite_stretched(spr_JADEcheckbox,bool(proparr[4]),96+16,(112+32*4)-12,8*3,8*3)
								
						//toggle variable
						var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*4,object_list_area_x+44,object_list_area_y+40+(32/3)*4)&&(!open_dropmenu||open_dropmenu-1==4)
								
						if (mbleftpress) {
							if (incheck) {
								proparr[4]=!proparr[4]
							}
						}
						
						ScribblejrFit($"Auto Start:", fa_left, fa_middle, global.omiFont, 3, 96, 32).Draw(16,112+32*5)
						draw_sprite_stretched(spr_JADEcheckbox,bool(proparr[5]),96+16,(112+32*5)-12,8*3,8*3)
								
						//toggle variable
						var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*5,object_list_area_x+44,object_list_area_y+40+(32/3)*5)&&(!open_dropmenu||open_dropmenu-1==5)
								
						if (mbleftpress) {
							if (incheck) {
								proparr[5]=!proparr[5]
							}
						}
					}
				}
			} else {
				temptypingstring=""
				is_typing=0;
			}
			
			surface_reset_target();
			
			//window text
			draw_set_font(global.omiFont)
			draw_text_transformed(object_list_area_x+2,object_list_area_y-4,$"properties - {objname}",0.66,0.66,0)
		}
		
		draw_surface_stretched(object_list_area_surface, object_list_area_x, object_list_area_y, object_list_area_width/3, object_list_area_height/3)
	} else {
		//Properties Tab
		draw_sprite_stretched(spr_JADEwindowtab,1,(object_list_area_x + 1 + ((object_list_area_width/3)/2)),object_list_area_y-16, -2 + ((object_list_area_width/3)/2),12)
		//Object List Tab
		draw_sprite_stretched(spr_JADEwindowtab,1,object_list_area_x-1,object_list_area_y-16, -1 + ((object_list_area_width/3)/2),12)
		//window
		draw_sprite_stretched(spr_JADEwindow,0,object_list_area_x-2,object_list_area_y-6,(object_list_area_width/3)+2,8)
		
		draw_set_font(global.omiFont)
		draw_set_halign(fa_left)
		
		//window text
		draw_text_transformed(object_list_area_x+2,object_list_area_y-4,"jade - select a tab",0.66,0.66,0)
		
		//tab text
		draw_set_halign(fa_center)
		draw_text_transformed((object_list_area_x - 1 + (object_list_area_width/3)/4),object_list_area_y-12,"Object List",0.66,0.66,0)
		draw_text_transformed((object_list_area_x + 1 + ((object_list_area_width/3)/4)*3),object_list_area_y-12,"Properties",0.66,0.66,0)		
		
		draw_set_halign(fa_left)
	}
}
#endregion

if (savetextdur) && (global.save_dir!="") {
	savetextdur=max(0,savetextdur-1)
	draw_set_font(global.omiFont)
	draw_set_halign(fa_center)
	draw_set_alpha(savetextdur/30)
	draw_text_outline(guiw/2,guih-24,$"Saved to: {global.save_dir}!", 1, c_black, 8, 1, 1, 0)
	draw_set_alpha(1)
	draw_set_halign(fa_left)
}