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
				stompCombo = 0;
			} else {
				gsp = hsp
				vsp = 0	
			}
		}
	}
}

function basic_step_move(iterations = 2){
    var true_hsp = hsp
    var true_vsp = vsp
    
    repeat(iterations) {
        x += hsp /iterations
        y += vsp /iterations
        
        player_interactions();
        player_collision();
    }
}


function player_collision(shoveOutOfWalls=true,auto_coords=true,l=0,r=0,t=0,b=0,c = 0){
	var loop_count = 0;
	
	var left, right, top, bottom;
	
	if (auto_coords)
	{
		left = -hit_sizex;
		right = hit_sizex;
		top = -hit_sizey;
		bottom = hit_sizey;
	}
	else
	{
		left = l;
		right = r;
		top = t;
		bottom = b;
	}
	
	var _piped = false;
	
	if (variable_instance_exists(self,"piped"))
	{
		_piped = piped;
	}
	
	if (_piped)
	{
		exit;
	}
	
	// init/reset colflags
	colflags = 0;
	
	var posx, posy
	posx = x
	posy = y
	
	if (shoveOutOfWalls) {
		//left wall
		while check_collision_line(posx+left, posy-sign(vsp)+c+top+3,posx+left,posy-sign(vsp)+c,COL_WALL){
			x++	
			posx = x
			colflags |= COL_LWALL;
			loop_count+=1;
			if (loop_count > 100000) {
				show_debug_message("too many loops at line 124, aborting")
				break;
			}
		}
		loop_count=0
		
		//right wall
		while check_collision_line(posx+right, posy-sign(vsp)+c+top+3,posx+right,posy-sign(vsp)+c,COL_WALL ){
			x--
			posx = x
			colflags |= COL_RWALL;
			loop_count+=1;
			if (loop_count > 100000) {
				show_debug_message("too many loops at line 137, aborting")
				break;
			}
		}
		loop_count=0
	}
	
	//landing on solid ground
	if !grounded && vsp >= 0 {
		if check_collision_rectangle(posx+left,posy,posx+right,posy+bottom, COL_BOTTOM) && (!check_collision_rectangle(posx+left,posy-2,posx+right,posy+bottom-2, COL_BOTTOM) || vsp>=2 ){
			grounded = true
			colflags |= COL_FLOOR;
			get_angle_rect(posx+left,posy+bottom-2,posx+right,posy+bottom + 3)
            
			
			if self.object_index = oPlayer{
				//move up
				while check_collision_rectangle(posx+left,posy, posx+right, posy+bottom /*+ vsp*/, COL_BOTTOM) {
					y --
					posy = y 
				}
				sig.Emit("floor_land")
				stompCombo = 0;
			} else {
				gsp = hsp
				vsp = 0	
			}
		}
	}
	
	//hitting the ceiling
	if !grounded && vsp < 0 {
		if (check_collision_line(posx+right, posy+top, posx+left, posy+top, COL_TOP)){
			//push out
				
			while (check_collision_line(posx+right, posy+top, posx+left, posy+top, COL_TOP)) {
				y++
				posy = y
				loop_count+=1;
				if (loop_count > 100000) {
					show_debug_message("too many loops at line 177, aborting")
					break;
				}
			}
			loop_count=0
			
			//bonking
			if object_index == oPlayer{
				//Hitting / Bumping blocks
				VinylPlay(snd_blockbump)
				sig.Emit("ceil_bonk")
				var _list = ds_list_create();
				var _num = collision_line_list(posx+left, posy+top-1+vsp, posx+right, posy+top-1+vsp, oHittable, false, true, _list, true);
				if (_num > 0) {
					var i=0;
					repeat (_num) {
						with(_list[| i]) if !(no_hit) {
							dummyTimer = dummyTimerReset;
							blockHit.Emit(-1, other.id)
						}
						i++;
					}
				}
				ds_list_destroy(_list);
			}
			
			colflags |= COL_CEILI;
			vsp = 2
		}
	}
	
	//normal ground loop (for a variety of slopes
	if grounded {
		
		if (vsp > 0)
		{
			colflags |= COL_FLOOR;
		}
		//gets angle so it doesnt jitter
		get_angle_rect(posx+left,posy+bottom-2,posx+right,posy+bottom + 3)
		
		var offsetx, offsety, nopoly;
		
		offsetx = xprevious - x
		offsety = yprevious - y
		
		if (!variable_instance_exists(self,"polyfloor"))
		{
			nopoly = true;
		}
		else
		{
			nopoly = (!abs(polyfloor[1]));
		}
		
		//fall
		if (!check_collision_rectangle(posx+left,posy+bottom,posx+right,posy+bottom + 15 , COL_BOTTOM)){
				if (nopoly)
				{
					vsp = gsp * -dsin(colangle)
					hsp = gsp * dcos(colangle)
					grounded = false
					colflags &= ~(COL_FLOOR);
					colangle = 0
					colslope = 0
				}
				exit;
			}
			
	}
		
		
	if grounded && (shoveOutOfWalls) {
		
		var shove = 0;
		//move down
		if (check_collision_rectangle(posx+left,posy+bottom,posx+right,posy+bottom + 15 , COL_BOTTOM)){   
			while !check_collision_line(posx+left,posy+bottom,posx+right,posy+bottom, COL_BOTTOM){
				y ++ 
				posy = y
				shove++;
				loop_count+=1
				if (loop_count > 100000) {
					show_debug_message("too many loops at line 257, aborting")
					break;
				}
			}
			loop_count = 0
		}
		
		//move up
		while check_collision_line(posx+left,posy+bottom, posx+right, posy+bottom, COL_BOTTOM) {
			y -- 
			posy = y
			shove--;
			loop_count+=1
			if (loop_count > 100000) {
				show_debug_message("too many loops at line 271, aborting")
				break;
			}
		}
		loop_count = 0
		
		if object_index == oPlayer{
			shove = 0;
		}
	}

}