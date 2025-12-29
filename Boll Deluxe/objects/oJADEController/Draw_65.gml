guiw = window_get_width();
guih = window_get_height();

if !os_is_paused() && guiw>0 && guih>0 {
	if !surface_exists(GUIcanvas) {
		GUIcanvas=surface_create(guiw,guih);
	} else {
		display_set_gui_size(guiw,guih)
		surface_resize(application_surface, guiw, guih);
	}
	objectlist.x = guiw-216-14
	gizmolist.x = guiw-216-14
	decolist.x = guiw-216-14
	bglist.x = guiw-216-14
	propertylist.x = guiw-216-14
	nodepropertylist.x = guiw-216-14
	rotatorpropertylist.x = guiw-216-14
	list_tabbuttons.x = guiw-216-14
	objectvisibility.x = guiw-240-96
	gizmovisibility.x = guiw-240-78
	tilelayervisibility.x = guiw-240-60
	assetlayervisibility.x = guiw-240-42
	bglayervisibility.x = guiw-240-24
	tilepicker.x = guiw-216-14
	bgalignbuttons.x = guiw-216-14
	camera_set_view_size(camera,guiw,guih)
	view_set_wport(0,guiw)
	view_set_hport(0,guih)
}