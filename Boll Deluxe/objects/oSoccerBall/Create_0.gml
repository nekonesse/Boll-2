///// PHYSICS /////
grav=0.25; //we're having an actual grav var now because changing gravity should be EASIER!!
defaultgrav = grav; //for resetting gravity back to default
vsp=0;
hsp=0;
gsp=0;

chsp = 0;
cvsp = 0;

steep_slope = false

fric = 0.0625; //slipperiness
rot=0
xsc=1
ysc=1
grounded = false
piped = false

hit_sizex = 6
hit_sizey = 8
flipped=false

function ball_movement() {
	if check_collision_dot(x+(hit_sizex+1)*xsc, y, COL_WALL, oCollider) {
		hsp=-hsp
		gsp=-gsp
	}
	
	if (grounded) gsp=approach_val(gsp,0,0.05) 
	
	if grounded {
		gsp -= (0.25 * dsin(colangle))
		
		vsp = gsp * -dsin(colangle)
		hsp = gsp * dcos(colangle)
	}
	
	if !grounded {
		vsp += grav
	} else {
		vsp = 0	
	}
	
	x += hsp 
	y += vsp
}