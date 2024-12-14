draw_self()
if (global.debug) {
	draw_set_font(global.omiFont)
	draw_text(x-16,y-8,$"name: {warpname}")
	draw_text(x-16,y,$"target:{warptarget}")
}