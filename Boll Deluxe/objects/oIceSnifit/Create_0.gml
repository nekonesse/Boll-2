// Inherit the parent event
event_inherited();
stun=0;
revving=false;
revtimer=0;
blowing=false;
blowtimer=0;
cooldowntimer=0;
fireballflash=0;
didstun=false;
		
uni_r = shader_get_uniform(shd_flatcolor, "red");

blowingPart=-1;

enemyStomped.Connect( self, function(hit_p) {
	stun=180;
	didstun=false;
	blowing=0;
	blowtimer=0;
	revtimer=0;
	revving=0;
	hsp=0;
	constantspd=0;
});

enemyFireballed.Connect( self, function(proj, hit_p) {
	fireballflash = 30;
});