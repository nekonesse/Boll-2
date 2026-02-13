if global.paused exit

//grounded=false

if !on_screen(32,32) && !origin_on_screen(xstart,ystart,32,32) {
	x = xstart
	y = ystart
} else if on_screen(32,32) {
	instance_activate_region(x-activation_region_width, y-activation_region_width, activation_region_width*2, activation_region_height*2, true)
}

onceiling = check_collision_line(x-hit_sizex+hsp,y-hit_sizey-6,x+hit_sizex+hsp,y-hit_sizey-6,COL_TOP)

if !(in_shell) && (edgeturn) && (grounded)
{
	if !(attach_to_ceiling) {
		if !check_collision_rectangle(x + (_direction * (hit_sizex+1)),y,x + (_direction * (hit_sizex-4)),y+hit_sizey+16, COL_BOTTOM) {
			if !(turned) {
				turned=1
				enemyTurnAround.Emit();
			}
		} else {
			turned=0
		}
	} else {
		if !check_collision_rectangle(x + (_direction * (hit_sizex+1)),y,x + (_direction * (hit_sizex-4)),y-hit_sizey-16, COL_TOP) {
			if !(turned) {
				turned=1
				enemyTurnAround.Emit();
			}
		} else {
			turned=0
		}
	}
}

var steely=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oBigSteely, true, true)

if (steely) && (abs(steely.hsp)>0) {
	hp=0
}

if check_collision_line(x+(hit_sizex+1)*_direction, y+(hit_sizey-2),x+(hit_sizex+1)*_direction, y-(hit_sizey-2), COL_WALL) {
	enemyTurnAround.Emit();
}

if (enemycoll) {
	var coll = check_rectangle_in_hitbox(x+(hit_sizex+1)*_direction,y+hit_sizey-3,x+(hit_sizex+1)*_direction,y-hit_sizey+3,oEnemy)
	
	if (coll) && (coll.enemycoll) {
		enemyTurnAround.Emit();
		with(coll) if (_direction!=other._direction) enemyTurnAround.Emit();
	}
}

if !(attach_to_ceiling) {
	if !grounded
	{
		vsp=min(vsp+grav,4);
	} else {
		if walker {
			gsp = constantspd * _direction
		}
		vsp = gsp * -dsin(colangle)
		hsp = gsp * dcos(colangle)
	}
} else {
	grav=-defaultgrav;
	
	if !(onceiling) {
		attach_to_ceiling=false;
		grav=defaultgrav
	} else {
		if walker {
			gsp = constantspd * _direction
		}
		vsp = gsp * -dsin(colangle)
		hsp = gsp * dcos(colangle)
	}
}

var shootblock=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,oShootBlock,false,true)
if (shootblock) && (shootblock.goDirection!=0) && !(phaseid) {
	with(shootblock) {
		instance_create(x,y+(sprite_height/2)*goDirection,pImpact)
	}
	VinylPlay(snd_enemykick)
	hp-=1
	phaseid=shootblock
	phase_leeway=3
}

x += hsp
y += vsp

player_collision();

if !(overridexsc) && !(in_shell)
if gsp != 0 && (hp > 0) xsc=-esign(gsp,-1)

prevsprite_index = sprite_index
event_user(0); //animation controller

if (sprite_index!=prevsprite_index) {
	event_user(1); //reset frame
}

if (turning) && !(in_shell) && !(no_turn_anim) {
	flipped = 0;
	turning=max(0,turning-1);
	xsc = -turnxsc;
	image_speed = 0;
	if !(turning) {
		image_speed = 1
	}
	
	image_index = (turning > 5)
} else if (in_shell) {
	turning = 0;
}

if !check_rectangle_in_hitbox(x+(hit_sizex+1)*_direction,y+hit_sizey-3,x+(hit_sizex+1)*_direction,y-hit_sizey+3,oEnemy) && !check_collision_line(x+(hit_sizex+1)*_direction,y+hit_sizey-3,x+(hit_sizex+1)*_direction,y-hit_sizey+3,COL_WALL) {
	flipped = 0;
}