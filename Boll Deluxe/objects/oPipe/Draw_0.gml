draw_self()
if (global.debug) {
	draw_rectangle(x-24,0,x+24,room_height + 255,true)
	draw_set_font(global.omiFont)
	draw_text(x-16,y-8,$"name: {warpname}")
	draw_text(x-16,y,$"target:{warptarget}")
	draw_text(x-16,y+8,$"timer:{string(alarm[0])}")
}