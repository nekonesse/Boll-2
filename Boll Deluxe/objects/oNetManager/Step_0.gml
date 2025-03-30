if time>=0 {
time=max(time-1,0);
	if !(time) {
		time=-1;
		global.actions_left=5;
	}
}

if doing_ping {
	ping_time++	
	if (ping_time > (11 * 60)){
		show_message("Connection timeout!")
		game_end();	
	}
}