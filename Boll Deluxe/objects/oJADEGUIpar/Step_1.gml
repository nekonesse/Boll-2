if mouse_check_button_pressed(mb_left) && !point_in_rectangle(window_mouse_get_x(),window_mouse_get_y(),bbox_left,bbox_top,bbox_right-1,bbox_bottom-1) {
	oJADEController.selected_button=[-1,-1]
	instance_destroy()
}