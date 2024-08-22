// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro COL_TOP 1
#macro COL_WALL 2
#macro COL_BOTTOM 3


#macro COL_DOT 1
#macro COL_LINE 2

function check_collision_dot(x1, y1, type = 0, object = collision_array){
    
    //var found = noone
    x1 = floor(x1)
	y1 = floor(y1)
    if collision_point(x1,y1,object,true,true)    {
	    var found_list = ds_list_create()
	    var found_size = collision_point_list(x1,y1,object,true,true, found_list, false)
    
	    for (var i = 0; i < found_size; ++i) {    
	        var found = found_list[| i];
	        if (!found.no_collide) { 
	          if (type != COL_BOTTOM && !found.semi) || (type == COL_BOTTOM) {
					if found.slope { 
						colslope = found.slope_factor * (-1 + (found.hflip* 2))
	                }else{
						colslope = 0
	                }
					ds_list_destroy(found_list)
	                return true;
			  }
			}
	    }
        ds_list_destroy(found_list)
    }
    //return false;
} 

function check_collision_line(x1, y1, x2, y2, type = 0, object = collision_array){
	x1 = floor(x1)
	y1 = floor(y1)
	x2 = floor(x2)
	y2 = floor(y2)
	//var found = noone
	
	if collision_line(x1 ,y1,x2, y2, object,true,true)    {
	    var found_list = ds_list_create()
	    var found_size = collision_line_list(x1 ,y1,x2, y2, object,true,true, found_list, false)
    
	    for (var i = 0; i < found_size; ++i) {    
	        var found = found_list[| i];
	        if (!found.no_collide) { 
	          if (type != COL_BOTTOM && !found.semi) || (type == COL_BOTTOM){
					if found.slope { 
						colslope = found.slope_factor * (-1 + (found.hflip* 2))
	                }else{
						colslope = 0
	                }
					ds_list_destroy(found_list)
	                return true;
			  }
			}
	    }
        ds_list_destroy(found_list)
    }

}

function check_collision_rectangle(x1, y1, x2, y2, type = 0, object = collision_array){
	x1 = floor(x1)
	y1 = floor(y1)
	x2 = floor(x2)
	y2 = floor(y2)
	//var found = noone
	
	if collision_rectangle(x1 ,y1,x2, y2, object,true,true)    {
	    var found_list = ds_list_create()
	    var found_size = collision_rectangle_list(x1 ,y1,x2, y2, object,true,true, found_list, false)
    
	    for (var i = 0; i < found_size; ++i) {    
	        var found = found_list[| i];
	        if (!found.no_collide) { 
	          if (type != COL_BOTTOM && !found.semi)|| (type == COL_BOTTOM) {
					if found.slope { 
						colslope = found.slope_factor * (-1 + (found.hflip* 2))
	                }else{
						colslope = 0
	                }
					ds_list_destroy(found_list)
	                return true;
			  }
			}
	    }
        ds_list_destroy(found_list)
    }

}

function get_angle_line(x1, y1, x2, y2){
	x1 = floor(x1)
	y1 = floor(y1)
	x2 = floor(x2)
	y2 = floor(y2)
	//var found = noone
	
	var object = collision_array
	
	if collision_line(x1 ,y1,x2, y2, object,false,true)    {
	    var found_list = ds_list_create()
	    var found_size = collision_line_list(x1 ,y1,x2, y2, object,false,true, found_list, true)

    
	    for (var i = 0; i < found_size; ++i) {    
	        var found = found_list[| i];
	        if (!found.no_collide) { 
	          
				if found.slope { 
					colangle = found.angle
	            }else{
					colangle = 0
	            }
				ds_list_destroy(found_list)
	            return true;
			  
			}
	    }
        ds_list_destroy(found_list)
    }

}