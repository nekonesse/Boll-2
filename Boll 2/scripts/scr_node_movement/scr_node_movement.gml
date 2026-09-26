function node_path_movement(movePlayer=true) {
	if (rotating) {
		rotangle=wrap_val(rotangle+rotspd,0,359)
		x=rotorgx+lengthdir_x(rotdist,rotangle)
		y=rotorgy+lengthdir_y(rotdist,rotangle)
	}
	
	if is_array(pathing) && (pathspd>0) && !(pathfallen) && (pathstarted) { //prevent crashing & a slight optimization
		
		var arr=pathing[pathnum];
		
		if !(pathfallen) {
			if !(rotating) {
				var dir=point_direction(x,y,arr[0],arr[1]);
				var xprev = x;
				var yprev = y;
				
				x+=lengthdir_x(pathspd,dir); //move towards the next node
				y+=lengthdir_y(pathspd,dir);
				x=median(x,pathing[pathprenum][0]-8+pathoffx,arr[0]); //prevent overshooting
				y=median(y,pathing[pathprenum][1]-8+pathoffy,arr[1]);
				
				var xdiff = x-xprev;
				var ydiff = y-yprev;
				var l=0
				repeat(array_length(binding_link)) {
					var ob = oGameManager.object_uuids[$ binding_link[l]];
					ob.x += xdiff;
					ob.y += ydiff;
					l++;
				}
			} else {
				var dir=point_direction(rotorgx,rotorgy,arr[0],arr[1]);
				rotorgx+=lengthdir_x(pathspd,dir); //move towards the next node
				rotorgy+=lengthdir_y(pathspd,dir);
				rotorgx=median(rotorgx,pathing[pathprenum][0],arr[0]); //prevent overshooting
				rotorgy=median(rotorgy,pathing[pathprenum][1],arr[1]);
			}
		} else {
			vsp = min(3,vsp+grav);
			y += vsp;
		}
	
		var checkx=x;
		var checky=y;
		if (rotating) {
			checkx=rotorgx;
			checky=rotorgy;
		}
		if !floor(point_distance(checkx,checky,arr[0]-8+pathoffx,arr[1]-8+pathoffy)) && !(pathfallen) { //check if we've reached our destination
			if !(rotating) {
				x=arr[0]-8+pathoffx; //snap to our destination just in case we misalign by a margin
				y=arr[1]-8+pathoffy;
			} else {
				rotorgx=arr[0]; //snap to our destination just in case we misalign by a margin
				rotorgy=arr[1];
			}
			pathprenum=pathnum;
			if !(pathisrev) && !(pathfallen) {
				if (pathnum < array_length(pathing)-1) {
					pathnum++ //if there is another node in our path, continue on
					var arr2 = pathing[pathnum];
					pathspd = arr2[2];
				} else {
					switch(pathendtype) {
						case "continue":
							pathnum = 0;
							var arr2=pathing[pathnum];
							pathspd = arr2[2];
						break;
						case "reverse":
							pathisrev=true;
							pathnum--; //we have reversed direction, go backwards in our pathing
							var arr2=pathing[pathnum];
							pathspd = arr2[2];
						break;
						case "fall":
							pathfallen=1
							var dir=point_direction(pathing[max(pathprenum-1,0)][0],pathing[max(pathprenum-1,0)][1],arr[0],arr[1]);
							hspeed=lengthdir_x(pathspd,dir)
							vspeed=lengthdir_y(pathspd,dir)
							gravity=0.15;
						break;
						case "reset":
							pathnum = 0;
							var arr2=pathing[pathnum];
							if !(rotating) {
								x=arr2[0]-8+pathoffx;
								y=arr2[1]-8+pathoffy;
							} else {
								rotorgx=arr2[0];
								rotorgy=arr2[1];
							}
						break;
					}
				}
			} else if (pathisrev) {
				if (pathnum < array_length(pathing)-1) {
					pathnum--;
					var arr2=pathing[pathnum];
					pathspd = arr2[2];
				} else {
					switch(pathendtype) {
						case "continue":
							pathnum = array_length(pathing)-1;
							var arr2=pathing[pathnum];
							pathspd = arr2[2];
						break;
						case "reverse":
							pathisrev=false;
							pathnum++;
							var arr2=pathing[pathnum];
							pathspd = arr2[2];
						break;
						case "fall":
							pathfallen=1
							var dir=point_direction(pathing[max(pathprenum-1,0)][0],pathing[max(pathprenum-1,0)][1],arr[0],arr[1]);
							hspeed=lengthdir_x(pathspd,dir)
							vspeed=lengthdir_y(pathspd,dir)
							gravity=0.15;
						break;
						case "reset":
							pathnum = array_length(pathing)-1;
							var arr2=pathing[pathnum];
							if !(rotating) {
								x=arr2[0]-8+pathoffx;
								y=arr2[1]-8+pathoffy;
							} else {
								rotorgx=arr2[0];
								rotorgy=arr2[1];
							}
						break;
					}
				}
			}
		}
	}
	
	x_diff = (x - xprevious) + hspeed;
	y_diff = (y - yprevious) + vspeed;
	
	if (pathstarttype == "touch") && !(pathstarted) {
		with(oPlayer) {
			if (grounded) && collision_line(x-hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),x+hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),other,false,true) {
				other.pathstarted=true;
			}
		}
	}
	
	if (movePlayer) {
		with(oPlayer) {
			if (grounded) && collision_line(x-hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),x+hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),other,false,true) {
				x += other.x_diff;
				y += other.y_diff;
			}
		}
	}
}

function node_init_vars() {
	pathing=-1;
	pathprenum=0;
	pathnum=1;
	pathspd=2;
	pathisrev=false;
	pathfallen=false;
	pathdraw=true;
	pathstarttype="auto";
	pathendtype="continue";
	pathstarted=true;
	rotdat=-1;
	rotangle=0;
	rotdist=0;
	rotorgx=0;
	rotorgy=0;
	rotspd=2;
	rotating=false;
	pathoffx = sprite_get_xoffset(sprite_index);
	pathoffy = sprite_get_yoffset(sprite_index);
	binding_link = [];
	nodeReverse = new Signal();
	
	nodeReverse.Connect(self, function(index, obj) {
		pathisrev = !pathisrev;
		pathprenum=pathnum;
		
		if !(pathisrev) {
			pathnum++;
			var arr2=pathing[pathnum];
			pathspd = arr2[2];
		} else {
			if (pathnum != 0) {
				pathnum--;
				var arr2=pathing[pathnum];
				pathspd = arr2[2];
			} else {
				pathnum=array_length(pathing)-1;
				var arr2=pathing[pathnum];
				pathspd = arr2[2];
			}
		}
	});
}

function getnodevars() {
	var pstruct = {
		pathing : pathing,
		pathprenum : pathprenum,
		pathnum : pathnum,
		pathspd : pathspd,
		pathisrev : pathisrev,
		pathfallen : pathfallen,
		pathdraw : pathdraw,
		pathstarted : pathstarted,
		pathstarttype : pathstarttype,
		pathendtype : pathstarttype,
		rotdat : rotdat,
		rotangle : rotangle,
		rotdist : rotdist,
		rotorgx : rotorgx,
		rotorgy : rotorgy,
		rotspd : rotspd,
		rotating : rotating
	}
	
	return pstruct
}

function node_init_post() {
	pathprenum=max(pathnum-1,0)
	switch (pathstarttype) {
		case "auto":
			pathstarted = true;
		break;
		case "touch":
		case "none":
			pathstarted = false;
		break;
	}
	if is_array(pathing) {
		/*if (pathdraw) { TODO: redo this entire system
			ds_list_add(oNodeManager.objectNodesList,[pathing,pathcanrev,pathcanfall,sprite_get_xoffset(sprite_index),sprite_get_yoffset(sprite_index),id])
		}*/
		var newpathing = [];
		var i=0;
		var counted_segments = 0;
		repeat(array_length(pathing)) {
			if (pathing[i][3]!=0) && (i < array_length(pathing)-1) {
				var j = 0;
				var x1 = pathing[i][0];
				var y1 = pathing[i][1];
				var x2 = pathing[i+1][0];
				var y2 = pathing[i+1][1];
				var curvature = pathing[i][3]/22.5;
				var segments = max(8,floor(abs(pathing[i][3])/2));
				var px = x1;
				var py = y1;
				var cx = (x1 + x2) * .5 + curvature * (y2 - y1);
				var cy = (y1 + y2) * .5 - curvature * (x2 - x1);
				repeat (segments)
				{
					var t = ++ j / segments;
					var xx = lerp(lerp(x1, cx, t), lerp(cx, x2, t), t);
					var yy = lerp(lerp(y1, cy, t), lerp(cy, y2, t), t);
					var new_node = [px,py,pathing[i][2],0];
					if (is_array(new_node)) {
						array_insert(newpathing,i+1+counted_segments,new_node)
					}
					px = xx;
					py = yy;
					counted_segments++;
				}
			} else {
				if (is_array(pathing[i])) {
					array_push(newpathing,pathing[i]);
				}
			}
			i++;
		}
		i=array_length(newpathing)-1;
		repeat(array_length(newpathing)) {
			if !is_array(newpathing[i]) {
				array_delete(newpathing,i,1);
			}
			i--;
		}
		pathing = newpathing;
	}
	if is_array(rotdat) && array_length(rotdat) {
		rotorgx=rotdat[0]; //these are different variables so that nodes can move them, and easier reading
		rotorgy=rotdat[1]; 
		rotdist=point_distance(x,y,rotorgx,rotorgy)
		rotangle=point_direction(x,y,rotorgx,rotorgy)
		rotating=true;
	}
}