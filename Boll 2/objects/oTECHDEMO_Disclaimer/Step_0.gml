
interim_timer--;

if (interim_timer <= 0 && !a11y_prompted) {
	a11y_prompted = true;
	// Enqueue after the disclaimer finishes (do not interrupt it)
	a11y_speak("Press any button to continue.", false);
}

if (keyboard_check_pressed(vk_anykey) && interim_timer <= 0) {
	a11y_silence();
	room_goto(rTECHDEMO_MainMenu)
}