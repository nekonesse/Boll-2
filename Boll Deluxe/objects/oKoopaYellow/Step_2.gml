/// @description Jumping from ledges
event_inherited();

if (global.paused) exit;

if !(in_shell) && (grounded)
{
	if !check_collision_rectangle(x + (_direction * (hit_sizex+1)),y,x + (_direction * (hit_sizex-4)),y+hit_sizey+16, COL_BOTTOM) {
		vsp = -4.65;
		grounded = false;
		turned = false;
	}
}