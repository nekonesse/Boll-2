mbleft=mouse_check_button_pressed(mb_left)

curs_x=mouse_x
curs_y=mouse_y

if keyboard_check_pressed(vk_escape) room_goto(rMainMenu)

for (var i = 0; i < 5; ++i)
{
	if (mbleft) && mouse_in_mode_slot(i) {
		selected_mode=i
	}
}

if (mbleft) && mouse_in_setting_slot(0) { //exit button
	room_goto(rMainMenu)
}