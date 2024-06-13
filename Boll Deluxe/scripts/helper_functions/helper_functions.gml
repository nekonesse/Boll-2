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

function modulo(value,lower,upper){
	///modulo(value,lower,upper):value
	//keeps a value within supplied range warping in both ways (lower incl, upper excl)
	var o,d,w;

	o=lower
	d=value-o
	w=upper-o

	if (w=0) return o
	return d-floor(d/w)*w+o
}

//legacy support
function instance_create(_x,_y,obj){
	return instance_create_depth(_x,_y,0,obj)
}

function draw_text_outline(_x,_y,str,outwidth,outcol,outfidelity,xscale,yscale,angle){
	//x,y: Coordinates to draw
	//str: String to draw
	//outwidth: height of outline in pixels
	//outcol: Colour of outline (main text draws with regular set colour)
	//outfidelity: Fidelity of outline (recommended: 4 for small, 8 for medium, 16 for larger. Watch your performance!)
	//separation, for the draw_text_EXT command.
	//height for the draw_text_EXT command.


	//2,c_dkgray,4,20,500 <Personal favorite preset. (For fnt_3)
	var dto_dcol=draw_get_color();

	draw_set_color(outcol);

	for(var dto_i=45; dto_i<405; dto_i+=360/outfidelity)
	{
	  //draw_text_ext(_x+lengthdir_x(outwidth,dto_i),_y+lengthdir_y(outwidth,dto_i),str,width,height);
	  draw_text_transformed(_x+round(lengthdir_x(outwidth,dto_i)),_y+round(lengthdir_y(outwidth,dto_i)),str,xscale,yscale,angle);
	}

	draw_set_color(dto_dcol);

	draw_text_transformed(_x,_y,str,xscale,yscale,angle);
}

function nearestplayer(){
	//returns nearest player instance
	var ret,xp;
	xp=x
	x=-999999999
	ret=instance_nearest(xp,y,oPlayer)
	x=xp
	return ret;
}

function LoadJSONFromFile(_fileName) {
    //@desc load json from file

    var buffer = buffer_load( _fileName );
    var _string = buffer_read(buffer,buffer_string);
    buffer_delete(buffer);

    var _json = json_parse(_string);
    return _json;

}

function SaveStringToFile(_fileName, _string) {
    //@description save string to file of choice
    
    var _buffer = buffer_create( string_byte_length(_string)+1, buffer_fixed, 1);
    buffer_write(_buffer,buffer_string,_string)
    buffer_save(_buffer,_fileName)
    buffer_delete(_buffer)
}

function esign(val,_default){
	if (val==0) return _default
	return sign(val)
}

function inview(obj = undefined) {
	if (obj != undefined)
	{
		with(obj)
		{
			var cam = view_camera[0];
			var x1 = camera_get_view_x(cam);
			var y1 = camera_get_view_y(cam);
			var x2 = x1 + camera_get_view_width(cam);
			var y2 = y1 + camera_get_view_height(cam);
		
			if(point_in_rectangle(x,y, x1-32, y1-32, x2+32, y2+32)) {
				return true
			}	
		}
	}
	else
	{
		var cam = view_camera[0];
		var x1 = camera_get_view_x(cam);
		var y1 = camera_get_view_y(cam);
		var x2 = x1 + camera_get_view_width(cam);
		var y2 = y1 + camera_get_view_height(cam);
		
		if(point_in_rectangle(x,y, x1-32, y1-32, x2+32, y2+32)) {
			return true
		}
	}
	
	return false
}

function is_range_onscreen_horizontal(left, right, wport = undefined)
{
	if (view_camera[0] != undefined)
	{
		if (wport == undefined)
			wport = camera_get_view_width(view_camera[0]);
		
		// horizontal
		if ((right < (camera_get_view_x(view_camera[0])) )
			|| (left > (camera_get_view_x(view_camera[0]) + (wport)) ))
			return false;
			
		// we've passed, return true
		return true;
	}
	
	// there's not even a camera, return false by default
	return false;
}

function chance(percent){
	// Returns true or false depending on RNG
	//Chance(0.7);    -> Returns true 70% of the time
	return percent > irandom(1);
}

function jump_in_direction(_spd, _direction){
	x += lengthdir_x(_spd,_direction)
	y += lengthdir_y(_spd,_direction)
}

function approach_val(a, b, amount) {
	// Moves "a" towards "b" by "amount" and returns the result
	// Nice bcause it will not overshoot "b", and works in both directions
	// Example:
	//      x = Approach(x, target_x, move_speed);
	//      y = Approach(y, target_y, move_speed);
 
	if (a < b)
	{
	    a += amount;
	    if (a > b)
	        return b;
	}
	else
	{
	    a -= amount;
	    if (a < b)
	        return b;
	}
	return a;
}

function wrap_val(value, _min, _max) {
	// Returns the value wrapped, values over or under will be wrapped around
 
	if (value mod 1 == 0)
	{
	    while (value > _max || value < _min)
	    {
	        if (value > _max)
	            value += _min - _max - 1;
	        else if (value < _min)
	            value += _max - _min + 1;
	    }
	    return(value);
	}
	else
	{
	    var vOld = value + 1;
	    while (value != vOld)
	    {
	        vOld = value;
	        if (value < _min)
	            value = _max - (_min - value);
	        else if (value > _max)
	            value = _min + (value - _max);
	    }
	    return(value);
	}
}

function wave_val(from, to, duration, offset=0) {
	// Returns a value that will wave back and forth between [from-to] over [duration] seconds
	// Example
	//      image_angle = Wave(-45,45,1,0)  -> rock back and forth 90 degrees in a second
 
	var a4 = (to - from) * 0.5;
	return from + a4 + sin((((global.roomTimer * 0.015) + duration * offset) / duration) * (pi*2)) * a4;
}

function ternary(statement,true_val,false_val) {
	return ((statement) ? true_val : false_val)
}