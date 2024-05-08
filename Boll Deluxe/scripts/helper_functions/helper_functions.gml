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

function unreal(str, defaultval) {
	var res,l,c,i,valid,dot;
	res="" valid=0 dot=0 l=string_length(str)
	for (i=1;i<=l;i+=1) {
	    c=string_char_at(str,i)
	    if (c="," || c=".") {res+="." if (dot) {valid=0 break} dot=1}
	    else if (string_pos(c,"0123456789")) {res+=c valid=1}
	    else if (res="" && c="-") res="-"
	}
	if (valid) return real(res)
	return defaultval
}

function nozerounreal(str, defaultval) {
	var res,l,c,i,valid,dot;
	res="" valid=0 dot=0 l=string_length(str)
	for (i=1;i<=l;i+=1) {
	    c=string_char_at(str,i)
	    if (c="," || c=".") {res+="." if (dot) {valid=0 break} dot=1}
	    else if (string_pos(c,"0123456789")) {res+=c valid=1}
	    else if (res="" && c="-") res="-"
	}
	if (valid && (real(res)!=0)) return real(res)
	return defaultval
}

function split_string(str, divider){
	var len = string_length(str);
	
	var subStr = "";
	var arrIndex = 0;
	var arr=[];
	for (var i = 1; i <= len; i++)
	{
		var char = string_char_at(str, i);
		if (char != divider)
		{
			//add char to substring
			subStr += char;
		}
		else
		{
			//ensure substring is not empty. 
			if(string_length(subStr) > 0)
			{
				//add substring to array
				arr[arrIndex] = subStr;
				arrIndex++;
				//clear substring
				subStr = "";
			}
		}
	}
		//Add final substring to array
		if(string_length(subStr) > 0)
		{
			arr[arrIndex] = subStr;
		}
	if arr == undefined
	return 1
	else
	return arr;
}
