if global.paused || inactive && (object_index!=oBulletBill && object_index!=oBanzaiBill) exit

//grounded=false

if !on_screen() & !origin_on_screen() {
	x = xstart
	y = ystart
}

if !on_screen() exit;

//instance_activate_region(x-64,y-64, 128, 128, true)

if !(in_shell) && (edgeturn) && (grounded)
{
	if !check_collision_line(x + (-xsc * (hit_sizex-4)),y,x + (-xsc * (hit_sizex-4)),y+hit_sizey+16, COL_BOTTOM){
		if !(turned) {
			turned=1
			_direction *= -1;
			turning = 10;
			prevsprite_index=sprite_index
		}
	} else {
		turned=0
	}
}


if check_collision_line(x+(hit_sizex+1)*-xsc, y+hit_sizey-3,x+(hit_sizex+1)*-xsc, y-hit_sizey+3, COL_WALL) {
	_direction *= -1;
	turning = 10;
	prevsprite_index=sprite_index
}

if (enemycoll) {
	var coll = instance_place(x+hsp, y, oEnemy)

	if !(no_interaction) && (coll != noone && object_get_parent(coll.object_index) == oEnemy) { 
		// i will eat my shoes. make sure the object is an enemy before checking variables that not enemies dont have
		if !(coll.no_interaction) && !(coll.inactive) && !(flipped) {
			flipped = 1;
			_direction *= -1;
			turning = 10;
			prevsprite_index=sprite_index
		}
	}
}

if (turning) {
	turning=max(0,turning-1)
	flipped = 0;
}
event_user(0); //animation controller

if !place_meeting(x+hsp,y, [oEnemy, oCollider]) {
	flipped = 0;
}

if !grounded
{
	vsp += grav;
} else {
	if walker {
		gsp = constantspd * _direction
	}
	vsp = gsp * -dsin(colangle)
	hsp = gsp * dcos(colangle)
}

x += hsp
y += vsp

player_collision();

if gsp != 0 xsc=-esign(gsp,-1)