

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
		bolldive = sin(global.roomTimer * 0.05) * (135 - (bounce * 75))
		bollStruct.x += (240 - bollStruct.x) / 35
		bollStruct.y += (135 - bollStruct.y) / 10
		bollStruct.z = sin(global.roomTimer * 0.0125) * 32
	
		if (bollStruct.z > bollStruct.biggestZ) {
			bollStruct.biggestZ = bollStruct.z
		} else {
			hsp = sign(bolldive)
			bolldive = -abs(bolldive);
			bollStruct.z = bollStruct.biggestZ
			bounce = 1;
			if (hsp == sign(bolldive) && bounce == 1) {
				frame = 1
				flash = 30
			}
		}
	}
}

if flash {flash -= 1}

if (!global.debug && keyboard_check_pressed(vk_anykey))||(keyboard_check_pressed(vk_enter) || mouse_check_button_pressed(mb_left)) {
	game_set_speed(60,gamespeed_fps)
	room_goto(rMainMenu)
}