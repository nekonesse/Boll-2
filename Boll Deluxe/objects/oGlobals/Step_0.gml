global.roomTimer+=1

if keyboard_check_pressed(vk_tab)
global.debug = global.debug ^ 1

if global.debug {
	if keyboard_check_pressed(vk_f1) {
		room_speed-=10
	} else if keyboard_check_pressed(vk_f2) {
		room_speed+=10
	}
}

global.camera_x = camera_get_view_x(view_camera[0]) div 1;