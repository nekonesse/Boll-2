if (parent_pipe == noone) {
	player_collision();
	var col = instance_place(x, y + hit_sizey + 2, oPipe)
	if (col != noone) {
		parent_pipe = col;
		exposed = true;
		y = parent_pipe.bbox_top;
		vsp = 0;
		go = -4;
		travel = 32;
		exit;
	}
	
	x += hsp
	y += vsp
	
	if grounded {
		vsp = 0;
		hsp /= 2;
	} else {
		vsp = clamp(vsp + 0.15,-8,8)
	}
	exit;
}

var nearplayer=instance_nearest(x,y,oPlayer)
if (go == 0) {
	timer = clamp(timer - 1,0,120)
	if (timer == 0) {
		if (exposed) {
			go = -0.5
		} else if (point_distance(x,0,nearplayer.x,0)) > 12 {
			go = 0.5
		}
		exit;
	}
}

if (go != 0) {
	travel += go;//approach_val(travel, 32 * esign(go, 1), go)
	travel = clamp(travel,-32,32); //i genuinely dont know why this is nessecary considering approach_val should already clamp
	
	if !place_meeting(x,y,parent_pipe) && y - hit_sizey < parent_pipe.bbox_top && !(exposed) {
		exposed = true;
		y = parent_pipe.bbox_top;
		timer = 90;
		go = 0;
	} else if y >= parent_pipe.bbox_top + 20 && (exposed) {
		y = parent_pipe.bbox_top + 20;
		exposed = false;
		timer = 120;
		go = 0;
	}
}

y = floor(parent_pipe.bbox_bottom-1) - travel - 12
x = parent_pipe.x