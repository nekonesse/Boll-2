if global.paused || inactive && (object_index!=oBulletBill && object_index!=oBanzaiBill) exit

grounded=false
	
if !(in_shell) && (edgeturn) && !check_collision_line(x+((hit_sizex-6)*-xsc)+hsp,y+hit_sizey+4,x+((hit_sizex-6)*-xsc)+hsp,y+hit_sizey+12,COL_BOTTOM)
{
	if !(turned) {
		turned=1
		hsp=-hsp
	}
} else {
	turned=0
}


if check_collision_line(x+(hit_sizex+1)*xsc, y+hit_sizey-4,x+(hit_sizex+1)*-xsc, y-hit_sizey+4, COL_WALL, oCollider) {
	hsp=-hsp
}

if (enemycoll) {
	var coll = instance_place(x+hsp, y-yPlus,oEnemy)

	if(coll != noone && object_get_parent(coll.object_index) == oEnemy) { 
		// i will eat my shoes. make sure the object is an enemy before checking variables that not enemies dont have
		if !(coll.inactive){
			coll.hsp = coll.hsp * sign(hsp);
			hsp = hsp * -1;
		}
	}
}


x += hsp
y += vsp
player_collision();

if hsp != 0 xsc=-esign(hsp,-1)

if grounded = false
{
vsp += grav;
}