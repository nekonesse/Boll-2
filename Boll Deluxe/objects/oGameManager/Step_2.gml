var i=0;
repeat(array_length(hidden_tile_layers)) {
	var _layer = hidden_tile_layers[i]
	if !(_layer.touched) {
		_layer.my_alpha=min(_layer.my_alpha+0.05,1);
	} else {
		_layer.my_alpha=max(_layer.my_alpha-0.05,0.25);
	}
	i++;
}

///ACTIVATION vvvv

var guiw = window_get_width();
var guih = window_get_height();
if !os_is_paused() && guiw>0 && guih>0 {
	if !surface_exists(HUDsurface) {
		HUDsurface=surface_create(camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0]))
	}
}

update_camerapos();

instance_deactivate_all(true)
var camx=camera_get_view_x(view_camera[0])-64
var camy=camera_get_view_y(view_camera[0])-64
var camwidth=camera_get_view_width(view_camera[0])+128
var camheight=camera_get_view_height(view_camera[0])+128
instance_activate_region(camx,camy,camwidth,camheight,true)
instance_activate_object(oBackgroundManager)
instance_activate_object(oTitlecard)
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
instance_activate_object(oLevelBorder)
with(oActivationRegion) {
	instance_activate_region(x,y,sprite_width,sprite_height,true)
}
with(oPlayer) {
	instance_activate_region(floor(x)-hit_sizex-32,floor(y)-hit_sizey-32, hit_sizex+64, hit_sizey+64, true)
}
with(oWMPlayer) {
	instance_activate_region(floor(x)-hit_sizex-32,floor(y)-hit_sizey-32, hit_sizex+64, hit_sizey+64, true)
}