///@description Animation Controller
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