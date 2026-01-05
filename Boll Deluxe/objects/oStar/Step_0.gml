event_inherited();

if (global.roomTimer & 7 == 0) {
	instance_create(x + random_range(-8, 8), y + random_range(-8, 8), pShine);
}

if (grounded) {
	if (hsp == 0) {
		hsp = 1;
	}
	
	vsp=-5;
	grounded=false;
}