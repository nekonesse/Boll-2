event_inherited();

vsp=min(vsp+grav,4)

image_xscale=esign(hsp,1)

if !on_screen(32,32) {
	instance_destroy();
	if (owner!=-1) {
		owner.has_fired-=1;
	}
}

//player_collision(false);

var checkside=hit_sizex*sign(hsp)

var coll=collision_line(x+checkside,y-hit_sizey,x+checkside,y+hit_sizey+vsp,[oFrozenItem,oFrozenEnemy],false,true)
if (coll) {
	with(coll) {
		event_user(0);
		show_debug_message("triggered user event 0")
	}
	if (owner!=-1) {
		owner.has_fired-=1;
	}
	instance_create_depth(x+hsp,y+vsp,0,pFireballExplosion)
	instance_destroy();
}

if check_collision_dot(x+checkside,y,COL_WALL)
	||(hit_tics)
{
	if (owner!=-1) {
		owner.has_fired-=1;
	}
	instance_create_depth(x+hsp,y,0,pFireballExplosion)
	instance_destroy();
}

if check_collision_dot(x,y+hit_sizey, COL_BOTTOM) {
	vsp=-2;
}

while check_collision_dot(x,y+hit_sizey, COL_BOTTOM) {
	y--	
}

var enemy=check_hitbox_on_hitbox(id,oEnemy)
if (enemy) {
	with (enemy) {
		if can_fireball {
			enemyFireballed.Emit(other.id,other.owner);
		}
	}
	if (owner!=-1) {
		owner.has_fired-=1;
	}
	instance_create_depth(x+hsp,y,0,pFireballExplosion)
	instance_destroy();
}

y+=vsp
x+=hsp