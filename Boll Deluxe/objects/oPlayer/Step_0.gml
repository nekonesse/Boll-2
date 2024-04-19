// this just makes sure that vsp and hsp actually work while in a pipe lol
if (piped)
{
    //y_frac += intlib_make_fixedpoint(vsp) >> FRACBITS;
    //x_frac += intlib_make_fixedpoint(hsp) >> FRACBITS;
	
	//x = x_frac >> FRACBITS;
	//y = y_frac >> FRACBITS;
    exit
}

// chearii: guessing these are a buncha quickvars
right = input_check("right");
left = input_check("left");
up = input_check("up");
down = input_check("down");
akey = input_check("jump");
apress = input_check_pressed("jump");
bkey = input_check("action");
bpress = input_check_pressed("action");
ckey = input_check("special");
cpress = input_check_pressed("special");

player_movement()

// polygons!!!!!
//nekonesse: i beg of you turn this into a basic script/function for charm users....

// check to see if we need to update the polybox
if (sprindex_prev != sprite_index)
{
	//obj_update_poly_from_bounding(self);
	sprindex_prev = sprite_index;
}

player_collision();

if (grounded)
    jump = 0;

// Pipes ??? (works now)
if (grounded && down && place_meeting(x, y + 4, oPipeUp))
{  
    with instance_place(x, y + 4, oPipeUp)
    {
        if (canenter)
        {
            with other
            {  
                alarm[3] = 80;
                piped = 1;
                vsp = 1.5;
                hsp = 0;
                //x_frac = intlib_make_fixedpoint((other.x + (other.sprite_width / 2))) >> FRACBITS;
            }
            // sorry about the global variables here but the player object isnt
            // persistent so im overpreparing for room reloads lol
            global.exitlocation = target;  
            
            global.exittype = warptypes.pipe;  
        }
    }
}

coll = instance_place(x, y, oMushroom);

if (coll)
{
    oldsize = size;

    if (size < 1)
        size = 1;

    alarm[11] = 60;
    instance_destroy(coll);
}

// switch for sheets or whatever
switch (size)
{
default:
case 0:
    sprite_index = spr_player;
    break;
case 1:
    sprite_index = spr_playerbig;
    break;
}