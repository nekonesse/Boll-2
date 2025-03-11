function slope_set_rise_run(obj)
{
    var rs, rn;
	rn = (bbox_right - bbox_left);
	rs = (bbox_bottom - bbox_top);
	
	obj.rise = rs;
	obj.run = rn;
	obj.slope_factor = rs/rn;
	
	if !obj.rounded {
		obj.angle = point_direction(0, 16*image_yscale, 16*image_xscale, 0)
		if (hflip) obj.angle += 180
	} else {
		obj.angle=0;
	}
}