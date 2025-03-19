var col = noone, i = 0;
if state == 128 {
	y += vsp
	vsp += 0.2
	if !on_screen(32,32) {
		instance_destroy();
	}
	exit;
}

if (state = 0) {
	frame = 0
	
	col = check_rectangle_in_hitbox(x-90,y,x+90,y+255,oPlayer)
	if col!=noone {
		if esign(x-col.x, 1) == -1 { //face left
			frame = 1
		} else if esign(x-col.x, 1) == 1 { //face right
			frame = 2
		}
	}
	
	col = check_rectangle_in_hitbox(x-40,y,x+40,y+255,oPlayer)
	if col!=noone {
		frame = 3
		state = 1
	}
}

if (state == 1) {
	vsp = clamp(vsp + 0.25, 0, 5)
	var enemy = check_hitbox_on_hitbox(id, oEnemy) 
	if (enemy) {
		enemy.hp = 0;
		enemy.killtype="stomp";
	}
	if check_collision_line(x-hit_sizex,y+hit_sizey+vsp,x+hit_sizex,y+hit_sizey+vsp,COL_BOTTOM,collision_array) {
		state = 2
		vsp = 0
		while check_collision_line(x-hit_sizex,y+hit_sizey,x+hit_sizex,y+hit_sizey,COL_BOTTOM,collision_array) {
			y--;
		}
		timer_offset = 90
		VinylPlay(snd_enemyexplode)
		with(oCamera) {
			shakeoffset=4
		}
	}
} else if (state == 2) {
	if !timer_offset {
		y = approach_val(y, ystart, 1)
		frame = 0
		if (y == ystart) {
			state = 0
		}
		exit;
	} else {
		var enemy = check_hitbox_on_hitbox(id, oEnemy) 
		if (enemy) {
			enemy.hp = 0;
			enemy.killtype="stomp";
		}
	}
	timer_offset -= 1
}

y += vsp