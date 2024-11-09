if !surface_exists(HUDsurface) {
	HUDsurface=surface_create(camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0]))
}