y+=vsp
x+=hsp

player_collision();

if check_collision_line(x+hit_sizex+hsp,y-hit_sizey,x+hit_sizex+hsp,y+hit_sizey,COL_WALL) || check_collision_line(x-hit_sizex+hsp,y-hit_sizey,x-hit_sizex+hsp,y+hit_sizey,COL_WALL) {
	if (owner!=-1) {
		owner.has_fired-=1;
	}
	instance_create_depth(x+hsp,y,0,pFireballExplosion)
	instance_destroy();
}

if (grounded) {
	grounded=false;
	vsp=-1.75;
} else {
	vsp+=grav
}

if check_hitbox_on_hitbox(id,oEnemy) {
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