/// @description Jumping from ledges
if (global.paused) exit;
event_inherited();

if !(in_shell) && (grounded)
{
	if !check_collision_rectangle(x + (_direction * (hit_sizex+1)),y,x + (_direction * (hit_sizex-4)),y+hit_sizey+16, COL_BOTTOM) {
		vsp = -4.65;
		jump = true;
		damage_on_contact = true;
		grounded = false;
		turned = false;
	}
}

if (grounded) {
	jump = false;
	damage_on_contact = false;
}