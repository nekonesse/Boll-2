var camx=camera_get_view_x(view_camera[0])-24
var camy=camera_get_view_y(view_camera[0])-24
var camwidth=camera_get_view_width(view_camera[0])+24
var camheight=camera_get_view_height(view_camera[0])+24
instance_deactivate_all(true)
instance_activate_region(camx,camy,camwidth,camheight,true)
instance_activate_object(oBackgroundManager)
instance_activate_object(oNodeManager)
instance_activate_object(oGlobals)
instance_activate_object(oCamera)
instance_activate_object(oPlayer)
instance_activate_object(input_controller_object)
instance_activate_object(oCameraBoundary)