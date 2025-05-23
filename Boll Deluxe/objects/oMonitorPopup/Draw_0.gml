if (vspeed != 0) {
	var frame = 0;
	fr += 0.2;
	if fr >= 4 fr = 0;
	frame = floor(fr);

	if (frame == 3) frame += itemfr
} else frame=3+itemfr

draw_sprite(sprite_index,frame,x,y)