x=median(x,0,oJADEController.guiw-sprite_width)
y=median(y,0,oJADEController.guih-sprite_height)

if (oJADEController.mbleftpress) {
	if (point_in_rectangle(window_mouse_get_x(),window_mouse_get_y(),bbox_left,bbox_top,bbox_right-1,bbox_bottom-1)) {
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		
		var i=0;
		repeat(array_length(names)) {
			var over = point_in_rectangle(curs_x,curs_y,x,y+(16*i),x+sprite_width,y+15+(16*i))
		
			if over {
				oJADEController.selected_button=[-1,-1]
				func(names[i], i);
				oJADEController.pressed_dropdown=1;
				show_debug_message("PRESSED BUTTON")
				instance_destroy(id, false);
			}
			i++;
		}
	} else {
		oJADEController.selected_button=[-1,-1]
		show_debug_message("NOT PRESSED BUTTON")
		instance_destroy();
	}
}