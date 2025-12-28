x=median(x,0,oJADEController.guiw-sprite_width)
y=median(y,0,oJADEController.guih-sprite_height)

mbleftpress = mouse_check_button_pressed(mb_left)

if (mbleftpress) && !instance_exists(oJADEDropDown) {
	if (is_struct(selected_layer)) {
		if is_instanceof(selected_layer, JADEtilelayer) {
			tilesetselector.update();
		}
	}
	
	exitbutton.update();
}