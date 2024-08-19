if global.paused || inactive && (object_index!=oBulletBill && object_index!=oBanzaiBill) exit

grounded=false
	
if (edgeturn) && !(turned) && !collision_rectangle(x-2*xsc,bbox_bottom,floor(x)+9*xsc,floor(y)+9,oCollider,true,true) && !collision_rectangle(x-2*xsc,bbox_bottom,floor(x)+9*xsc,floor(y)+9,oSemilider,true,true) 
{
	turned=1
	hsp=-hsp
}

if (!in_shell && !place_meeting(x+hsp, y+2, oCollider))
{
   turned=0
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

player_collision();

if hsp != 0 xsc=-esign(hsp,-1)

if grounded = false
{
vsp += grav;
}