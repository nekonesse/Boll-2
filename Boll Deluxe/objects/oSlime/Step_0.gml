//vsp_px = vsp >> FRACBITS;

/*if (on_screen())
{
	show_debug_message("look ma, I'm on tv!");
	
	active = true;
	if (action_state == 7)
	{
		if (eyes) && (instance_exists(eyes))
		{
			eyes.visible = true;
		}
	}
}
else
{
	show_debug_message("i'll be in my trailer");
	// literally respawn ourselves if we're inactive
	if (active)
	{
		if (eyes) && (instance_exists(eyes))
		{
			instance_destroy(eyes);
			eyes = noone;
		}
		
		init();
	}
	
	active = false;
	
}*/

if ((global.paused)||(!active)||(!ready))
{
	show_debug_message("no.");
	exit;
}

// bandaid: set y_rel to where we spawned instead
if (reset_yrel)
{
	y_rel = make_s16(spawn_y - camera_y) + 22;
	reset_yrel--;
}

if (instance_position(x,y,oCollider)) && (vsp > 0)
&& (!(action_state == 5))
{
	//show_debug_message("collider at point");
	colflags |= COL_FLOOR;
	vsp = 0;
}
else
{
	colflags &= ~COL_FLOOR;
}


var nearestObj = instance_nearest(x,y,oPlayer);

if (nearestObj)
{
	var xdiff = (x - nearestObj.x);
	facing = (xdiff < 0) ? 2 : 0;
	yfacing = (y >= nearestObj.y) ? 2 : 0;
	camx2 = xdiff;
}

grounded = (colflags & COL_FLOOR);

SlimeThinker();

cur_delta = get_timer();

//hit_sizex = morph.vis_width div 2;

if (abs(timer))
{
	timer--;
	timer = timer div 1;
}

if (abs(hit_severity))
{
	hit_severity--;
	hit_severity = hit_severity div 1;
}

vsp += vaccel;

if (action_state == 5)
{
	if (vsp > 1)
	{
		vsp -= vaccel;	
	}
}

var iVar5 = haccel;

if (make_s32(make_u32(hsp_mem) - make_u32(hsp * 256)) < 0)
{
	iVar5 = -iVar5;
}

iVar5 = hsp + (iVar5);
hsp = iVar5;

iVar5 = iVar5;

var xpos_prev = x;

x += iVar5;

movesign = x - xpos_prev;

x = clamp(x,0,room_width);

y += vsp;

otime++;

// clamp sprite to screen bounds if needed
morph_max_width = morph.vis_width;
morph_top = (y div 1) - morph.vis_height;

morph_exceed = max(0, ((x - camera_x) + ((morph_max_width div 2) + 64)) - 256);

// handle extra collisions
colflags &= ~COL_CEILI;

var morph_height = abs(y - morph_top);

if (collision_line(x - ((morph_max_width div 2) + 1) + 2,
				  morph_top,
				  x + ((morph_max_width div 2) + 1) - 2,
				  morph_top,
				  oCollider,
				  false,
				  true)) && (vsp < 0)
{
	//show_debug_message("collider at point");
	
	colflags |= COL_CEILI;
}

if (collision_line(x + ((morph_max_width div 2) + 1),
				  y - 8,
				  x + ((morph_max_width div 2) + 1),
				  y - (morph_height div 2) + 8,oCollider,
				  false,
				  true))
    && (hsp >= 0)
{
	colflags |= COL_RWALL;
	
	if (!(colflags & COL_FLOOR))
	{
		slime[SLIME_HSPEED] *= -1;
		hsp *= -1;
		hsp_mem *= -1;
	}
	else
	{
		hsp = 0;
	}
}
else
{
	colflags &= ~COL_RWALL;	
}

if (collision_line(x - ((morph_max_width div 2) + 1),
				  y - 8,
				  x - ((morph_max_width div 2) + 1),
				  y - (morph_height div 2) + 8,oCollider,
				  false,
				  true))
    && (hsp < 0)
{
	colflags |= COL_LWALL;
	
	if (!(colflags & COL_FLOOR))
	{
		slime[SLIME_HSPEED] *= -1;
		hsp *= -1;
		hsp_mem *= -1;
	}
	else
	{
		hsp = 0;
	}
}
else
{
	colflags &= ~COL_LWALL;	
}

if (collision_rectangle(x - ((morph_max_width div 2) + 1),
						y - (morph_height div 2) + 8,
						x + ((morph_max_width div 2) + 1),
						y,
						oProjectile,true,true))
	&& (action_state < 5)
{
	collide_obj = instance_nearest(x,y,oProjectile);
	//morph_scale -= 3 * FRACUNIT;
}

if (variable_instance_exists(self,"intro_ypos2"))
&& (action_state == 5)
{
	if (y > yprevious)
	{
		if ((intro_ypos / FRACUNIT) < y)
		{
			intro_yspd += intro_yaccel;
			intro_yspd = min(63, intro_yspd);
			intro_ypos2 += intro_yspd;
		}
	}
	else if ((y div 1) < (yprevious div 1))
	{
		intro_ypos2 = max(intro_ypos, intro_ypos2 - (abs(y - yprevious) * FRACUNIT));
		
		if (intro_ypos == intro_ypos2)
		{
			intro_yspd = 0;
		}
	}
}

if (deleteflag)
{
	if (crush_vsp == -1)
	{
		instance_create_depth(x,y,depth,pSmoke);
	}
	else
	{
		// spray slime particles
		var part_num = 8;
		var part_ang = 90;
		var ang_factor = (part_ang / part_num);
		var ang_offset = 90 + (part_ang / 2);
		var new_part;
		var launchang, phsp, pvsp;
		
		for (var i = 0; i < part_num; i++)
		{
			launchang = (ang_factor * max(1, i + 1));
			phsp = (crush_vsp / 2) * cos(degtorad(launchang - ang_offset));
			pvsp = (crush_vsp / 2) * sin(degtorad(launchang - ang_offset));
			new_part = instance_create_depth(x, y - 24, depth - 1, pSlimeParticle);
			new_part.hsp = phsp;
			new_part.vsp = pvsp;
		}
	}
	
	instance_destroy();
}