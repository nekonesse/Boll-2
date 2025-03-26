global.roomTimer+=1

if keyboard_check_pressed(vk_f3) {
	global.debug = !global.debug
}

if keyboard_check_pressed(vk_f5) {
	global.fps_display = !global.fps_display;
}