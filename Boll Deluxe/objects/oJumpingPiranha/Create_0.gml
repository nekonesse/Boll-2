// Inherit the parent event
event_inherited();

travel=0; //the the manipulated coordinate within the pipe
timer=120;
go=0.5; //whether or not it should go up the pipe
exposed=false; //when it has fully exited the pipe
vsp=-5;
hit_sizey=8;
is_shy = true;

dojump = false;

fall_sprite=spr_jumpingpiranhafall
fly_sprite=spr_jumpingpiranhafly

depth = oGameManager.piping_object_depth