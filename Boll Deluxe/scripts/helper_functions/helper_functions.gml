/// global helper functions

function obj_place_meeting(src,x,y,obj)
{
	var meet = false;
	
	with(src)
	{
		meet = place_meeting(x,y,obj);
	}
	
	return meet;
}

function obj_get_coll(src,_x,_y)
{
	var walls, wnum, wall, whit;
	
	whit = noone;
	
	walls = ds_list_create();
	
	with(src)
		wnum = instance_place_list(_x, _y, oCollider,walls,false);
	
	if (wnum > 0)
	{
	    for (var i = 0; i < wnum; ++i;)
	    {
	        wall = (walls[| i]);
			
			if (wall.no_collide)
				continue;
			
			whit = wall;
			break;
		}
	}
	
	// avoid memleaks
	ds_list_destroy(walls);
	
	return whit;
}