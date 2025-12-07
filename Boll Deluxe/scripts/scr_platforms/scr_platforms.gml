/// \file  scr_platforms.gml
/// \brief Platform thinkers.

//
// blue spinning platform stuff
// ported from decompiled SMA2 code
//

#macro RADFRACDIV 10430.378

global.bluechainplat_distances = [0x10, 0x20, 0x30, 0x40, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50];
global.bluechainplat_xdiffs = [0, 86, 336, 512, 16, 86];


// complete overhaul to support multiple players
function blue_plat_check_playercol(obj,param_1,param_2)
{
    var timermax, timeradd;
    var player_screeny; // short, what it says on the tin
    var uVar4;
    var bVar1;
	var shittyangle;
	var crappyangle;
    var platsub;
	var timersign;
    
    var left = param_1; // clipping X
    var width = 80; // hitbox width
    var top = param_2 - 12; // clipping Y
    var height = 19; // hitbox height
	
	var top_lenient = top - max(0, obj.plat_sinydiff);
	
    // local camera coords so online isn't fucked
    var camy = camera_get_view_y(view_camera[0]);

    // uh oh!!! player interaction!
    obj.playercollidemem = 0;

    var p;
	var randval;
	var pdist = 0;
	var newy;
	var stopconveyor = false;
	
	var playerstand = false;
	var playerclip = false;
	
	var plist = ds_list_create();
	var pnum = collision_rectangle_list(left, top_lenient, left + width, top + height, 
										oPlayer, false, true, plist, false);
	if pnum > 0
	{
		var i=0;
	    repeat (pnum)
	    {
			p = (plist[| i]);
			stopconveyor = false;
			
			obj.plrcollides = 1;

            obj.coord1 = (obj.platangmem - camy) + -8; // screen Y

            player_screeny = (p.y div 1) - camy;

            if (player_screeny < obj.coord1) 
            {
                if (p.vsp >= 0) 
                {
                    p.vsp = 0;
					
					playerstand = true;

                    obj.playercollidemem = 3;

                    platsub = 40; //uVar4;
					
					newy = (obj.platangmem - 16) + 1; //- obj.plat_sinydiff;
					
					with(p)
					{
						playerclip = (check_collision_dot(p.x div 1,newy,COL_TOP) ? true : false);	
					}
					
					if (!playerclip)
					{
	                    p.y = newy - obj.y_diff;
					}
					
					p.grounded = true;
					p.gsp = p.hsp
					
					with(p)
					{
						playerclip = (check_collision_dot(p.x div 1,newy,COL_WALL) ? true : false);	
					}
                    
                    // update the player's X if they haven't hit a wall
                    if (!playerclip)
					&& (!stopconveyor)
					{
                        //show_debug_message("move me please");
						//show_debug_message(obj.sinedata);
						p.x -= intlib_make_s16(obj.sinedata);
						//p.cspeedx = -obj.var6;
					}
					
					shittyangle = ((((intlib_make_u16(obj.orbit_angle) / 91.022) * 256) % 92160) div 1);
					crappyangle = (shittyangle div 256);
					draw_text(x,y+16,shittyangle / 256);
					
					//bVar1 = ((shittyangle / 256) <= (180 + sign(obj.timer)) );
					var u16_oVar2 = intlib_make_u16(obj.orbit_angle);
					var icmp = intlib_compare(0x8000, u16_oVar2);
					
					bVar1 = (icmp == 0);

                    timermax = ((bVar1) ? -64 : 64);
                    timeradd = ((bVar1) ? -1 : 1);
					
                    if (((obj.swing_speed >> 16) != timermax))
					//&& (global.leveltime & 1)
					{
						obj.swing_speed += intlib_make_fixedpoint(timeradd * 0.487); // why does this work why does this work WHY DOES THIS WOR
						obj.platang_add = (obj.swing_speed div 1) >> 16; // make it an integer and shift back 16 bits
					}
                }
            }
			i++;
	    }
	}
	else
    {
        if (obj.plrcollides != 0) // reset plrcollides
            obj.plrcollides = 0;
    }
	
	ds_list_destroy(plist);
}

function thinker_blue_spinning_platform(obj)
{
    var cVar1;
	var sin_prev, sin_new;
	var oldx, oldy;
	
    if (global.freezeframe) 
    {
        if (((current_time & 3 | obj.playercollidemem) == 0) &&
        (obj.platang_add != 0)) 
        {
            if (obj.platang_add < 0)
                cVar1 = obj.platang_add + 1;
            else
                cVar1 = obj.platang_add - 1;
            obj.platang_add = cVar1;
        }
    }
	
    // chearii: let me tell you a story about a generic, **65536-number long** sine/cosine LUT nintendo used for sine/cosine stuff constantly
    // this port does away with ALL of that and instead uses an approximation with gamemaker sines
	// this both keeps the behavior accurate, and the code (relatively) sane
    sin_prev = floor(sin(intlib_make_u16(obj.orbit_angle) / RADFRACDIV) * 65536);

    update_blueplat_angle(obj);
    
    sin_new = floor(sin(intlib_make_u16(obj.orbit_angle) / RADFRACDIV) * 65536);

    cVar1 = intlib_make_s8(intlib_make_u32((sin_prev >> 8) * 0x5000) >> 0x10) -
            intlib_make_s8(intlib_make_u32((sin_new >> 8) * 0x5000) >> 0x10);

    // confusion
	
	obj.sinediff = obj.sinedata - cVar1;
    
    obj.sinedata = cVar1; // sine data
	
	// momentum to pass to the player
	obj.platmom = ((intlib_make_s16(obj.sinedata) * (16 * 103)) / 100) / 16;
	
	
	//TODO: a bunch of stuff, but this in particular might need a rework
    blue_plat_interact_with_objects(obj);
}

function update_blueplat_angle(obj)
{
    if (!global.freezeframe)
        obj.orbit_angle += (obj.platang_add << 3);
  
    return;
}

function draw_blue_swinging_platform(obj)
{
    var platdist; // short
    var drawy; // short
    var drawx; // short

    var iVar7;
    var iVar10;

    var coord_sine, coord_cosine;

	var camx = camera_get_view_x(view_camera[0]) div 1;
	var camy = camera_get_view_y(view_camera[0]) div 1;

    drawx = intlib_make_s16(intlib_make_s16(obj.x) - camx);
    drawy = intlib_make_s16(intlib_make_s16(obj.y) - camy);

	var onscreen = (is_range_onscreen_horizontal(floor(obj.x - 0x78) - 136, floor(obj.x - 0x78) + 136) || (global.netgame));
	
	if (!onscreen)
		return;
		
	draw_sprite(spr_swingplatchain,1,floor(obj.x - 0x78) + 32 + 8, floor(obj.y)-11);

    iVar10 = 9;
    while (iVar10 >= 0)
    {
        platdist = bluechainplat_distances[iVar10];
		
		
        coord_sine = (sin(intlib_make_u16(obj.orbit_angle) / RADFRACDIV) * 65536) div 1;
        coord_cosine = intlib_make_s16(intlib_make_s32(platdist) * (coord_sine >> 8) >> 8);
        coord_sine = (sin((intlib_make_u16(obj.orbit_angle) - 0x4000) / RADFRACDIV) * 65536) div 1;

        // set the X coordinate
        obj.coord1 = (intlib_make_s16(coord_cosine + drawx + bluechainplat_xdiffs[0]) - 0x78) + 32;
		
        // and then the Y coordinate      
        obj.coord2 = intlib_make_s16((intlib_make_s32(platdist) * (coord_sine >> 8) >> 8)) + bluechainplat_xdiffs[1] + drawy - 0x68;
        
        iVar7 = obj.coord2; // iVar7 = Screen Y
		
		if (iVar10 < 5)
			draw_sprite(spr_swingplatchain,0,obj.coord1 + camx + 8, obj.coord2 + camy + 11 - 3);
		else if (iVar10 == 5)
		{
			obj.plat_x = obj.coord1 + camx;
			obj.plat_y = obj.coord2 + camy;
		}
        iVar10--;
    }
	
	draw_sprite_ext(spr_swingingplatform,0,obj.plat_x+8,obj.plat_y+8,image_xscale,image_yscale,0,image_blend,image_alpha);
}

function blue_plat_interact_with_objects(obj)
{
    var real_siny;
    var sin_x, sin_y;

    sin_x = (sin(intlib_make_u16(obj.orbit_angle) / RADFRACDIV) * 65536) div 1;
    sin_x = (sin_x >> 8) * 5;

    sin_y = (sin((intlib_make_u16(obj.orbit_angle) - 0x4000) / RADFRACDIV) * 65536) div 1;
    sin_x = (sin_x >> 4) + intlib_make_u32(obj.x div 1) - 0x78;

    real_siny = intlib_make_s16((sin_y >> 8) * 5 >> 4) + (obj.y div 1) - 10;
	
	var port = 480 + 31;

    obj.collideactive =
        (((global.freezeframe) ? 1 : 0) |
        (port < ( (((sin_x * 0x10000 >> 0x10) - intlib_make_u32(global.camera_x)) + 0x10) div 1) ));
    
    if (obj.collideactive == 0) // if we're active...
    {
        // ...check for player collision first

		obj.plat_sinydiff = obj.platangmem - real_siny;
        obj.platangmem = real_siny;

        // TODO: collision check
		blue_plat_check_playercol(obj,intlib_make_s16(sin_x),real_siny);
    }
}

function thinker_swinging_platform(obj)
{
	var dir = obj.reverse ? 1 : -1

	if !(obj.continuous) {
		if swing_speed!=0 {
			obj.orbit_angle = -wave_val(obj.start_angle,obj.end_angle,(16 / obj.swing_speed) * dir);
		}
	}
	else {
		//continuous movement, no swinging
		if swing_speed!=0 {
			obj.orbit_angle += (obj.swing_speed/2) * dir;
		}
		obj.orbit_angle = wrap_val(obj.orbit_angle,0,359);
	}

	obj.orbit_length = (obj.chain_length * 16)

	var oldx, oldy
	
	oldx = floor(obj.newx)
	oldy = floor(obj.newy)

	if !(obj.lock_x) {
		obj.newx = (obj.targetx) + (obj.orbit_length * dcos(obj.orbit_angle + obj.offset_angle));
		obj.x = floor(obj.newx)
	} else {
		obj.x = floor(obj.targetx)
	}
	
	if !(obj.lock_y) {
		obj.newy = (obj.targety)- (obj.orbit_length * dsin(obj.orbit_angle + obj.offset_angle));
		obj.y = floor(obj.newy)
	} else {
		obj.y = floor(obj.targety)
	}

	if (obj.x > obj.xprevious)
		dir=1;
	else if (obj.x < obj.xprevious)
		dir=-1;

	if (obj.y > obj.xprevious)
		obj.ydir=1;
	else if (obj.y < obj.xprevious)
		obj.ydir=-1;
}