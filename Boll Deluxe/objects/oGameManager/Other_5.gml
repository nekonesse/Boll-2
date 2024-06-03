instance_destroy(oBackgroundManager);

with(oPlayer) {
	if sprite_exists(sheet) {
		show_debug_message("fracked up and deletd")
		sprite_delete(sheet)
	}	
}