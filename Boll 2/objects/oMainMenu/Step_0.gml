if (!optionLock) {
	left	=InputPressed(INPUT_VERB.LEFT);
	right	=InputPressed(INPUT_VERB.RIGHT);
	up		=InputPressed(INPUT_VERB.UP);
	down	=InputPressed(INPUT_VERB.DOWN);
	akey	=(InputPressed(INPUT_VERB.A) || InputPressed(INPUT_VERB.ENTER));
	bkey	=(InputPressed(INPUT_VERB.B) || InputPressed(INPUT_VERB.PAUSE));
	ckey	=InputPressed(INPUT_VERB.C)
	
	if (startLock) { //discard inputs when first created to prevent immediately being booted to the level select sometimes
		akey		=0;
		bkey		=0;
		ckey		=0;
		startLock -= 1;
	}
	
} else {
	right	=0;
	left	=0;
	up		=0;
	down	=0;
	akey	=0;
	bkey	=0;
	ckey	=0;
}

if (!optionLock) {
	OptionMover();

	switch (crMenu) {
		case "mainmenu":
			optMAX = 3;
			if (akey) {
				switch option {
					case 0: crMenu="levelselectm" option=0 break;
					case 1: crMenu="settings" option=0 break;
					case 2: global.save_dir="" room_goto(rEditor) option=0 break;
					//case 3: global.save_dir="" room_goto(rWMEditor) option=0 break;
					//case 3: room_goto(rIntro) option=0 break;
					case 3: game_end(); break;
				}
				safe = 1
			}
		break
		
		case "settings":
			optMAX = 7;
			if (akey) {
				switch option {
					case 5:
						crMenu="accessibility" option=0
					break;
					case 6:
						crMenu="keybindsm" option=0
					break;
					case 7: 
						var oldscale = global.settings[$ "fullscreen_type"]
						
						global.settings[$ "resolution_scale"] = temp_settings.resolution_scale
						global.settings[$ "fullscreen_type"] = temp_settings.fullscreen_type
						global.settings[$ "master_vol"] = temp_settings.master_vol
						global.settings[$ "music_vol"] = temp_settings.music_vol
						global.settings[$ "sound_vol"] = temp_settings.sound_vol
						
						if (!global.settings[$ "fullscreen_type"]) {
							window_enable_borderless_fullscreen(false);
							window_set_fullscreen(false);
							if global.settings[$ "resolution_scale"]!=oldscale {
								window_set_size(432*global.settings[$ "resolution_scale"],248*global.settings[$ "resolution_scale"]);
								window_center();
							}
						} else {
							if (global.settings[$ "fullscreen_type"] == 1) window_enable_borderless_fullscreen(true);
							else window_enable_borderless_fullscreen(false);
							window_set_fullscreen(true);
						}
						
						VinylMasterSetGain(global.settings[$ "master_vol"])
						VinylMixSetGain("music", global.settings[$ "music_vol"])
						VinylMixSetGain("sound effects", global.settings[$ "sound_vol"])
					break;
				}
				safe = 1
			}
			if (left || right) {
				switch (option) {
					case 0: temp_settings.resolution_scale = clamp(temp_settings.resolution_scale + floor(right - left),1,5) break;
					case 1: temp_settings.fullscreen_type = clamp(temp_settings.fullscreen_type + floor(right - left),0,2) break;
					case 2: temp_settings.master_vol = clamp(temp_settings.master_vol + (floor(right - left)/20),0,2) break;
					case 3: temp_settings.music_vol = clamp(temp_settings.music_vol + (floor(right - left)/20),0,2) break;
					case 4: temp_settings.sound_vol = clamp(temp_settings.sound_vol + (floor(right - left)/20),0,2) break;
				}
			}
			if (bkey) {
				backAmenu("mainmenu");
				temp_settings = global.settings;
			}
		break
		
		case "accessibility":
			optMAX = 4;
			if (akey) {
				switch option {
					case 4:
						crMenu="settings" option=0
					break;
					case 3: 
						global.settings[$ "alternate_hud"] = temp_settings.alternate_hud
						global.settings[$ "sensitive_sound"] = temp_settings.sensitive_sound
						a11y_speak("Changes applied.")
					break;
				}
				safe = 1
			}
			if (left || right) {
				switch (option) {
					case 0: temp_settings.alternate_hud = !temp_settings.alternate_hud break;
					case 1: temp_settings.sensitive_sound = !temp_settings.sensitive_sound break;
					case 2:
						temp_settings.screen_reader = clamp(temp_settings.screen_reader + floor(right - left), -1, 1);
						a11y_apply_setting(temp_settings.screen_reader);
					break;
				}
			}
			if (bkey) {
				backAmenu("settings");
				temp_settings = global.settings;
			}
		break
	
		case "levelselectm":
			optMAX = array_length(global.levellist)-1;
			if (akey) {
				crMenu="cssm";
				var struct = global.levellist[option];
				global.nextlevel=$"{working_directory}{struct.dir}"
				level_preparse(global.nextlevel);
				optionLock=1;
				instance_create_depth(x,y,depth,oCSS);
			}
			if (bkey) {
				backAmenu("mainmenu");
			}
		break
		
		case "cssm":
			//if (!instance_exists(oCSS)) instance_create_depth(x,y,depth,oCSS);
			//optMAX = 0;
			if (bkey) {
				backAmenu("levelselectm");
			}
		break
	
		case "keybindsm":
			var _binds = [INPUT_VERB.RIGHT,INPUT_VERB.LEFT,INPUT_VERB.UP,INPUT_VERB.DOWN,INPUT_VERB.A,INPUT_VERB.B,INPUT_VERB.C,INPUT_VERB.V,"reset"];
			optMAX = array_length(_binds)-1;
			
			if (lemmebind!=-1) {
				var _device = InputPlayerGetDevice();
				if (InputDeviceGetRebinding(_device))
				{
				    var _result = InputDeviceGetRebindingResult(_device);
				    if (_result != undefined)
				    {
				        //Rebind the jump verb once we get a response
				        InputBindingSet(InputDeviceIsGamepad(_device), lemmebind, _result);

				        //Make sure we turn off rebinding once a binding has been found
				        InputDeviceSetRebinding(_device, false);
						lemmebind=-1;
						a11y_speak("Binding set.")
				    }
				} else {
					lemmebind=-1;
				}
			} else {
				if (akey) {
					if (option!=8) {
						rebindKey(_binds[option])
						var _kbLabels = a11y_menu_options(id);
						a11y_speak("Press a key or button for " + string(_kbLabels[option]) + ".")
					} else {
						InputBindingsReset(false);
						InputBindingsReset(true);
						a11y_speak("Bindings reset.")
					}
				}
				if (bkey) {
					backAmenu("settings");
				}
			}
		break
	}
}

// Screen reader menu announcements
if (a11y_enabled()) {
	var _a11y_labels = a11y_menu_options(id);
	var _a11y_label = "";
	if (option >= 0 && option < array_length(_a11y_labels)) _a11y_label = _a11y_labels[option];
	if (crMenu != a11y_prev_menu) {
		var _a11y_title = a11y_menu_title(crMenu);
		if (_a11y_label != "") a11y_speak(_a11y_title + ". " + _a11y_label); else a11y_speak(_a11y_title);
	} else if (_a11y_label != a11y_prev_label) {
		a11y_speak(_a11y_label);
	}
	a11y_prev_menu = crMenu;
	a11y_prev_label = _a11y_label;
}
