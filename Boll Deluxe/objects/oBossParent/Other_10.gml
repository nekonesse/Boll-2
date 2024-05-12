var player = instance_place(x,y,oPlayer),hit = false;
if (invincible || alarm[0]) {exit}
if (player) {
	if hit_type == "sonic" {
		player.vsp = -player.vsp
		player.hsp = -player.hsp
		hit = true
		alarm[0] = 20
	} else 
	if (hit_type == "mario" && place_meeting(x,y-sprite_height,player) && player.vsp > 0) {
		player.vsp = -6
		hit = true
		alarm[0] = 60
	}
}

if (hit) {
	hp -= 1
	event_user(1)
}