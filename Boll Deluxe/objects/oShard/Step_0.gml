draw_angle += 1 + col_timer;
other_angle += (offset / 64) + col_timer;

if (col_timer != 0) {
	col_timer += 0.25;
} else if place_meeting(x,y,oPlayer) {
	col_timer += 0.25;
	
	instance_create_depth(x,y,depth,pGlowRing);
	
	var dir = 30;
	repeat (3) {
		make_particle(pGlitter,x,y,depth-1,1,lengthdir_x(2,dir),lengthdir_y(2,dir),0,0);
		dir+=120;
	}
	VinylPlay(snd_itemshard);
	
	with (instance_create(x,y,pScoreText)) {
		image_index = 4;
	}
}

if (col_timer > 30) {
	instance_create_depth(x,y,depth,pGlowRing);
	
	var dir = 30;
	repeat (3) {
		make_particle(pGlitter,x,y,depth-1,1,lengthdir_x(2,dir),lengthdir_y(2,dir),0,0);
		dir+=120;
	}
	
	instance_destroy(self);
}