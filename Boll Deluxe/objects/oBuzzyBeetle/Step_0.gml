// Inherit the parent event
event_inherited();

var pl = nearestplayer();

if (pl && attach_to_ceiling) {
	var dist = abs(pl.x-x);
	
	if (dist <= 80) {
		attach_to_ceiling = false;
		grav = defaultgrav;
		in_shell = shell_time;
		constantspd = 0;
		hsp = 0;
		ceiling_falling=true;
		targeting_player=pl;
	}
}

if (ceiling_falling && grounded) {
	ceiling_falling = false;
	constantspd = 3.5;
	enemycoll = false;
	no_stomping = false;
	shell_move = true;
	if instance_exists(targeting_player) {
		_direction = esign(pl.x-x,-xsc);
	} else {
		_direction = -xsc;
	}
}