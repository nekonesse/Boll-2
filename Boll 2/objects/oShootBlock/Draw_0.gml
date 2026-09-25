if (goDirection != 0) {
	var fhsp = x-xprevious; //fake hsp calculation
	var fvsp = y-yprevious; //fake vsp calculation

	draw_sprite_ext(sprite_index,image_index,x-fhsp*2,y-fvsp*2,1,1,0,c_white,0.2);
	draw_sprite_ext(sprite_index,image_index,x-fhsp*4,y-fvsp*4,1,1,0,c_white,0.1);
}

event_inherited();

if (disguised) && (sprite_index == image_normal) {
	var scissor = gpu_get_scissor()

	gpu_set_scissor(x-(sprite_width/2)+1-global.camera_x,y-(sprite_height/2)+1-global.camera_y,sprite_width-2,sprite_height-2)

	var overlay_x = (global.roomTimer/3.5) mod sprite_width

	draw_sprite(spr_itemboxoverlay,floor(global.roomTimer/6),x-overlay_x+sprite_width,y+dy)

	draw_sprite(spr_itemboxoverlay,floor(global.roomTimer/6),x-overlay_x,y+dy)

	gpu_set_scissor(scissor);
}