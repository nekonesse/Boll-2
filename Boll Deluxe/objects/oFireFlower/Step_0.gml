if (going!=0) {
	y+=0.33*(going)
	if !place_meeting(x,y-1*going,parentblock) {
		going=0
	}
}

if (going!=0) exit;

if !grounded {
	vsp += grav
} else {
	vsp = 0	
}

x += hsp;
y += vsp;

player_collision()


if hsp != 0 xsc=-esign(hsp,-1)

if (place_meeting(x,y,oPlayer)) {
	oPlayer.sig.Emit("fireflower")
	instance_destroy();
}