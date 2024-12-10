/// @description Jumping from ledges
if (global.paused) exit;

if (turned) {
	hsp = -hsp //undo turn
	vsp = -4.65
	y += vsp
	grounded = 0
	turned = 0
}