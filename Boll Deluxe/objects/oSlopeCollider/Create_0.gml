/// @description init


event_inherited()

hflip = false;
slope = true;
influence = true;
ramp = false;
LDtkReloadFields();

if hflip = true {
	image_xscale *= -1;
	x -= sprite_width + 0.5
}

angle = floor(point_direction(x,y+sprite_height,x+(sprite_width*sign(image_xscale)),y))*sign(image_xscale)
jagged = (image_yscale * sign(image_yscale) > 1 && image_xscale * sign(image_xscale) > 1)