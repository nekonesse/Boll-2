function node_path_movement(movePlayer=true) {
	if (rotating) {
		rotangle=wrap_val(rotangle+rotspd,0,359)
		x=rotorgx+lengthdir_x(rotdist,rotangle)
		y=rotorgy+lengthdir_y(rotdist,rotangle)
	}
	
	if !(pathstarted) {
		with(oPlayer) {
			if (grounded) && collision_line(x-hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),x+hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),other,false,true) {
				other.pathstarted=true;
			}
		}
	}
	
	if is_array(pathing) && (pathspd>0) && !(pathfallen) && (pathstarted) { //prevent crashing & a slight optimization
		
		var arr=pathing[pathnum];
		
		if !(pathfallen) {
			if !(rotating) {
				var dir=point_direction(x,y,arr[0],arr[1]);
				x+=lengthdir_x(pathspd,dir); //move towards the next node
				y+=lengthdir_y(pathspd,dir);
				x=median(x,pathing[pathprenum][0],arr[0]); //prevent overshooting
				y=median(y,pathing[pathprenum][1],arr[1]);
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
		if !floor(point_distance(checkx,checky,arr[0],arr[1])) && !(pathfallen) { //check if we've reached our destination
			if !(rotating) {
				x=arr[0]; //snap to our destination just in case we misalign by a margin
				y=arr[1];
			} else {
				rotorgx=arr[0]; //snap to our destination just in case we misalign by a margin
				rotorgy=arr[1];
			}
			pathprenum=pathnum;
			if !(pathisrev) && !(pathfallen) {
				if ((array_length(pathing)-1) > pathnum) {
					pathnum++ //if there is another node in our path, continue on
				} else {
					if (pathcanrev) { //can we reverse our pathing?
						pathisrev=true;
						pathnum--; //we have reversed direction, go backwards in our pathing
					} else if (pathcanfall) {
						pathfallen=1
						var dir=point_direction(pathing[max(pathprenum-1,0)][0],pathing[max(pathprenum-1,0)][1],arr[0],arr[1]);
						show_debug_message(dir)
						hspeed=lengthdir_x(pathspd,dir)
						show_debug_message(hspeed)
						vspeed=lengthdir_y(pathspd,dir)
						gravity=0.15;
					} else {
						pathnum=0; //stop running the path code, because why would we? we've stopped.
					}
				}
			} else if (pathisrev) {
				if (pathnum==0) { //if we have reached the beginning
					pathisrev=false;
					pathnum++; //we have reversed direction, go forwards in our pathing
				} else { //if not, then continue
					pathnum--;
				}
			}
		}
	}
	
	x_diff = (x - xprevious) + hspeed;
	y_diff = (y - yprevious) + vspeed;
	
	if movePlayer {
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
	pathcanrev=false;
	pathisrev=false;
	pathfallen=false;
	pathcanfall=false;
	pathdraw=true;
	pathstarted=true;
	rotdat=-1;
	rotangle=0;
	rotdist=0;
	rotorgx=0;
	rotorgy=0;
	rotspd=2;
	rotating=false;
}

function node_init_post() {
	pathprenum=max(pathnum-1,0)
	if is_array(pathing) && (pathdraw) {
		ds_list_add(oNodeManager.objectNodesList,[pathing,pathcanrev,pathcanfall,sprite_get_xoffset(sprite_index),sprite_get_yoffset(sprite_index),id])
	}
	if is_array(rotdat) && array_length(rotdat) {
		rotorgx=rotdat[0]; //these are different variables so that nodes can move them, and easier reading
		rotorgy=rotdat[1]; 
		rotdist=point_distance(x,y,rotorgx,rotorgy)
		rotangle=point_direction(x,y,rotorgx,rotorgy)
		rotating=true;
	}
}