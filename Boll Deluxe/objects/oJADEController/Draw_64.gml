var guiw=display_get_gui_width()
var guih=display_get_gui_height()

//i am so sorry for this random math its just trial and error honestly
#region Mode Icons
draw_sprite_stretched(spr_JADEtab_left,0,0,(guih/4)-10,32,(32*5)+4)

for (var i = 0; i < 5; ++i) //draw Mode icons
{
	draw_sprite(spr_JADEicon_bg,0,0,((guih/4)-8)+32*i) //bg square
   
	draw_sprite(spr_JADEicons,17+i,4,((guih/4)-4)+32*i) //icon
   
	if (selected_mode == i) { //selection overlay
		draw_sprite(spr_JADEicon_bg,1,0,((guih/4)-8)+32*i)
	} else if mouse_in_mode_slot(i) {
		draw_sprite(spr_JADEicon_bg,2,0,((guih/4)-8)+32*i) //hover overlay
	}
}
#endregion

#region Editor Icons
draw_sprite_stretched(spr_JADEtab_top,0,(guiw)-(32*5),0,(32*5)+4,34)

for (var i = 0; i < 5; ++i) //draw Editor icons
{
	draw_sprite(spr_JADEicon_bg,0,(guiw-32)-(32*i),0) //bg square
   
	draw_sprite(spr_JADEicons,16-i,(guiw-28)-(32*i),4) //icon
   
	if mouse_in_setting_slot(i) {
		draw_sprite(spr_JADEicon_bg,2,(guiw-32)-(32*i),0) //hover overlay
	}
}
#endregion

#region Toolbar Icons
var tb_length = array_length(toolbar[selected_mode])
draw_sprite_stretched(spr_JADEtab_top,0,(guiw-16)-(32*14),0,(32*tb_length)+4,34)

for (var i = 0; i < tb_length; ++i) //draw Editor icons
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
}
#endregion

#region Tile Picker
if selected_mode = TILE_MODE {
	if show_tileset {
		var tilelapmap = tileset_get_info(tTilesetMain)
		draw_sprite_ext(spr_TilesetMain, 0, tileset_picker_x,tileset_picker_y, 0.33, 0.33, 0, c_white, 1)	
		var t_width = sprite_get_width(spr_TilesetMain)
		var t_x,t_y,t_w,t_h;
		t_x = tileset_picker_x+((current_tile_id[0][0] mod (t_width / 16))* (16*0.33))
		t_y = tileset_picker_y+(floor(current_tile_id[0][0]/(t_width/16))* (16*0.33))
		t_w = (tile_sel_width + 1)* 16 * 0.33
		t_h = (tile_sel_height + 1) * 16 * 0.33
		
		
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
			draw_set_font(smallF)
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
	
			var _str = "null"
			//object list
			for (var i = 0; i < ds_list_size(jade_cats[selected_mode][current_cat]); ++i) {
				
					//upward culling								//downwards culling
				if (32*i < object_list_scroll_pos[selected_mode][current_cat]-24) || (32*i > object_list_scroll_pos[selected_mode][current_cat]+object_list_area_height) {
					continue;
				}
			
				_str = ds_list_find_value(jade_cats[selected_mode][current_cat], i)
				if _str == undefined{
					break;	
				}
				var overlapping=point_in_rectangle(curs_x,curs_y,object_list_area_x,object_list_area_y+((32/3)*i)-object_list_scroll_pos[selected_mode][current_cat]/3,object_list_area_x+object_list_area_width-6,object_list_area_y+(((32/3)*i)+10)-object_list_scroll_pos[selected_mode][current_cat]/3)
		
				if (overlapping && mbleftpress) {
					current_obj_id[selected_mode][current_cat]=i
					selected_obj = _str
				}
		
				var color = c_black
				if (selected_obj == _str) color = c_white
				else if (current_obj_id[selected_mode][current_cat] == i) color=c_blue
				else if (overlapping) color=c_yellow
				else color=c_black
		
				//draw background rectangle
				draw_rect(2,(32*i)+2-object_list_scroll_pos[selected_mode][current_cat],object_list_area_width-8,28, color,0.5)
				//draw object name
				ScribblejrFit(_str, fa_right, fa_middle, smallF, 3, object_list_area_width-44, 32).Draw(object_list_area_width-6,(32*i)+15-object_list_scroll_pos[selected_mode][current_cat])
		
				//draw object sprite
				var arr=ds_map_find_value(obj_data,_str)
				var sprite=arr[0]
				var ysize=32
				if sprite_get_height(sprite)*2 < 32
				ysize=sprite_get_height(sprite)
		
				//draw object icon
				draw_sprite_stretched(sprite,0,4,(32*i)-object_list_scroll_pos[selected_mode][current_cat],32,ysize)
				draw_set_halign(fa_left)
			}
	
			surface_reset_target();
		} else if properties_tab_active {
			//Properties Tab
			draw_sprite_stretched(spr_JADEwindowtab,0,(object_list_area_x + 1 + ((object_list_area_width/3)/2)),object_list_area_y-20, -2 + ((object_list_area_width/3)/2),16)
			//Object List Tab
			draw_sprite_stretched(spr_JADEwindowtab,1,object_list_area_x-1,object_list_area_y-16, -1 + ((object_list_area_width/3)/2),12)
		
			//window
			draw_sprite_stretched(spr_JADEwindow,0,object_list_area_x-2,object_list_area_y-6,(object_list_area_width/3)+2,(object_list_area_height/3)+8)
			draw_set_font(smallF)
		
			//tab text
			draw_set_halign(fa_center)
			draw_text_transformed((object_list_area_x - 1 + (object_list_area_width/3)/4),object_list_area_y-12,"Object List",0.66,0.66,0)
			draw_text_transformed((object_list_area_x + 1 + ((object_list_area_width/3)/4)*3),object_list_area_y-16,"Properties",0.66,0.66,0)
			
			surface_set_target(object_list_area_surface)
			draw_clear_alpha(c_black, 0)
			draw_set_halign(fa_left)
			
			var size = ds_list_size(object_layer_map)
			var properties_group = [-4];
			
			for (var i = 0; i < size; ++i) {
				var obj = ds_list_find_value(object_layer_map, i)
				var sprite = ds_map_find_value(obj_data,obj[0])
				if (obj[5] = 1) {
					if (properties_group[0] = -4) {
						properties_group[0] = obj
					} else if (properties_group[0][0] == obj[0]) {
						array_push(properties_group,obj)
					}
				}
			}
			
			var objname=""
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
				ScribblejrFit(objname, fa_left, fa_middle, smallF, 3, object_list_area_width-104, 32).Draw(96,48)
				//draw divider
				draw_rect(12,96,object_list_area_width-24,3,$65555c,1,false)
				//we're doing a reverse loop, starting from the bottom to the top so that things like drop down menus can overlay the buttons below
				for (var i = array_length(proparr[10])-1; i >= 0; --i) {
					if is_array(proparr[10][i]) { 
						//draw variable name
					    ScribblejrFit($"{string(proparr[10][i][1])}:", fa_left, fa_middle, smallF, 3, 96, 32).Draw(16,112+32*i)
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
										}
									}
								} else break
								break
							}
							case "dropdown": {
								draw_sprite_stretched(spr_JADEdropdown,0,96+16,(112+32*i)-12,8*20,8*3)
								//draw selected variable
								ScribblejrFit(string(proparr[10][i][2]), fa_left, fa_top, smallF, 2, 160-8, 20).Draw(96+24,(112+32*i)-6)

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
									
									for (var j = 0; j < array_length(menuarr); ++j) {
									    //draw dropdown menus
										draw_sprite_stretched(spr_JADEdropdown,j == array_length(menuarr)-1 ? 2 : 1,96+16,(112+32*i+24*j)+12,8*20,8*3)
										//draw list of variables
										ScribblejrFit(string(menuarr[j]), fa_left, fa_top, smallF, 2, 160-8, 20).Draw(96+24,(112+32*i+24*j)+18)
										
										var insubcheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+40+(32/3)*i+8*j,object_list_area_x+34+56,object_list_area_y+48+(32/3)*i+8*j)&&(!open_dropmenu||open_dropmenu-1==i)
								
										if (insubcheck) && (mbleftpress) {
											//set selected object to selected variable
											proparr[10][i][2]=menuarr[j];
											open_dropmenu=0;
										}
									}
								}
								break
							}
							case "number_input": {
								if !open_dropmenu {
									draw_sprite_stretched(spr_JADEnumberinput,0,96+16,(112+32*i)-12,8*3,8*3)
									if !(is_typing-1==i)
									ScribblejrFit(string(proparr[10][i][2]), fa_middle, fa_top, smallF, 2, 19, 19).Draw(96+29,(112+32*i)-6)
									else
									ScribblejrFit(temptypingstring, fa_middle, fa_top, smallF, 2, 19, 19).Draw(96+29,(112+32*i)-6)
									
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
											proparr[10][i][2]=unreal(temptypingstring,proparr[10][i][2])
											temptypingstring=""
											is_typing=0;
										}
									}
									
									//if pressed enter and typing, finish typing aswell
									if keyboard_check_pressed(vk_enter) && (is_typing-1==i) {
										proparr[10][i][2]=unreal(temptypingstring,proparr[10][i][2])
										temptypingstring=""
										is_typing=0;
									}
									
									if (is_typing-1==i) {
										//simple typing script for numbers only
										if string_length(string_digits(keyboard_lastchar)) && keyboard_check_pressed(vk_anykey) {
											temptypingstring+=string_digits(keyboard_lastchar)
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
									draw_sprite_stretched(spr_JADEnumberinput,0,96+16,(112+32*i)-12,8*12,8*3)
									if !(is_typing-1==i)
									ScribblejrFit(string(proparr[10][i][2]), fa_left, fa_top, smallF, 2, 90, 19).Draw(96+29,(112+32*i)-6)
									else
									ScribblejrFit(temptypingstring, fa_left, fa_top, smallF, 2, 90, 19).Draw(96+29,(112+32*i)-6)
									
									//check if clicking on box
									var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+11*i,object_list_area_x+133,object_list_area_y+40+11*i)&&(!open_dropmenu||open_dropmenu-1==i)
									
									if (mbleftpress) {
										//start typing
										if (incheck) && !is_typing {
											is_typing=i+1
										}
										
										//if clicking off of the box, finish typing
										if !(incheck) && (is_typing-1==i) {
											//set the variable to our typed number, if its blank reset back to the value it was before
											proparr[10][i][2]=string(temptypingstring)
											temptypingstring=""
											is_typing=0;
										}
									}
									
									//if pressed enter and typing, finish typing aswell
									if keyboard_check_pressed(vk_enter) && (is_typing-1==i) {
										proparr[10][i][2]=string(temptypingstring)
										temptypingstring=""
										is_typing=0;
									}
									
									if (is_typing-1==i) {
										//simple typing script
										if string_length(string_lettersdigits(keyboard_lastchar)) && keyboard_check_pressed(vk_anykey) {
											switch (keyboard_lastkey) {
												case vk_tab:
												case vk_backspace:
												case vk_capslock:
												case vk_control:
												case vk_rcontrol:
												case vk_shift:
												case vk_rshift:
												case vk_enter: { //forbidden keys, these can create unnessecary letters that are unwanted
													break;
												}
												default: {
													temptypingstring+=string_lettersdigits(keyboard_lastchar)
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
				}
			} else {
				temptypingstring=""
				is_typing=0;
			}
			
			surface_reset_target();
			
			//window text
			draw_set_font(smallF)
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
		
		draw_set_font(smallF)
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
			draw_set_font(smallF)
			
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
			for (var i = 0; i < ds_list_size(jade_cats[selected_mode][current_cat]); ++i) {
				
					//upward culling								//downwards culling
				if (32*i < object_list_scroll_pos[selected_mode][current_cat]-24) || (32*i > object_list_scroll_pos[selected_mode][current_cat]+object_list_area_height) {
					continue;
				}
			
				_str = ds_list_find_value(jade_cats[selected_mode][current_cat], i)
				if _str == undefined{
					break;	
				}
				var overlapping=point_in_rectangle(curs_x,curs_y,object_list_area_x,object_list_area_y+((32/3)*i)-object_list_scroll_pos[selected_mode][current_cat]/3,object_list_area_x+object_list_area_width-6,object_list_area_y+(((32/3)*i)+10)-object_list_scroll_pos[selected_mode][current_cat]/3)
		
				if (overlapping && mbleftpress) {
					current_obj_id[selected_mode][current_cat]=i
					selected_obj = _str
				}
		
				var color = c_black
				if (selected_obj == _str) color = c_white
				else if (current_obj_id[selected_mode][current_cat] == i) color=c_blue
				else if (overlapping) color=c_yellow
				else color=c_black
		
				//draw background rectangle
				draw_rect(2,(32*i)+2-object_list_scroll_pos[selected_mode][current_cat],object_list_area_width-8,28, color,0.5)
				//draw object name
				ScribblejrFit(_str, fa_right, fa_middle, smallF, 3, object_list_area_width-44, 32).Draw(object_list_area_width-6,(32*i)+15-object_list_scroll_pos[selected_mode][current_cat])
		
				//draw object sprite
				var arr=ds_map_find_value(obj_data,_str)
				var sprite=arr[0]
				var ysize=32
				if sprite_get_height(sprite)*2 < 32
				ysize=sprite_get_height(sprite)
		
				//draw object icon
				draw_sprite_stretched(sprite,0,4,(32*i)-object_list_scroll_pos[selected_mode][current_cat],32,ysize)
				draw_set_halign(fa_left)
			}
	
			surface_reset_target();
		} else if properties_tab_active {
			//Properties Tab
			draw_sprite_stretched(spr_JADEwindowtab,0,(object_list_area_x + 1 + ((object_list_area_width/3)/2)),object_list_area_y-20, -2 + ((object_list_area_width/3)/2),16)
			//Object List Tab
			draw_sprite_stretched(spr_JADEwindowtab,1,object_list_area_x-1,object_list_area_y-16, -1 + ((object_list_area_width/3)/2),12)
		
			//window
			draw_sprite_stretched(spr_JADEwindow,0,object_list_area_x-2,object_list_area_y-6,(object_list_area_width/3)+2,(object_list_area_height/3)+8)
			draw_set_font(smallF)
		
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
			
			for (var i = 0; i < size; ++i) {
				var obj = ds_list_find_value(node_layer_map, i)
				var sprite = ds_map_find_value(obj_data,obj[0])
				if (obj[5] = 1) {
					if (properties_group[0] = -4) {
						properties_group[0] = obj
					} else if (properties_group[0][0] == obj[0]) {
						array_push(properties_group,obj)
					}
				}
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
				ScribblejrFit(objname, fa_left, fa_middle, smallF, 3, object_list_area_width-104, 32).Draw(96,48)
				//draw divider
				draw_rect(12,96,object_list_area_width-24,3,$65555c,1,false)
				//we're doing a reverse loop, starting from the bottom to the top so that things like drop down menus can overlay the buttons below
				for (var i = array_length(proparr[10])-1; i >= 0; --i) {
					if is_array(proparr[10][i]) { 
						//draw variable name
					    ScribblejrFit($"{string(proparr[10][i][1])}:", fa_left, fa_middle, smallF, 3, 96, 32).Draw(16,112+32*i)
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
										}
									}
								} else break
								break
							}
							case "dropdown": {
								draw_sprite_stretched(spr_JADEdropdown,0,96+16,(112+32*i)-12,8*20,8*3)
								//draw selected variable
								ScribblejrFit(string(proparr[10][i][2]), fa_left, fa_top, smallF, 2, 160-8, 20).Draw(96+24,(112+32*i)-6)

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
									
									for (var j = 0; j < array_length(menuarr); ++j) {
									    //draw dropdown menus
										draw_sprite_stretched(spr_JADEdropdown,j == array_length(menuarr)-1 ? 2 : 1,96+16,(112+32*i+24*j)+12,8*20,8*3)
										//draw list of variables
										ScribblejrFit(string(menuarr[j]), fa_left, fa_top, smallF, 2, 160-8, 20).Draw(96+24,(112+32*i+24*j)+18)
										
										var insubcheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+40+(32/3)*i+8*j,object_list_area_x+34+56,object_list_area_y+48+(32/3)*i+8*j)&&(!open_dropmenu||open_dropmenu-1==i)
								
										if (insubcheck) && (mbleftpress) {
											//set selected object to selected variable
											proparr[10][i][2]=menuarr[j];
											open_dropmenu=0;
										}
									}
								}
								break
							}
							case "number_input": {
								if !open_dropmenu {
									draw_sprite_stretched(spr_JADEnumberinput,0,96+16,(112+32*i)-12,8*3,8*3)
									if !(is_typing-1==i)
									ScribblejrFit(string(proparr[10][i][2]), fa_middle, fa_top, smallF, 2, 19, 19).Draw(96+29,(112+32*i)-6)
									else
									ScribblejrFit(temptypingstring, fa_middle, fa_top, smallF, 2, 19, 19).Draw(96+29,(112+32*i)-6)
									
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
											proparr[10][i][2]=unreal(temptypingstring,proparr[10][i][2])
											temptypingstring=""
											is_typing=0;
										}
									}
									
									//if pressed enter and typing, finish typing aswell
									if keyboard_check_pressed(vk_enter) && (is_typing-1==i) {
										proparr[10][i][2]=unreal(temptypingstring,proparr[10][i][2])
										temptypingstring=""
										is_typing=0;
									}
									
									if (is_typing-1==i) {
										//simple typing script for numbers only
										if string_length(string_digits(keyboard_lastchar)) && keyboard_check_pressed(vk_anykey) {
											temptypingstring+=string_digits(keyboard_lastchar)
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
									draw_sprite_stretched(spr_JADEnumberinput,0,96+16,(112+32*i)-12,8*12,8*3)
									if !(is_typing-1==i)
									ScribblejrFit(string(proparr[10][i][2]), fa_left, fa_top, smallF, 2, 90, 19).Draw(96+29,(112+32*i)-6)
									else
									ScribblejrFit(temptypingstring, fa_left, fa_top, smallF, 2, 90, 19).Draw(96+29,(112+32*i)-6)
									
									//check if clicking on box
									var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+11*i,object_list_area_x+133,object_list_area_y+40+11*i)&&(!open_dropmenu||open_dropmenu-1==i)
									
									if (mbleftpress) {
										//start typing
										if (incheck) && !is_typing {
											is_typing=i+1
										}
										
										//if clicking off of the box, finish typing
										if !(incheck) && (is_typing-1==i) {
											//set the variable to our typed number, if its blank reset back to the value it was before
											proparr[10][i][2]=string(temptypingstring)
											temptypingstring=""
											is_typing=0;
										}
									}
									
									//if pressed enter and typing, finish typing aswell
									if keyboard_check_pressed(vk_enter) && (is_typing-1==i) {
										proparr[10][i][2]=string(temptypingstring)
										temptypingstring=""
										is_typing=0;
									}
									
									if (is_typing-1==i) {
										//simple typing script
										if string_length(string_lettersdigits(keyboard_lastchar)) && keyboard_check_pressed(vk_anykey) {
											switch (keyboard_lastkey) {
												case vk_tab:
												case vk_backspace:
												case vk_capslock:
												case vk_control:
												case vk_rcontrol:
												case vk_shift:
												case vk_rshift:
												case vk_enter: { //forbidden keys, these can create unnessecary letters that are unwanted
													break;
												}
												default: {
													temptypingstring+=string_lettersdigits(keyboard_lastchar)
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
				}
			} else {
				temptypingstring=""
				is_typing=0;
			}
			}
			else if selected_tool==NODE_TOOL && drawing_node!=-1 {
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
				ScribblejrFit(objname, fa_left, fa_middle, smallF, 3, object_list_area_width-104, 32).Draw(96,48)
				//draw divider
				draw_rect(12,96,object_list_area_width-24,3,$65555c,1,false)
				//we're doing a reverse loop, starting from the bottom to the top so that things like drop down menus can overlay the buttons below
					if is_array(proparr) { 
						ScribblejrFit($"Reverse on End:", fa_left, fa_middle, smallF, 3, 96, 32).Draw(16,112+32*1)
						draw_sprite_stretched(spr_JADEcheckbox,bool(proparr[1]),96+16,(112+32*1)-12,8*3,8*3)
								
						//toggle variable
						var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*1,object_list_area_x+44,object_list_area_y+40+(32/3)*1)&&(!open_dropmenu||open_dropmenu-1==1)
								
						if (mbleftpress) {
							if (incheck) {
								proparr[1]=!proparr[1]
							}
						}
						
						//number inputs
						ScribblejrFit($"Path Speed:", fa_left, fa_middle, smallF, 3, 96, 32).Draw(16,112)
						
						draw_sprite_stretched(spr_JADEnumberinput,0,96+16,(112)-12,8*3,8*3)
						if !(is_typing-1==0)
						ScribblejrFit(string(proparr[0]), fa_middle, fa_top, smallF, 2, 19, 19).Draw(96+29,(112)-6)
						else
						ScribblejrFit(temptypingstring, fa_middle, fa_top, smallF, 2, 19, 19).Draw(96+29,(112)-6)
						
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
						ScribblejrFit($"Starting Node:", fa_left, fa_middle, smallF, 3, 96, 32).Draw(16,112+32*2)
						
						draw_sprite_stretched(spr_JADEnumberinput,0,96+16,(112+32*2)-12,8*3,8*3)
						if !(is_typing-1==2)
						ScribblejrFit(string(proparr[2]), fa_middle, fa_top, smallF, 2, 19, 19).Draw(96+29,(112+32*2)-6)
						else
						ScribblejrFit(temptypingstring, fa_middle, fa_top, smallF, 2, 19, 19).Draw(96+29,(112+32*2)-6)
						
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
							proparr[2]=unreal(temptypingstring,proparr[2])
							temptypingstring=""
							is_typing=0;
						}
									
						if (is_typing) {
							//simple typing script for numbers only
							if string_length(string_digits(keyboard_lastchar)) && keyboard_check_pressed(vk_anykey) {
								temptypingstring+=string_digits(keyboard_lastchar)
							}
							if keyboard_check_pressed(vk_backspace) {
								temptypingstring=string_copy(temptypingstring,0,string_length(temptypingstring)-1)
							}
						}
						
						ScribblejrFit($"Fall on End:", fa_left, fa_middle, smallF, 3, 96, 32).Draw(16,112+32*3)
						draw_sprite_stretched(spr_JADEcheckbox,bool(proparr[3]),96+16,(112+32*3)-12,8*3,8*3)
								
						//toggle variable
						var incheck=point_in_rectangle(curs_x,curs_y,object_list_area_x+37,object_list_area_y+34+(32/3)*3,object_list_area_x+44,object_list_area_y+40+(32/3)*3)&&(!open_dropmenu||open_dropmenu-1==3)
								
						if (mbleftpress) {
							if (incheck) {
								proparr[3]=!proparr[3]
							}
						}
				}
			} else {
				temptypingstring=""
				is_typing=0;
			}
			
			surface_reset_target();
			
			//window text
			draw_set_font(smallF)
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
		
		draw_set_font(smallF)
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
	draw_set_font(smallF)
	draw_set_halign(fa_center)
	draw_set_alpha(savetextdur/30)
	draw_text_outline(guiw/2,guih-24,$"Saved to: {global.save_dir}!", 1, c_black, 8, 1, 1, 0)
	draw_set_alpha(1)
	draw_set_halign(fa_left)
}