if global.paused || inactive exit

if (in_shell) && (hsp=0) {
	in_shell--; //Decreases the time for the koopa to get up
	if (!in_shell) {y -= 9; hsp = 0.5 * sign(image_xscale)} //Gets the Koopa to pull itself from the ground and continue walking in the direction the shell is facing
}

event_inherited();

enemy=instance_place(x,y,oEnemy)

if (enemy != noone) { //make sure shell is actually colliding with an enemy before trying to kill the enemy it collided with???
	if (in_shell) && (abs(hsp)) {
		if !(enemy.unshellable) {
			enemy.killtype="shell";
			enemy.killdir = sign(hsp);
			instance_destroy(enemy);
		} else {
			instance_destroy();
		}
	}
}

event_user(0);