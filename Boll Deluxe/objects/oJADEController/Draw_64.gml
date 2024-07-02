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

#region Object List
	if selected_mode = OBJECT_MODE {
		draw_set_font(smallF)
		draw_set_halign(fa_right)
		/*draw_sprite_stretched(spr_JADEtab_right,0,guiw-96,56,96,(32*5)+4)
		if surface_exists(list_area_surface) {
		surface_set_target(list_area_surface)
			
		}
		surface_reset_target();*/
	
		var _str = "null"
		//first 4 objects before selected 
		for (var i = 1; i < 4; ++i) {
			_str = ds_list_find_value(obj_name, current_obj_id - i)
			if _str == undefined{
				break;	
			}
		    draw_text(guiw - 16, (guih/ 2) - (8* (i)), _str)	
		}
		//your object
		_str = ds_list_find_value(obj_name, current_obj_id)
		draw_text_color(guiw - 16, (guih/ 2), _str, c_yellow, c_yellow, c_yellow, c_yellow, 1)
		//next 4 objects
		for (var i = 1; i < 4; ++i) {
			_str = ds_list_find_value(obj_name, current_obj_id + i)
			if _str == undefined {
				break;	
			}
		    draw_text(guiw - 16, (guih/ 2) + (8* (i)), _str)	
		} 
		draw_set_halign(fa_left)
	
	}
#endregion