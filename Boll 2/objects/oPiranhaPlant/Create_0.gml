event_inherited()
hit_sizey = 8;
travel = 0; //the y level within the pipe
timer = 120;
go = 0; //whether or not it should go up the pipe
exposed = false; //when it has fully exited the pipe
is_shy = true;
visible = true;

enemyBumped.Destroy();

mybite = undefined;
bitedelay = 0;
playbite = true;

escapePipe = new Signal();

enemyRespawn.Connect( self, function(thrown_p) {
	travel = 0;
	timer = 120;
	go = 0.5;
	exposed = false;
});

enemyStomped.Destroy();

enemyStomped.Connect( self, function(hit_p) {
	if !(hit_p.spinjump) {
		with(hit_p) {
			sig.Emit("stomp_failed")
		}
		phaseid=hit_p
		phase_leeway=7;
	} else {
		enemySpinjumped.Emit(hit_p);
	}
});

enemySpinjumped.Destroy();

enemySpinjumped.Connect( self, function(hit_p) {
	with(hit_p) {
		instance_create_depth(x,y+hit_sizey,-5,pImpact)
		sig.Emit("enemy_spinjumped");
	}
	VinylPlay(snd_enemyspinjump_reflect)
	phaseid=hit_p;
	phase_leeway=7;
});

enemyKilled.Connect( self, function() {
	VinylPlayAt(snd_piranhadie,x,y,0);
});
