draw_sprite_ext(sprite_index, frame, x, y, xsc, ysc,0,#FFFFFF,1)
if (global.debug) {
	draw_rect(x-hit_sizex,y-hit_sizey,hit_sizex*2,hit_sizey*2,c_red,0.5)
}