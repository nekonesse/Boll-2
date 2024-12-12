var col = noone;
if (state = 0) {
	
	frame = 0
	
	if collision_rectangle(x-90,y,x+90,y+255,oPlayer,false,true) {
		frame = 1
	}
	
	if collision_rectangle(x-40,y,x+40,y+255,oPlayer,false,true) {
		frame = 2
		state = 1
	}
}

if (state = 1) {
	vsp = clamp(vsp + 0.25, 0, 4)
	col = instance_place(x, y+vsp, oCollider)
	if col {
		state = 2
		vsp = 0
		timer_offset = 90
		y = col.bbox_top - 15
		VinylPlay(snd_enemyexplode)
	}
} else if (state = 2) {
	if !timer_offset {
		y = approach_val(y, ystart, 1)
		frame = 0
		if (y == ystart) {
			state = 0
		}
		exit;
	}
	timer_offset -= 1
}

y += vsp