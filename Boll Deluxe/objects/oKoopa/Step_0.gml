if global.paused || inactive exit

no_dam = false

if (in_shell) && (!shell_move){
	in_shell--; //Decreases the time for the koopa to get up
	if (!in_shell) {
		y -= 9; 
		constantspd = 0.5 
		no_stomping = false
	} //Gets the Koopa to pull itself from the ground and continue walking in the direction the shell is facing
}

if (in_shell) {
	if (!shell_move) {
		shell_leway = 2;
	}
	
	shell_leway--
	if shell_leway > 0 {
		no_dam = true	
	}
}

event_inherited();

var enemy=instance_place(x,y,oEnemy)

if (enemy != noone) { //make sure shell is actually colliding with an enemy before trying to kill the enemy it collided with???
	if (in_shell) && (abs(hsp)) {
		if !(enemy.unshellable) {
			enemy.killtype="spin";
			enemy.killhsp = sign(hsp);
			instance_create_depth(x+hit_sizex*xsc,y,2,pImpact)
			enemy.hp-=1;
		} else {
			instance_destroy();
		}
	}
}

event_user(0);