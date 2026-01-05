event_inherited();
//in_shell: If this variable is 0, the koopa should be walking. Otherwise, it should stay in its shell
//shell_time: Variable for setting the timer the koopa has upon being stomped to get back up
start_hit_sizex = 6;
start_hit_sizey = 10;
hit_sizex = start_hit_sizex;
hit_sizey = start_hit_sizey;
in_shell = 0;
shell_time = 60*8.5;
no_stomping = 0;
shell_move = true
can_break_bricks = true
kickedplayer = noone;
kickCombo = 0;
kick_delay = 0

koopaEscapeShell = new Signal();

delete enemyStomped;
enemyStomped = new Signal();

enemyStomped.Connect( self, function(hit_p) {
	if (phaseid!=hit_p) {
		if (!no_stomping && kick_delay == 0) {
			if !in_shell {
				constantspd = 0;
				enemycoll=true;
				y += (start_hit_sizey-6); //Pulling the shell to the ground
				in_shell = shell_time;
				no_stomping = true
				shell_move = false
				kick_delay = 7
			}
			if (in_shell) && (shell_move) {
				constantspd = 0;
				enemycoll=true;
				in_shell = shell_time;
				no_stomping = true
				shell_move = false
				phaseid=hit_p
				phase_leeway=7;
				kick_delay = 7
			}
			hit_sizex = 6;
			hit_sizey = 6;
			event_user(0);
		}
		with(hit_p) {
			increase_combo(other.x,other.y);
			
			sig.Emit("enemy_stomped")
			instance_create_depth(x,y+hit_sizey,2,pImpact)
		}
		phaseid=hit_p
		phase_leeway=7;
		kickedplayer = noone;
		kickCombo = 0;
	}
	hp=1;
});

enemyCollidePlayer.Connect( self, function(hit_p) {
	phaseid=hit_p
	phase_leeway=7;
	if (no_stomping && kick_delay == 0) {
		if (in_shell) && !(shell_move) {
			VinylPlay(snd_enemykick)
			with (hit_p) {
				instance_create_depth(x+hit_sizex*xsc,other.y,2,pImpact)
			}
			constantspd = 3.5;
			_direction = sign(x-phaseid.x) 
			shell_move = true
			in_shell = shell_time
			no_stomping = false
			kickedplayer = hit_p
			enemycoll=false;
		}
	}
});

enemyTurnAround.Connect( self, function() {
	if (in_shell) && (shell_move) {
		VinylPlay(snd_blockbump)
	}
});

koopaEscapeShell.Connect( self, function() {
	hit_sizex = start_hit_sizex;
	hit_sizey = start_hit_sizey;
	y -= (start_hit_sizey-6)
});