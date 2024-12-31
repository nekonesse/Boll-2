///// PHYSICS /////
grav=0.2; //we're having an actual grav var now because changing gravity should be EASIER!!
defaultgrav = grav; //for resetting gravity back to default
vsp=0;
hsp=0;
gsp=0;

chsp = 0;
cvsp = 0;

steep_slope = false

fric = 0; //slipperiness
rot=0
xsc=1
ysc=1
grounded = true
piped = false

hit_sizex = 20
hit_sizey = 20
collision_array=[oCollider, oEnemyGround];

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
		if (floor(vsp) > 0.5 && check_collision_line(x-hit_sizex,y+hit_sizey+vsp,x+hit_sizex,y+hit_sizey+vsp, COL_BOTTOM)) || (floor(vsp) < 0 && check_collision_line(x-hit_sizex,y-hit_sizey-vsp,x+hit_sizex,y-hit_sizey-vsp, COL_TOP)) {
			vsp =-vsp
			vsp *= 0.5
			
			with(oCamera) {
				shakeoffset=4
			}
			
			VinylPlay(snd_enemyexplode)
			var i=instance_create_depth(x-1, y + hit_sizey, 0, pSkidDust);
			i.depth = (depth + 5);
			i.image_xscale = 1;
			i.hspeed=-3.25;
			i.friction=0.2;
			i.vspeed=-0.2;
			i.gravity=-0.04;
			var i=instance_create_depth(x+1, y + hit_sizey, 0, pSkidDust);
			i.depth = (depth + 5);
			i.image_xscale = -1;
			i.hspeed=3.25;
			i.friction=0.2;
			i.vspeed=-0.2;
			i.gravity=-0.04;
			
			//bounce off a slope at an angle
			get_angle_line(x-(hit_sizex-2),y+hit_sizey+5,x+(hit_sizex-2),y+hit_sizey+5)
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
	
	gsp=clamp(gsp,-3,3)
	hsp=clamp(hsp,-3,3)
	
	x += hsp 
	y += vsp
}
	
function ball_interactions() {
	var spring = collision_line(x-hit_sizex,y+hit_sizey+vsp,x+hit_sizex,y+hit_sizey+vsp, oTerrainSpring, true, true)
	if (spring) {
		vsp=min(-spring.spring_power,vsp) //dont set vsp if it exceeds power
		spring.image_speed=1
		grounded = false
	}
}