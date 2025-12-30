pal_swap_init_system(shd_pal_swapper);

window_set_cursor(cr_none)

#macro RESOLUTION_X 432
#macro RESOLUTION_Y 248

global.settings = {};

global.settings[$ "resolution_scale"] = min(floor(display_get_width()/RESOLUTION_X),floor(display_get_height()/RESOLUTION_Y))
global.settings[$ "fullscreen_type"] = 0
global.settings[$ "master_vol"] = 1
global.settings[$ "music_vol"] = 1
global.settings[$ "sound_vol"] = 1
global.settings[$ "keybinds"] = input_player_export()

if file_exists(game_save_id+"\settings.ini")
{
	var loaded = buffer_load(game_save_id+"\settings.ini")
	if (loaded != -1) {
		var save_file = buffer_decompress(loaded)
		global.settings = json_parse(buffer_read(save_file,buffer_string))
		var opstruct = global.settings[$ "keybinds"]
		if input_player_verify(opstruct) input_player_import(opstruct);
		buffer_delete(loaded)
		buffer_delete(save_file)
	}
}

if (!global.settings[$ "fullscreen_type"]) {
	window_enable_borderless_fullscreen(false);
	window_set_fullscreen(false);
	window_set_size(432*global.settings[$ "resolution_scale"],248*global.settings[$ "resolution_scale"]);
	window_center();
} else {
	//fullscreen setting has to be delayed or else it causes a weird bug where it doesnt show up in the taskbar
	alarm[0]=2;
}
						
VinylMasterSetGain(global.settings[$ "master_vol"])
VinylMixSetGain("music", global.settings[$ "music_vol"])
VinylMixSetGain("sound effects", global.settings[$ "sound_vol"])

global.roomTimer = 0;
global.freezeframe = false;
global.animdat[0]=[];

//application_surface_draw_enable(false); 


global._findDefine = function(_filedir){
	var _code		=file_text_open_read(_filedir);
	var _str		="",
		_cur		=file_text_read_string(_code),
		_NLstr		="",
		_fileSTR	="",
		_list		=[];
	var index = 0
	//Looking for our section
	while (!file_text_eof(_code)) {
		while (!string_starts_with(_cur,"#define")) {
		    file_text_readln(_code);
			_cur	=file_text_read_string(_code);
			if file_text_eof(_code) {
				break;
			}
		}
		
		if string_starts_with(_cur,"#define") { 
			_cur = string_delete(_cur, 0, 8);
			_list[index++] = _cur;
			show_debug_message(_cur);
		}

	}
	file_text_close(_code);
	show_debug_message("DONE READING... going away")
	return _list
}

global._loopThrough = function(_lookfor, _filedir) { //Function to go through and collect string from specific parts of the GML file
	var _code		=file_text_open_read(_filedir);
	var _str		="",
		_cur		=file_text_read_string(_code),
		_NLstr		="",
		_fileSTR	="";
	
	//Looking for our section
	while (_cur!=$"#define {_lookfor}") {
		file_text_readln(_code);
		_cur	=file_text_read_string(_code);
	}
	//Getting the code from our section
	while (!file_text_eof(_code) and !string_starts_with(_NLstr,"#define")) {
	    file_text_readln(_code);
		_fileSTR	=file_text_read_string(_code);
		_NLstr		=_fileSTR;
		if (!string_starts_with(_NLstr,"#define"))
			_str +=$"{_fileSTR}\n";
	}
	file_text_close(_code);
	
	//Returning it to the caller
	return _str;
}

global.scripts = compile_code()
global.scripts_level = compile_level_scripts()
global.scripts_object = compile_object_scripts()