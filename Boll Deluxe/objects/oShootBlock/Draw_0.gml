if (goDirection != 0) {
	var fhsp = x-xprevious; //fake hsp calculation
	var fvsp = y-yprevious; //fake vsp calculation

	draw_sprite_ext(sprite_index,image_index,x-fhsp*2,y-fvsp*2,1,1,0,c_white,0.2);
	draw_sprite_ext(sprite_index,image_index,x-fhsp*4,y-fvsp*4,1,1,0,c_white,0.1);
}

event_inherited();