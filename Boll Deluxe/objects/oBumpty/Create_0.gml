// Inherit the parent event
event_inherited();

bumpPower = 4;
deal_dam = false;

timer = 0;

state = 0;

sliding = false;

goingdown = false;

bumped = false;

looking_around = false;

enum bumptyBehaviors {
	wander_mode,
	jumping_mode,
	flying_mode,
}

behavior_mode = bumptyBehaviors.wander_mode;

enemyStomped.Destroy();

enemyStomped.Connect( self, function(hit_p) {
	with(hit_p) {
		vsp = -other.bumpPower
		sig.Emit("collide_with_enemy")
	}
	VinylPlay(snd_bumptybounce)
	phaseid=hit_p
	phase_leeway=7;
});

enemyCollidePlayer.Destroy();

enemyCollidePlayer.Connect( self, function(hit_p) {
	var dir = sign(x-hit_p.x);
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
	
	show_debug_message(hsp);
	
	if (grounded) gsp=hsp;
});