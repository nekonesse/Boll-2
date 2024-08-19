/// @description Animation
if (in_shell) {
	sprite_index = spr_koopashellspin_r; 
	image_speed = abs(hsp); 
	if (hsp==0) image_index = 0;
}
else {
	sprite_index = spr_koopawalk_r;
	image_speed = 1;
}