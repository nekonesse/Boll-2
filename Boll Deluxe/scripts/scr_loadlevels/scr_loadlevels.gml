function load_levels(){
	var files = [];
	var file_name = file_find_first(working_directory+"/mods/level/*.jade", fa_none);

	while (file_name != "")
	{
		array_push(files, file_name);
		
		show_debug_message($"Found Level {file_name}!")
		file_name = file_find_next();
	}
	
	file_find_close();
	global.levellist=files
}