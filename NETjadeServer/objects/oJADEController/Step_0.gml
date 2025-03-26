var cam_x = camera_get_view_x(view_camera[0])
var cam_y = camera_get_view_y(view_camera[0])
var cam_w = camera_get_view_width(view_camera[0])
var cam_h = camera_get_view_height(view_camera[0])

curs_x=mouse_x-cam_x
curs_y=mouse_y-cam_y

mbleftpress=mouse_check_button_pressed(mb_left)
mbleftrel=mouse_check_button_released(mb_left)
mbleft=mouse_check_button(mb_left)
mbrightpress=mouse_check_button_pressed(mb_right)
mbrightrel=mouse_check_button_released(mb_right)
mbright=mouse_check_button(mb_right)
mbmiddle = (mouse_check_button(mb_middle) || (keyboard_check(vk_space) && mouse_check_button(mb_left)))

#region Camera Panning
if (mbmiddle) {
	if !(view_grab) { //check position
		view_grab=1 
		view_grabx=curs_x
		view_graby=curs_y
		initial_viewx = cam_x
		initial_viewy = cam_y
	}
} else {
	view_grab=0
}

if (view_grab) { //update camera position
    camera_set_view_pos(view_camera[0],floor(initial_viewx+(view_grabx-curs_x)),floor(initial_viewy+(view_graby-curs_y)))
	//divide by zoom later
}
#endregion