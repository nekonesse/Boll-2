image_xscale=1;
image_yscale=1;

var i=instance_create_depth(x+8,y,0,oPlayer)
instance_destroy();

if (!instance_exists(oTouchControl) && global.touchscreen=1) instance_create(x,y,oTouchControl)