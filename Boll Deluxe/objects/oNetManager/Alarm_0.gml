if struct_names_count(levelstruct) > 1 {
	with(oJADEController) {
		JADE_load(other.levelstruct);
	}
} else {
	show_message("Failed to fetch level from server!\nIf you got this error, try again!")
	game_end();
}
levelstruct={};