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
			}
		}
	}
}

function warp_out_pipe(obj,spd,dir) {
	
}

function player_warping(){
	//THIS SUCKS!!!!!!!!!
	var pipecoll=instance_place(x,y+1,oPipe)
	if (pipecoll && pipecoll.pipe_direction==directions.up) {
		if (down) && !(piped) && (grounded) && !(warp_coll) {
			piped=true
			warp_timer=60;
			warp_coll=pipecoll
		}
	}
	if (warp_coll) && warp_timer {
		warp_in_pipe(warp_coll,1,270)
	}
}