guiw = window_get_width();
guih = window_get_height();

if !os_is_paused() && guiw>0 && guih>0 {
	if !surface_exists(GUIcanvas) {
		GUIcanvas=surface_create(guiw,guih);
	} else {
		display_set_gui_size(guiw,guih)
		surface_resize(application_surface, guiw, guih);
	}
}
VinylStopAll();
editorMusic=VinylPlay("editor bgm", true, 0.2);