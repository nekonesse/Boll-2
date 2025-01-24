///@description Animation Controller
xsc = -esign(grounded?gsp:hsp, -1)
sprite_index = spr_bobombwalk;

if unshellable {
	sprite_index = spr_bobombpanic;
}

if in_shell {
	sprite_index = spr_bobomblit;
	if (shell_time < 120) {
		image_speed = 3
	}
}