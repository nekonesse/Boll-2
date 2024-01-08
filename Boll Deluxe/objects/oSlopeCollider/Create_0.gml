/// @description init

// chearii: about time we rip off the bandaid on this
// currently is ONLY semisolid and I can only see full-solid slopes being polygons

hflip = false;
LDtkReloadFields();

slope_set_rise_run(self);
no_collide = false;
