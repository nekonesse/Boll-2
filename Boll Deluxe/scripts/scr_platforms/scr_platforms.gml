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
    var sVar1; // short/int16
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

    // draw the platform
	// (this was, like everything in SMW--and by extension SMA2--a draw thinker)
	// not anymore though! :sunjob:
    //DrawBrownPlatform(obj);
	
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
    var platsine; // short
    var drawy; // short
    var drawx; // short
	var sVar2;
    var iVar7;
    var iVar10;
	var prevcolor = draw_get_color();
	var peek_y;
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

        //(iVar7 + 0xeb6) = OAM Y?

        // NO MORE TABLES, YIPPEE!!!!
        coord_sine = floor(sin(intlib_make_u16(obj.var2) / RADFRACDIV) * 65536);
        coord_cosine = intlib_make_s16(intlib_make_s32(platdist) * (coord_sine >> 8) >> 8);
        coord_sine = floor(sin((intlib_make_u16(obj.var2) - 0x4000) / RADFRACDIV) * 65536);

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