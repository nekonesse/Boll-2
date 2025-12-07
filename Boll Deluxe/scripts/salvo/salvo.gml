/// \file  salvo.gml
/// \brief ported salvo the slime code from SMA3

// the code's been modified where necessary to not rely too much on arrays
// and to use raw math instead
// otherwise, this is a near-straight port, so subpixeling and other Fun Stuff ahoy

/* TODO:
 * slime polygon stuff at some point
*/

#macro SLIME_MOVE 0
#macro SLIME_DMG_REBOUND 1
#macro SLIME_BOUNCE 2
#macro SLIME_HSPEED 3

#macro MCOL_FLOOR 1
#macro MCOL_CEILI 2
#macro MCOL_VERTI 3

#macro FINEEASE 65536

globalvar Slime_Offsets, SlimePosOffsetTable;

Slime_Offsets = [0xEAC0, 0x0EC0, 0xE0F0, 0x18F0, 0x00B0, 0x0000, 0x0000, 0x007F];

SlimePosOffsetTable = [2,  4,  14, 4,
                       2,  20, 14, 20, 
                       8,  32, 2,  18, 
                       14, 18, 2,  20, 
                       14, 20, 8,  32, 
                       2,  2,  14, 2,
                       2,  10, 14, 10,
                       8,  16, 0,  0 ];

// GBA is 240x160
#macro CAMERA_MAX_HEIGHT 160

// easing functions to replace arrays
function fixedEaseInCirc(a, mul)
{
    var b = min(1, max(0, a / FINEEASE));
    return max(0, min(mul * FINEEASE, (mul div 1) * ((sqrt(1-((b-1)*(b-1))) * FINEEASE) div 1)));
}

function fixedEaseOutCirc(a, mul)
{
    var aa = max(0, FINEEASE - a);
    var b = (aa / FINEEASE);
    return max(0, min(mul * FINEEASE, (mul div 1) * (((sqrt(1-((b-1)*(b-1))) * FINEEASE) div 1))));
}

function fixedMul(a, b)
{
    return (a * b) div FINEEASE;	
}

function fixedEaseInQuad(a, mul)
{
    return fixedMul(a, a) * mul;
}

// DAT_081a7e84 is a quadratic ease-in into 122, over 36 iterations

function get_dat_081a7e84(a)
{
    return fixedEaseInQuad((a * FINEEASE) div 36, 122) div FINEEASE;
}

// replaces a slime "roundness" array with a formula-based replica
// this'll allow for easier modification, if ever needed
function get_slime_width(_x)
{
    if (_x < 0) || (_x > 96)
    {
        return 0;	
    }
    if (_x > 63)
    {
        return min(127, fixedEaseOutCirc(((_x - 63)*FINEEASE) div 33, 128) div FINEEASE);
    }
    else
    {
        return min(127, fixedEaseInCirc((_x*FINEEASE) div 64, 128) div FINEEASE);
    }
}



// EWRAM vars
global.EWR_SprYRelToCamY = 0; // Y relative to the camera, (obj.y - camera_y)

// morph.y2 is used for so many things that I can't bother to think of a better name

function init_slime_data(obj = self)
{
    obj.active = true;
    
    // oooooouuuurrrruurgggghghghghghh
    obj.collision_array = [oCollider, oEnemyGround];
    
    // Morph!!! (crowd cheering sfx)
    obj.morph = new morph_struct(obj);
    
    obj.action_state = 0; // what action we're currently performing

    // eye positions
    obj.eye_x = 0;
    obj.eye_y = 0;

    // collision
    obj.collide_xdiff = 0;
    obj.collide_obj = noone;
    obj.colmem = 0;
    obj.colflags = 0; // generic collision flags
    obj.vertcoltime = 0; // timer set whenever a floor or ceiling is hit
    obj.bounces = 0;

    // damage
    obj.hurtmem = obj.collide_obj;
    obj.dmg_factor = 0; // how much we've been damaged
    obj.hit_severity = 0; // how severe was the hit?
    obj.dmgtics = 0; // time (in frames) used to show damage flashes

    // speeds
    obj.vsp_px = 0;
    obj.hsp_mem = 0;
    obj.vsp_mem = 0;
    obj.movesign = 0; // movement sign

    // accels
    obj.haccel = 0; // horizontal acceleration
    obj.vaccel = 0; // vertocal acceleration

    // general purpose timer
    obj.timer = 0;

    obj.camx2 = 0; // not actually camx2, this is the difference between an object and the player
    obj.camy2 = 0;

    // where are we facing?
    // 0 = right, 2 = left
    obj.facing = 0;

    // 1 = down, 2 = up
    obj.yfacing = 0;

    obj.settings = 0;

    // "delete me!"
    obj.deleteflag = false;

    // unknown data
    obj.field_0x1c = 0;
    
    // Literally Just Relays Stuff To the Morph Struct
    obj.morph_sinoffs = 0;
    obj.morph_bottom = 0;
    obj.morph_scale = 0;
    obj.morph_sinmul = 0;
    obj.morph_yprev = 0;
    obj.morph_yprev2 = 0;
    obj.morph_yoffset = 0;

    // ta ll
    obj.height = 0;

    // no idea what this is!!
    obj.field67_0x62 = 0;

    // scaling difference, used to control wall rebound speeds
    obj.morph_scalediff = 0;

    // slime's rebound
    obj.rebound = 0;
    obj.rebound_px = 0;

    // pixel (integer) based vertical speed
    obj.vsp_px = 0;

    // are we in the intro stte?
    obj.do_intro = 0;

    // slime-exclusive data
    // [SLIME_MOVE, SLIME_DMG_REBOUND, SLIME_BOUNCE, SLIME_HSPEED]
    obj.slime = [ 0, 0, 0, 0 ];

    // boss variant is in its intro state
    obj.intro_state = 0;
    obj.intro_ypos = 0;
    obj.intro_ypos2 = 0;
    obj.intro_yaccel = 2;
    obj.intro_yspd = 0;
    
    // someone ground pounded on us; this speed tracks how fast
    obj.crush_vsp = -1;

    // we're dead, this is how long it's been for
    obj.deadtime = 0;
}

function SlimeSpawn(obj = self)
{

    if (!variable_instance_exists(obj,"morph"))
    {
        // initialize data if the programmers are Stupid
        init_slime_data(obj);
    }
    
    obj.vaccel = 0.01171875;

    obj.bottom_bounding = 1968;

    obj.action_state = 5;

    obj.y += 6;
    obj.ystart2 = obj.y; // redundant? yea, but ystart is already used, so I have to do this

    obj.intro_ypos = int64(obj.y * FRACUNIT) + 8;
    obj.intro_ypos2 = obj.intro_ypos;

    obj.y_rel = make_s16(obj.ystart2 - global.camera_y)
                + 22; // this allows the camera to move freely while slimes spawn

    obj.rebound = 0;
    obj.vsp_px = 0;
    obj.do_intro = 0;
    obj.eyexpos = 0;

    obj.morph_sinmul = 0;
    obj.morph_sinoffs = 0x100;

    obj.slime = [ 0, 0, 0, 0 ];

    obj.morph_scale = 0xb000;
    obj.dmgtics = 0;

    obj.height = 0xe0;
    obj.field67_0x62 = 0;

    obj.vertcoltime = 0;
    obj.intro_state = 1;
    obj.deadtime = 0;
    //obj.action_state |= 0x8000;

    obj.morph.scale = obj.morph_scale;
}

function Slime_HandleBGRender(obj = self)
{
    //show_debug_message("BG render");
    var morph = obj.morph;
    
    // falling from ceiling
    if (obj.action_state == 5)
    {
        // initialize morph spr positions
        morph.vis_y = 0;
        morph.vis_x = 0;

        // this is... using level tick??? what the fuck???
        // NOT USING LEVEL TICK, I'M A FUCKING MORON
        morph.y2 = (obj.intro_ypos2 div FRACUNIT) - camera_y;
    }
    else
    {
        if (obj.action_state == 11)
        {
            return;
        }
        
        // chearii: who the fuck commented vis_x out
        morph.vis_x = 0;
        morph.vis_y = (make_s8((make_u32(obj.rebound_px) >> 8)) 
                        - make_s16((obj.morph_bottom * 5 >> 5))) - 8;

        morph.y2 = 0;
    }

    morph.y_rel = (obj.y_rel div 1);

    morph.x1 = ((obj.x div 1) + 8) - global.camera_x;
    morph.y1 = (obj.y div 1) - global.camera_y;

    morph.bottom = obj.morph_bottom;

    morph.parent = obj; //IWRAM_MorphObjID = (ushort)*(byte *)(DAT_0300702c + 0x156e);
    morph.scale = make_u16((704 - obj.height) * make_u32(obj.morph_scale >> 8) >> 8);

    //IWRAM_MorphUnused = _EWRAM_UnkData_0202b358;

    morph.sinmul = obj.morph_sinmul;
    morph.sinoffs = obj.morph_sinoffs;

    morph.collide_severity = 0;

    FUN_DrawSlime(obj);
    obj.morph_yprev = morph.y_prev;
    if (obj.action_state != 5)
    {
        obj.eyexpos = morph.vis_x;
    }
}

function FUN_RenderSlime(morph,obj)
{
    // hack: prevent that annoying line at the top of the morph by being selective about excess
    if (obj.action_state == 5)
    {
        morph.exceed_y = max(0, (morph.y1 + 1 - (CAMERA_MAX_HEIGHT - 8)));	
    }
    else
    {
        morph.exceed_y = 0;
    }
    
    Slime_SetMorphParams(morph);
    Slime_SetXPos(morph);
    SlimePostRenderInteractions(morph,obj,Slime_Offsets);
}

function FUN_DrawSlime(obj)
{
    FUN_RenderSlime(obj.morph,obj);
}

function Slime_SetMorphParams(morph)
{
    var hmul, height2, height, offset;
    var uHeight;

    var iVar1;
    //var addr_s16;
    
    //addr_s16 = new morph_system();
    
    var exceed_1 = max(0, (morph.y2 + 1 - (CAMERA_MAX_HEIGHT - 8)));
    
    morph.y2 = morph.y2 + 1;
    morph.y_rel = morph.y_rel + 1;
    morph.y_prev = 96;

    height = (96 << FRACBITS);
    offset = (CAMERA_MAX_HEIGHT - 1);

    morph.y3 = morph.y1 + 1;
    
    var exceed_2 = max(0, (morph.y3 - (CAMERA_MAX_HEIGHT - 8)));

    

    // cut the excess here
    // read_short(DAT_HeightTable, morph.bottom);
    // DAT_HeightTable is literally a prerender of (1/x); nintendo, WHY???
    morph.height = max(128, (65536 div max(1, morph.bottom)));
    //show_debug_message($"height: {morph.height}, bottom: {morph.bottom}");

    uHeight = make_u32(morph.height);
    //show_debug_message(uHeight);
    morph.x2 = morph.x1;
    if (make_s32(make_s32(morph.x1) + 96) < ((room_width div 1) + 448))
    {

        morph.offset = 160;
        //var offset_real = morph.offset div 2;
        hmul = (CAMERA_MAX_HEIGHT - 2) - (morph.y3 - exceed_2);

        if (hmul < 0)
        {
            height = make_s32(0x6000 - (uHeight * -hmul));
            //show_debug_message("out of range");
        }
        else
        {
            //show_debug_message("in range");
            if ((CAMERA_MAX_HEIGHT - 2) - hmul < 0)
            {
                hmul = (CAMERA_MAX_HEIGHT - 1);
            }
            
            offset = (CAMERA_MAX_HEIGHT - 1) - (hmul + 1);
            morph = Slime_SetStraightWidth(morph,hmul + 1);
            
            if (offset < 0)
            {
                return;
            }
        }
        hmul = make_s32(morph.scale);
        height2 = ((offset + morph.exceed_y) - (morph.y2 - exceed_1)) + 1;
        
        morph.vis_width = make_s32(128 * hmul + 0x40) >> 9;
        morph.vis_height = 0;
        
        //show_debug_message($"height2: {height2}, offset: {offset}, morph's Y2: {(morph.y2 - exceed_1)}");
        
        do
        {
            morph.vis_height++;
            height = make_s32(height - uHeight);
            
            if (height < 0)
            {
                if (morph.vis_height < 8)
                {
                    morph.vis_height = 8;	
                }
                Slime_SetIncreasingWidth(morph,offset,height2);
                return;
            }

            iVar1 = make_s32(make_u32(get_slime_width(height >> 8)) * hmul + 0x40) >> 9;

            morph.offset--;
            //set_short(morph.data, morph.offset, (make_s16(iVar1) - make_s16(offset)) + 1);
            morph.shader_data[1][max(0, morph.offset)] = make_s16((make_s16(iVar1)
                                                              - make_s16(offset)) + 1);
            offset--;

            if (offset < 0)
            {
                if (morph.vis_height < 8)
                {
                    morph.vis_height = 8;	
                }
                return;
            }
            
            height2--;
        } until (height2 == 0);
        
        if (morph.vis_height < 8)
        {
            morph.vis_height = 8;	
        }

        FUN_08109490(morph,offset,iVar1,exceed_2);
    }
    else {
        morph.x2 = -0x80;
    }
}

function Slime_SetIncreasingWidth(morph,startwidth,height)
{
    var puVar1;
    var uVar2;
    
    uVar2 = make_u32(~startwidth);
    puVar1 = (morph.offset * 2) + height * -2;
    
    //show_debug_message("[SetIncreasingWidth] loop");
    do
    {
        uVar2++;
        morph.offset--;
        //set_short(morph.data, morph.offset, uVar2);
        morph.shader_data[1][max(0, morph.offset)] = make_s16(uVar2);
        //show_debug_message($"[SetIncreasingWidth] set {make_s16(uVar2)} at {morph.offset}");
    } until (puVar1 >= (morph.offset * 2));
    //show_debug_message("[SetIncreasingWidth] end loop");
    FUN_08109490(morph,startwidth - height,0);
}

function Slime_SetStraightWidth(morph, offs, width = 97)
{
    var min_offset;
    var sVar2;

    sVar2 = make_s16(0xFF00 | width); // 0xFF61
    min_offset = make_s16((morph.offset * 2) + offs * -2);
    
    //show_debug_message("[SetStraightWidth] loop");
    do
    {
        morph.offset--;
        //set_short(morph.data, morph.offset, sVar2);
        morph.shader_data[1][max(0, morph.offset)] = make_s16(sVar2);
        //show_debug_message($"set data at {morph.offset}");
        sVar2++;
    } until (min_offset >= (morph.offset * 2));
    //show_debug_message("[SetStraightWidth] end loop");
    return morph;
}


function FUN_08109490(addr_s16,max_height,width,exceed = 0)
{
    var pbVar1;
    var ypos;
    var iVar3, iVar5;
    var uVar4;
    var pbVar6;
    
    var offset_real = addr_s16.offset div 2;
    
    ypos = make_u32(make_s32(addr_s16.y2) - (make_s32(addr_s16.y_rel)));
    //show_debug_message($"{make_s32(addr_s16.y2)} - {make_s32(addr_s16.y_rel)} = {make_s32(ypos)}");
    
    uVar4 = make_u32(ypos);
    if (make_s32(ypos) < 0) {
        uVar4 = make_u32(-ypos);
    }
    if (0x22 < uVar4) {
        uVar4 = 0x22;
    }
    if (max_height <= uVar4) {
        uVar4 = max_height;
    }
    //show_debug_message($"FUN_08109490: uVar4: {uVar4}");
    iVar5 = uVar4 + 1;
    pbVar6 = 1 + uVar4;
    width = width - make_u32(get_dat_081a7e84(pbVar6));
    if (make_s32(ypos < 0)) {
        iVar5 = 0x23 - iVar5;
        if (iVar5 == 0) {
            iVar5 = 1;
        }
        else {
            pbVar6 = 2 + uVar4;
        }
    }
    else {
        pbVar1 = uVar4; // &DAT_081a7e84 + uVar4
        //show_debug_message($"FUN_08109490: loop, iVar5: {iVar5}");
        //addr_s16.offset = iVar5 * 2;
        do
        {
            pbVar6 = pbVar1;
            uVar4 = max_height;
            iVar3 = make_u32(get_dat_081a7e84(pbVar6)) + width;

            if (iVar3 < 0)
            {
                iVar3 = -1;
            }

            addr_s16.offset--;
            //set_short(addr_s16.data, addr_s16.offset, (make_s16(iVar3) - make_s16(uVar4)) + 1);
            addr_s16.shader_data[1][max(0, addr_s16.offset)] = make_s16((make_s16(iVar3)
                                                                - make_s16(uVar4)) + 1);

            max_height = uVar4 - 1;
            if (make_s32(max_height) < 0)
            {
                //show_debug_message("FUN_08109490: end loop, return");
                return;
            }
            iVar5 -= 1;
            pbVar1 = pbVar6 - 1;
        } until (make_s32(iVar5) == 0)
        //show_debug_message("FUN_08109490: end loop");

        if (max_height < 0x24)
        {
            FUN_08109450(addr_s16,get_dat_081a7e84,pbVar6,max_height,width,uVar4);
            return;
        }
        iVar5 = 0x24;
    }
    FUN_08109450(addr_s16,get_dat_081a7e84,pbVar6,max_height,width,iVar5);
}

function FUN_08109450(addr_s16, calcFunc, offset, morphtbl_offs, width, cycles)
{
    var width_array;
    var min_offset;
    var morphdata, morph_offs;
    
    var offset_real = addr_s16.offset div 2;
    
    while(true)
    {
        morph_offs = morphtbl_offs;
        width_array = make_u8(calcFunc(offset));
        offset++;
        morphdata = width_array + width;
        if (morphdata < 0)
        {
            morphdata = -1;
        }
        morphdata = (morphdata - morph_offs) + 1;

        addr_s16.offset--;
        //set_short(addr_s16.data, addr_s16.offset, morphdata);
        addr_s16.shader_data[1][max(0, addr_s16.offset)] = make_s16(morphdata);

        if ((morph_offs - 1) < 0)
        {
            break;
        }

        cycles--;
        morphtbl_offs = morph_offs - 1;

        if (cycles == 0)
        {
            min_offset = (addr_s16.offset * 2) + morph_offs * -2;
            while (min_offset < (addr_s16.offset * 2))
            {
                addr_s16.offset--;
                morphdata += 1;
                //set_short(addr_s16.data, addr_s16.offset, morphdata);
                addr_s16.shader_data[1][max(0, addr_s16.offset)] = make_s16(morphdata);
            }
            return;
        }
    }
}

function Slime_SetMorphX(morph,
                     angleVel,
                     _y,
                     limit,
                     sineScale,
                     _x,
                     angle)
{
    var offset, offset_real;

    if (-1 < _y)
    {
        offset = (_y * 2);
        offset_real = (_y);
        do
        {
            if (_y < CAMERA_MAX_HEIGHT)
            {
                /*set_short(
                    morph.data,
                    offset,
                    );*/
                morph.shader_data[0][max(0, offset_real)] = make_s16(
                                                            make_s16(
                                                            make_s32(sineScale *
                                                            make_s16(floor(sin((angle & 0xffff)
                                                                    / RADFRACDIV) * 256))) >>
                                                                0x10) +
                                                                _x) / 256;
            }

            angle = (angle & 0xffff) + angleVel;
            offset -= 2;
            offset_real--;

            _y--;
            limit--;
        } until ((limit == 0) || (-1 >= _y));
        //show_debug_message("Slime_SetMorphX: end loop");
        ;
    }
}


function SetMorphPositions(morph, yoff, xoff)
{
    var morphY;
    var yPos;
    
    morphY =
        make_s32(make_s16(make_u16(make_u32(morph.vis_y << 0x10) >> 8)) | make_u8(make_u32(morph.vis_y) >> 8))
        * ldrsh(morph.bottom) + 0x8000;
    morph.vis_y = make_s16(morphY >> 0x10);
    
    yPos = (morphY >> 0x10) + yoff;

    if (yPos < CAMERA_MAX_HEIGHT)
    {
        xoff = xoff - int64(morph.shader_data[0][max(0, yPos)] * 256);
    }
    else
    {
        xoff = 0;
    }

    morph.vis_x = xoff + make_s16((morph.scale * make_s16(make_u16((morph.vis_x << 0x10) >> 8) |
                                                          make_u8(morph.vis_x >> 8)) +
                                   0x8000) >>
                                  0x10);
}

function Slime_SetXPos(morph)
{
    var xPos;
    var yPos;

    yPos = make_s32(morph.y1);
    morph.exceed_x = max(0, morph.x2 + ((morph.vis_width div 2) + 64) - 256);
    xPos = make_s32(morph.x2 - 8 - morph.exceed_x);
    
    var exceed = max(0, (yPos + 1 - (CAMERA_MAX_HEIGHT - 8)));

    Slime_SetMorphX(morph,
                    morph.height * morph.sinoffs >> 8,
                    yPos + 1 - exceed,
                    morph.bottom * morph.prevy * 0x100 >> 0x10,
                    morph.scale * morph.sinmul,
                    128 - xPos, 0);

    SetMorphPositions(morph, yPos + 1 - exceed, 0x80 - xPos);
}

//
// POST-RENDER COLLISION
// lol! lol! (No This Will Not Be In The Draw Event)
//

function SlimePostRenderInteractions(morph,obj,tbl)
{
    MorphHandleObjectCollisions(morph,obj);
}

function CheckMorphCollision(obj, morph, xpos = 0, yoff = 0)
{
    // TODO: rename these, there are all dummy names from ghidra's decompiler
    var sVar1, uVar2, uVar5, uVar6, iVar4;

    var x_pos, y_fac, ycam, exceed; 

    var offset, targ_offset, morph_offset;

    uVar6 = 0;
    offset = 0;
    
    morph.hitme = noone;

    if (morph.collide_severity != 0)
    {
        // there's Some form of collision severity, offset by 10 cycles
        offset = 6;
    }

    sVar1 = floor((obj.y - obj.hit_sizey) - global.camera_y);
    exceed = max(0, sVar1 - (CAMERA_MAX_HEIGHT + 8));
    
    var index = 0;
    
    var under, over;
    var xhit, lefthit, righthit;
    under = 0;
    over = 0;

    while (true)
    {
        ycam = make_s32(sVar1);
        uVar5 = 0;
        // loop for 5 cycles
        targ_offset = offset + 6;
        index = 0;
        array_resize(morph.debug_col,1);
        morph.debug_col[0] = [ 0, 0, 0 ];
        do
        {
            // multiply by 2 (presumably prevents erroneous collides)
            uVar5 *= 2;

            // 0x030069fc = dataptr[cycle] + yoshi's relative X
            morph.rel_offset[0] = SlimePosOffsetTable[offset] + (obj.x - global.camera_x);
            // uVar2 = dataptr[cycle + 1] + yoshi's relative Y
            uVar2 = make_u32(SlimePosOffsetTable[offset + 1] + ycam);

            if (uVar2 < ((CAMERA_MAX_HEIGHT + 8) + yoff))
            && (uVar2 >= (yoff))
            {
                // relY = uVar2 = (yoshiRelY + data[cycle + 1])

                var read_pos = (max(0, uVar2 - yoff) );
                morph.x_width = morph.shader_data[1][read_pos] + make_s16(uVar2 - yoff) & 0xff;
                x_pos = abs((0x80 - int64(morph.shader_data[0][read_pos] * 256))
                        - make_s32(morph.rel_offset[0]));

                uVar6 = uVar2;
                
                if (morph.x_width >= 255)
                {
                    morph.x_width = 0;
                }
                
                // resize the debug array if it Exists and is too small
                // debug stuff
                if (variable_instance_exists(morph, "debug_col"))
                {
                    if (array_length(morph.debug_col) < (index + 1))
                    {
            
                        array_resize(morph.debug_col, index + 1);
                    }

                    // log this!!!
                    morph.debug_col[index] = [ xpos - (morph.x_width div 2),
                                               (read_pos) + yoff,
                                               xpos + (morph.x_width div 2) ];
                }

                // check if there's a collision at this line
                // enmded up rewriting this because the old system was too jank
                // it's 2024, not 2003. I don't need to imitate archaic systems!
                
                xhit = ((obj.x >= (xpos - (morph.x_width div 2)))
                        && (obj.x <= (xpos + (morph.x_width div 2))));
                
                lefthit = (((obj.x - obj.hit_sizex) >= (xpos - (morph.x_width div 2)))
                            && ((obj.x - obj.hit_sizex) <= (xpos + (morph.x_width div 2))));
                            
                righthit = (((obj.x + obj.hit_sizex) >= (xpos - (morph.x_width div 2)))
                            && ((obj.x + obj.hit_sizex) <= (xpos + (morph.x_width div 2))));
                
                if (xhit || lefthit || righthit)
                && (morph.x_width > 2)
                {
                    uVar5 = uVar5 + 1;
                    
                    morph.col_width = morph.x_width div 2;
                    morph.col_height = (read_pos);
                }
            }
            offset += 2;
            index++;
        } until (offset >= targ_offset);

        // check if we're colliding
        if ((uVar5 & 1) != 0)
        {
            y_fac = 0;

            // get the offset Y position, minus 1
            uVar6--;
            if (-1 < make_s32(uVar6))
            {
                morph_offset = (max(0, uVar6 - yoff)); //(short*)(uVar6 * 4 + addr);
                while (true)
                {
                    // get the x width
                    morph.x_width = morph.shader_data[1][morph_offset] + make_s16(uVar6 - yoff) & 0xff;

                    // get the x diff (morphline_x - playerXOffset)
                    ycam = (0x80 - int64(morph.shader_data[0][morph_offset] * 256))
                            - make_s32(morph.rel_offset[0]);

                    // iVar4 = abs(xdiff)
                    iVar4 = abs(ycam);

                    y_fac--;

                    // if we're out of range, jump ship
                    if (make_u32(morph.x_width) <= make_u32(iVar4 << 1))
                    {
                        break;
                    }

                    morph_offset = (max(0, morph_offset - 1));  // address is subtracted by 4! remember this!
                    uVar6--;

                    // only allow 10 units of collision
                    if ((make_s32(uVar6) < 0) || (y_fac < -10))
                    {
                        break;
                    }
                }
            }

            // set the collision data
            morph.colfactor_y = make_s16(y_fac);

            // if yoshi isn't offscreen, check the severity of the collision
            if (uVar6 + 2 < CAMERA_MAX_HEIGHT)
            {
                // line comparison: compare collision morph width against the saved width
                uVar2 = (make_s32(morph.shader_data[1][((uVar6 + 2))]) + uVar6 & 0xff) -
                        make_s16(morph.x_width);
            }
            else
            {
                // offscreen == no severity
                uVar2 = 0;
            }

            uVar2 = uVar2 >> 1;
            if (3 < uVar2)
            {
                // if (uVar2 / 2) is more than 3, set a max severity of 4
                uVar2 = 4;
            }

            // negative xdiff? add to the severity
            if (ycam < 0)
            {
                uVar2 = uVar2 + 5;
            }

            morph.collide_severity = make_s16(uVar2 << 1);  // severity can be 8
        }

        // jump ship if our cycles go past 20
        if (20 < offset)
        {
            morph.colfactor_x = uVar5;
            return;
        }
        
        morph.fin_collide_severity = morph.collide_severity;
        
        if (morph.fin_collide_severity)
        {
            morph.hitme = obj;
        }

        if (morph.unk_6f46 != 0)
        {
            morph.colfactor2 = uVar5;
            morph.colfactor_y = 0;
            return;
        }

        sVar1 = floor((obj.y - obj.hit_sizey) - global.camera_y);
        exceed = max(0, sVar1 - (CAMERA_MAX_HEIGHT - 8));

        // if we get no collision, run the loop a second time
        offset = 20;
        morph.colfactor2 = uVar5;
    };
}

function MorphHandleObjectCollisions(morph, obj)
{
    var proj_x_diff, proj_y_rel;

    // check morph collision first

    // get the closest player, and check them first

    var collide_p = instance_nearest(obj.x, obj.y, oPlayer);
    
    var exceed = max(0, (obj.y - global.camera_y) - (CAMERA_MAX_HEIGHT - 8));

    if (collide_p)
    {
        
        //show_debug_message("player close");
        morph.col_height = -1;
        CheckMorphCollision(collide_p, morph, obj.x, exceed);
        
        if (morph.col_height > -1)
        {
            var hit_height = min(CAMERA_MAX_HEIGHT - 8, morph.col_height + collide_p.hit_sizey);
            var real_height = max(0, obj.y - (hit_height + exceed + global.camera_y));
            
            var heightpct = max(0, min(100, ((real_height) / (morph.vis_height)) * 100)) div 1;
            
            if (heightpct >= 60)
            && (collide_p.damagespecial > 0)
            {
                if (obj.colflags & COL_FLOOR)
                {
                    // we're being crushed
                    obj.action_state = 9;
                    obj.crush_vsp = int64(collide_p.damagespecial);
                }
                else if (obj.action_state != 6)
                {
                    // slam us to the ground
                    obj.vsp = collide_p.damagespecial + 0.1125;
                    obj.action_state = 0;
                }
            }
        }
    }

    // projectile collisions are handled in the step events
}

function SetProjectileCollisionData(obj, hit, xdiff)
{
    obj.collide_xdiff = -xdiff;
    obj.collide_obj = hit;
}

function DoSlimeRebound(obj = self, vsp)
{
    // THIS IS SO ASSSSSSSS
    vsp = asr(make_s32(make_u32(vsp << 16)), 16);
    
    obj.rebound = make_s16(make_u16(make_u32(vsp * -176) >> FRACBITS));
    obj.rebound_px = obj.rebound;
    obj.vsp_px = -(obj.rebound);
}

function OBJ_SlimeBouncing(obj  = self)
{
    var objVsp, scaleMem, rebound2, nextAction; /* u16 */
    var objScale;                               /* s16 */
    var checkVsp, maxVsp;                       /* u32 */

    if (obj.action_state == 2)
    {
        objScale = 0xa00;
    }
    else if (obj.action_state == 4)
    {
        objScale = 0x4000;
    }
    else
    {
        objScale = -0x3000;

        if (make_u16(obj.slime[SLIME_BOUNCE]) != 0)
        {
            objScale = -0x3400;
        }

        // this is way messier and harder to read, but more accurate overall;
        // this is EXACTLY how the ASM does it:
        // the code gets the morph scale, converts it to signed 16-bit by shifting up and back down
        // 16 bits
        // THEN, we add 32 fracunits to the object's morph scale * the current scale value
        // this final value is then converted to a 16 bit integer
        if (true)
        {
            var reg1, oScale2;
            reg1 = (asr(make_u32((make_u16(obj.morph_scale) >> FRACBITS) - FRACUNIT) << 16, 16));
            oScale2 = asr((roundtrip_ashift(objScale, 16) * reg1), FRACBITS) + 0x2000;
            oScale2 = (roundtrip_shift(oScale2, 16));
            objScale = make_s16(roundtrip_ashift(oScale2, 16));
        }
    }

    if (make_s16(obj.vsp_mem) < 0)
    {
        maxVsp = ldrsh(obj.vsp_mem) * -1;
    }
    else
    {
        maxVsp = make_u16(obj.vsp_mem);
    }
    
    // get used to ASR spam, it's a tell I ended up writing code based on the ASM LMAO
    scaleMem = make_s32(asr(make_s32(make_u32(objScale << 16)), 16));
    
    scaleMem += abs(obj.vsp_mem);

    scaleMem = make_s32(make_u32(scaleMem * 2));
    
    // get the units of (scale * 2)
    scaleMem = (scaleMem >> FRACBITS);
    
    // only 8-bit because Reasons!!!
    scaleMem &= 0xFF;
    
    var diff = make_s32(ldrsh(obj.rebound_px) - ldrsh(obj.vsp_mem));
    
    if (diff >= 0)
    {
        // this is an obnoxiously common procedure, and one of the main reasons why
        // moving this from subpixeling/fracunits will be a major pain:
        // the code is using unsigned 16-bit integer checks of subpixel values
        // to check if the rebounds match
        if (make_u16(obj.rebound_px) != make_u16(obj.rebound))
        {
            if (obj.action_state == 2)
            {
                obj.slime[SLIME_MOVE]++;
                if (obj.slime[SLIME_MOVE] == 4)
                {
                    obj.haccel = 0;
                    obj.action_state--;
                    return;
                }
            }
            else
            {
                // more ASM snippets
                // ghidra overcomplicated this to hell
                var new_vsp, r1, new_vsp_temp;

                new_vsp = make_u16(obj.vsp_px);

                new_vsp_temp = make_u32(new_vsp << 16);

                if (new_vsp_temp != 0)
                {
                    // divide temp vsp by 2
                    new_vsp_temp = make_s32(asr(new_vsp_temp, 17));
                    
                    // this is actual nonsense that I can't bother to describe
                    r1 = new_vsp - (128 * FRACUNIT);
                    
                    // do an OR operation for reasons I can't entirely decipher
                    new_vsp_temp |= r1;
                    
                    // roundtrip; make this an unsigned 16 bit integer
                    new_vsp_temp = make_s32(make_u32(new_vsp_temp << 16));
                    new_vsp = make_s32(make_u32(new_vsp_temp) >> 16);

                    if (make_u16(new_vsp) < 0xFFDF)
                    {
                        // under the maximum, set the new value
                        obj.vsp_px = make_s16(new_vsp);
                    }
                    else
                    {
                        // over the max, reset vsp_ox
                        obj.vsp_px = 0;
                        //show_debug_message("alright dirty dan, your time is up!!!!");
                    }
                }
            }
            obj.rebound_px = make_s16(obj.rebound);
        }
        objScale = make_u16(obj.vsp_mem) + scaleMem;
        // /*AVOID GOTOS*/ goto LAB_080be890;
        obj.vsp_mem = make_s16(objScale);

        var nextAction = 1;
        if ((make_u16(obj.vsp_px) | make_u16(obj.rebound)) == 0)
        {
            if (obj.action_state == 6)
            {
                DoSlimeRebound(obj, 0xfe00);
                obj.timer = 32;
                nextAction = obj.action_state + 1;
            }
            else if (obj.action_state == 7)
            {
                obj.timer = 64;
                nextAction = obj.action_state + 1;
            }
            else
            {
                nextAction = 1;
            }	
            obj.action_state = nextAction;
        }
        return;
    }
    rebound2 = make_u16(obj.rebound_px);
    
    if (rebound2 == make_u16(obj.rebound))
    {
        if ((obj.action_state == 2) || (rebound2 == 0))
        {
            maxVsp = 0x600;
        }
        else
        {
            if (rebound2 < 0x40)
            {
                obj.rebound = 0;
            }
            else
            {
                obj.rebound = make_s16(obj.rebound div 2);
            }
            maxVsp = 0x1d0;
        }
        objVsp = make_u16(obj.vsp_mem);
        checkVsp = ldrsh(obj.vsp_mem);
        if (checkVsp >= 0)
        {
            if (make_u16(obj.colmem) == 0)
            {
                if (obj.action_state != 7)
                {
                    if ((obj.intro_state != 0) && (obj.intro_state == 1))
                    {
                        obj.intro_state = 2;
                        checkVsp = (make_u32(checkVsp << 17) >> 16);
                    }

                    if (maxVsp <= checkVsp)
                    {
                        objVsp = asr((checkVsp * -(1 << 16) >> 16) << 16, 16);

                        obj.vsp = make_s32(objVsp) / FRACUNIT;
                        
                        //show_debug_message(obj.vsp);

                        VinylPlay(snd_slimebounce,false);

                        obj.hsp = ldrsh(obj.slime[SLIME_HSPEED]) / FRACUNIT;
                        obj.vertcoltime = 0;
                        obj.vaccel = 0.0625;

                        if (obj.intro_state == 0)
                        {
                            return;
                        }
                        //show_debug_message("Find my pages.");
                        obj.hsp = 0.75;
                    }
                }
            }
            else
            {
                obj.vsp = make_s32(asr(objVsp << 16, 16)) / FRACUNIT;
                
                //show_debug_message(obj.vsp);

                VinylPlay(snd_slimebounce,false);

                obj.hsp = ldrsh(obj.slime[SLIME_HSPEED]) / FRACUNIT;
                obj.vertcoltime = 0;
                obj.vaccel = 0.0625;

                if (obj.intro_state == 0)
                {
                    return;
                }
                //show_debug_message("five night frederick");
                obj.hsp = 0.75;
            }
        }
        obj.rebound_px = make_s16(obj.vsp_px);
    }
    objScale = make_u16(obj.vsp_mem) - scaleMem;

    obj.vsp_mem = make_s16(objScale);

    var nextAction = 1;
    if ((make_u16(obj.vsp_px) | make_u16(obj.rebound)) == 0)
    {
        if (obj.action_state == 6)
        {
            DoSlimeRebound(obj, 0xfe00);
            obj.timer = 32;
            nextAction = obj.action_state + 1;
        }
        else if (obj.action_state == 7)
        {
            obj.timer = 64;
            nextAction = obj.action_state + 1;
        }
        else
        {
            nextAction = 1;
        }

        obj.action_state = nextAction;
    }
}

function OBJ_SlimeMain(obj = self)
{
    var colOverride, colflags;
    var vsp_unsigned;
    var oVsp;
    
    colOverride = -1;

    if (obj.vertcoltime == 0)
    {
        colflags = obj.colflags;
        if ((colflags & COL_VERTI) != 0)
        {
            colOverride = colflags & COL_CEILI;
            obj.colmem = make_u16(colOverride);
        }
        else
        {
            obj.colmem = make_u16(colflags & COL_VERTI);
            vsp_unsigned = make_u32(int64(obj.vsp * FRACUNIT));
            obj.do_intro = colflags & COL_VERTI;
            obj.vsp_mem = make_s16(vsp_unsigned);
            if (-1 < make_s32(vsp_unsigned * 0x10000))
            {
                vsp_unsigned = make_u32(make_u16(obj.vsp_mem));
                if (obj.settings == 1)
                {
                    // make salvo slightly taller
                    oVsp = make_s16(vsp_unsigned >> 3) + int64(0.625 * FRACUNIT);
                }
                else
                {
                    oVsp = make_s16(vsp_unsigned >> 3) + int64(0.5 * FRACUNIT);
                }

                obj.height = oVsp;
                return;
            }
        }
    }
    else
    {
        colOverride = COL_CEILI;
    }

    // LAB_080be5a6
    if (colOverride != -1)
    {
        obj.colmem = make_u16(colOverride);
    }

    if (obj.do_intro == 0)
    {
        // start slime cutscene
        obj.do_intro = 1;

        // archive our speed
        if (obj.hsp != 0)
        {
            obj.slime[SLIME_HSPEED] = make_s16(int64(obj.hsp * FRACUNIT));
        }
        
        // bandaid fix, only reset hspeed if colflags match
        if (((obj.vsp >= 0) && (obj.colflags & COL_FLOOR))
            || ((obj.vsp < 0) && (obj.colflags & COL_CEILI)))
        {
            obj.hsp = 0;
        }
        
        oVsp = make_s16(obj.vsp_mem);
        if (-1 < make_s16(obj.vsp_mem))
        {
            oVsp = -oVsp;
        }

        obj.vsp_mem = make_u16(oVsp);
        
        DoSlimeRebound(obj, ldrsh(obj.vsp_mem));
    }

    OBJ_SlimeBouncing(obj);
    vsp_unsigned = make_u32(make_u16(obj.vsp_mem));
    if (-1 < make_s16(obj.vsp_mem))
    {
        vsp_unsigned = make_u32(make_u16(obj.vsp_mem));
    }
    else
    {
        vsp_unsigned = -vsp_unsigned & 0xffff;
    }

    if (obj.settings == 1)
    {
        // make salvo slightly taller
        oVsp = make_s16(vsp_unsigned >> 3) + 0xa0;
    }
    else
    {
        oVsp = make_s16(vsp_unsigned >> 3) + 0x80;
    }
    
    obj.height = oVsp;
}


// case 1: generic behavior
function SlimeGeneric(obj)
{
    var sin_mul, sin_mul_add;
    
    if (obj.depth == 610)
    {
        obj.depth = obj.real_depth + 1;
        //obj.eyes.depth = obj.depth - 1;
    }

    OBJ_SlimeMain(obj);
    sin_mul = make_u32(make_u16(obj.morph_sinmul) << 16);

    if (sin_mul != 0)
    {
        if (sin_mul == 0 || (make_s32(sin_mul) < 0))
        {
            sin_mul_add = 1;
        }
        else
        {
            sin_mul_add = -1;
        }
        obj.morph_sinmul = make_s16(obj.morph_sinmul + sin_mul_add);
    }
}

// case 2: movement on ground
function Slime_MoveOnGround(obj)
{
    var nextAction, bounceMem;

    if (obj.intro_state != 0)
    {
        return;
    }

    bounceMem = make_u32(obj.slime[SLIME_BOUNCE]);
    
    if (bounceMem == 0)
    {
        obj.hsp2 = 192 * ((obj.facing) ? 1 : -1);

        if (((obj.colflags & COL_HORIZ) != 0) &&
            (make_s32(((make_u32(obj.colflags & COL_HORIZ) - 6) ^ make_u16(obj.camx2)) << 16) >= 0))
        {
            obj.hsp2 = -obj.hsp2;
        }

        if (obj.slime[SLIME_DMG_REBOUND] != 0)
        {
            obj.slime[SLIME_DMG_REBOUND] = 0;
            obj.hsp2 = -obj.hsp2;
        }
    }
    else
    {
        if (obj.morph_scale < 0x4c00)
        {
            return;
        }

        if ((obj.slime[SLIME_BOUNCE] & 1) == 0)
        {
            obj.haccel = bounceMem & 1;
            obj.hsp = (bounceMem & 1) / FRACUNIT;

            obj.slime[SLIME_MOVE] = 2;
            
            // sonic SFX for a mario enemy? blasphemous!
            VinylPlay(snd_hydrocityturbine,false,0.5);
            
            obj.action_state = 3;
            return;
        }

        obj.hsp2 = make_s16((bounceMem & 2) ? -1 : 1);
    }

    obj.morph_scalediff = 0x200 - (obj.morph_scale >> 8);
    obj.hsp_mem = make_s32(asr(make_s32(make_u32(ldrsh(obj.hsp2) * ldrsh(obj.morph_scalediff))),
                               8));

    if (obj.slime[SLIME_BOUNCE] == 0)
    {
        if ((make_u16(obj.camx2 + 128) < 0x100) && ((irandom(65535) & 3) != 0))
        {
            obj.slime[SLIME_MOVE] = obj.slime[SLIME_BOUNCE];
            obj.morph_sinmul = make_s16(obj.slime[SLIME_BOUNCE]);

            obj.haccel = 0.0625;

            obj.rebound_px = 0x100;
            obj.rebound = 0x100;

            obj.action_state = 2;
            return;
        }
        nextAction = 0;
    }
    else
    {
        obj.slime[SLIME_BOUNCE] = 0;
        nextAction = 4;
    }

    obj.action_state = nextAction;

    obj.rebound_px = 0x400;
    obj.rebound = 0x400;

    obj.vsp_px = 0xfce0;

    obj.slime[SLIME_HSPEED] = make_s16(obj.hsp_mem);
    obj.haccel = 0;
}

function nearest_object_difference(obj = self)
{
    var ydiff_pixels, xdiff_pixels;
    var result = -1;

    var nearest_inst = instance_nearest(x, y, oProjectile);
    
    if (!nearest_inst)
    {
        return [ 0, noone ];	
    }
    xdiff_pixels = abs(nearest_inst.x - obj.x);
    ydiff_pixels = abs(nearest_inst.y - obj.y);

    result = ydiff_pixels + xdiff_pixels;

    return [ result, nearest_inst ];
}

// case 3: chasing
function SlimeChase(obj)
{
    var hspMem;
    var pxdiff, xdiff;

    var nearestObj;
    var mask_xdiff;

    if (make_u16(obj.rebound) != make_u16(obj.rebound_px))
    {
        if (obj.hsp_mem < 0)
        {
            obj.morph_sinmul--;
        }
        else
        {
            obj.morph_sinmul++;
        }
    }
    else
    {
        if (obj.hsp_mem < 0)
        {
            obj.morph_sinmul++;
        }
        else
        {
            obj.morph_sinmul--;
        }
    }

    SlimeJiggle(obj);

    if (0x4bff < obj.morph_scale)
    {
        nearest_data = nearest_object_difference(obj);

        if (nearest_data[1])
        {
            nearestObj = nearest_data[1];
            
            if (nearestObj)
            {
                xdiff = make_u32(make_u16(nearestObj.x) - make_u16(obj.x));
                //show_debug_message(xdiff);
                mask_xdiff = xdiff & 0xffff;

                if ((xdiff * 0x10000 + 0x800000 >> 0x10 < 0x100) &&
                    (make_s32((nearestObj.hsp ^ mask_xdiff) * 0x10000) < 0))
                {
                    obj.slime[SLIME_BOUNCE] = 1;
                    obj.action_state = 1;

                    if (xdiff >= 0)
                    {
                        obj.slime[SLIME_BOUNCE] = 3;
                        return;
                    }
                }
            }
        }
        else
        {
            //obj.action_state = 1;
        }
    }

    if ((obj.colflags & 0xc) != 0)
    {
        obj.slime[SLIME_MOVE] = 3;
    }
}

function SlimeJiggle(obj)
{
    var vspMem;

    OBJ_SlimeBouncing(obj);
    
    vspMem = make_u16(abs(obj.vsp_mem));
    
    obj.height = make_s16(vspMem >> 3) + 0xa0;
}

// case 4: defense
function SlimeDefend(obj)
{
    var sinoffs_target, newmove;

    newmove = make_u16(obj.slime[SLIME_MOVE]);
    if (obj.slime[SLIME_MOVE] == 0)
    {
        if (make_s16(obj.morph_sinmul) < 0)
        {
            obj.action_state = 1;
            obj.morph_sinmul = make_s16(newmove);
            obj.slime[SLIME_BOUNCE] = newmove;
        }
        else
        {
            obj.morph_sinmul--;
        }
    }
    else
    {
        if ((obj.slime[SLIME_MOVE] & 1) == 0)
        {
            obj.morph_sinoffs = obj.morph_sinoffs + 64;
            sinoffs_target = 2048;
        }
        else
        {
            obj.morph_sinoffs = obj.morph_sinoffs - 64;
            sinoffs_target = 256;
        }
        if (obj.morph_sinoffs == sinoffs_target)
        {
            obj.slime[SLIME_MOVE]--;
            //show_debug_message("pea. tear. griffin!!");
        }
        if (obj.morph_sinmul < 8)
        {
            obj.morph_sinmul++;
        }
    }
}

// case 5: setup boss variant (in our case, the standard variant)
// handled during salvo's boss introduction
// sets the relevant timers to handle stuff like his growing animation
function BOSS_Salvo(obj)
{
    var eyesYDiff;

    eyesYDiff = (obj.y - (obj.intro_ypos div FRACUNIT));
    
    // behind all main tiles
    obj.depth = 610;
    
    if (obj.grounded)
    {
        // immediately move on
        obj.vaccel = 0.046875;
        obj.field_0x1c = (FRACUNIT * 4);
        obj.action_state++;
        obj.timer = 32;
        obj.eyes_visible = true;
        obj.colactive = true;
    }
    else if (106 < eyesYDiff)
    {
        if (eyesYDiff < 111)
        {
            obj.vaccel = 0.09375;
            obj.field_0x1c = (FRACUNIT div 2);
        }
        else
        {
            obj.vaccel = 0.046875;
            obj.field_0x1c = (FRACUNIT * 4);
            obj.action_state++;
            obj.timer = 32;
            obj.eyes_visible = true;
            obj.colactive = true;
        }
    }
    OBJ_SlimeMain(obj);
}

// case 6: growing
function SlimeIntro_Grow(obj)
{
    
    var grow_rate = (2.25 * FRACUNIT) div 1;
    
    if (obj.timer == 0)
    {
        if (spawn_huge)
        {
            // only grow if we have to
            if (make_s32((obj.morph_scale + grow_rate) * 65536) < 0)
            {
                obj.morph_scale = make_u16(obj.morph_scale + grow_rate);
            }
            else
            {
                obj.morph_scale = 0xffff;
            }
        }
        else
        {
            obj.action_state++;
        }
        
        OBJ_SlimeMain(obj);
    }
}

// case 7: end the intro and start bouncing around
function SlimeStartBossBattle(obj = self)
{
    var curTimer;

    curTimer = obj.timer;
    if (curTimer == 0)
    {
        obj.intro_state = 0;
        obj.action_state = 1;
    }
}

global.particle_hspds =
    [128, 1, 2, 4, -128, -256, -512, -1024, -128, -256, -512, -1024, 192, -192];
global.particle_vspds = [-128, -256, -512, -1024, 192, -192, -192];

// handles death; shrinks the slime until it's incredibly small, then destroys it
function SlimeHandleDeath(obj)
{
    var new_part, rand;

    if (obj.timer == 0)
    {
        obj.timer = 2;

        // IWRAM_SFXPanning = (short)(obj.xpos >> 8) - BG_CamX;
        // PlaySound(0x8d);
        
        VinylPlay(snd_popYI,false,0.15,1);
        
        new_part = instance_create_depth(obj.x, obj.y, obj.depth - 1, pSlimeParticle);
        rand = irandom(65535);

        new_part.x = obj.x + ((make_s32(((rand & 0xf) - 8) * 0x10000) >> 8) / 256);
        new_part.y = obj.y - 12;
        new_part.timer = 0xffff;
        new_part.hsp = particle_hspds[min(13, (rand % 14))] / 256;
        new_part.vsp = particle_vspds[min(6, (rand % 7))] / 256;
        new_part.field_0xa2 = 0xff;
        
    }
    obj.morph_scale = obj.morph_scale - 32;
    if (obj.morph_scale < 0x2000)
    {
        obj.timer = 64;
        obj.action_state++;
    }
}

// set the deletion flag
function SlimeDoPoof(obj)
{
    obj.deleteflag = true;
}

// empty function to pad out the function table
function dummyfunc(obj)
{
    return 0;
}

// got crushed by Something
function SlimeCrushed(obj = self)
{
    obj.hsp = 0;
    obj.height = max(16, obj.height - max(0, int64(obj.crush_vsp * 2)));
    
    if (obj.height <= 16)
    {
        VinylPlay(snd_popYI,false,0.45,1);
        // maybe add a spray of particles here?
        obj.deleteflag = true;	
    }
}

global.SlimeFuncs = [SlimeGeneric,          // 0
              Slime_MoveOnGround,    // 1
              SlimeChase,            // 2
              SlimeDefend,           // 3
              SlimeGeneric,          // 4
              BOSS_Salvo,            // 5
              SlimeGeneric,          // 6
              SlimeIntro_Grow,       // 7
              SlimeStartBossBattle,  // 8
              SlimeCrushed,          // 9
              SlimeHandleDeath,      // 10
              SlimeDoPoof
              ];


function SlimeMovePlayer(obj)
{
    var hsp_frac, vsp_frac;
    
    var hitme;
    
    hitme = obj.morph.hitme;
    
    if (!hitme)
    {
        return;	
    }
    
    if (obj.morph.colfactor2 != 0)
    {
        hsp_frac = (hitme.hsp * FRACUNIT) div 1;
        vsp_frac = (hitme.vsp * FRACUNIT) div 1;
        
        //YoshiGroundPound = 0;
        if (((obj.morph.colfactor2 & 1) == 0) || ((obj.morph.colfactor2 & 0xe) != 0))
        {
            obj.morph.colflags =
                make_s16((128 * ((obj.facing >> 1) ? -1 : 1)) - (obj.camx2 div 2));
            if ((2 < make_u16(obj.action_state - 9) && (obj.action_state != 9)) &&
                ((abs(hsp_frac) + (FRACUNIT * 4)) < ((FRACUNIT * 7999) div 1000)))
            {
                hsp_frac = hsp_frac - obj.morph.colflags;
                hitme.hsp = min(8, abs(hsp_frac) / FRACUNIT) * sign(hsp_frac);
            }
        }

        if (((obj.morph.colfactor2 & 1) != 0) && (-1 < vsp_frac))
        {
            vsp_frac = vsp_frac >> 1;
        }

        if (((make_s32((abs(vsp_frac) + (FRACUNIT * 2))) div FRACUNIT) 
                < ((FRACUNIT * 3999) div 1000)))
        {
            vsp_frac -= (((((FRACUNIT div 2) * ((obj.yfacing >> 1) ? -1 : 1))
                            - obj.camy2 & 0xffff) + 0x80));

            if (vsp_frac < 0)
            {
                // set jump parameters
                // rewrite this for boll idfk kjhgkjfdhgkfdg

                // YoshiFrame = 6;
                // YoshiJumpState = 0x8001;
            }
            
            // no, this doesn't make sense
            hitme.vsp = (vsp_frac / (FRACUNIT)) / FRACUNIT;
        }
    }
}

// how the slime interacts with floors
function SlimeCollisionInteractions(obj)
{
    var uVar1, colmask;
    var uVar2;

    if (obj.action_state == 5)
    {
        uVar1 = 0;
        obj.colflags = uVar1;
        return;
    }

    /*if (((-1 < obj.vsp) && (-1 < obj.bottom_bounding)) &&
        (make_s32(obj.bottom_bounding - (obj.y)) * 0x10000) < 0)
    {
        obj.y = obj.bottom_bounding;
        obj.colflags = obj.colflags | COL_FLOOR;
    }*/

    if (obj.vertcoltime == 0)
    {
        
        if (obj.vsp < 0)
        {
            colmask = ~(COL_FLOOR);
        }
        else
        {
            colmask = ~(COL_CEILI);
        }

        obj.colflags = obj.colflags & colmask;

        uVar1 = obj.colflags;
        uVar2 = uVar1;
        // check collisions
        if ((uVar1 & COL_VERTI) != 0)
        {
            // check for floor collides if we hit the ceiling
            if ((uVar1 & COL_CEILI) != 0)
            {
                //show_debug_message($"hit ceiling: {(uVar1 & COL_CEILI)}");
                
                obj.morph_yprev2 = obj.morph_yprev - 4;

                obj.vsp = 0;
                
                // don't do this during the intro; it causes the slime to lock up
                if (obj.action_state != 6)
                {
                    obj.action_state = 0;
                    
                    obj.vertcoltime++;
                    obj.vaccel = 0;
                }

                obj.y = obj.y +
                            make_s32(make_u32(obj.morph_yprev2 - obj.morph_yprev));

                uVar2 = make_u32(obj.colflags);
                obj.colflags = uVar1;
                return;
            }

            obj.y = ((obj.y * FRACUNIT) & (~(0x0F * FRACUNIT)) | FRACUNIT) div FRACUNIT;
        }
    }
    else
    {
        obj.y =
            obj.y +
            ((make_s32(make_u32(obj.morph_yprev2 - obj.morph_yprev) * 0x10000) >> FRACBITS) /
            FRACUNIT);
        uVar2 = make_u32(obj.colflags);
    }

    uVar1 = make_u16((uVar2 & 0x30) >> 2) | make_u16(uVar2);
    obj.colflags = uVar1;
}

// how the slime interacts with walls
function SlimeReboundWalls(obj)
{
    var col_flags;

    if (((obj.intro_state != 0) || (obj.action_state == 4)) || (obj.action_state < 3))
    {
        col_flags = obj.colflags;
        
        // make sure we've hit a wall, but not BOTH walls...
        if (((col_flags & COL_HORIZ) != 0) && ((col_flags & COL_HORIZ) != COL_HORIZ))
        {
            // collision: if we hit a left wall, don't subtract by 1
            obj.x = (((make_s32(col_flags & COL_LWALL) >> 2) - 1 + (obj.x)) -
                 obj.movesign);
        }
    }
}

function SlimeHandleDamage(obj)
{
    var action, hitGravity;
    var hitID, minislime_hspd;
    var hitX;
    var spawnObj, hitMe, newslime;
    var hitMe_offset, hitY;

    hitMe = obj.collide_obj;

    if ((((hitMe != undefined) && (hitMe) && (instance_exists(hitMe))) && (hitMe.can_damage)))
    {
        if (hitMe != obj.hurtmem)
        {
            obj.hurtmem = hitMe;
            obj.dmg_factor = 0;
        }

        if (0x4bff < obj.morph_scale)
        {
            action = obj.action_state;
            if (((action != 3) && (action != 9)) && (((action != 10) && (action != 11))))
            {
                obj.dmgtics = 0x20;
                hitMe.hit_tics++;

                if (obj.hit_severity != 0)
                {
                    obj.dmgtics = 0x20;
                    obj.hurtmem = 0xffff;
                    return;
                }

                hitX = (hitMe.x);
                hitY = (hitMe.y);

                hitGravity = int64(hitMe.grav * 256);

                VinylPlay(snd_popYI,false,0.15,1);

                var noptrset = true;

                // spawn a slime, if we can
                if (((obj.dmg_factor & 3) == 0) && (obj.morph_scalediff < 6))
                {
                    spawnObj = instance_create_depth(obj.x, obj.y, obj.depth - 1, oMiniSlime);

                    if (instance_exists(spawnObj))
                    {
                        spawnObj.x = hitX;
                        spawnObj.y = hitY;

                        spawnObj.action_state = 2;

                        spawnObj.vaccel = 0.25;

                        newslime = spawnObj;
                        noptrset = false;
                    }
                }

                if (noptrset)
                {
                    spawnObj = instance_create_depth(obj.x, obj.y, obj.depth - 1, pSlimeParticle);
                    newslime = spawnObj;
                    newslime.timer = 0xffff;
                }

                newslime.x = hitX;
                newslime.y = hitY;

                newslime.field_0xa2 = 0xff;

                minislime_hspd = (irandom(65535) & ((FRACUNIT * 2) - 1)) - FRACUNIT;
                newslime.hsp = minislime_hspd / FRACUNIT;

                newslime.vsp = (~(make_u32(irandom(65535) >> 8) | (irandom(65535) & 3) << 8) + 1)
                               / FRACUNIT;
                obj.dmg_factor++;

                if (obj.slime[SLIME_DMG_REBOUND] == 0)
                {
                    obj.slime[SLIME_DMG_REBOUND] = 1;
                    obj.slime[SLIME_BOUNCE] = 2;

                    if (obj.action_state == 2)
                    {
                        obj.slime[SLIME_MOVE] = 3;
                        obj.haccel = 0;
                        obj.hsp = 0;
                    }

                    obj.hsp *= -1;
                    obj.hsp_mem *= -1;
                }

                obj.morph_scale -= (3 * FRACUNIT);

                if (obj.morph_scale < (76 * FRACUNIT))
                {
                    obj.morph_scale = (76 * FRACUNIT) - 1;
                }

                if (hitGravity < 64)
                {
                    obj.hit_severity = 1;
                    return;
                }

                obj.hit_severity = 2;
                return;
            }
        }
    }
    obj.hurtmem = noone;
}

function SlimeStartDeath(obj)
{
    if ((obj.morph_scale >> FRACBITS) < 76)
    {
        if ((((obj.colflags & COL_FLOOR) != 0)) &&
            (2 < make_u8(make_s8(obj.action_state) - 9)))
        {
            obj.haccel = 0;
            obj.hsp = 0;
            obj.timer = 64;
            obj.action_state = 10;
        }
    }
}

function SlimeThinker(obj = self)
{
    var action;
    
    var curtime = get_timer();
    
    obj.last_delta = 0;
    obj.last_delta += (curtime);
    
    //show_debug_message($"height: {obj.height}, scale: {obj.morph_scale}");

    obj.morph_bottom =
        make_u16((make_s32((make_s32(obj.height) * make_u32(obj.morph_scale >> 8)) >> 8) )
            * 3 >> 1);
            
    if (obj.action_state < 12)
    {
        Slime_HandleBGRender(obj);
        SlimeCollisionInteractions(obj);
    }
    
    //return;
    
    SlimeReboundWalls(obj);
    
    if (obj.active)
    {
        action = obj.action_state;
        if ((action != 12))
        {
            if (action != 13)
            {
                SlimeHandleDamage(obj);
            }
            SlimeMovePlayer(obj);
        }
        SlimeStartDeath(obj);

        call_func_from_table(obj, SlimeFuncs, obj.action_state);

        if (obj.dmgtics != 0)
        {
            obj.dmgtics--;
        }
    }
}