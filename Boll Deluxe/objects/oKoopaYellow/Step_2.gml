/// @description Jumping from ledges
if (global.paused) exit;

if !(in_shell) && (grounded)
{
	if !check_collision_rectangle(x + (-xsc * (hit_sizex+1)),y,x + (-xsc * (hit_sizex-4)),y+hit_sizey+16, COL_BOTTOM) {
		vsp = -4.65;
		grounded = false;
		turned = false;
	}
}