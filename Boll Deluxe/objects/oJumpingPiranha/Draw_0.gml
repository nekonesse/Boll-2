// Inherit the parent event
if (parent_pipe != noone) {
	rot = parent_pipe.image_angle
}
event_inherited()

if (global.debug) {
	draw_text(x-8,y-16,timer)
	draw_text(x-8,y-32,vsp)
	draw_point(x,y+hit_sizey+24)
}