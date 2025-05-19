if collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,oDeactivationRegion,false,true) && !on_screen(32,32) {
	instance_destroy();
}