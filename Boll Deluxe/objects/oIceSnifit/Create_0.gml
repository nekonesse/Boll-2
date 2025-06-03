// Inherit the parent event
event_inherited();
stun=0;
revving=false;
revtimer=0;
blowing=false;
blowtimer=0;

blowingPart=-1;

enemyStomped.Connect( self, function(hit_p) {
	stun=120;
	blowing=0;
	blowtimer=0;
	revtimer=0;
	revving=0;
	hsp=0;
	constantspd=0;
});