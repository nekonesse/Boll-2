
interim_timer--;

if (keyboard_check_pressed(vk_anykey) && interim_timer <= 0) {
	room_goto(rTECHDEMO_MainMenu)
}