event_inherited();
//in_shell: If this variable is 0, the koopa should be walking. Otherwise, it should stay in its shell
//shell_time: Variable for setting the timer the koopa has upon being stomped to get back up
in_shell = 0;
shell_time = 60*5;
no_stomping = 0;
shell_leway = 0
shell_move = true

enemyStomped.Connect( self, function(hit_p) {
	show_debug_message("hi im the okoopa stomp signal")
	if (!no_stomping) {
		//if (in_shell && shell_leway == 0) {
		//	show_debug_message(hsp)
		//	show_debug_message("i kick koopera")
		//	phaseid=hit_p
		//	hsp = 0;
		//	enemycoll=true;
		//	with(hit_p) sig.Emit("enemy_stomped")
		//	in_shell = shell_time;
		//	shell_leway = 10
		//	hsp = sign(phaseid.x - x) * 2.2;
		//	shell_move = !shell_move
		//} 
		if !in_shell{
			show_debug_message("ARRGH")
			constantspd = 0;
			enemycoll=true;
			y += 6; //Pulling the shell to the ground
			with(hit_p) sig.Emit("enemy_stomped")
			in_shell = shell_time;
			no_stomping = true
			shell_move = false
			shell_leway = 15
		}
		if in_shell{
			show_debug_message("ARRGH")
			constantspd = 0;
			enemycoll=true;
			with(hit_p) sig.Emit("enemy_stomped")
			in_shell = shell_time;
			no_stomping = true
			shell_move = false
			shell_leway = 15
		}
	}
});

enemyCollidePlayer.Connect( self, function(hit_p) {
		phaseid=hit_p
		if (no_stomping) {
			if (in_shell) && !shell_move && (shell_leway<=2) {
				//enemycoll=false;
				show_debug_message("kicked =kooper ground") 
				constantspd = 4.25;
				_direction = sign(x-phaseid.x) 
				shell_move = true
				shell_leway = 15
				in_shell = shell_time
				no_stomping = false
			}
		}
		//in_shell = shell_time;
});