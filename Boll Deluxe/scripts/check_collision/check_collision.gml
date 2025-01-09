// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro COL_TOP 1
#macro COL_WALL 2
#macro COL_BOTTOM 3

// YI collision flags, mainly used for post-collision checks
#macro COL_FLOOR 1
#macro COL_CEILI 2
#macro COL_LWALL 4
#macro COL_RWALL 8
#macro COL_VERTI 3
#macro COL_HORIZ 12


#macro COL_DOT 1
#macro COL_LINE 2

#macro MAX_POLYCHECK_TIME 6
#macro POLYFLOOR_TIME 8

function check_collision_dot(x1, y1, type = 0, object = collision_array){
    
    if collision_point(floor(x1),floor(y1),object,true,true)    {
	    var found_list = ds_list_create()
	    var found_size = collision_point_list(floor(x1),floor(y1),object,true,true, found_list, false)
    
	    for (var i = 0; i < found_size; ++i) {    
	        var found = found_list[| i];
	        if (!found.no_collide) { 
				if (type == COL_TOP || !found.ceiling_only) {
		          if (type != COL_BOTTOM && !found.semi) || (type == COL_BOTTOM) {
						//if found.slope {
							//if !(found.rounded) {
								//colslope = found.slope_factor * (-1 + (found.hflip * 2))
							//} else {
								//var new_rise=point_distance(x,y,x,found.bbox_bottom)
								//var new_run=point_distance(x,y,found.x,y)
								//var new_slope_factor=new_rise/new_run
								//colslope = new_slope_factor * (-1 + (found.hflip * 2))
							//}
		                //}else{
							//colslope = 0
		                //}
						ds_list_destroy(found_list)
		                return true;
				  }
				}
			}
	    }
        ds_list_destroy(found_list)
    }
    return false;
} 

function check_collision_line(x1, y1, x2, y2, type = 0, object = collision_array){
	//var found = noone
	
	if collision_line(floor(x1),floor(y1),floor(x2), floor(y2), object,true,true)    {
	    var found_list = ds_list_create()
	    var found_size = collision_line_list(floor(x1),floor(y1),floor(x2), floor(y2), object,false,true, found_list, false)
    
	    for (var i = 0; i < found_size; ++i) {    
	        var found = found_list[| i];
		     if (!found.no_collide) {
				if (type == COL_TOP || !found.ceiling_only) {
		          if (type != COL_BOTTOM && !found.semi) || (type == COL_BOTTOM){
						//if found.slope { 
							//if !(found.rounded) {
								//colslope = found.slope_factor * (-1 + (found.hflip * 2))
							//} else {
								//var new_rise=point_distance(x,y,x,found.bbox_bottom)
								//var new_run=point_distance(x,y,found.x,y)
								//var new_slope_factor=new_rise/new_run
								//colslope = new_slope_factor * (-1 + (found.hflip * 2))
							//}
		                //}else{
							//colslope = 0
		                //}
						ds_list_destroy(found_list)
		                return true;
				  }
				}
			}
	    }
        ds_list_destroy(found_list)
    }
	return false;
}

function check_collision_rectangle(x1, y1, x2, y2, type = 0, object = collision_array){
	//var found = noone
	
	var bestobj = noone;
	
	if collision_rectangle(floor(x1) ,floor(y1),floor(x2),floor( y2), object,true,true)    {
	    var found_list = ds_list_create()
	    var found_size = collision_rectangle_list(floor(x1),floor(y1),floor(x2), floor(y2), object,true,true, found_list, false)
    
	    for (var i = 0; i < found_size; ++i) {    
	        var found = found_list[| i];
	        if (!found.no_collide) { 
				if (type == COL_TOP || !found.ceiling_only) {
		          if (type != COL_BOTTOM && !found.semi)|| (type == COL_BOTTOM) {
						//if found.slope { 
							//if !(found.rounded) {
								//colslope = found.slope_factor * (-1 + (found.hflip * 2))
							//} else {
								//var new_rise=point_distance(x,y,x,found.bbox_bottom)
								//var new_run=point_distance(x,y,found.x,y)
								//var new_slope_factor=new_rise/new_run
								//colslope = new_slope_factor * (-1 + (found.hflip * 2))
							//}
		                //}else{
							//colslope = 0
		                //}
					
                        ds_list_destroy(found_list) 
                        return true;
				  }
				}
			}
	    }
        ds_list_destroy(found_list)
    }
	return false;
}

 function get_angle_rect(x1, y1, x2, y2){
	//var found = noone
	
	var object = collision_array
	
	if collision_rectangle(floor(x1) ,floor(y1),floor(x2), floor(y2), object,false,true)    {
	    var found_list = ds_list_create()
	    var found_size = collision_rectangle_list(floor(x1) ,floor(y1),floor(x2), floor(y2), object,false,true, found_list, true)

    
	    for (var i = 0; i < found_size; ++i) {    
	        var found = found_list[| i];
	        if (!found.no_collide) { 
	          
				if found.slope {
					if !found.rounded {
						colangle = found.angle
                        colslope = found.slope_factor * (-1 + (found.hflip * 2))
					} else {
                        var new_rise=point_distance(x,y,x,found.bbox_bottom)
                        var new_run=point_distance(x,y,found.x,y)
                        var new_slope_factor=new_rise/new_run
                        colslope = new_slope_factor * (-1 + (found.hflip * 2))
						if !found.hflip {
							colangle = 360-point_direction(x,y,found.x,found.y) //basically we have to flip it diagonally, so we minus the angle by 360 to get the 'reverse' angle
						} else {
							colangle = 360-(point_direction(x,y,found.x,found.y)+180)
						}
					}
	            }else{
                    colslope = 0
					colangle = 0
	            }
				ds_list_destroy(found_list)
	            return true;
			  
			}
	    }
        ds_list_destroy(found_list)
    }
	return false;
}


function check_hitbox_on_hitbox(object1, object2){
	//var found = noone
	if !instance_exists(object1) || !instance_exists(object2) exit;
	
	var x1, x2, y1, y2, hit_sizex2, hit_sizey2
	x1 = floor(object1.x)
	y1 = floor(object1.y)
	
	if (instance_number(object2) > 0) {
	    for (var i = 0; i < instance_number(object2); ++i) {    
	        var found = instance_find(object2, i);
			x2 = floor(found.x)
			y2 = floor(found.y)
			hit_sizex2 = found.hit_sizex
			hit_sizey2 = found.hit_sizey
	        if rectangle_in_rectangle(x1 - hit_sizex,y1 - hit_sizey,x1 + hit_sizex,y1 + hit_sizey, x2 - hit_sizex2, y2 - hit_sizey2, x2 + hit_sizex2, y2 + hit_sizey2) {
	            return found;
			}
	    }
    }
	return noone;
}

function check_rectangle_in_hitbox(x1, y1, x2, y2, object){
	//var found = noone
	if !instance_exists(object) exit;
	
	var x3, y3, hit_sizex2, hit_sizey2
	
	if (instance_number(object) > 0) {
	    for (var i = 0; i < instance_number(object); ++i) {    
	        var found = instance_find(object, i);
			x3 = floor(found.x)
			y3 = floor(found.y)
			hit_sizex2 = found.hit_sizex
			hit_sizey2 = found.hit_sizey
	        if rectangle_in_rectangle(x1,y1,x2,y2, x3 - hit_sizex2, y3 - hit_sizey2, x3 + hit_sizex2, y3 + hit_sizey2) {
	            return found;
			}
	    }
    }
	return noone;
}

function check_collision_place(x1, y1, type = 0, object = collision_array){
    
    if place_meeting(x1,y1,object)    {
	    var found_list = ds_list_create()
	    var found_size = instance_place_list(x1,y1,object,found_list, false)
    
	    for (var i = 0; i < found_size; ++i) {    
	        var found = found_list[| i];
	        if (!found.no_collide) { 
				if (type == COL_TOP || !found.ceiling_only) {
		          if (type != COL_BOTTOM && !found.semi) || (type == COL_BOTTOM) {
						//if found.slope {
							//if !(found.rounded) {
								//colslope = found.slope_factor * (-1 + (found.hflip * 2))
							//} else {
								//var new_rise=point_distance(x,y,x,found.bbox_bottom)
								//var new_run=point_distance(x,y,found.x,y)
								//var new_slope_factor=new_rise/new_run
								//colslope = new_slope_factor * (-1 + (found.hflip * 2))
							//}
		                //}else{
							//colslope = 0
		                //}
						ds_list_destroy(found_list)
		                return true;
				  }
				}
			}
	    }
        ds_list_destroy(found_list)
    }
    return false;
} 

// polygon collision

function poly_collide(obj = self, is_player = false)
{
    if (abs(obj.polyfloor[1]))
	{
		obj.polyfloor[1] = max(0, obj.polyfloor[1] - 1);
	}
	
	if (is_player)
	{
		player_update_poly_from_hitsize(obj);	
	}
    else if (obj.sprindex_prev != sprite_index)
    {
        // check to see if we need to update the polybox
		obj_update_poly_from_bounding(obj);
        obj.sprindex_prev = sprite_index;
    }

    var bbb = max(0, sprite_yoffset - 16);

    var topbox = (bbox_top - y) div 1;

    // manage boxpoly
    P_PolygonManager(obj,false,0,0);
    var this = obj;

    // get our polygon vertices
    var verticesA = GetTransformedVertices(obj,false,0,0);

    var clipcheck, clipdiff, clipsave, ynormal, polycos, polyacos, acos_check, docollide, getslope;
	
	getslope = true;

    // polygon collision handle
    with(oPolyCollider)
    {
        if (IntersectPolygons(self,verticesA,GetTransformedVertices(self,true,sprite_xoffset div 1,sprite_yoffset div 1)))
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
                // we can collide, do some checks to make sure we're not clipping
                // TODO: make this play nice with the new collision
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

                // polygon collisions
                if (nrm.Y > 0) // floor
                {
                    // we hit the floor

                    if (this.vsp > 0)
                        this.vsp = 0; // switch this out with whatever vertical speed value you're using

                    this.polyfloor[0] = true;
					this.polyfloor[1] = POLYFLOOR_TIME;

                    // use radtodeg(nrm.X) to get the angle of the floor!
                    // chearii: indeed I will
                    this.colangle = radtodeg(nrm.X);
					
					if (this.object_index == oPlayer)
					{
						if (this.slopesliding)
						getslope = false;	
					}

                    if (getslope)
                    {
                        this.colslope = sign(radtodeg(nrm.X));
                    }
                }
                else if (nrm.Y > 0.2)
                {
                    this.polycheck = min(MAX_POLYCHECK_TIME, this.polycheck + 2);
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
}

function find_camera_bound(x1, y1, x2, y2)
{
	var found = noone;
	
	if collision_rectangle(floor(x1),floor(y1),floor(x2),floor(y2),oCameraBoundary,true,true)
	{
	    var found_list = ds_list_create();
	    var found_size = collision_rectangle_list(floor(x1),floor(y1),floor(x2),floor(y2),oCameraBoundary,true,true,found_list,false);
    
	    for (var i = 0; i < found_size; ++i)
		{    
	        found = found_list[| i];
	    }
        ds_list_destroy(found_list);
    }
	return found;
}

function node_path_movement(movePlayer=true) {
	if !(pathstarted) {
		with(oPlayer) {
			if (grounded) && collision_line(x-hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),x+hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),other,false,true) {
				other.pathstarted=true;
			}
		}
	}
	
	if is_array(pathing) && (pathspd>0) && !(pathfallen) && (pathstarted) { //prevent crashing & a slight optimization
		
		var arr=pathing[pathnum];
	
		if (arr[2]) && !(pathfallen)
		{
			// curved path, handle special behavior
			var dir=point_direction(pathing[pathprenum][0],
									pathing[pathprenum][1],
									arr[0],
									arr[1]);
		
			// first, get the x and y path distances
			var pathx, pathy;
		
			pathx = arr[0] - pathing[pathprenum][0];
			pathy = arr[1] - pathing[pathprenum][1];
		
			show_debug_message(pathy);
		
			// this is very, very dumb
			x+=lengthdir_x(pathspd,dir);
		
			// prevent X from overshooting
			x=median(x,pathing[pathprenum][0],arr[0]);
		
			// get the x difference
			var xdiff;
		
			xdiff = abs(x - pathing[pathprenum][0]);
		
			// do circular easing on the y movement
		
			var curvey = easeMovement(xdiff,max(0.75,abs(pathx))) * pathy;
		
			// clamp y instead of finding the median point
		
			var top, bttm;
		
			top = pathing[pathprenum][1];
			bttm = arr[1];
		
			// FINALLY set the Y value
			y = median(pathing[pathprenum][1] + curvey, top, bttm);
		}
		else
		{
			var dir=point_direction(x,y,arr[0],arr[1]);
			x+=lengthdir_x(pathspd,dir); //move towards the next node
			y+=lengthdir_y(pathspd,dir);
			x=median(x,pathing[pathprenum][0],arr[0]); //prevent overshooting
			y=median(y,pathing[pathprenum][1],arr[1]);
		}
	
		if !floor(point_distance(x,y,arr[0],arr[1])) && !(pathfallen) { //check if we've reached our destination
			x=arr[0]; //snap to our destination just in case we misalign by a margin
			y=arr[1];
			pathprenum=pathnum;
			if !(pathisrev) && !(pathfallen) {
				if ((array_length(pathing)-1) > pathnum) {
					pathnum++ //if there is another node in our path, continue on
				} else {
					if (pathcanrev) { //can we reverse our pathing?
						pathisrev=true;
						pathnum--; //we have reversed direction, go backwards in our pathing
					} else if (pathcanfall) {
						pathfallen=1
						var dir=point_direction(pathing[max(pathprenum-1,0)][0],pathing[max(pathprenum-1,0)][1],arr[0],arr[1]);
						show_debug_message(dir)
						hspeed=lengthdir_x(pathspd,dir)
						show_debug_message(hspeed)
						vspeed=lengthdir_y(pathspd,dir)
						gravity=0.15;
					} else {
						pathnum=0; //stop running the path code, because why would we? we've stopped.
					}
				}
			} else if (pathisrev) {
				if (pathnum==0) { //if we have reached the beginning
					pathisrev=false;
					pathnum++; //we have reversed direction, go forwards in our pathing
				} else { //if not, then continue
					pathnum--;
				}
			}
		}
	}
	
	x_diff = (x - xprevious) + hspeed;
	y_diff = (y - yprevious) + vspeed;
	
	if movePlayer {
		with(oPlayer) {
			if (grounded) && collision_line(x-hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),x+hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),other,false,true) {
				x += other.x_diff;
				y += other.y_diff;
			}
		}
	}
}
