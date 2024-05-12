event_user(0)
if (hp < 0) {
	//spawn the upside down goal orb
	instance_destroy(self)
} else if (hp == 0) {
	event_user(2)
	exit;
}
hsp = sign(floor(oPlayer.x) - x)
vsp += 0.2

event_user(14)

x += hsp
y += vsp