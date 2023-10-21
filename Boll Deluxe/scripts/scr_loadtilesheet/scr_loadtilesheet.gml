function load_tilesheet(path,replacement){
	if file_exists(path) {
		sprite_replace(replacement,path,0,0,0,0,0);
	} else {
		show_message("ERROR: FILE DOES NOT EXIST "+path);
	}
}