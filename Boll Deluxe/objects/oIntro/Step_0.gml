

if (egg == "3") {
	if !(global.roomTimer & 1) {frame += 1}
	if (frame >= hsp) {
		game_set_speed(60,gamespeed_fps)
		frame = 1
		flash = 30
		egg = ""
		bollStruct.x = 240
		bollStruct.y = 135
		bollStruct.z = 40
	}
} else {
	if !frame {
		bollStruct.x += (240 - bollStruct.x) / 10
		bollStruct.y += (135 - bollStruct.y) / 10
		bollStruct.z = sin(global.roomTimer * 0.01) * 32
	
		if (bollStruct.z > bollStruct.biggestZ) {
			bollStruct.biggestZ = bollStruct.z
		} else {
			bollStruct.z = bollStruct.biggestZ
			frame = 1
			flash = 30
		}
	}
}

if flash {flash -= 1}

if (!global.debug && keyboard_check_pressed(vk_anykey))||(keyboard_check_pressed(vk_enter)) {
	game_set_speed(60,gamespeed_fps)
	room_goto(rMainMenu)
}