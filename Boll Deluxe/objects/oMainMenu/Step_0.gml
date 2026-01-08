if (!optionLock) {
	right	=input_check_pressed("right");
	left	=input_check_pressed("left");
	up		=input_check_pressed("up");
	down	=input_check_pressed("down");
	akey	=(input_check_pressed("a") || input_check_pressed("enter"));
	bkey	=input_check_pressed("b") || input_check_pressed("pause");
	ckey	=input_check_pressed("c");
	
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
			optMAX = 6;
			if (akey) {
				switch option {
					case 5:
						crMenu="keybindsm" option=0
					break;
					case 6: 
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
	
		case "levelselectm":
			optMAX = array_length(global.levellist)-1;
			if (akey) {
				crMenu="cssm";
				//option=0;
				global.nextlevel=$"{working_directory}\mods\\level\\{global.levellist[option]}"
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
			var _binds = ["right","left","up","down","a","b","c"];
			optMAX = array_length(_binds);
			if (akey) {
				if (option!=7) {
					rebindKey(_binds[option])
				} else {
					input_profile_reset_bindings(INPUT_AUTO_PROFILE_FOR_KEYBOARD);
				}
			}
			if (bkey) {
				backAmenu("settings");
			}
		break
	}
}