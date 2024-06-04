/// @description init


event_inherited()
// chearii: about time we rip off the bandaid on this
// currently is ONLY semisolid and I can only see full-solid slopes being polygons

hflip = false;
slope = true;
influence = true;
LDtkReloadFields();

if hflip = true {
	image_xscale = image_xscale * -1
	x -= sprite_width 
	}
slope_set_rise_run(self);
//no_collide = false;

angle = floor(point_direction(x,y+sprite_height,x+(sprite_width*sign(image_xscale)),y))*sign(image_xscale)
jagged = (image_yscale * sign(image_yscale) > 1 && image_xscale * sign(image_xscale) > 1)