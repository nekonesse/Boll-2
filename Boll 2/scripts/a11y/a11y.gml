/// Screen reader / accessibility speech helpers (GMSTolkTalk + Tolk).
/// Speech follows live screen-reader presence: NVDA open => speak, closed => silent.
/// Never uses the SAPI fallback (that would speak with no screen reader).

#macro A11Y_AUTO (-1)

/// Boot Tolk. Detection is refreshed by a11y_poll() every frame.
function a11y_init() {
	global.a11y_ready = false;
	global.a11y_reader = "null";
	global.a11y_active = false;
	global.a11y_mode = A11Y_AUTO;

	// Sequential speech queue — used only by the disclaimer screen
	// (disclaimer text -> "Press any button to continue")
	global.a11y_queue = [];
	global.a11y_speaking = false;
	global.a11y_speak_min = 0;
	global.a11y_speak_hard = 0;
	global.a11y_speak_idle = 0;

	TolkFallbackSet(false);
	if (!TolkPowerOn()) {
		show_debug_message("a11y: TolkPowerOn failed - screen reader speech unavailable");
		return;
	}
	global.a11y_ready = true;

	if (variable_struct_exists(global.settings, "screen_reader")) {
		global.a11y_mode = global.settings[$ "screen_reader"];
	}
	a11y_poll(true);
}

function a11y_enabled() {
	return variable_global_exists("a11y_active") && global.a11y_active;
}

/// Re-probe for a screen reader and update a11y_active.
/// force=true skips the frame throttle (init / apply).
function a11y_poll(_force = false) {
	if (!variable_global_exists("a11y_ready") || !global.a11y_ready) return false;

	if (!_force) {
		global.a11y_poll_timer = (variable_global_exists("a11y_poll_timer") ? global.a11y_poll_timer : 0) + 1;
		// ~4x per second at 60fps — cheap, catches NVDA start/stop mid-game
		if (global.a11y_poll_timer < 15) return global.a11y_active;
		global.a11y_poll_timer = 0;
	}

	TolkFallbackSet(false);
	// Re-probe: PowerOn again refreshes which backends are available
	TolkPowerOn();
	global.a11y_reader = TolkGetScreenReader();
	var _detected = (global.a11y_reader != "null" && global.a11y_reader != "");
	var _mode = global.a11y_mode;

	if (_mode == 0) {
		global.a11y_active = false;
	} else {
		// Auto and On both mean: speak only when a screen reader is actually running
		global.a11y_active = _detected;
	}
	return global.a11y_active;
}

/// Speak text; interrupts current speech by default (like NVDA focus change).
/// _interrupt=true  -> clear queue, silence, speak now (menus, gameplay, critical events).
/// _interrupt=false -> enqueue after current speech (disclaimer screen only).
function a11y_speak(_text, _interrupt = true) {
	if (!a11y_enabled()) return false;
	if (is_undefined(_text) || _text == "") return false;
	if (_interrupt) {
		a11y_queue_clear();
		return a11y_speak_now(_text);
	}
	return a11y_queue_push(_text);
}

/// Estimated speech length in frames (~15 chars/sec at 60fps + latency buffer).
/// Used as the queue's completion gate so follow-ups cannot cut off long text
/// when TolkIsSpeaking() reports idle early (common with NVDA).
function a11y_speech_frames(_text) {
	return max(90, ceil(string_length(_text) * 4) + 90);
}

/// Speak immediately (clears any in-flight speech first). Used by a11y_speak(interrupt).
function a11y_speak_now(_text) {
	if (!a11y_enabled()) return false;
	if (is_undefined(_text) || _text == "") return false;
	TolkSilence();
	if (TolkSpeak(_text) == 0) {
		global.a11y_speaking = false;
		return false;
	}
	global.a11y_speaking = true;
	// Full length estimate before the queue may advance; TolkIsSpeaking only
	// allows an early finish after that (with a consecutive-idle debounce).
	global.a11y_speak_min = a11y_speech_frames(_text);
	global.a11y_speak_hard = global.a11y_speak_min * 2;
	global.a11y_speak_idle = 0;
	return true;
}

/// Enqueue speech to play after the current item finishes (disclaimer screen only).
function a11y_queue_push(_text) {
	if (!a11y_enabled()) return false;
	if (is_undefined(_text) || _text == "") return false;
	if (!variable_global_exists("a11y_queue")) {
		global.a11y_queue = [];
		global.a11y_speaking = false;
		global.a11y_speak_min = 0;
		global.a11y_speak_hard = 0;
		global.a11y_speak_idle = 0;
	}
	array_push(global.a11y_queue, _text);
	// Cap so a runaway enqueue can't grow unbounded; drop oldest.
	while (array_length(global.a11y_queue) > 8) {
		array_delete(global.a11y_queue, 0, 1);
	}
	// Kickstart immediately if idle (first queue item plays without waiting a frame).
	if (!global.a11y_speaking) a11y_queue_update();
	return true;
}

function a11y_queue_clear() {
	if (!variable_global_exists("a11y_queue")) {
		global.a11y_queue = [];
		global.a11y_speaking = false;
		global.a11y_speak_idle = 0;
		return;
	}
	global.a11y_queue = [];
	global.a11y_speaking = false;
	global.a11y_speak_min = 0;
	global.a11y_speak_hard = 0;
	global.a11y_speak_idle = 0;
}

/// Pump the sequential speech queue. Called every frame from oGlobals End Step.
/// Used only for the disclaimer screen sequence.
function a11y_queue_update() {
	if (!variable_global_exists("a11y_ready") || !global.a11y_ready) return;
	if (!variable_global_exists("a11y_queue")) return;

	// Screen reader gone / setting off -> drop pending speech.
	if (!a11y_enabled()) {
		if (global.a11y_speaking || array_length(global.a11y_queue) > 0) {
			a11y_queue_clear();
			TolkSilence();
		}
		return;
	}

	if (global.a11y_speaking) {
		// Hard gate: never advance before the estimated speech duration.
		// (TolkIsSpeaking alone is unreliable — NVDA often reports idle while still talking.)
		if (global.a11y_speak_min > 0) {
			global.a11y_speak_min--;
			if (global.a11y_speak_hard > 0) global.a11y_speak_hard--;
			return;
		}
		// Past estimate: finish early only after Tolk reports idle for several
		// consecutive frames, or when the hard cap expires.
		if (TolkIsSpeaking() && global.a11y_speak_hard > 0) {
			global.a11y_speak_idle = 0;
			global.a11y_speak_hard--;
			return;
		}
		global.a11y_speak_idle++;
		if (global.a11y_speak_idle < 12 && global.a11y_speak_hard > 0) return;
		global.a11y_speaking = false;
		global.a11y_speak_idle = 0;
	}

	if (array_length(global.a11y_queue) > 0) {
		var _t = global.a11y_queue[0];
		array_delete(global.a11y_queue, 0, 1);
		TolkSilence();
		if (TolkSpeak(_t) != 0) {
			global.a11y_speaking = true;
			global.a11y_speak_min = a11y_speech_frames(_t);
			global.a11y_speak_hard = global.a11y_speak_min * 2;
			global.a11y_speak_idle = 0;
		} else {
			global.a11y_speaking = false;
		}
	}
}

function a11y_silence() {
	if (!variable_global_exists("a11y_ready") || !global.a11y_ready) return;
	a11y_queue_clear();
	TolkSilence();
}

/// Apply screen reader setting immediately: -1 auto, 0 off, 1 on.
/// Auto/On = speak iff a screen reader is detected (live). Off = never. No SAPI.
function a11y_apply_setting(_mode) {
	if (!variable_global_exists("settings")) return;
	global.settings[$ "screen_reader"] = _mode;
	global.a11y_mode = _mode;

	var _ready = variable_global_exists("a11y_ready") && global.a11y_ready;
	if (!_ready) {
		global.a11y_active = false;
		return;
	}

	a11y_poll(true);

	var _detected = (global.a11y_reader != "null" && global.a11y_reader != "");
	var _msg;
	if (_mode == A11Y_AUTO) {
		_msg = _detected ? "Screen reader set to auto." : "Screen reader set to auto. No screen reader detected.";
	} else if (_mode == 1) {
		_msg = _detected ? "Screen reader on." : "Screen reader on. No screen reader detected yet.";
	} else {
		_msg = "Screen reader off.";
	}
	if (global.a11y_active) {
		a11y_speak(_msg, true);
	} else {
		show_debug_message("a11y: " + _msg);
	}
}

/// Display labels for the current menu of a menu instance (mirrors Draw).
function a11y_menu_options(_obj) {
	var _ts = _obj.temp_settings;
	switch (_obj.crMenu) {
		case "mainmenu":
			return ["Level Select", "Settings", "Editor", "Exit Game"];
		case "settings": {
			var _fs = ["None", "Windowed Borderless", "Legacy Fullscreen"][_ts.fullscreen_type];
			return [
				"Window Scale: " + string(_ts.resolution_scale) + "x",
				"Fullscreen: " + _fs,
				"Master Volume: " + string(round(_ts.master_vol * 100)) + "%",
				"Music Volume: " + string(round(_ts.music_vol * 100)) + "%",
				"Sound Volume: " + string(round(_ts.sound_vol * 100)) + "%",
				"Accessibility",
				"Keybinds",
				"Apply Changes"
			];
		}
		case "accessibility": {
			var _ah = _ts.alternate_hud ? "On" : "Off";
			var _ss = _ts.sensitive_sound ? "Off" : "On";
			var _sr = "Auto";
			if (_ts.screen_reader == 0) _sr = "Off";
			else if (_ts.screen_reader == 1) _sr = "On";
			return ["Alternate HUD: " + _ah, "Sensitive Sounds: " + _ss, "Screen Reader: " + _sr, "Apply Changes", "Back"];
		}
		case "levelselectm": {
			var _labels = [];
			var i = 0;
			repeat (array_length(global.levellist)) {
				_labels[i] = global.levellist[i].name;
				i++;
			}
			return _labels;
		}
		case "cssm":
			return [];
		case "keybindsm":
			return ["Right", "Left", "Up", "Down", "A", "B", "C", "V", "Reset Bindings"];
	}
	return [];
}

function a11y_menu_title(_menu) {
	switch (_menu) {
		case "mainmenu": return "Main menu";
		case "settings": return "Settings";
		case "accessibility": return "Accessibility settings";
		case "levelselectm": return "Level select";
		case "cssm": return "Character select";
		case "keybindsm": return "Keybinds";
	}
	return "";
}