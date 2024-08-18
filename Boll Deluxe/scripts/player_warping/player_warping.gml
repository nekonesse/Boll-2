function warp_in_pipe(obj,spd,dir) {
	piped=true;
	x+=lengthdir_x(spd,dir)
	y+=lengthdir_y(spd,dir)
		
	warp_timer=approach_val(warp_timer,0,1)
	if !(warp_timer) {
		with (obj) {
			var found = noone;
			var pipe = noone;
			instance_activate_object(oPipe)
			for (var i = 0; i < instance_number(oPipe); ++i;)
			{
				pipe = instance_find(oPipe,i+1);
				if pipe.warpname == warptarget {
					show_debug_message("found pipe")
					found=pipe
					break;
				}
			}
			if found != noone {
				other.x=found.x
				other.y=found.y
				other.piped=true;
				other.warp_timer=1;
				other.warp_coll=found
				other.warp_out=true;
			}
		}
	}
}

function warp_out_pipe(obj,spd,dir) {
	piped=true;
	x+=lengthdir_x(spd,dir)
	y+=lengthdir_y(spd,dir)
		
	if !check_collision_dot(x,y+hit_sizey,COL_WALL, obj) {
		piped=false
		warp_timer=0;
		warp_coll=noone
		warp_out=false;
	}
}

function player_warping(){
	//THIS SUCKS!!!!!!!!!
	var pipecoll=instance_place(x,y+1,oPipe)
	if (pipecoll && pipecoll.pipe_direction==directions.up) {
		if (down) && !(piped) && (grounded) && !(warp_coll) {
			piped=true
			warp_timer=60;
			warp_coll=pipecoll
			x=pipecoll.x
		}
	}
	if (warp_coll) && (warp_timer) && (piped) {
		if !(warp_out) {
			warp_in_pipe(warp_coll,1,270)
		} else {
			warp_out_pipe(warp_coll,1,90)
		}
	}
}