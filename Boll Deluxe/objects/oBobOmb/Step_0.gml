if (global.paused) exit
event_inherited();
//var col = noone;

//if (no_interaction) {
//	col = instance_place(x,y,oPlayer)
//	if (col != ignore) {
//		ignore = noone;
//	}
	
//	if (col != noone && col != ignore) {
//		instance_create_depth(x + col.x / 2, y + col.y / 2, 2, pImpact)
//		VinylPlay(snd_enemykick)
//		hsp = (abs(col.hsp) + 2) * sign(x - col.x);
//		vsp = -3;
//		grounded = false;
//		ignore = col;
//	}
	
//	if (grounded) {
//		gsp = 0
//	}
//}

if (in_shell || unshellable) {
	shell_time -= 1;
	phase_leeway += 1;
}

if !(shell_time) {
	instance_destroy(self);
}

event_user(0)