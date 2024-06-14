///@description Cursor
if global.debug {
	draw_set_font(smallF)
	draw_text(curs_x,curs_y+16,string(gridx)+" "+string(gridy))
	draw_rectangle_color(gridx*16,gridy*16,gridx*16+16,gridy*16+16,c_red,c_red,c_red,c_red,true)
}

draw_sprite(spr_JADEcursor,0,curs_x,curs_y)
draw_sprite_ext(spr_JADEicons,selected_tool-1,curs_x+4,curs_y+4,0.5,0.5,0,c_white,1)