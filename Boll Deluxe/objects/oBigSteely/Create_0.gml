///// PHYSICS /////
no_collide = false;
semi = false;
ceiling_only = false;
slope = false;
rounded = false;
x_diff = 0;
y_diff = 0;
my_friction = 1;

grav=0.2; //we're having an actual grav var now because changing gravity should be EASIER!!
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
grounded = true
piped = false
natural = false
//natural = (global.roomTimer < 3)

turned=false

hit_sizex = 20
hit_sizey = 20
collision_array=[oCollider, oEnemyGround, oBigSteely];

colangle=0;

flipped=false

can_break_bricks=true;

sprindex_prev = sprite_index;
setup_box_poly(id);

function ball_movement() {
	var col=collision_line(x+hsp+(hit_sizex+1)*xsc, y+(hit_sizey),x+hsp+(hit_sizex+1)*xsc, y-(hit_sizey),oBigSteely,true,true)
	if (col) {
		col.hsp+=hsp/2
		col.gsp=col.hsp
		hsp=-(hsp/2)
		gsp=hsp
	}
	
	var list=ds_list_create();
	var num=collision_ellipse_list(x-24+hsp,y-24+vsp,x+24+hsp,y+24+vsp, oCollider, true, true, list, true)
	
	if (num > 0) {
		var i=0;
		repeat (num) {
			with(list[| i]) {
				if (object_index == oHardBlock || object_index == oItemBox) {
					instance_destroy();
				} else if object_is_ancestor(object_index, oHittable) {
					if (hit == 0) {
						blockHit.Emit(esign(y - other.y, -1), id);
					}
				}
			}
			i++;
		}
	}
	
	ds_list_destroy(list);
	
	//bounce off wall
	if check_collision_line(x+hsp+(hit_sizex+1)*xsc, y+(hit_sizey-4),x+hsp+(hit_sizex+1)*xsc, y-(hit_sizey-4), COL_WALL) {
		if !turned {
			hsp=-hsp
			gsp=-gsp
		}
	} else {
		turned=0
	}
	
	if !grounded {
		vsp += grav
		
		//bounce off the ground
		if (floor(vsp) > 0.5 && check_collision_line(x-hit_sizex,y+hit_sizey+vsp,x+hit_sizex,y+hit_sizey+vsp, COL_BOTTOM)){
			vsp =-vsp
			vsp *= 0.5
			
			with(oCamera) {
				shake_screen(2,10);
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
			get_angle_rect(x-(hit_sizex-2),y-hit_sizey,x+(hit_sizex-2),y+hit_sizey+5)
			hsp += lengthdir_x(2,colangle+90) //the first value in lengthdir_x is the strength of a slope bounce
		}
	} else {
		vsp = 0	
	}
	
	if (grounded) {
		
		var coll=collision_line(x-hit_sizex,y+hit_sizey+2,x+hit_sizex,y+hit_sizey+2, collision_array, false, true)
		var is_coll=check_collision_line(x-hit_sizex,y+hit_sizey+2,x+hit_sizex,y+hit_sizey+2, COL_BOTTOM, collision_array)
		
		//center of mass checking, checks if the center is leaning off an edge and pushes it off
		if (is_coll) && (coll) && (x > coll.bbox_right) && (y < (coll.bbox_top+2)) { //left leaning
			hsp -= 0.05
		} else if (is_coll) && (coll) && (x < coll.bbox_left) && (y < (coll.bbox_top+2)) { //right leaning
			hsp += 0.05
		}
			
		gsp -= (fric * dsin(colangle)) //regular slope speed
		
		vsp = gsp * -dsin(colangle)
		hsp = gsp * dcos(colangle)
	}
	
	gsp=clamp(gsp,-3,3)
	hsp=clamp(hsp,-3,3)
	if (hsp < 1 && hsp > -1) && (colangle==0) hsp=approach_val(hsp,1*sign(hsp),fric)
	
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