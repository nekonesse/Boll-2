xscale=lerp(xscale,1,0.05)
yscale=lerp(yscale,1,0.05)

if !(timer) {
	if on_screen_xy(hit_sizex,hit_sizey) {
		var dir = 1,
			xsize = hit_sizex div 2,
			ysize = hit_sizey div 2,
			go = false;
		if (instance_exists(oPlayer)) {
			dir = sign(nearestplayer().x - (x + xsize))
		}
		
		//shooting requirements
		var col = collision_rectangle(x + xsize, y, x + xsize + (hit_sizex * dir), y + hit_sizey - 1, oCollider,false,true)
		go = (col == noone)
		if (!go) {
			go = (col.no_collide && col.semi)
		}
		if (go) {
			go = (collision_rectangle(x - 8, -9999999, x + hit_sizex + 8, room_height + 999999,oPlayer,false,true) == noone)
		}
		
		
		if (go) {
			with instance_create_depth(x + xsize, y + ysize, depth + 2, shoot) {
				hsp = dir * 2
				xsc = -dir;
				spawn_object = other.id;
			}
			VinylPlay(snd_enemycannonfast)
			xscale = 1.33;
			yscale = 1.33;
			timer = random_range(120, 120 + abs(timer_offset));
		}
	}
	exit;
}
timer -= 1