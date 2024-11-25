// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//#macro COL oCollider

// run this in end step, clipping stupidity happens otherwise
function player_poly_collision()
{
	if (piped) exit;
	
	// polygon collisions
	var lastpolyfloor = polyfloor[1];
	polyfloor[0] = false;
	poly_collide(self, true);
	
	// dumb hack: if our timer's gone down, scan downwards a bit until we hit a polygon
	if ((polyfloor[1]) && (lastpolyfloor > polyfloor[1]))
	{
		var scan = 4; // only 4 cycles since this is per-pixel
		var prescany = y;
		
		while (scan)
		{
			y += 1;
			polyfloor[0] = false;
			poly_collide(self, true);
			
			if (polyfloor[0])
			{
				break;	
			}
			
			scan -= 1;
		}
		
		// prevent shitty jumpsnaps that I'll get yelled at for
		// have to do this AFTER the scan due to polyfloor[0] being a boolean
		if ((intlib_make_fixedpoint(vsp) < 0) && (polyfloor[0] == false))
		{	
			if (polyfloor[1])
			{
				polyfloor[1] = 0;
			}
		}
		
		// found nothing, return to our old position
		if (polyfloor[0] == false)
		{
			y = prescany;	
		}
	}
	
	if (polyfloor[1] > 0)
	{
		grounded = true;
		if (lastpolyfloor == 0)
		{
			// landed on a polygon, do the usual landing routine
			if self.object_index = oPlayer{
				sig.Emit("floor_land")
			} else {
				gsp = hsp
				vsp = 0	
			}
		}
	}
}

function player_collision(){
	if (piped) exit
	if (object_get_parent(self.object_index) == oEnemy) //since enemies do not use gsp this is my hash tag Fixed! for gsp-related enemy issues
		gsp = hsp 
	
	var posx, posy
	posx = x
	posy = y
	
	//left wall
	while check_collision_dot(posx-hit_sizex, posy-sign(vsp), COL_WALL){
		x++	
		posx = x
	}
		
	//right wall
	while check_collision_dot(posx+hit_sizex, posy-sign(vsp), COL_WALL){
		x--
		posx = x
	}
	
	//landing on solid ground
	if !grounded && vsp >= 0 {
		if check_collision_line(posx-hit_sizex,posy+hit_sizey,posx+hit_sizex,posy+hit_sizey, COL_BOTTOM){
			grounded = true
			get_angle_line(posx-hit_sizex,posy+hit_sizey,posx-hit_sizex,posy +hit_sizey + 3)
			get_angle_line(posx+hit_sizex,posy+hit_sizey,posx+hit_sizex,posy +hit_sizey + 3)
			
			if self.object_index = oPlayer{
				//move up
				while check_collision_line(posx-hit_sizex,posy+hit_sizey, posx+hit_sizex, posy+hit_sizey, COL_BOTTOM) {
					y -- 
					posy = y
				}
				sig.Emit("floor_land")
			} else {
				gsp = hsp
				vsp = 0	
			}
		}
	}
	
	//hitting the ceiling
	if !grounded && vsp < 0 {
		if (check_collision_dot(posx+hit_sizex, posy-hit_sizey, COL_TOP)
			or check_collision_dot(posx-hit_sizex, posy-hit_sizey, COL_TOP)){
			//push out
				
			while (check_collision_dot(posx+hit_sizex, posy-hit_sizey, COL_TOP) 
				or check_collision_dot(posx-hit_sizex, posy-hit_sizey, COL_TOP)) {
				y++
				posy = y
				
			}
			
			//bonking
			if object_index == oPlayer{
				//Hitting / Bumping blocks
				VinylPlay(snd_blockbump)
				sig.Emit("ceil_bonk")
				var _list = ds_list_create();
				var _num = collision_line_list(posx-(hit_sizex-1), posy-(hit_sizey+1)+vsp, posx+(hit_sizex-1), posy-(hit_sizey+1)+vsp, oHittable, false, true, _list, true);
				if (_num > 0) {
					for (var i = 0; i < _num; ++i;) {
						with(_list[| i]) if !(no_hit) {
							dummyTimer = dummyTimerReset;
							blockHit.Emit(-1, other.id)
						}
					}
				}
			}
			
			vsp = 2
		}
	}
	
	//normal ground loop (for a variety of slopes
	if grounded {
		//gets angle so it doesnt jitter
		get_angle_line(posx-hit_sizex,posy+hit_sizey,posx-hit_sizex,posy +hit_sizey + 3)
		get_angle_line(posx+hit_sizex,posy+hit_sizey,posx+hit_sizex,posy +hit_sizey + 3)
		
		
		var offsetx, offsety;
		
		offsetx = xprevious - x
		offsety = yprevious - y
		
		//fall
		if (!check_collision_line(posx-hit_sizex,posy+hit_sizey,posx-hit_sizex,posy +hit_sizey + 15 , COL_BOTTOM) && !check_collision_line(posx+hit_sizex-1,posy+hit_sizey,posx+hit_sizex-1,posy+hit_sizey + 15, COL_BOTTOM) ){
				if (!abs(polyfloor[1]))
				{
					vsp = gsp * -dsin(colangle)
					hsp = gsp * dcos(colangle)
					grounded = false
					colangle = 0
					colslope = 0
				}
				exit;
			}
			
	}
		
		
	if grounded {
		//move down
		if (check_collision_line(posx-hit_sizex,posy+hit_sizey,posx-hit_sizex,posy +hit_sizey + 15 , COL_BOTTOM) || check_collision_line(posx+hit_sizex-1,posy+hit_sizey,posx+hit_sizex-1,posy+hit_sizey + 15, COL_BOTTOM) ){   
			while !check_collision_line(posx-hit_sizex,posy+hit_sizey, posx+hit_sizex, posy+hit_sizey, COL_BOTTOM){
				y ++ 
				posy = y
				
			}
		}
		
		//move up
		while check_collision_line(posx-hit_sizex,posy+hit_sizey, posx+hit_sizex, posy+hit_sizey, COL_BOTTOM) {
			y -- 
			posy = y
		}
	}

}