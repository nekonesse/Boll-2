global.roomTimer+=1

if keyboard_check_pressed(vk_f3) {
	global.debug = !global.debug
}

with(oCollider) {
	if object_index==oCollider||object_index==oSemilider||object_index==oSlopeCollider||object_index==oSemiSlope||object_index==oRoundedSlope1x1||object_index==oRoundedSlope2x2||object_index==oPipe {
		visible=global.debug
	}
}

if global.debug {
	if keyboard_check_pressed(vk_f1) {
		room_speed-=10
	} else if keyboard_check_pressed(vk_f2) {
		room_speed+=10
	}
}