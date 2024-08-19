if global.paused || inactive exit

if (!in_shell && !place_meeting(x + hsp, y + 2, oCollider)) { //There's a ledge there Maybe Don't Walk Off Of That
	hsp *= -1	
}

event_inherited();