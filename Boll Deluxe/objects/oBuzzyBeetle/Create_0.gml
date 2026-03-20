// Inherit the parent event
event_inherited();

start_hit_sizex = 6;
start_hit_sizey = 6;
hit_sizex = start_hit_sizex;
hit_sizey = start_hit_sizey;
targeting_player = noone;

ceiling_falling = false;

ceiling = noone;
in_shell = 0;

koopaEscapeShell.Connect( self, function() {
	ysc=1;
});