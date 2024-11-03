///@description JADE variable reload
if hflip = true {
	image_xscale *= -1;
	x -= sprite_width
}
slope_set_rise_run(self)
angle = floor(point_direction(x,y+sprite_height,x+(sprite_width*sign(image_xscale)),y))*sign(image_xscale)
jagged = (image_yscale * sign(image_yscale) > 1 && image_xscale * sign(image_xscale) > 1)