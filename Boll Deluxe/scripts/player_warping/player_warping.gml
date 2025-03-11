function warp_in_pipe(obj,spd,dir) {
	piped=true;
	x+=lengthdir_x(spd,dir)
	y+=lengthdir_y(spd,dir)
	depth=610; //behind all main tiles
		
	warp_timer=approach_val(warp_timer,0,1)
	if warp_timer <= 30 {
		visible=0
	}
	/*switch (obj.image_angle) {
		case 0: y=max(y,obj.y) break;
		case 90: x=max(x,obj.x) break;
		case 180: y=min(y,obj.y) break;
		case 270: x=min(x,obj.x) break;
	}*/
	if !(warp_timer) {
		with (obj) {
			var found = noone;
			var pipe = noone;
			instance_activate_object(oPipe)
			var i=0;
			repeat (instance_number(oPipe))
			{
				pipe = instance_find(oPipe,i);
				if pipe.warpname == warptarget {
					show_debug_message("found pipe")
					found=pipe
					break;
				}
				i++;
			}
			if found != noone { //warp to found pipe
				other.x=found.x
				if found.image_angle!=90 && found.image_angle!=270
				other.y=found.y
				else
				other.y=found.y+4
				other.warp_coll=found
				
				// chearii: camera stupidity
				if (other.my_camera)
				{
					other.my_camera.x = found.x;
					other.my_camera.y = found.y;
				
					other.my_camera.x_final = found.x;
					other.my_camera.y_final = found.y;
				}
			} else {//if pipe is for some reason, not found, send back to original pipe
				other.x=x
				if image_angle!=90 && image_angle!=270
				other.y=y
				else
				other.y=y+4
				other.warp_coll=id;
				
				// chearii: camera stupidity
				if (other.my_camera)
				{
					other.my_camera.x = x;
					other.my_camera.y = y;
				
					other.my_camera.x_final = x;
					other.my_camera.y_final = y;
				}
			}
			other.piped=true;
			other.warp_out=true;
			other.warp_timer=21; //very hacky value
		}
	}
}

function warp_out_pipe(obj,spd,dir) {
	piped=true;
	x+=lengthdir_x(spd,dir)
	y+=lengthdir_y(spd,dir)
	warp_timer=approach_val(warp_timer,1,1)
	if warp_timer <= 1 {
		visible=1;
	}
	if !collision_line(x,y-hit_sizey-4,x,y+hit_sizey, obj, false, true) {
		piped=false
		warp_timer=0;
		warp_coll=noone
		warp_out=false;
		depth=0;
		visible=1;
	}
}

function player_warping(){
	//THIS SUCKS!!!!!!!!!
	var pipecoll=collision_line(x-hit_sizex,y+hit_sizey+1,x+hit_sizex,y+hit_sizey+1,oPipe,false,true)
	if (pipecoll && pipecoll.image_angle==0 && pipecoll.warptarget!="") { //WARPING DOWN PIPE
		if (down) && !(piped) && (grounded) && !(warp_coll) {
			piped=true
			warp_type="enter_pipe"
			warp_timer=60;
			warp_coll=pipecoll
			x=pipecoll.x
		}
	}
	pipecoll=collision_line(x+hit_sizex+1,y-hit_sizey,x+hit_sizex+1,y+hit_sizey,oPipe,false,true)
	if (pipecoll && pipecoll.image_angle==90 && pipecoll.warptarget!="") { //WARPING RIGHT PIPE
		if (right) && !(piped) && (grounded) && !(warp_coll) {
			piped=true
			warp_type="enter_pipe"
			warp_timer=60;
			warp_coll=pipecoll
			y=pipecoll.y+4
		}
	}
	pipecoll=collision_line(x-hit_sizex-1,y-hit_sizey,x-hit_sizex-1,y+hit_sizey,oPipe,false,true)
	if (pipecoll && pipecoll.image_angle==270 && pipecoll.warptarget!="") { //WARPING LEFT PIPE
		if (left) && !(piped) && (grounded) && !(warp_coll) {
			piped=true
			warp_type="enter_pipe"
			warp_timer=60;
			warp_coll=pipecoll
			y=pipecoll.y+4
		}
	}
	pipecoll=collision_line(x-hit_sizex,y-hit_sizey-1,x+hit_sizex,y-hit_sizey-1,oPipe,false,true)
	if (pipecoll && pipecoll.image_angle==180 && pipecoll.warptarget!="") { //WARPING UP PIPE
		if (up) && !(piped) && !(grounded) && !(warp_coll) {
			piped=true
			warp_type="enter_pipe"
			warp_timer=60;
			warp_coll=pipecoll
			x=pipecoll.x
		}
	}
	if (warp_coll) && (warp_timer) && (piped) {
		if !(warp_out) {
			switch(warp_coll.image_angle) {
				case 0:
				warp_in_pipe(warp_coll,0.5,270)
				break;
				case 90:
				warp_in_pipe(warp_coll,0.5,0)
				break;
				case 180:
				warp_in_pipe(warp_coll,0.5,90)
				break;
				case 270:
				warp_in_pipe(warp_coll,0.5,180)
				break;
			}
		} else {
			warp_out_pipe(warp_coll,0.5,warp_coll.image_angle+90)
		}
	}
}