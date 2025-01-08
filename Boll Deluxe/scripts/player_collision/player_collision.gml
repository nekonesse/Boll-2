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

function basic_step_move(iterations = 4){
    /*var true_hsp = hsp
    var true_vsp = vsp
    
    repeat(iterations) {
        x += hsp /iterations
        y += vsp /iterations
        
        player_interactions();
        player_collision();
    }
   */
    player_interactions();
    player_collision();
}


function player_collision(shoveOutOfWalls=true,auto_coords=true,l=0,r=0,t=0,b=0,c = 0){
	
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
	
	var _subPixel = 0.25;
	if place_meeting(x+hsp, y, collision_array) {
		if !place_meeting(x+hsp, y-abs(hsp*2)-1, collision_array) {
			while place_meeting(x+hsp, y, collision_array) { //climbing up slope
				y -= _subPixel;
				myFloorPlat=instance_place(x+hsp, y, collision_array)
			}
		} else {
			if !place_meeting(x+hsp, y+abs(hsp*2)+1, collision_array) {
				while place_meeting(x+hsp, y, collision_array) { //climbing down ceiling slopes
					y+= _subPixel;
				}
			} else {
				var _pixelCheck = _subPixel * sign(hsp) //stop at all
				while !place_meeting(x+_pixelCheck, y, collision_array) {
					x += _pixelCheck;	
				}
	
				hsp = 0;
			}
		}
	}

	if (vsp >= 0) && !place_meeting(x+hsp, y+1, collision_array) && place_meeting(x+hsp, y+abs(hsp*2), collision_array) { //climbing down slope
		while !place_meeting(x+hsp, y+_subPixel, collision_array) {
			y += _subPixel;
		}
	}

	x += hsp;

	var _clampVsp = max(0, vsp);
	var _list = ds_list_create();

	var _num = instance_place_list(x, y+_clampVsp+1, collision_array, _list, false);

	if _num > 0 {
		for (var i = 0; i < _num; ++i) {
		   var _inst = _list[| i];
	   
		   if place_meeting(x, y+1+_clampVsp, _inst) || (_inst.vsp <= vsp || instance_exists(myFloorPlat)) || (_inst.vsp >= 0) {
			   var _isWall = !_inst.semi
		   
			   if _isWall || floor(bbox_bottom) <= ceil(_inst.bbox_top-_inst.vsp) {
				   if !instance_exists(myFloorPlat) 
				   || ((_inst.bbox_top + _inst.vsp == myFloorPlat.bbox_top + myFloorPlat.vsp) && !_isWall)
				   || (_inst.bbox_top + _inst.vsp > myFloorPlat.bbox_top + myFloorPlat.vsp)
				   || (_inst.bbox_top + _inst.vsp > myFloorPlat.bbox_top + myFloorPlat.vsp)
				   || (_inst.bbox_top + _inst.vsp <= bbox_bottom) {
					   myFloorPlat = _inst;
				   }
			   }
		   } else continue
		}
	}

	ds_list_destroy(_list);

	if instance_exists(myFloorPlat) && !place_meeting(x, y+1, myFloorPlat) {
		myFloorPlat = noone;
	}

	if instance_exists(myFloorPlat) {
		while !place_meeting(x, y+_subPixel, myFloorPlat) && !place_meeting(x,y,collision_array) {
			y += _subPixel;
		}
		
		while place_meeting(x,y,myFloorPlat) {
			y -= _subPixel;
		}
	
		y = floor(y);
		if (object_index==oPlayer) && (vsp!=0) sig.Emit("floor_land")
		vsp = 0;
		grounded = true;
	} else {
		grounded = false;
		myFloorPlat = noone;
	}

	if vsp < 0 {
		if place_meeting(x,y+vsp, collision_array) {
			var _slopeSlide = false;
		
			if !(_slopeSlide) {
				var _pixelCheck = _subPixel * sign(vsp);
				while !(place_meeting(x, y+_pixelCheck, collision_array)) {
					y += _pixelCheck;
				}
				
				if (object_index==oPlayer) && (vsp!=0) sig.Emit("floor_land")
				vsp = 0;
			}
		}
	}

	y += vsp;

	moveplathsp = 0;
	if instance_exists(myFloorPlat) {
		moveplathsp = myFloorPlat.hsp;
	}

	if place_meeting(x+moveplathsp, y, collision_array) {
		var _pixelCheck = _subPixel * sign(moveplathsp);
		while !place_meeting(x+_pixelCheck, y, collision_array) {
			 x+=_pixelCheck;
		}
	
		moveplathsp = 0;
	}
	x += moveplathsp;

	if instance_exists(myFloorPlat) && (myFloorPlat.vsp != 0) {
		if !place_meeting(x, myFloorPlat.bbox_top, collision_array) 
		&& myFloorPlat.bbox_top >= bbox_bottom {
			y = myFloorPlat.bbox_top;
		}
	
		if myFloorPlat.vsp < 0 && place_meeting(x,y+myFloorPlat.vsp, collision_array) {
			if myFloorPlat.object_index == obj_semi || object_is_ancestor(myFloorPlat.object_index, obj_semi) {
				while place_meeting(x, y+myFloorPlat.vsp, collision_array) {
					y+=_subPixel;
				}
			
				while place_meeting(x,y, collision_array) {
					y-=_subPixel;
				}
				y=round(y);
			}
		
			//myFloorPlat = noone;
			grounded = false;
		}
	}

	if (grounded) {
		gsp=hsp
	}

}