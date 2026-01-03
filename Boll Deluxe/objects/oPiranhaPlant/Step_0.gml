//we need to recode this i think.....

if (parent_pipe == noone) {
	player_collision();
	
	x += hsp
	y += vsp
	
	if !grounded {
		vsp = clamp(vsp + grav,-8,8)
	}
	exit;
}

if (go == 0) {
	var shycheck = true;
	if (is_shy) {
		var nearplayer=instance_nearest(x,y,oPlayer)
		
		if (rot mod 180 == 0) {
			shycheck=(abs(nearplayer.x-x) > 24)
		} else {
			shycheck=(abs(nearplayer.y-y) > 24)
		}
	}
	
	if (!(exposed) && shycheck) || (exposed)
	timer = max(timer - 1, 0)
	
	if !(timer) {
		if (exposed) {
			go = -0.5
		} else {
			go = 0.5
		}
		exit;
	}
}

if (go != 0) {
	travel += go;
	travel = clamp(travel,-32,32);
	visible=true;
	
	if !collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,parent_pipe,false,false) && !(exposed) {
		exposed = true;
		timer = 90;
		go = 0;
	} else if travel <= 0 && (exposed) {
		visible=false;
		go = 0;
		timer = 120;
		exposed = false;
	}
}

y = ystart + (dsin(rot-90) *  travel);
x = xstart + (dcos(rot-90) * -travel);