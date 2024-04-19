/// \file  scr_platforms.gml
/// \brief Platform thinkers.

// brown chain platform
// ported from decompiled SMA2 code

#macro RADFRACDIV 10430.378

globalvar DAT_08106a17;
globalvar DAT_081069be;
DAT_08106a17 = [0x10, 0x20, 0x30, 0x40, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50];
DAT_081069be = [0, 86, 336, 512, 16, 86];

function P_BrownSpinningPlatform(obj)
{
    var cVar1;
	var sin_prev, sin_new;

    if (global.freezeframe) 
    {
        if (((current_time & 3 | obj.playercollidemem) == 0) &&
        (obj.timer != 0)) 
        {
            if (obj.timer < 0)
                cVar1 = obj.timer + 1;
            else
                cVar1 = obj.timer - 1;
            obj.timer = cVar1;
        }
    }
	
    // chearii: let me tell you a story about a generic, **65536-number long** sine/cosine LUT nintendo used for sine/cosine stuff constantly
    // this port does away with ALL of that and instead uses an approximation with gamemaker sines
	// this both keeps the behavior accurate, and the code (relatively) sane
    sin_prev = floor(sin(intlib_make_u16(obj.var2) / RADFRACDIV) * 65536);

    UpdatePlatformAngle(obj);
    
    sin_new = floor(sin(intlib_make_u16(obj.var2) / RADFRACDIV) * 65536);

    cVar1 = intlib_make_s8(intlib_make_u32((sin_prev >> 8) * 0x5000) >> 0x10) -
            intlib_make_s8(intlib_make_u32((sin_new >> 8) * 0x5000) >> 0x10);

    // confusion
	
	obj.sinediff = obj.sinedata - cVar1;
    
    obj.sinedata = cVar1; // sine data
	
	// momentum to pass to the player
	obj.var6 = ((intlib_make_s16(obj.sinedata) * (16 * 103)) / 100) / 16;
	
	
	//TODO: a bunch of stuff, but this in particular might need a rework
    //P_BrownPlatInteractWithObjects(obj);
}

function UpdatePlatformAngle(obj)
{
    if (!global.freezeframe)
        obj.var2 += (obj.timer << 3);
  
    return;
}

function DrawBrownPlatform(obj)
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
	
	var onscreen = inview(obj);
	
	if (!onscreen)
		return;

    iVar10 = 9;
    while (iVar10 >= 0)
    {
        platdist = DAT_08106a17[iVar10];
		
		
        coord_sine = (sin(intlib_make_u16(obj.var2) / RADFRACDIV) * 65536) div 1;
        coord_cosine = intlib_make_s16(intlib_make_s32(platdist) * (coord_sine >> 8) >> 8);
        coord_sine = (sin((intlib_make_u16(obj.var2) - 0x4000) / RADFRACDIV) * 65536) div 1;

        // set the X coordinate
        obj.coord1 = (intlib_make_s16(coord_cosine + drawx + DAT_081069be[0]) - 0x78) + 32;
		
        // and then the Y coordinate      
        obj.coord2 = intlib_make_s16((intlib_make_s32(platdist) * (coord_sine >> 8) >> 8)) + DAT_081069be[1] + drawy - 0x68;
        
        iVar7 = obj.coord2; // iVar7 = Screen Y
		
		if (iVar10 < 5)
			draw_sprite(spr_swingplatchain,0,obj.coord1 + camx, obj.coord2 + camy + 11);
		else if (iVar10 == 5)
		{
			obj.var8 = obj.coord1 + camx;
			obj.var4 = obj.coord2 + camy;
		}
        iVar10--;
    }
	
	if ((obj.platsprite != undefined) && (sprite_exists(obj.platsprite)))
		draw_sprite_ext(obj.platsprite,0,obj.var8-(obj.mwidth div 2)+8,obj.var4,image_xscale,image_yscale,0,image_blend,image_alpha);
}

function P_BrownPlatInteractWithObjects(obj)
{
    var real_siny;
    var sin_x, sin_y;

    sin_x = (sin(intlib_make_u16(obj.var2) / RADFRACDIV) * 65536) div 1;
    sin_x = (sin_x >> 8) * 5;

    sin_y = (sin((intlib_make_u16(obj.var2) - 0x4000) / RADFRACDIV) * 65536) div 1;
    sin_x = (sin_x >> 4) + intlib_make_u32(obj.x div 1) - 0x78;

    real_siny = intlib_make_s16((sin_y >> 8) * 5 >> 4) + (obj.y div 1) - 10;
	
	var port = 480 + 31;

    obj.collideactive =
        (((global.freezeframe) ? 1 : 0) |
        (port < ( (((sin_x * 0x10000 >> 0x10) - intlib_make_u32(global.camera_x)) + 0x10) div 1) ));
    
    if (obj.collideactive == 0) // if we're active...
    {
        // ...check for player collision first

		obj.var5 = obj.mem2 - real_siny;
        obj.mem2 = real_siny;

        // TODO: collision check
    }
}