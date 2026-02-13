// Inherit the parent event
event_inherited();
turncount = 0;
stuck = false;

enemyTurnAround.Connect( self, function() {
	if (grounded) {
		turncount++;
		if (turncount>3) {
			constantspd = 0;
			x+=1*turnxsc
			xsc = 1;
			stuck = true;
		}
	}
});