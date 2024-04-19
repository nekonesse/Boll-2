/// @description init


event_inherited()
// chearii: about time we rip off the bandaid on this
// currently is ONLY semisolid and I can only see full-solid slopes being polygons

hflip = false;
slope = true
LDtkReloadFields();

if hflip = true {
	image_xscale = image_xscale * -1
	x -= sprite_width 
	}
slope_set_rise_run(self);
//no_collide = false;

