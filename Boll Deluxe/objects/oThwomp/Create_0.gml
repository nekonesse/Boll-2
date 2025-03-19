event_inherited();

enemyFireballed.Connect( self, function(proj, hit_p) {
	instance_destroy(proj);
});

state = 0;
frame = 0;
timer_offset = 0;

hit_sizex=14;
hit_sizey=14;