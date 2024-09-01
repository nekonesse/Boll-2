event_inherited();
//in_shell: If this variable is 0, the koopa should be walking. Otherwise, it should stay in its shell
//shell_time: Variable for setting the timer the koopa has upon being stomped to get back up
in_shell = 0;
shell_time = 60*5;
no_stomping = 0;

enemyStomped.Connect( self, function(hit_p) {
	show_debug_message("hi im the okoopa stomp signal")
	if (!no_stomping) {
		if (in_shell) {
			if (floor(hsp)!=0) {
				show_debug_message(hsp)
				show_debug_message("ARRGH")
				phaseid=hit_p
				hsp = 0;
				enemycoll=true;
				with(hit_p) sig.Emit("enemy_stomped")
				in_shell = shell_time;
			}
		} else {
			show_debug_message("ARRGH")
			hsp = 0;
			enemycoll=true;
			y += 6; //Pulling the shell to the ground
			with(hit_p) sig.Emit("enemy_stomped")
			in_shell = shell_time;
		}
	}
});

enemyCollidePlayer.Connect( self, function(hit_p) {
	if (!no_stomping) {
		phaseid=hit_p
		if (in_shell) && (hsp==0) {
				enemycoll=false;
				hsp = sign(phaseid.xsc) * 2.2;
		}
		in_shell = shell_time;
	}
});