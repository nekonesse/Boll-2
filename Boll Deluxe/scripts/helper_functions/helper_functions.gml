/// global helper functions

//
// shove camera macros in here, I have no idea where else to put them
//
#macro CAM_SENSOR_WIDTH 32
#macro CAM_SENSOR_HEIGHT 56
//
// the time it should take in total for the camera to zoom from 0 to 1
// CAM_ZOOM_TIME being 80 means the camera zooms out from 0.5 to 1 in 40 frames
#macro CAM_ZOOM_TIME 80
#macro CAM_ZOOM_RATE (1/CAM_ZOOM_TIME)
//
// stall flags
#macro STALL_X 1
#macro STALL_Y 2
#macro IN_LOCK 4
//
// the target FPS threshold
// ideally, the uncapped FPS should *never* drop below this
#macro FPS_TARGET 300

global.camera_x = 0;
global.camera_y = 0;

function check_signs_matching(a, b)
{
    var fa = intlib_make_fixedpoint(a);
    var fb = intlib_make_fixedpoint(b);

    var asign, bsign;

    asign = ((fa >= 0) ? 1 : 0);
    bsign = ((fb >= 0) ? 1 : 0);

    return (asign == bsign);
}

function check_signs_matching_zero(a, b)
{
	//function that calls check_signs_matching and then performs an additional check for if either value is zero
	//used for replicating old engine accel bug
    var check = check_signs_matching(a, b)
	
	if (a == 0 || b == 0) {
		check = 0	
	}
    return check;
}

function unreal(str, defaultval) {
	var res,l,c,i,valid,dot;
	res="" 
	valid=0 
	dot=0 
	l=string_length(str)
	var i=1;
	repeat(l) {
	    c=string_char_at(str,i)
		i++;
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
	var i=1;
	repeat(l) {
	    c=string_char_at(str,i)
	    if (c="," || c=".") {res+="." if (dot) {valid=0 break} dot=1}
	    else if (string_pos(c,"0123456789")) {res+=c valid=1}
	    else if (res="" && c="-") res="-"
		i++;
	}
	if (valid && (real(res)!=0)) return real(res)
	return defaultval
}

function split_string(str, divider){
	var len = string_length(str);
	
	var subStr = "";
	var arrIndex = 0;
	var arr=[];
	var i=1;
	repeat (len)
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
		i++
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

function update_camerapos()
{
	if (view_camera[0] != undefined)
	{
		global.camera_x = camera_get_view_x(view_camera[0]) div 1;
		global.camera_y = camera_get_view_y(view_camera[0]) div 1;
	}
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

function draw_rect(_x, _y, w, h, color, alpha, outline=false){
	if !outline
	draw_sprite_stretched_ext(spr_1x1,0,_x,_y,w,h,color,alpha)
	else
	draw_sprite_stretched_ext(spr_1x1outline,0,_x,_y,w,h,color,alpha)
}

function lines_intersect(x1,y1,x2,y2,x3,y3,x4,y4,segment) {
    var ua, ub, ud, ux, uy, vx, vy, wx, wy;
    ua = 0;
    ux = x2 - x1;
    uy = y2 - y1;
    vx = x4 - x3;
    vy = y4 - y3;
    wx = x1 - x3;
    wy = y1 - y3;
    ud = vy * ux - vx * uy;
    if (ud != 0) 
    {
        ua = (vx * wy - vy * wx) / ud;
        if (segment) 
        {
            ub = (ux * wy - uy * wx) / ud;
            if (ua < 0 || ua > 1 || ub < 0 || ub > 1) ua = 0;
        }
    }
    return ua;
}

function sprite_check_valid(spr)
{
	return ((spr != undefined) && (sprite_exists(spr)));
}

function point_in_ellipse(x_, y_, _width, _height, x_o, y_o) {
	return (sqr(x_o - x_) / sqr(_width / 2)) + (sqr(y_o - y_) / sqr(_height / 2)) <= 1
}

function easeOutCirc(_x)
{
    return sqrt(1 - ((_x - 1) * (_x - 1)));
}

function easeMovement(_x, xdist)
{
    return easeOutCirc(min(xdist, _x)/xdist);
}

// calls a function from an array
function call_func_from_table(obj, A, idx)
{
    var func = A[max(0, min(array_length(A) - 1, idx))];

    func(obj);
}

// gets cost of morphing sprites
function get_morph_cost()
{
	var raw, pct;
	
	raw = -1;
	pct = -1;
	
	if (variable_global_exists("drawcost") && variable_global_exists("drawcost_pct"))
	{
		raw = global.drawcost;
		pct = global.drawcost_pct;
	}
	
	return [ raw, pct ];
}

function in_water() {
	return bool(collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,oWater,false,true));
}
