///// PHYSICS /////
grav=0.25; //we're having an actual grav var now because changing gravity should be EASIER!!
defaultgrav = grav; //for resetting gravity back to default
vsp=0;
hsp=0;
gsp=0;

chsp = 0;
cvsp = 0;

steep_slope = false

fric = 0.02; //slipperiness
rot=0
xsc=1
ysc=1
grounded = false
piped = false

hit_sizex = 6
hit_sizey = 6
collision_array=[oCollider];

colangle=0;

flipped=false

sprindex_prev = sprite_index;
setup_box_poly(id);

function ball_movement() {
	//bounce off wall
	if check_collision_line(x+(hit_sizex+1)*xsc, y+hit_sizey-4,x+(hit_sizex+1)*xsc, y-hit_sizey+4, COL_WALL, oCollider) {
		hsp=-hsp
		gsp=-gsp
	}
	
	if !grounded {
		vsp += grav
		
		//bounce off the ground
		if (floor(vsp) > 0 && check_collision_line(x-hit_sizex,y+hit_sizey+vsp,x+hit_sizex,y+hit_sizey+vsp, COL_BOTTOM)) || (floor(vsp) < 0 && check_collision_line(x-hit_sizex,y-hit_sizey-vsp,x+hit_sizex,y-hit_sizey-vsp, COL_TOP)) {
			vsp =-vsp
			vsp *= 0.5
			
			//bounce off a slope at an angle
			get_angle_rect(x-hit_sizex-2,y-hit_sizey,x+hit_sizex+2,y+hit_sizey+3)
			hsp += lengthdir_x(2,colangle+90) //the first value in lengthdir_x is the strength of a slope bounce
		}
	} else {
		vsp = 0	
	}
	
	if (grounded) {
		//apply friction
		gsp = approach_val(gsp,0,fric)
		
		var coll=collision_line(x-hit_sizex,y+hit_sizey+2,x+hit_sizex,y+hit_sizey+2, collision_array, true, true)
		var is_coll=check_collision_line(x-hit_sizex,y+hit_sizey+2,x+hit_sizex,y+hit_sizey+2, COL_BOTTOM, collision_array)
		
		//center of mass checking, checks if the center is leaning off an edge and pushes it off
		if (is_coll) && (coll) && (x > coll.bbox_right) && (y < (coll.bbox_top+2)) { //left leaning
			hsp -= 0.05
		} else if (is_coll) && (coll) && (x < coll.bbox_left) && (y < (coll.bbox_top+2)) { //right leaning
			hsp += 0.05
		} else {
			gsp -= (0.25 * dsin(colangle)) //regular slope speed
		}
		
		vsp = gsp * -dsin(colangle)
		hsp = gsp * dcos(colangle)
	}
	
	x += hsp 
	y += vsp
}
	
function ball_interactions() {
	var spring = collision_line(x-hit_sizex,y+hit_sizey+1+vsp,x+hit_sizex,y+hit_sizey+1+vsp, oTerrainSpring, true, true)
	if (spring) {
		vsp=min(-spring.spring_power,vsp) //dont set vsp if it exceeds power
		spring.image_speed=1
		grounded = false
	}
}