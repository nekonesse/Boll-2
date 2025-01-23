xscale=lerp(xscale,1,0.05)
yscale=lerp(yscale,1,0.05)

if collision_rectangle(x - 8, -999999, x + 24, room_height + 9000, oPlayer, false, true) {
	if !(timer) {
		var xsize = hit_sizex div 2,
			ysize = hit_sizey div 2,
			go = false;
	
		if on_screen() {
			var dir = 1
			if (instance_exists(oPlayer)) {
				dir = sign(nearestplayer().x-x)
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
				var i=instance_create_depth(x + xsize + (xsize * dir), y + ysize, depth + 2, shoot);
				i.hsp = dir * 2
				i.xsc = -dir;
				i.spawn_object = id;
				VinylPlay(snd_enemycannonfast)
				xscale = 1.33;
				yscale = 1.33;
				timer = random_range(120, 120 + abs(timer_offset));
			}
		}
		exit;
	}
	timer -= 1
}