if global.paused || inactive exit

if (in_shell) && (hsp=0) in_shell--; //Decreases the time for the koopa to get up

event_inherited();

enemy=instance_place(x,y,oEnemy)
if (in_shell) && (abs(hsp)) {
	if !(enemy.unshellable) {
		enemy.killtype="shell";
		enemy.killdir = sign(hsp);
		instance_destroy(enemy);
	} else {
		instance_destroy();
	}
}

//Animation
if (in_shell) {
	sprite_index = spr_koopashellspin_g; 
	image_speed = abs(hsp); 
	if (hsp==0) image_index = 0;
}
else { sprite_index = spr_koopawalk_g; image_speed = 1;}