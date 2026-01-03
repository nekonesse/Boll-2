if (assist != noone) {
	instance_activate_object(assist);
}

if (content != "nothing") && !(stop_spawning)  {
	spawning=max(spawning-1,0);
		
	if !(spawning) {
		spawnObject();
		spawning=spawn_timer;
	}
}