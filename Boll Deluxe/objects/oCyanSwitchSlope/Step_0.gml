if (switch_state) {
	image_index=approach_val(image_index,3,0.25)
	if image_index >= 2 {
		mask_index=spr_slopesolid
		slope = true;
		influence = true;
	}
} else {
	image_index=approach_val(image_index,0,0.33)
	if image_index <= 1 {
		mask_index=spr_collider
		slope = false;
		influence = false;
	}
}
image_index=clamp(image_index,0,3)