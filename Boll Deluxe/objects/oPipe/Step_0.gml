if (assist != noone) {
	instance_activate_object(assist);
}

if ((assist == noone) || !(instance_exists(assist))) && (alarm[0] == -1) {
	alarm[0] = spawn_timer;
	assist = noone;
}