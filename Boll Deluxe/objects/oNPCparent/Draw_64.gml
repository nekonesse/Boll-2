if (over && !(is_talking || text_leftover)) {
	draw_sprite(spr_npctalkarrow,0,x+(sprite_width/2)-global.camera_x,y-8-global.camera_y)
}

if (is_talking || text_leftover) {
	draw_set_font(global.omiFont);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_bottom);
	if (text_leftover) {
		draw_set_alpha(text_leftover/(text_leftover_max/2))
	}
	
	draw_set_color(c_black);
	
	draw_text_ext(x+(sprite_width/2)-global.camera_x+1,y-8-global.camera_y+1,temptext,8,96);
	
	draw_set_color(c_white);
	
	draw_text_ext(x+(sprite_width/2)-global.camera_x,y-8-global.camera_y,temptext,8,96);
	
	draw_set_alpha(1);
	draw_set_halign(0);
	draw_set_valign(0);
}