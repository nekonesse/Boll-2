// Inherit the parent event
event_inherited();
onStunRecover = new Signal();

stun=0;
revving=false;
revtimer=0;
blowing=false;
blowtimer=0;
cooldowntimer=0;
fireballflash=0;
didstun=false;
pausestun=false;
		
uni_r = shader_get_uniform(shd_flatcolor, "red");

blowingPart=-1;

enemyStomped.Connect( self, function(hit_p) {
	stun=60*7.5;
	didstun=false;
	hsp=0;
	constantspd=0;
	overridexsc=true;
});

enemyFireballed.Connect( self, function(proj, hit_p) {
	fireballflash = 30;
});

onStunRecover.Connect( self, function() {
	constantspd=0.5;
	hp=2;
	didstun=true;
	overridexsc=false;
});

enemyCollidePlayer.Destroy(); //override

enemyCollidePlayer.Connect( self, function(hit_p) {
	if !(stun) {
		with(hit_p) {
			sig.Emit("collide_with_enemy")
		}
		phase_leeway=7;
	} else if (grounded) {
		VinylPlay(snd_enemykick)
		with (hit_p) {
			instance_create_depth(x+hit_sizex*xsc,other.y,2,pImpact)
		}
		hsp=sign(x-hit_p.x)*3;
		vsp=-2;
		grounded=false;
		phase_leeway=15;
	}
	
	phaseid=hit_p
});

enemyShelled.Connect( self, function(hit_obj, kick_p) {
	vsp=-4;
	grounded=false;
	stun=60*7.5;
	didstun=false;
	hsp=0;
	constantspd=0;
	overridexsc=true;
});

enemyRolledInto.Connect( self, function(hit_p) {
	vsp=-4;
	grounded=false;
	stun=60*7.5;
	didstun=false;
	hsp=0;
	constantspd=0;
	overridexsc=true;
	phaseid=hit_p;
	phase_leeway=5;
});