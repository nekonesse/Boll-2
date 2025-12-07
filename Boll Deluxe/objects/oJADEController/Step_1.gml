pressed_dropdown=false;

mbleftpress = mouse_check_button_pressed(mb_left)
mbleftrel = mouse_check_button_released(mb_left)
mbleft = mouse_check_button(mb_left)
mbrightpress = mouse_check_button_pressed(mb_right)
mbrightrel = mouse_check_button_released(mb_right)
mbright = mouse_check_button(mb_right)
mbmiddle = (mouse_check_button(mb_middle) || (keyboard_check(vk_space) && mouse_check_button(mb_left)))