event_inherited();
//in_shell: If this variable is 0, the koopa should be walking. Otherwise, it should stay in its shell
//shell_time: Variable for setting the timer the koopa has upon being stomped to get back up
in_shell = 0;
shell_time = 60*5;
no_stomping = 0;
shell_move = true
can_break_bricks = true

enemyStomped.Connect( self, function(hit_p) {
	show_debug_message("hi im the okoopa stomp signal")
	hp=1
	if (!no_stomping) {
		if !in_shell{
			VinylPlay(snd_enemystomp)
			constantspd = 0;
			enemycoll=true;
			y += 6; //Pulling the shell to the ground
			in_shell = shell_time;
			no_stomping = true
			shell_move = false
		}
		if in_shell{
			VinylPlay(snd_enemystomp)
			constantspd = 0;
			enemycoll=true;
			in_shell = shell_time;
			no_stomping = true
			shell_move = false
		}
	}
});

enemyCollidePlayer.Connect( self, function(hit_p) {
		phaseid=hit_p
		phase_leeway=7;
		if (no_stomping) {
			if (in_shell) && !(shell_move) {
				VinylPlay(snd_enemykick)
				with (hit_p) {
					instance_create_depth(x+hit_sizex*xsc,other.y,2,pImpact)
				}
				constantspd = 4;
				_direction = sign(x-phaseid.x) 
				shell_move = true
				in_shell = shell_time
				no_stomping = false
			}
		}
});

enemyTurnAround.Connect( self, function() {
	if (in_shell) && (shell_move) {
		VinylPlay(snd_blockbump)
	}
});