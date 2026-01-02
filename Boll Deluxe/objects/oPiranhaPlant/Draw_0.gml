//draw_sprite_ext(sprite_index,image_index,floor(x),floor(y) + hit_sizey,xsc,ysc,rot,image_blend,image_alpha)
if (parent_pipe != noone) {
	rot = parent_pipe.image_angle
}
event_inherited()
 
if global.debug {
	depth = -1;
	draw_text(x+8,y+16,string(timer))
	draw_text(x+8,y-16,place_meeting(x,y,parent_pipe))
	draw_text(x-8,y-16,go)
	draw_text(x-8,y-32,exposed)
	exit;
}