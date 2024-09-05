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
		t_x = tileset_picker_x+((current_tile_id mod (t_width / 16))* (16*0.33))
		t_y = tileset_picker_y+(floor(current_tile_id/(t_width/16))* (16*0.33))
		t_w = 16 * 0.33
		t_h = 16 * 0.33
		draw_rectangle(t_x,t_y,t_x + t_w-1,t_y + t_h-1,true)
	}
}
#endregion

#region Object List
if selected_mode == OBJECT_MODE {
	if show_object_list && surface_exists(object_list_area_surface) {
		//window tab
		draw_sprite_stretched(spr_JADEwindow,0,object_list_area_x-2,object_list_area_y-6,(object_list_area_width/3)+2,(object_list_area_height/3)+8)
		draw_set_font(smallF)
		//top tab text
		var tab_name = ["blocks", "baddies", "items", "tech"]
		draw_text_transformed(object_list_area_x+2,object_list_area_y-4,$"object list - {tab_name[current_cat]}",0.66,0.66,0)
	
		surface_set_target(object_list_area_surface)
		draw_clear_alpha(c_black, 0)
		draw_set_halign(fa_right)
	
		var _str = "null"
		//object list
		for (var i = 0; i < ds_list_size(jade_cats[current_cat]); ++i) {
			
			if ((32/3)*i < object_list_scroll_pos[current_cat]/3) || ((32/3)*i > (object_list_scroll_pos[current_cat]/3)+object_list_area_height) {
				continue;
			}
			
			_str = ds_list_find_value(jade_cats[current_cat], i)
			if _str == undefined{
				break;	
			}
			var overlapping=point_in_rectangle(curs_x,curs_y,object_list_area_x,object_list_area_y+((32/3)*i)+object_list_scroll_pos[current_cat]/3,object_list_area_x+object_list_area_width-6,object_list_area_y+(((32/3)*i)+10)+object_list_scroll_pos[current_cat]/3)
		
			if (overlapping && mbleftpress) {
				current_obj_id[current_cat]=i
				selected_obj = _str
			}
		
			var color = c_black
			if (selected_obj == _str) color = c_white
			else if (current_obj_id[current_cat] == i) color=c_blue
			else if (overlapping) color=c_yellow
			else color=c_black
		
			//draw background rectangle
			draw_rect(2,(32*i)+2+object_list_scroll_pos[current_cat],object_list_area_width-8,28, color,0.5)
			//draw object name
			ScribblejrFit(_str, fa_right, fa_middle, smallF, 3, object_list_area_width-44, 32).Draw(object_list_area_width-6,(32*i)+15+object_list_scroll_pos[current_cat])
		
			//draw object sprite
			var arr=ds_map_find_value(obj_data,_str)
			var sprite=arr[0]
			var ysize=32
			if sprite_get_height(sprite)*2 < 32
			ysize=sprite_get_height(sprite)
		
			draw_sprite_stretched(sprite,0,4,(32*i)+object_list_scroll_pos[current_cat],32,ysize)
			draw_set_halign(fa_left)
		}
	
		surface_reset_target();
	
		draw_surface_stretched(object_list_area_surface, object_list_area_x, object_list_area_y, object_list_area_width/3, object_list_area_height/3)
	} else {
		draw_sprite_stretched(spr_JADEwindow,0,object_list_area_x-2,object_list_area_y-6,(object_list_area_width/3)+2,8)
		draw_set_font(smallF)
		//top tab text
		var tab_name = ["blocks", "baddies", "items", "tech"]
		draw_text_transformed(object_list_area_x+2,object_list_area_y-4,$"object list - {tab_name[current_cat]}",0.66,0.66,0)
	}
}
#endregion