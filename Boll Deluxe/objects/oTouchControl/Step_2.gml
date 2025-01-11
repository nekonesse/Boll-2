
//I'll be using the normal input variables locally in the object here to just track them seperately
//it makes it easier to test on pc and should make multi-tap more stable -christian

	right	=0;
	left	=0;
	up		=0;
	down	=0;
	akey	=0;
	bkey	=0;
	ckey	=0;



//this is a horrible way to do it but i NEED it to work for now

	if (device_mouse_check_button(0, mb_left)) 
	{
		
		//A Button
	    if (device_mouse_x_to_gui(0) > AbutX && device_mouse_x_to_gui(0) < AbutX+48
		&& device_mouse_y_to_gui(0) > AbutY && device_mouse_y_to_gui(0) < AbutY+48) {
	         keyboard_key_press(ord("X")) akey=1
			}

		//Up Button
	    if (device_mouse_x_to_gui(0) > PadX+20 && device_mouse_x_to_gui(0) < PadX+44
		&& device_mouse_y_to_gui(0) > PadY && device_mouse_y_to_gui(0) < PadY+26) {
	         keyboard_key_press(vk_up) up=1
			}

		//Down Button
	    if (device_mouse_x_to_gui(0) > PadX+20 && device_mouse_x_to_gui(0) < PadX+44
		&& device_mouse_y_to_gui(0) > PadY+26 && device_mouse_y_to_gui(0) < PadY+48) {
	         keyboard_key_press(vk_down) down=1
			}
			
		//Left Button
	    if (device_mouse_x_to_gui(0) > PadX && device_mouse_x_to_gui(0) < PadX+26
		&& device_mouse_y_to_gui(0) > PadY+29 && device_mouse_y_to_gui(0) < PadY+48) {
	         keyboard_key_press(vk_left) left=1
			}
			
		//Right Button
	    if (device_mouse_x_to_gui(0) > PadX+48 && device_mouse_x_to_gui(0) < PadX+70
		&& device_mouse_y_to_gui(0) > PadY+29 && device_mouse_y_to_gui(0) < PadY+48) {
	         keyboard_key_press(vk_right) right=1
			}
			

		}
