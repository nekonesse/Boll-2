image_xscale=1;
image_yscale=1;

if room==rGame {
	instance_create_depth(x+8,y,0,oPlayer)
} else {
	instance_create_depth(x+8,y,0,oWMPlayer)
}

instance_destroy();

if (!instance_exists(oTouchControl) && global.touchscreen=1) instance_create(x,y,oTouchControl)