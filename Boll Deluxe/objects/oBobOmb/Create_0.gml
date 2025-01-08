event_inherited();

state = 0;
shell_time = 60 * 5;
shell_move = false;
hp = 2;
ignore = noone;

enemyStomped.Connect( self, function(hit_p) {
	if !(no_interaction) && !(unshellable) {
		phaseid = hit_p;
		phase_leeway = 60 * 6;
		in_shell = true;
		walker = false;
		gsp = 0;
		no_interaction = true;
		no_stomping = true;
		VinylPlay(snd_enemystomp)
		with(hit_p) {
			sig.Emit("enemy_stomped")
			instance_create_depth(x,y+hit_sizey,2,pImpact)
		}
	}
});

enemyFireballed.Connect( self, function(proj, hit_p) {
	instance_create_depth(proj.x,proj.y,2,pImpact)
	VinylPlay(snd_enemykick)
	vsp = -2;
	grounded = false;
	if !(no_interaction) && !(in_shell) {
		no_interaction = true;
		no_stomping = true;
		unshellable = true;
		constantspd = 1;
		x = floor(x);
		phaseid = hit_p;
		phase_leeway = 60 * 6;
	}
});

alarm[0]=1