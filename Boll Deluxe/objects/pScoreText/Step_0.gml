if (vspeed == 0) {
	image_blend=merge_color(image_blend,c_black,0.1)
	image_alpha=approach_val(image_alpha,0,0.05);
		
	if !ceil(image_alpha) instance_destroy();
}