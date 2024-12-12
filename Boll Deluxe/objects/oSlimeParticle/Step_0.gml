vsp += (global.roomTimer & 0b11 == 0)
vMove = (vsp >= 0)

if (vMove && global.roomTimer & 0b11 == 0) {
	if (sprite >= 4) {
		instance_destroy(self);
	}
}

if (place_meeting(x, y + vsp, oCollider) && vsp > 0) {
	vsp = floor(-vsp div 2)
	sprite += 1
}
if place_meeting(x+hsp, y, oCollider) {
	hsp = -hsp
	sprite += 1
}

y += vsp
x += hsp