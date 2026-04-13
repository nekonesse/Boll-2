global.roomTimer+=1

if keyboard_check_pressed(vk_f3) {
	global.debug = !global.debug
}

if keyboard_check_pressed(vk_f4) {
	global.show_collision = !global.show_collision
}

if keyboard_check_pressed(vk_f5) {
	global.fps_display = !global.fps_display;
}

with(oCollider) {
	if object_index==oCollider||object_index==oSemilider||object_index==oSlopeCollider||object_index==oSemiSlope||object_index==oRoundedSlope1x1||object_index==oRoundedSlope2x2||object_index==oPipe||object_index==oRoundedSlope3x3 {
		visible=(global.debug || global.show_collision)
	}
}

with(oBarrier) {
	visible=(global.debug || global.show_collision)
}

with(oSnowboardGiver) {
	visible=(global.debug || global.show_collision)
}

with(oLevelBorder) {
	visible=(global.debug || global.show_collision)
}

if global.debug {
	if keyboard_check_pressed(vk_f1) && (room_speed > 10) {
		room_speed-=10
	} else if keyboard_check_pressed(vk_f2) {
		room_speed+=10
	}
}

if (window_get_fullscreen()) {
	if (!windowfocused && window_has_focus()) { // if it didn't have focus the previous step but now it does, that means the app was restored to the foreground
	    window_set_fullscreen(false);
	    window_set_fullscreen(true);
	    // toggling fullscreen off then on is required to regain exclusive fullscreen mode
	}
	windowfocused = window_has_focus();
}

file_dropper_flush()