if !surface_exists(HUDsurface) {
	HUDsurface=surface_create(camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0]))
}

instance_deactivate_all(true)
var camx=camera_get_view_x(view_camera[0])-64
var camy=camera_get_view_y(view_camera[0])-64
var camwidth=camera_get_view_width(view_camera[0])+128
var camheight=camera_get_view_height(view_camera[0])+128
instance_activate_region(camx,camy,camwidth,camheight,true)
instance_activate_object(oBackgroundManager)
instance_activate_object(oNodeManager)
instance_activate_object(oDrawingManager)
instance_activate_object(oPlayer)
instance_activate_object(oWMPlayer)
instance_activate_object(oGlobals)
instance_activate_object(oCamera)
instance_activate_object(input_controller_object)
instance_activate_object(oCameraBoundary)
instance_activate_object(pSmoke)
instance_activate_object(oDeactivationRegion)
instance_activate_object(oMonitorPopup)
with(oActivationRegion) {
	instance_activate_region(x,y,sprite_width,sprite_height,true)
}
with(oPlayer) {
	instance_activate_region(floor(x)-hit_sizex-32,floor(y)-hit_sizey-32, hit_sizex+64, hit_sizey+64, true)
}
with(oWMPlayer) {
	instance_activate_region(floor(x)-hit_sizex-32,floor(y)-hit_sizey-32, hit_sizex+64, hit_sizey+64, true)
}


update_camerapos();