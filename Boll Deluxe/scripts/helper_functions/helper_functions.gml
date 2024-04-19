/// global helper functions

function check_signs_matching(a, b)
{
    var fa = intlib_make_fixedpoint(a);
    var fb = intlib_make_fixedpoint(b);

    var asign, bsign;

    asign = ((fa >= 0) ? 1 : 0);
    bsign = ((fb >= 0) ? 1 : 0);

    return (asign == bsign);
}

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

function instance_valid_at_position(_x,_y,obj,src = self)
{
	var objs, onum, o, ohit;
	
	ohit = noone;
	
	objs = ds_list_create();
	
	with (src)
		onum = instance_position_list(_x, _y, oCollider,objs,false);
	
	if (onum > 0)
	{
	    for (var i = 0; i < onum; ++i;)
	    {
	        o = (objs[| i]);
			
			if (o.no_collide)
				continue;
			
			ohit = o;
			break;
		}
	}
	
	// avoid memleaks
	ds_list_destroy(objs);
	
	return ohit;
}

function instance_valid_at_place(_x,_y,obj,src = self)
{
	var objs, onum, o, ohit;
	
	ohit = noone;
	
	objs = ds_list_create();
	
	with (src)
		onum = instance_place_list(_x, _y, oCollider,objs,false);
	
	if (onum > 0)
	{
	    for (var i = 0; i < onum; ++i;)
	    {
	        o = (objs[| i]);
			
			if (o.no_collide)
				continue;
			
			ohit = o;
			break;
		}
	}
	
	// avoid memleaks
	ds_list_destroy(objs);
	
	return ohit;
}

// isin_S4
// modified form of cearn's isin_S4 (https://www.coranac.com/2009/07/sines/)
// outputs a Q16 sine value instead of Q12
// (in layperson's terms: max value is 65536 and not 4096)
function isin_S4(u)
{
    var c, v;
    var qN = 14, qA = 16, B = 39800, C = 1758;

    c = make_s32(u << (30 - qN));    // Semi-circle info into carry.
    u -= 1 << qN;                    // sine -> cosine calc

    u = make_s32(u << (31 - qN));    // Mask with PI
    u = u >> (31 - qN);              // Note: SIGNED shift! (to qN)
    u = u * u >> (2 * qN - 14);      // u=u^2 To Q14

    v = B - (u * C >> 12);           // B - u^2*C
    v = (1 << qA) - (u * v >> 13);   // A - u^2*(B-u^2*C)

    return c >= 0 ? v : -v;
}

// a cosine with this function is simply to offset it by 90 degrees
function icos_S4(u)
{
	return isin_S4(u + 0x4000);
}

// sin_S4
// fourth-order sine
function sin_S4(radian_angle)
{
	var irad = round(radian_angle * 10430.378);

	var _isin = isin_S4(irad);

	return _isin / 65536;
}

// cos_S4
// fourth-order cosine
function cos_S4(radian_angle)
{
	var irad = round(radian_angle * 10430.378);

	var _icos = icos_S4(irad);

	return _icos / 65536;
}