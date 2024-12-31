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

if check_collision_line(x-hit_sizex,y,x+hit_sizex,y,COL_WALL)
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


if check_hitbox_on_hitbox(id,instance_nearest(x,y,oEnemy)) {
	var enemy=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,oEnemy,false,true)
	with(enemy) {
		enemyFireballed.Emit(other.id,other.owner);
	}
	if (owner!=-1) {
		owner.has_fired-=1;
	}
	instance_create_depth(x+hsp,y,0,pFireballExplosion)
	instance_destroy();
}

y+=vsp
x+=hsp