if !(global.roomTimer & 1) {frame += 1}
if (frame >= hsp || keyboard_check_pressed(vk_anykey)) {
	room_goto(rMainMenu)
}