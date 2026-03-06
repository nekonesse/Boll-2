// Inherit the parent event
event_inherited();

if (active) {
	pal=wrap_val(pal+0.2,1,6);
	lifespan=max(lifespan-1,0);
	
	if !(lifespan) {
		make_particle(pSmoke,x,y);
		instance_destroy();
	}
}