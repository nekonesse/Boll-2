/// \file  scr_collision.gml
/// \brief Setup and handling of collision with colliders.

// TODO: use the SMW system for moving platforms, god knows they need a redo too
// also slopes eventually

// chearii: 256 subpixels, like the sonic hedgehogeghe
#macro FRACBITS 8
#macro FRACUNIT 256
#macro TILE_PIXELS 16

// collision flags
#macro WALL_LEFT  1
#macro WALL_RIGHT 2
#macro WALL_FLOOR 4
#macro WALL_CEIL  8

#macro WALL_HORIZ 3
#macro WALL_VERTI 12

function setup_frac(obj)
{
	obj.x_frac = intlib_make_fixedpoint(obj.x) >> FRACBITS;
	obj.y_frac = intlib_make_fixedpoint(obj.y) >> FRACBITS;
}

// chearii: remind me to add all the other polygon-related functions to charm
function collision_handle_polygon(obj = self)
{
	var bbb = max(0, sprite_yoffset - 16);

	var topbox = (bbox_top - y) div 1;

	// manage boxpoly
	P_PolygonManager(obj,false,0,-8);

	// get our polygon vertices
	var verticesA;
	
	with(obj)
		verticesA = GetTransformedVertices(false,0,0,true);

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
				clipcheck = move_obj_by_poly(obj, vector_mul(vector_mul(nrm, -1), dpt/2), true, oCollider);

	            if (clipcheck[0]) // if we're clipping...
				{
				
					if (!((abs((clipcheck[2] * 100) div 1)))) && (ynormal == polycos) // ...and our normals and cosine match up...
					{
						// ...check just how severe the clipping is
	                    clipdiff = (obj.x - x) div 1;
					
						if (abs(clipdiff) <= 4)
						{
							// damage threshold, do damage stuff
						}
						else
						{
							// push the object out of the clip area
	                        clipsave = ((obj.x div 1) & -16) + 16 * sign(clipdiff);
							obj.x = clipsave + (sprite_xoffset div 1);
						}
					}
					else if ((abs((clipcheck[2] * 100) div 1)))
					{
						// do damage stuff (crushing)
						//show_debug_message("[oPlayer] vertical clip");
					}
				}
				
				// even if we're clipping or not, set subpixel values if we have them
				if (obj.x_frac != undefined)
				{
					obj.x_frac = intlib_make_fixedpoint(obj.x) >> 8;	
				}
				
				if (obj.y_frac != undefined)
				{
					obj.y_frac = intlib_make_fixedpoint(obj.y) >> 8;	
				}
			
				//show_debug_message(this.canjump);

	            // polygon collisions
	            if (nrm.Y > 0) // floor
				{
					// we hit the floor
				
					if (obj.vsp > 0)
						obj.vsp = 0; // switch this out with whatever vertical speed value you're using
				
					obj.grounded = true;
					// use radtodeg(nrm.X) to get the angle of the floor!
				}
				else if (nrm.Y > 0.2)
				{
					if (obj.vsp >= 0)
						obj.vsp = (((16 * cos(nrm.Y)) * 2) div 3) / 16; //32 - (abs(nrm.Y * FRACUNIT) div 1);
				}
	            else if (abs(acos_check) == abs(polyangle)) // wall
				{
					// treat it like a wall
					if (sign(obj.hsp) == sign(nrm.X*10))
						obj.hsp = (sin(degtorad(polyacos))); // rebound!!
				}
				else
					obj.vsp = (abs(nrm.Y));
	        }
		}
	}
}

function collision_routine_do_xcoll(obj = self)
{
	// 3 sensors for less chances of it fucking up
	var hsensor_A, hsensor_B, hsensor_C, xdiff, hface;
	var hitme, hit_dist;
	
	// sensor distances stored into one value
	// 0x00CCBBAA
	var hsensor_dist = 0;
	var bttm = obj.bbox_bottom - 2;
	var top = obj.bbox_top + 2;
	
	hsensor_A = (intlib_make_fixedpoint(top) >> FRACBITS);
	hsensor_B = (intlib_make_fixedpoint(bttm - ((bttm - obj.bbox_top) / 2)) >> FRACBITS);
	hsensor_C = (intlib_make_fixedpoint(bttm) >> FRACBITS);
	
	xdiff = ((obj.hsp < 0) ? ((obj.bbox_left) - obj.x) : ((obj.bbox_right) - obj.x)) div 1;
	hface = ((obj.hsp < 0) ? 0 : 1);
	
	var hitx;
	
	// chearii: this is horribly messy and I'm really sorry
	// sensor A
	hitme = instance_valid_at_position(obj.x + xdiff, hsensor_A >> FRACBITS, oCollider, obj);
	
	if (hitme)
	{
		hitx = (hface ? (hitme.bbox_left) : (hitme.bbox_right));
		
		if (hface)
			hsensor_dist |= intlib_make_u8((obj.x + xdiff) - hitx);
		else
			hsensor_dist |= intlib_make_u8(hitx - (obj.x + xdiff));
	}
		
	// sensor B
	hitme = instance_valid_at_position(obj.x + xdiff, hsensor_B >> FRACBITS, oCollider, obj);
	
	if (hitme)
	{
		hitx = (hface ? (hitme.bbox_left) : (hitme.bbox_right));
		
		if (hface)
			hsensor_dist |= (intlib_make_u8((obj.x + xdiff) - hitx) << 8);
		else
			hsensor_dist |= (intlib_make_u8(hitx - (obj.x + xdiff)) << 8);
	}
		
	// sensor C
	hitme = instance_valid_at_position(obj.x + xdiff, hsensor_C >> FRACBITS, oCollider, obj);
	
	if (hitme)
	{
		hitx = (hface ? (hitme.bbox_left) : (hitme.bbox_right));
		
		if (hface)
			hsensor_dist |= (intlib_make_u8((obj.x + xdiff) - hitx) << 16);
		else
			hsensor_dist |= (intlib_make_u8(hitx - (obj.x + xdiff)) << 16);
	}
		
	if (hsensor_dist != 0) // if this has any value, we've collided with something
	{
		var sa, sb, sc;
		
		sa = (hsensor_dist & 0xFF);
		sb = (hsensor_dist >> 8) & 0xFF;
		sc = (hsensor_dist >> 16);
		
		// uncomment for debug
		//show_debug_message("x sensors: " + string(sa) + ", " + string(sb) + ", " + string(sc));
		
		if ((sa > sb) && (sa > sc))
			obj.x -= sa * (hface ? 1 : -1);
		else if (sb > sc)
			obj.x -= sb * (hface ? 1 : -1);
		else
			obj.x -= sc * (hface ? 1 : -1);
			
		obj.x_frac = intlib_make_fixedpoint(obj.x) >> FRACBITS;
		
		return ((hface) ? WALL_RIGHT : WALL_LEFT);
	}
	return 0;
}

function collision_routine_do_ycoll(obj = self)
{
	// 3 sensors for less chances of it fucking up
	var vsensor_A, vsensor_B, vsensor_C, ydiff, vface;
	var hitme, hit_dist;
	
	var collhit = 0;
	
	// sensor distances stored into one value
	// 0x00CCBBAA
	var vsensor_dist = 0;
	
	var l = obj.bbox_left + 3;
	var r = obj.bbox_right - 3;
	
	vsensor_A = (intlib_make_fixedpoint(l) >> FRACBITS);
	vsensor_B = (intlib_make_fixedpoint(r - ((r - l) / 2)) >> FRACBITS);
	vsensor_C = (intlib_make_fixedpoint(r) >> FRACBITS);
	
	ydiff = ((obj.vsp < 0) ? ((obj.bbox_top) - obj.y) : ((obj.bbox_bottom) - obj.y)) div 1;
	vface = ((obj.vsp < 0) ? 0 : 1);
	
	var hity;
	
	// chearii: this is horribly messy and I'm really sorry
	// sensor A
	hitme = instance_valid_at_position(vsensor_A >> FRACBITS, obj.y + ydiff, oCollider, obj);
	
	if (hitme)
	{
		hity = (vface ? hitme.bbox_top : hitme.bbox_bottom);
		
		collhit = ((vface) ? WALL_FLOOR : WALL_CEIL);
		
		if (vface)
			vsensor_dist |= intlib_make_u8((obj.y + ydiff) - hity);
		else
			vsensor_dist |= intlib_make_u8(hity - (obj.y + ydiff));
	}
		
	// sensor B
	hitme = instance_valid_at_position(vsensor_B >> FRACBITS, obj.y + ydiff, oCollider, obj);
	
	if (hitme)
	{
		hity = (vface ? hitme.bbox_top : hitme.bbox_bottom);
		
		collhit = ((vface) ? WALL_FLOOR : WALL_CEIL);
		
		if (vface)
			vsensor_dist |= (intlib_make_u8((obj.y + ydiff) - hity) << 8);
		else
			vsensor_dist |= (intlib_make_u8(hity - (obj.y + ydiff)) << 8);
	}
		
	// sensor C
	hitme = instance_valid_at_position(vsensor_C >> FRACBITS, obj.y + ydiff, oCollider, obj);
	
	if (hitme)
	{
		hity = (vface ? hitme.bbox_top : hitme.bbox_bottom);
		
		collhit = ((vface) ? WALL_FLOOR : WALL_CEIL);
		
		if (vface)
			vsensor_dist |= (intlib_make_u8((obj.y + ydiff) - hity) << 16);
		else
			vsensor_dist |= (intlib_make_u8(hity - (obj.y + ydiff)) << 16);
	}
		
	if (vsensor_dist != 0) // if this has any value, we've collided with something
	{
		var sa, sb, sc;
		
		sa = max(0, (vsensor_dist & 0xFF) - vface);
		sb = max(0, ((vsensor_dist >> 8) & 0xFF) - vface);
		sc = max(0, ((vsensor_dist >> 16)) - vface);
		
		// uncomment for debug
		//show_debug_message("y sensors: " + string(sa) + ", " + string(sb) + ", " + string(sc));
		
		if (sa >= sb)
		{
			if (sa >= sc)
            {
                obj.y -= sa * (vface ? 1 : -1);
			}
            else
            {
				obj.y -= sc * (vface ? 1 : -1);
			}
		}
		else if (sb >= sc)
		{
			obj.y -= sb * (vface ? 1 : -1);
		}
		else
		{
			obj.y -= sc * (vface ? 1 : -1);
		}
			
		obj.y_frac = intlib_make_fixedpoint(obj.y) >> FRACBITS;
	}	
	
	return collhit;
}

// yspeed should be in subpixels!!!
function collision_routine_do_semisolid(obj = self, yspeed = 0)
{
	var y_future = obj.y_frac;
	var y_future_pixel = 0;
	var diff_to_bbottom = (obj.bbox_bottom - obj.y) div 1;
	var semihit;

	if (abs(yspeed) && (obj.vsp >= 0))
	{
		for (var i = 0; i < max(1, abs(yspeed) >> (FRACBITS / 2)); i++)
		{
			y_future += (FRACUNIT >> (FRACBITS / 2));

			y_future_pixel = (y_future >> FRACBITS);

			semihit = instance_place(obj.x,y_future_pixel + 1,oSemilider);

			if (semihit)
			{
				show_debug_message("hit semi");

				var pixeldist = intlib_make_s32(obj.bbox_bottom - semihit.bbox_top);

				show_debug_message(pixeldist);

				if (pixeldist <= 5)
				{
					obj.y = (semihit.bbox_top + 1) - diff_to_bbottom;

					obj.y_frac = intlib_make_fixedpoint(obj.y) >> FRACBITS;

					obj.vsp = 0;

					obj.collflags |= WALL_FLOOR;
					obj.grounded = true;

					break;
				}
			}
		}
	}
}

function my_collision(obj = self) 
{
	// chearii: damn, I messed up, we gotta go bald
	
	// reset collision flags
	obj.collflags = 0;

	// handle polygons first
	collision_handle_polygon(obj);

	// okay time for subpixel bullshit
	var frachsp, fracvsp;
	
	// first, make subpixel versions of hsp and vsp
	frachsp = intlib_make_fixedpoint(obj.hsp) >> FRACBITS;
	fracvsp = intlib_make_fixedpoint(obj.vsp) >> FRACBITS;
	
	// before we do anything, do future sense for the y coordinate so that we can check if we 
	// hit a semisolid
	collision_routine_do_semisolid(obj, fracvsp);

	// now, add the speeds to the SUBPIXEL VERSIONS of our coordinates
	obj.x_frac += frachsp;
	obj.y_frac += fracvsp;
	
	obj.x = obj.x_frac >> FRACBITS;
	obj.y = obj.y_frac >> FRACBITS;
	
	// sonic-style "sensor" collision
	// https://info.sonicretro.org/SPG:Solid_Tiles#Sensors
	
	obj.collflags |= collision_routine_do_ycoll(obj);
	obj.collflags |= collision_routine_do_xcoll(obj);
	
	if (obj.collflags & WALL_VERTI)
	{
		obj.vsp = 0;	
		
		if (obj.collflags & WALL_FLOOR)
			obj.grounded = true;
		
	}
	
	if (obj.collflags & WALL_HORIZ)
		obj.hsp = 0;
	
}

function collider_metting(_x,_y){
	var Solid = instance_place(_x,_y,oCollider)
	
	if Solid.no_collide{
		return true
	}
}