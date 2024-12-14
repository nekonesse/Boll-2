vsp += 0.25

if (place_meeting(x, y + vsp, oCollider) && vsp > 0) {
	vsp = -vsp/2
	sprite += 1
}

if place_meeting(x+hsp, y, oCollider) {
	hsp = -hsp
	sprite += 1
}

if (sprite >= 4) {
	instance_destroy(self);
}

y += floor(vsp)
x += floor(hsp)