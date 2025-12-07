pal_swap_init_system(shd_pal_swapper);

if file_exists(game_save_id+"\keybinds.ini")
{
	var opstruct = LoadJSONFromFile(game_save_id+"\keybinds.ini")
	if input_player_verify(opstruct) input_player_import(opstruct);
	else SaveStringToFile(game_save_id+"\keybinds.ini",input_player_export())
}
global.roomTimer = 0;
global.freezeframe = false;
global.animdat[0]=[];

window_set_size(432*3,248*3);
window_center();

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


//var lol = global._findDefine($"{working_directory}\\_vanilla\\character\\testcharm\\testcharm.gml")

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