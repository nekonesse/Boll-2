reset_yrel = 3;

last_delta = 0;
cur_delta = 0;
collision_array = [oCollider,oEnemyGround]

init = function()
{
	var start_yoff = 0;
	
	x = xstart - 32;
	y = ystart;
	
	real_depth = depth;
	
	if (snap_to_ceiling)
	{
		start_yoff = 136;
	}
	else if (!(skip_spawn_anim))
	{
		start_yoff = 8;
	}
	
	y -= (62 + start_yoff);

	init_slime_data(self);
	
	colactive = false;

	vsp = 0;
	hsp = 0;
	hsp2 = 0;

	haccel = 0;
	vaccel = 0;

	hit_sizex = 65;
	hit_sizey = 96;

	otime = 0;

	morph_exceed = 0;
	morph_max_width = 0;
	morph_top = 0;
	sine = 0;
	
	eye_frame = 2;
	eye_blinktime = 0;
	eye_opentime = 0;
	eyes_visible = false;

	grounded = 0;

	SlimeSpawn(self);

	if (skip_spawn_anim)
	{
		// start off moving around
		//SlimeSpawnEyes(self);
		eyes_visible = true;
		colactive = true;
		action_state = 8;
	
		if (spawn_huge)
		{
			// spawn huge
			morph_scale = 0xffff;
		}
	}

	settings = (spawn_tall) ? 1 : 0;
	ready = true;
}

eyedestx = 0;
eyedesty = 0;
active = false;
ready = false;