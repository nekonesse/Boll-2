// Inherit the parent event
event_inherited();

bumpPower = 4;
deal_dam = false;

hit_sizex = 14;
hit_sizey = 14;

timer = 0;

state = 0;

sliding = false;

goingdown = false;

bumped = false;

jumped = false;

looking_around = false;

behavior_mode = bumptyBehaviors.wander_mode;

enemyBumped.Destroy();

enemyBumped.Connect( self, function() {
	hp = 1;
	jumped = true;
	grounded = false;
	vsp = -3;
	killtype="bump";
	VinylPlay(snd_bumptybounce);
});

enemyStomped.Destroy();

enemyStomped.Connect( self, function(hit_p) {
	with(hit_p) {
		vsp = -other.bumpPower
		sig.Emit("stomp_failed");
	}
	VinylPlay(snd_bumptybounce)
	phaseid=hit_p;
	phase_leeway=7;
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

enemyPounded.Destroy();

enemyPounded.Connect( self, function(hit_p) {
	with(hit_p) {
		vsp = -other.bumpPower
		sig.Emit("pound_failed");
	}
	VinylPlay(snd_bumptybounce)
	phaseid=hit_p;
	phase_leeway=7;
});

enemyCollidePlayer.Destroy();

enemyCollidePlayer.Connect( self, function(hit_p) {
	var dir = esign(x-hit_p.x,hit_p.xsc);
	with(hit_p) {
		hsp = other.bumpPower*-dir;
		if (grounded) {
			gsp = hsp;
		}
		sig.Emit("collide_with_enemy")
	}
	if (grounded) && (behavior_mode != bumptyBehaviors.flying_mode) && !(sliding) {
		hsp = 2 * dir;
		vsp = -2
		grounded = false;
		bumped = true;
	}
	VinylPlay(snd_bumptybounce)
	phaseid=hit_p
	phase_leeway=7;
});

enemyTurnAround.Connect( self, function() {
	switch(behavior_mode) {
		case bumptyBehaviors.flying_mode:
			timer = 180;
		break;
		case bumptyBehaviors.jumping_mode:
			if !(sliding)
			hsp=-hsp;
		break;
	}
	
	if (sliding) {
		hsp=-hsp;
	}
	
	if (grounded) gsp=hsp;
});

enemyRolledInto.Destroy();

enemyRolledInto.Connect( self, function(hit_p) {
	if (hit_p.state == "frozen") {
		hp-=1;
		vsp=-4;
		phaseid=hit_p
		phase_leeway=15;
		killdir= esign(x-x,1)
		killhsp= max(abs(hit_p.hsp)/1.75,2)
		xsc= esign(hit_p.hsp,hit_p.xsc)
		killvsp= -max(2,abs(hit_p.hsp)/1.5)
		killtype= "spin"
		with(hit_p) {
			make_particle(pImpact,x+hit_sizex*xsc,y,-5);
			increase_combo(x,y);
		}
		VinylPlay(snd_enemykick);
	} else {
		var dir = esign(x-hit_p.x,hit_p.xsc);
		with(hit_p) {
			hsp = other.bumpPower*-dir;
			if (state == "boarding") {
				bonk=true;
			}
			vsp = -2
			grounded=false;
		}
		VinylPlay(snd_bumptybounce)
		phaseid=hit_p;
		phase_leeway=7;
		hsp = 2 * dir;
		vsp = -2
		grounded = false;
		bumped = true;
	}
});

enemyFireballed.Destroy();
enemyShelled.Destroy();