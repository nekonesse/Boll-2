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

// F6: read HUD status (coins, lives, time, reserved item) for screen readers
if (keyboard_check_pressed(vk_f6)) {
	if (room == rGame && instance_exists(oGameManager) && a11y_enabled()) {
		var _msg = "Coins: " + string(global.coins_collected);
		if (variable_global_exists("lives")) {
			_msg = _msg + ". Lives: " + string(global.lives[0]);
		}
		var _sec = floor(oGameManager.game_timer);
		_msg = _msg + ". Time: " + string(_sec) + " seconds";
		if (oGameManager.reserved_item != noone) {
			var _n = object_get_name(oGameManager.reserved_item);
			if (string_length(_n) > 1 && string_char_at(_n, 1) == "o") {
				_n = string_delete(_n, 1, 1);
			}
			_msg = _msg + ". Reserved item: " + _n;
		}
		a11y_speak(_msg, true);
	}
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

// Live screen-reader presence (NVDA open => speech, closed => silent)
if (variable_global_exists("a11y_ready") && global.a11y_ready) {
	a11y_poll(false);
	// Speech queue pump (disclaimer screen: disclaimer -> press any key)
	a11y_queue_update();
}