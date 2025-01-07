// Inherit the parent event
event_inherited();

instance_activate_object(oPipe)
parent_pipe=collision_point(x,y+hit_sizey+24,oPipe,false,true)
if (parent_pipe) {
	xstart=parent_pipe.x
	ystart=parent_pipe.y
	x=xstart
	y=ystart
}