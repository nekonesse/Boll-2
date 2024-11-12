// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function compile_code(){
	var index = 0
	var _compiled = ds_map_create();
	var def_names = []
	var	found_folders = []
	
	show_debug_message("BEGIN SCRIPT COMPLATION...")
	
	var _folder = file_find_first($"{working_directory}\\_vanilla\\scripts\\*", fa_directory)
	while(_folder != "") {
		
		show_debug_message("SCRIPT FOLDER FOUND! `" + _folder + "`");
		
		if string_starts_with(_folder, "!") {
			show_debug_message("WARNING: Terminate symbol found in `" + _folder + "`. Ignoring...");
			_folder = file_find_next();
		}else {
			found_folders[index++] = "scripts\\" + _folder
			_folder = file_find_next();
		}
	}
	show_debug_message("END SCRIPT FOLDER SEARCH");
	
	_folder = file_find_close();
	
	show_debug_message("LETS DO IT AGAIN!!")
	
	var _folder = file_find_first($"{working_directory}\\_vanilla\\character\\*", fa_directory)
	while(_folder != "") {
		
		show_debug_message("SCRIPT FOLDER FOUND! `" + _folder + "`");
		
		if string_starts_with(_folder, "!") {
			show_debug_message("WARNING: Terminate symbol found in `" + _folder + "`. Ignoring...");
			_folder = file_find_next();
		}else {
			found_folders[index++] = "character\\" + _folder
			_folder = file_find_next();
		}
	}
	show_debug_message("END SCRIPT FOLDER SEARCH");
	
	_folder = file_find_close();
	
	
	for(var j = 0; j < array_length(found_folders); ++j) {
		
		var _file = file_find_first($"{working_directory}\\_vanilla\\" + found_folders[j] + "\\*.gml",0)
		show_debug_message("BEGIN SCRIPT COMPILE IN `" + found_folders[j] + "`");
	
		while(_file != "") {
			show_debug_message("SCRIPT FILE FOUND! `" + _file + "`");
			
			var _filepath = $"{working_directory}\\_vanilla\\" + found_folders[j] + "\\" + _file
			//var _filepath2 = $"{working_directory}\\_vanilla\\scripts\\" + _folder 
			show_debug_message(_filepath)
			//show_debug_message(_filepath2)
			_file = string_delete(_file, string_length(_file) -3, 4)
			def_names = global._findDefine( _filepath)
		
			for(var i = 0; i < array_length(def_names); ++i) {
			
				var store = _file + "_" + def_names[i]
				show_debug_message(store)
				//show_message(store);
			
				if !is_undefined(_compiled[? store]) {
					show_message("WARNING: `" + store + "` already has a script compiled.")
				}
			
				_compiled[? store] = txr_compile(global._loopThrough(def_names[i], _filepath));
				if (_compiled[? store] == undefined) {
					show_message("ERROR IN `" + _file + "`: "+ def_names[i] + ": " + txr_error);
				} 
			}
			
			show_debug_message("END SCRIPT EXTRACT IN FILE " + _file);
			_file = file_find_next();

		}
		
		show_debug_message("END SCRIPT COMPILE IN FOLDER " + found_folders[j]);
		_file = file_find_close();
	
	}
	
	show_debug_message("Scripts have finished being compiled")
	
	return _compiled
}

function import_sheets() {
	show_debug_message("BEGIN SPRITE COMPLATION...")
	oGameManager.PlayerColl.StartBatch();
	for(var i = 0; i < array_length(global._playerChars); ++i) {
		var _name = global._playerChars[i]; 
		var dir=$"{working_directory}\\_vanilla\\character\\{_name}"
		if file_exists($"{dir}\\sprites\\_HUDicon.png") {
			oGameManager.PlayerColl.AddFile($"{dir}\\sprites\\_HUDicon.png",$"spr_{_name}_HUDicon",1,false,false,CollageOrigin.CENTER,CollageOrigin.CENTER)
		} else throw $"SORRY! NO HUD ICON IN CHARACTER \"{_name}\" EXISTS! CHECK YOUR SPRITES!"
		if is_array(config_getarray("sprite_list", dir)) {
			global.player_spritelists[i]=config_getarray("sprite_list", dir)
			var array=global.player_spritelists[i]
			for (var j = 0; j < array_length(global.powerups); ++j) {
				for (var g = 0; g < array_length(array); ++g) {
					if (array[g]!="_HUDicon") && file_exists($"{dir}\\sprites\\{global.powerups[j]}\\{array[g]}.png") { //make sure they arent trying to overwrite our HUD icon that we imported
						var frames=nozerounreal(config_setting(global.powerups[j]+" "+array[g]+" frames", dir),config_setting(array[g]+" frames", dir))
						var org_x=nozerounreal(config_setting(global.powerups[j]+" "+array[g]+" orgx", dir),nozerounreal(config_setting(array[g]+" orgx", dir), nozerounreal(config_setting("origin x", dir), CollageOrigin.CENTER)))
						var org_y=nozerounreal(config_setting(global.powerups[j]+" "+array[g]+" orgy", dir),nozerounreal(config_setting(array[g]+" orgy", dir), nozerounreal(config_setting("origin y", dir), CollageOrigin.CENTER)))
						oGameManager.PlayerColl.AddFile($"{dir}\\sprites\\{global.powerups[j]}\\{array[g]}.png",$"spr_{_name}_{global.powerups[j]}_{array[g]}",frames,false,false,org_x,org_y)
					} else continue
				}
			}
		}
	}
	oGameManager.PlayerColl.FinishBatch();
	show_debug_message("Sprite have finished being compiled")
}

function delete_sheets() {
	for(var i = 0; i < array_length(oGlobals._charmList); ++i) {
		for (var j = 0; j < array_length(global.powerups); ++j) {
			if sprite_exists(global.player_sheets[i][j]) {
				show_debug_message($"Deleting sprite cache index of {j} for charm: {oGlobals._charmList[i]}")
				sprite_delete(global.player_sheets[i][j])
			}
		}
	}
}