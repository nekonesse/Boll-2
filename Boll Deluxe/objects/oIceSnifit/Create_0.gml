// Inherit the parent event
event_inherited();
revving=false;
revtimer=0;
blowing=false;
blowtimer=0;
cooldowntimer=0;

enemyStomped.Connect( self, function(hit_p) {
	blowing=0;
	blowtimer=0;
	revtimer=0;
	revving=0;
});

onStunRecover.Connect( self, function() {
	cooldowntimer=60;
});