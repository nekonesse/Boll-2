function warp_in_pipe(obj,spd,dir) {
	no_step = true;
	piped=true;
	x+=lengthdir_x(spd,dir)
	y+=lengthdir_y(spd,dir)
	depth=oGameManager.piping_object_depth; //behind all main tiles
	
	my_camera.set_paused(true);
		
	warp_timer=approach_val(warp_timer,0,1)
	
	if (warp_timer <= 60) {
		visible=0
		if (warp_timer == 30) {
			var found = warp_coll.mytargetpipe //predicting the camera position
			instance_activate_object(found);
			var xx = x;
			var yy = y;
			if instance_exists(found) {
				xx=found.x
				if found.image_angle!=90 && found.image_angle!=270
				yy=found.y
				else
				yy=found.y+4
			} else {
				xx=warp_coll.x
				if warp_coll.image_angle!=90 && warp_coll.image_angle!=270
				yy=warp_coll.y
				else
				yy=warp_coll.y+4
			}
			my_camera.move(xx,yy,30);
		}
	}
	
	if !(warp_timer) {
		var found = warp_coll.mytargetpipe
		instance_activate_object(found);
		if instance_exists(found) { //warp to found pipe
			x=found.x;
			if found.image_angle!=90 && found.image_angle!=270
			y=found.y;
			else
			y=found.y+4;
			
			if (found.image_angle == 90) {
				xsc = -1;
			}
			
			if (found.image_angle == 270) {
				xsc = 1;
			}
			warp_coll=found
		} else {//if pipe is for some reason, not found, send back to original pipe
			x=warp_coll.x
			if warp_coll.image_angle!=90 && warp_coll.image_angle!=270
			y=warp_coll.y
			else
			y=warp_coll.y+4
		}
		switch(warp_coll.image_angle) {
			case 0:
				warp_type="exit_pipe_up";
			break;
			case 180:
				warp_type="exit_pipe_down";
			break;
			case 90:
			case 270:
				warp_type="exit_pipe_side";
			break;
		}
		piped=true;
		warp_out=true;
		warp_timer=21; //very hacky value
		visible=true;
	}
}

function warp_out_pipe(obj,spd,dir) {
	no_step = true;
	piped=true;
	x+=lengthdir_x(spd,dir)
	y+=lengthdir_y(spd,dir)
	if !collision_rectangle(x-hit_sizex-4,y-hit_sizey-4,x+hit_sizex-4,y+hit_sizey, obj, false, true) {
		piped=false
		warp_timer=0;
		warp_coll=noone
		warp_out=false;
		hsp = 0;
		gsp = 0;
		vsp = 0;
		move = 0;
		state = "";
		depth = 0;
		visible=true;
		warp_type = "";
		VinylPlay(snd_pipe)
		sig.Emit("exit_pipe")
		my_camera.set_paused(false);
		no_step = false;
	}
}

function player_warping(){
	if (dead || hurt) exit;
	
	//THIS SUCKS!!!!!!!!!
	var pipecoll=collision_line(x-hit_sizex,y+hit_sizey+1,x+hit_sizex,y+hit_sizey+1,oPipe,false,true)
	if (pipecoll && pipecoll.image_angle==0 && pipecoll.warptarget!="") { //WARPING DOWN PIPE
		if (down) && !(piped) && (grounded) && !(warp_coll) {
			piped=true
			warp_type="enter_pipe_down"
			warp_timer=90;
			warp_coll=pipecoll
			x=pipecoll.x
			hsp = 0;
			gsp = 0;
			vsp = 0;
			move = 0;
			state = "";
			VinylPlay(snd_pipe)
			sig.Emit("enter_pipe")
			my_camera.move(x,y,30);
		}
	}
	pipecoll=collision_line(x+hit_sizex+1,y-hit_sizey,x+hit_sizex+1,y+hit_sizey,oPipe,false,true)
	if (pipecoll && pipecoll.image_angle==90 && pipecoll.warptarget!="") { //WARPING RIGHT PIPE
		if (right) && !(piped) && (grounded) && !(warp_coll) {
			piped=true
			warp_type="enter_pipe_side"
			warp_timer=90;
			warp_coll=pipecoll
			y=pipecoll.y+4
			hsp = 0;
			gsp = 0;
			vsp = 0;
			move = 0;
			state = "";
			VinylPlay(snd_pipe)
			sig.Emit("enter_pipe")
			my_camera.move(x,y,30);
		}
	}
	pipecoll=collision_line(x-hit_sizex-1,y-hit_sizey,x-hit_sizex-1,y+hit_sizey,oPipe,false,true)
	if (pipecoll && pipecoll.image_angle==270 && pipecoll.warptarget!="") { //WARPING LEFT PIPE
		if (left) && !(piped) && (grounded) && !(warp_coll) {
			piped=true
			warp_type="enter_pipe_side"
			warp_timer=90;
			warp_coll=pipecoll
			y=pipecoll.y+4
			hsp = 0;
			gsp = 0;
			vsp = 0;
			move = 0;
			state = "";
			VinylPlay(snd_pipe)
			sig.Emit("enter_pipe")
			my_camera.move(x,y,30);
		}
	}
	pipecoll=collision_rectangle(x-hit_sizex,y-hit_sizey-3,x+hit_sizex,y-hit_sizey-1,oPipe,false,true)
	if (pipecoll && pipecoll.image_angle==180 && pipecoll.warptarget!="") { //WARPING UP PIPE
		if (up) && !(piped) && !(warp_coll) {
			piped=true
			warp_type="enter_pipe_up"
			warp_timer=120;
			warp_coll=pipecoll
			x=pipecoll.x;
			hsp = 0;
			vsp = 0;
			state = "";
			VinylPlay(snd_pipe)
			sig.Emit("enter_pipe")
			my_camera.move(x,y,30);
		}
	}
	if (warp_coll) && (warp_timer) && (piped) {
		if !(warp_out) {
			instance_activate_object(warp_coll)
			warp_in_pipe(warp_coll,0.5,wrap_val(warp_coll.image_angle-90,0,359))
		} else {
			instance_activate_object(warp_coll)
			warp_out_pipe(warp_coll,0.5,warp_coll.image_angle+90)
		}
	}
}