if mouse_check_button_pressed(mb_left) {
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
			instance_destroy(id,false);
		}
		i++;
	}
}

x=median(x,0,oJADEController.guiw-sprite_width)
y=median(y,0,oJADEController.guih-sprite_height)