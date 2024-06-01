// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro COL_TOP 1
#macro COL_WALL 2
#macro COL_BOTTOM 3


#macro COL_DOT 1
#macro COL_LINE 2

function check_collision_dot(x1, y1, type = 0, object = oCollider){
    
    x1 = round(x1)
    y1 = round(y1)
    
    var found = noone
    
    if collision_point(x1 ,y1,object,true,true)    {
	    var found_list = ds_list_create()
	    var found_size = collision_point_list(x1 ,y1,object,true,true, found_list, true)
    
	    for (var i = 0; i < found_size; ++i) {    
	        found = found_list[| i];
	        if (instance_exists(found)) && (!found.no_collide) { 
	            switch type {
	                case 0:
	                    //awesome
	                break;
	                case COL_BOTTOM:
	                    if found.slope { 
	                        colslope = found.slope_factor * (-1 + (found.hflip* 2))
	                        //show_debug_message(found.angle)
	                        colangle = found.angle
	                        steep_slope = abs(found.image_yscale) > abs(found.image_xscale) //probably replace this with a factor check?
	                    }else{
	                        colslope = 0
	                        steep_slope = 0
	                        colangle = 0
	                    }
	                    ds_list_destroy(found_list)
	                    return found;    
	                break;
	                case COL_WALL:
	                    if !found.semi {
	                        ds_list_destroy(found_list)
	                        return found;
	                    }
	                break;
	                case COL_TOP:
	                    if !found.semi {
	                        ds_list_destroy(found_list)
	                        return found;
	                    }
	                break;
	            }

	        }
        
	    }
        ds_list_destroy(found_list)
    }
    //return false;
} 

function check_collision_line(x1, y1, x2, y2, type = 0, object = oCollider){
	
	x1 = round(x1)
	x2 = round(x2)
	y1 = round(y1)
	y2 = round(y2)
	
	var found = noone
	var found_list = ds_list_create()
	
	if collision_line_list(x1 ,y1,x2, y2, object,true,true, found_list, true)	{
	
	var found_length = ds_list_size(found_list)
	
	for (var i = 0; found_length; ++i) {
		    // code here
		found = found_list[| i]
		//the nefarious
		
		//if !instance_exists(found) {
		//	break;
		//}
		
		
			if found.no_collide { 
				
				break;
			}
		
	
		//if found != noone{
			switch type {
				case 0:
					//awesome
				break;
				case COL_BOTTOM:
					if found.slope { 
						colslope = found.slope_factor * (-1 + (found.hflip* 2))
						//show_debug_message(found.angle)
						colangle = found.angle
						steep_slope = abs(found.image_yscale) > abs(found.image_xscale) //probably replace this with a factor check?
					}else{
						colslope = 0
						steep_slope = 0
						colangle = 0
					}
					ds_list_destroy(found_list)
					return found;
				break;
				case COL_WALL:
					if !found.semi {
						ds_list_destroy(found_list)
						return found;
					}
				break;
				case COL_TOP:
					if !found.semi {
						ds_list_destroy(found_list)
						return found;
					}
				break;
			}
		//}
		
		//if found != noone {
		//	ds_list_destroy(found_list)
		//	return found;	
		//}
		//exit found;
		break;
		}
	}
	return false;
}