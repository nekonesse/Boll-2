//vertical sensors
//TODO: make it not stutter when walking up slopes
var signy = sign(y - round(oPlayer.y))
if (y > oPlayer.y) {
	if (ydist != 0) {
		ydist = y - round(oPlayer.y)
		ydist -= sign(ydist) * 3 //this stutters it
		
		//y = oPlayer.y + ydist; 
		y -= sign(ydist) * 3 
		if (round(ydist) div 3 == 0 || signy != sign(y - round(oPlayer.y))) {
			ydist = 0
			y = oPlayer.y
		}
		
	} else if (oPlayer.grounded) {
		ydist = y - round(oPlayer.y) //get distance to travel
	}
} else if (y < oPlayer.y - 24) {
	y = round(oPlayer.y - 24);
	ydist = 0
}


//horizontal sensors
switch state {
	case 0 : { //follow player
		var check = (oPlayer.x - x > 64 || oPlayer.x - x < -64); // check boundaries and store
		
		if (xsc == sign(x - oPlayer.x)) {x = oPlayer.x} // snap to player if they keep going the same direction
		
		xdist = x - round(oPlayer.x) // get distance in case camera should pan...
		if (check) { //...if it should, change state
			state = 1
		}
		
	} break;
	
	case 1 : { //camera panning
		xsc = sign(x - oPlayer.x) //offset deadzone for state 0
		
		xdist -= sign(xdist) * 2
		x = round(oPlayer.x) + xdist; // pan to player
		
		if (round(xdist div 2) == 0) {
			state = 0
		}
	} break;
	default : {
		x = oPlayer.x;
	} break;
}