function my_collision() {
//nekonesse: what the fuck did you guys do here its so messy and theres so many redundant collision checks that do nothing

var bbb = max(0, sprite_yoffset - 16);

var topbox = (bbox_top - y) div 1;

// manage boxpoly
P_PolygonManager(self,false,0,-8);
var this = self;

// get our polygon vertices
var verticesA = GetTransformedVertices(false,0,0,true);

var clipcheck, clipdiff, clipsave, ynormal, polycos, polyacos, acos_check, docollide;

// polygon collision handle
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

            if (clipcheck[0]) // if we're clipping...
			{
				
				if (!((abs((clipcheck[2] * 100) div 1)))) && (ynormal == polycos) // ...and our normals and cosine match up...
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
				else if ((abs((clipcheck[2] * 100) div 1)))
				{
					// do damage stuff (crushing)
					//show_debug_message("[oPlayer] vertical clip");
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
// me when the code order issue hits - chopp

coll = instance_place(x + hsp, y, oCollider);
if ((coll) && (!coll.no_collide)){
		
		if(x >= coll.x + ((coll.bbox_right - coll.bbox_left) / 2))
		{
			while collider_metting(x + hsp, y){
				x++
			}
		}else{
			while collider_metting(x + hsp, y){
				x--
			}
		}
}

//not sure whats happening with the flip platforms tbh

var _Platform = instance_place(x, y + vsp, oSemilider);
if (_Platform && bbox_bottom <= _Platform.bbox_top)
{
    if (vsp > 0)
    {
        while (!place_meeting(x, y + sign(vsp), _Platform))
        {
            y += sign(vsp);
        }
        vsp = 0;
    }
}

var speedhtotal, isFlipBlock;

speedhtotal = ((chsp + hsp) * 16) div 1;

//y += sign(((cvsp + vsp) * 16) div 1)/16;

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
		
	if (!((isFlipBlock) && abs(wall.hit)))
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


// making collision a "litle worse" here to make sure it actually works -chopp
// btw this one done before you pointed out the issue you did so umm
// oops ig this was a litle overkill lol
// still theres something up with the collision loop because the moving platforms should NOT be doing that


//x += hsp/steps;

/*coll = instance_place(x, y + vsp, oCollider);
if ((coll) && (!coll.no_collide)){
    while(!place_meeting(x,round(y+sign(vsp)),oCollider)){
        y += sign(vsp);
    }
    vsp = 0;
	grounded=true
}
y += vsp/steps;*/


}

function collider_metting(_x,_y){
	var Solid = instance_place(_x,_y,oCollider)
	
	if Solid.no_collide{
		return true
	}
}