// this just makes sure that vsp and hsp actually work while in a pipe lol
if (piped)
{
    y += vsp;
    x += hsp;
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

if ((apress) && (grounded == false))
{
    alarm[1] = 10;  // ammount of frames for jump buffering
    alarm[2] = 10;  // Walljump buffering
}
else if (grounded == true)
{
    alarm[2] = 0;
    wallbuffer = 0;
}

if ((alarm[1] > 0) && (grounded == true))
{
    bufferjump = 1;
    alarm[1] = 0;
}

move = (right - left);

maxspd = 2;

if (move != 0)
{
    image_speed = 1;

    hsp += (move * accel);

    hsp = clamp(hsp, -maxspd, maxspd);
}
else
{
    image_speed = 0;
    image_index = 0;
    hsp = lerp(hsp, 0, fric);
}

// Fall off platform
if (!grounded)
{
    vsp = min(4, vsp + grav);
    canjump -= 1;
	
	// chearii: coneyor speed management
	if (abs(chsp * 100))
	{
		chsp *= 0.95;
		
		if ((chsp * 100 div 1) == 0)
			chsp = 0;
	}
}
else
{
    canjump = 5;  // Coyote frames
}

grounded = false;


// polygons!!!!!

// manage boxpoly
P_PolygonManager(self,false,0,-8);
var this = self;

// get our polygon vertices
var verticesA = GetTransformedVertices(true,sprite_xoffset div 1,(sprite_yoffset - 7) div 1);

var clipcheck, clipdiff, clipsave, ynormal, polycos, polyacos, acos_check, docollide;

// polygon collision handler
with(oPolyCollider)
{
	if (IntersectPolygons(verticesA,GetTransformedVertices(true,sprite_xoffset div 1,sprite_yoffset div 1)))
	{
		// get the normal and pdepths
        var nrm = array_get(datapacket,0);
		var dpt = array_get(datapacket,1);

		ynormal = ((abs(nrm.Y)*100) div 10);
		polycos = abs((100 * cos(degtorad(polyangle))) div 10);
		
        // get the inverse cosine, for wall collisions
		polyacos = radtodeg(arccos(-nrm.X)) div 1;
		
        // some junk for acos_check, mostly just the angle values
		if ((polyacos > 90) && (polyacos <= 270))
			acos_check = polyacos-180;
		else
			acos_check = polyacos;
		
        // reset the datapacket
		datapacket = undefined;
		
        // docollide: only one type of box collision always collides, otherwise its semisolid
		docollide = ((object_index == oPolyCollider) ? true : ((nrm.Y > 0) ? ((abs(radtodeg(nrm.X)) div 1) < 54) : false ));
		
        // clipcheck: check if we've clipped into a tile
		clipcheck = false;
		
		if (docollide)
		{
			clipcheck = move_obj_by_poly(this, vector_mul(vector_mul(nrm, -1), dpt/2), true, oCollider);

            if (clipcheck) // if we're clipping...
			{
				if (ynormal == polycos) // ...and our normals and cosine match up...
				{
					// ...check just how severe the clipping is
                    clipdiff = (this.x - x) div 1;
					
					if (abs(clipdiff) <= 4)
					{
						// damage threshold, do damage stuff
					}
					else
					{
						// push the object out of the clip area
                        clipsave = ((this.x div 1) & -16) + 16 * sign(clipdiff);
						this.x = clipsave + (sprite_xoffset div 1);
					}
				}
			}
			
			//show_debug_message(this.canjump);

            // polygon collisions
            if (nrm.Y > 0) // floor
			{
				// we hit the floor
				
				if (this.vsp > 0)
					this.vsp = 0; // switch this out with whatever vertical speed value you're using
				
				this.grounded = true;
				// use radtodeg(nrm.X) to get the angle of the floor!
			}
			else if (nrm.Y > 0.2)
			{
				if (this.speedy >= 0)
					this.speedy = (((16 * cos(nrm.Y)) * 2) div 3) / 16; //32 - (abs(nrm.Y * FRACUNIT) div 1);
				
				this.cspeedx = (rotdiff * 4) div 1;
				
				this.polycheck = min(4, this.polycheck + 2);
			}
            else if (abs(acos_check) == abs(polyangle)) // wall
			{
				// treat it like a wall
				if (sign(this.hsp) == sign(nrm.X*10))
					this.hsp = (sin(degtorad(polyacos))); // rebound!!
			}
			else
				this.vsp = (abs(nrm.Y));
        }
	}
}

// chearii: standard collision stuff below
// nekonesse: rewrite this i beg of you this sucks ass to manage but i dont know a better way

var _Platform = instance_place(x, y + vsp, oSemilider);
if (_Platform && bbox_bottom <= _Platform.bbox_top)
{
    if (vsp > 0)
    {
        while (!place_meeting(x, y + sign(vsp), _Platform))
        {
            y += sign(vsp);
        }
        grounded = true;
        vsp = 0;
    }
}

coll = instance_place(x + hsp, y, oCollider);
if ((coll) && (!coll.no_collide))
{
	
	yPlus = 0;
    while (place_meeting(x + hsp, y - yPlus, oCollider) && yPlus <= abs(2 * hsp))
    {
        yPlus += 1;
    }
    if (place_meeting(x + hsp, y - yPlus, oCollider))
    {
        while (!place_meeting(x + sign(hsp), y, oCollider))
        {
            x += sign(hsp);
        }
        hsp = 0;
    }
    else
    {
        y -= yPlus;
    }
}
else
{
    yMinus = 0;
    while ((!place_meeting(x + hsp, y + yMinus, oCollider)) && (yMinus <= abs(1 * hsp)))
    {
        yMinus += 1;
    }
    // still not sure why exactly this needs to be here, but it does for math reasons.
    yMinus -= 1;

    // if there is a place of meeting at yMinus (speed+1) but not at yMinus (speed) AND we're
    // already on the ground, move down
    if ((place_meeting(x + hsp, round(y + yMinus) + 1, oCollider)) &&
        (!place_meeting(x + hsp, round(y + yMinus), oCollider)) && 
        (place_meeting(x, y + 1, oCollider)))
    {
        y = round(y + yMinus);
    }
}

mplat = instance_place(x, y + 1, oMovingPlatform)

if (mplat)
{
	chsp = mplat.x_diff;
}

var speedhtotal, isFlipBlock;

speedhtotal = ((chsp + hsp) * 16) div 1;

// chearii: ME WHEN GAMEMAKER COLLISION
// heads up: this means there's currently TWO wall collision routines
// this just iterates through all potential movements until a collision happens ("future sense")
var wall, walls, wnum, no_walls, hsign;

no_walls = true;

repeat(abs(speedhtotal))
{
	hsign = (sign(speedhtotal)/16);
	
	walls = ds_list_create();
	wnum  = instance_place_list(x + hsign,y,oCollider,walls,false);
	
	if (wnum > 0)
	{
	    for (var i = 0; i < wnum; ++i;)
	    {
	        wall = (walls[| i]);
			
			if (wall.no_collide)
				continue;
				
			no_walls = false;
			break;
		}
	}
	
	// avoid memleaks
	ds_list_destroy(walls);
	
	if (no_walls)
		x += sign(speedhtotal)/16;
	else	
		hsp = 0;
}

wall = instance_place(x, y, oCollider);

// chearii: unoptimized shitty loop to force the player out of a platform
// time complexity is O(n)
if ((wall))
{
	isFlipBlock = false;
	
	if ((wall.object_index == oFlipblock) || (wall.object_index == oFlipblockLong))
		isFlipBlock = true;
		
	if (!((isFlipBlock) && (wall.hit)))
	{
		if(x >= wall.x + ((wall.bbox_right - wall.bbox_left) / 2))
		{
			while(wall)
			{
				x += 1;
				wall = place_meeting(x, y, oCollider);
			}
		}
		else
		{
			while(wall)
			{
				x -= 1;
				wall = place_meeting(x, y, oCollider);
			}
		}
	}
}

var collhit, vsptotal, semicoll, vsign;

semicoll = false;

vsptotal = ((cvsp + vsp) * 16) div 1;

// vertical collision overhaul with BLEHHHHH nested loops...
// time complexity is O(n^2) (can be VERY slow given circumstances)
no_walls = true;

repeat(abs(vsptotal)) 
{
		
	collhit = undefined;
	
	//collhit = instance_place(x, y + (sign(vsptotal)/16), oCollider);
	
	vsign = (sign(vsptotal)/16);
	
	collhit = obj_get_coll(self,x,y + vsign);
	
	// no collision, let's try a semisolid
	if (!collhit) && ((vsp * 16) >= 0)
	{
		collhit = instance_place(x, y + (sign(vsptotal)/16), oSemilider);
			
		if (collhit) 
		{
			if ( ((bbox_bottom - collhit.bbox_top) div 1) > 1)
				collhit = noone;
			else
			{
				y = (collhit.bbox_top) div 1;
				semicoll = true;
			}
		}
	}
	
	if (!collhit)
	{
		y += sign(vsptotal)/16; 
	}
	else 
	{	
		var dist = 0;
			
		if (collhit)
			dist = ((y div 1) - ((collhit.y + 8) div 1));
			
		vsptotal = 0;
			
		vsp = ((dist <= -4) ? (2/16) : 0);
	    break;
	}
}

collhit = obj_get_coll(self,x,y + 1);

if ((collhit)||(semicoll))
{
	fr = 0;
    grounded = true;
	
	chsp = 0;
}

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
                x = (other.x + (other.sprite_width / 2));
            }
            // sorry about the global variables here but the player object isnt
            // persistent so im overpreparing for room reloads lol
            global.exitlocation = target;  
            
            global.exittype = warptypes.pipe;  
        }
    }
}

// Jumping
if (!akey)
{
    if ((canstopjump == 1) && (vsp < -2))
    {
        vsp *= 0.6;
    }
}

if ((canjump > 0 && (apress)) 
    || (bufferjump))
{
	jump = 1;
    fr = 1;
    bufferjump = 0;
    vsp = -6;
    canjump = 0;
    canstopjump = 1;
}

// Switch direction
if (left)
{
    xsc = -1;
}
else if (right)
{
    xsc = 1;
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