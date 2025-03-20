// Inherit the parent event
event_inherited();

jump = false;

hit_sizex=10;
hit_sizey=10;

enemyCollidePlayer.Connect( self, function(hit_p) {
	if (hit_p.y > y) {
		vsp=-5;
		jump=true;
	}
});