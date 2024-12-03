// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function on_screen(RegionW = 16, RegionH = 16) {
	var c, cx, cy, sw, sh;
	c = view_camera[view_current]
	cx = camera_get_view_x(c)
	cy = camera_get_view_y(c)
	sw = camera_get_view_width(c);
	sh = camera_get_view_height(c);
 
	if(x-hit_sizex > cx-RegionW && x+hit_sizex < cx + sw +  RegionW && y+hit_sizey > cy - RegionH && (y-hit_sizey < cy + sh+RegionH)) 
	{
		return true;
	}
	else return false;
}


function origin_on_screen(origin_x = xstart, origin_y = ystart, RegionW = 16, RegionH = 16) {
	var c, cx, cy, sw, sh;
	c = view_camera[view_current]
	cx = camera_get_view_x(c)
	cy = camera_get_view_y(c)
	sw = camera_get_view_width(c);
	sh = camera_get_view_height(c);
 
	if(origin_x > cx-RegionW && origin_x < cx + sw +  RegionW && origin_y > cy - RegionH && (origin_y < cy + sh+RegionH)) 
	{
		return true;
	}
	else return false;
}