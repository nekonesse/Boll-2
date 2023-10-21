right=input_check_pressed("right");
left=input_check_pressed("left");
up=input_check_pressed("up");
down=input_check_pressed("down");
akey=(input_check_pressed("jump") || input_check_pressed("enter"));
bkey=input_check_pressed("action");
ckey=input_check_pressed("special");

selectedoption=wrap_val(selectedoption,0,8)

if (up)
selectedoption-=1
else if (down)
selectedoption+=1

if (akey) {
	switch selectedoption {
		case 0: room_goto(rMainMenu) break;
		case 1: rebinding_verb="right" event_user(0) break;
		case 2: rebinding_verb="left" event_user(0) break;
		case 3: rebinding_verb="up" event_user(0) break;
		case 4: rebinding_verb="down" event_user(0) break;
		case 5: rebinding_verb="action" event_user(0) break;
		case 6: rebinding_verb="jump" event_user(0) break;
		case 7: rebinding_verb="special" event_user(0) break;
		case 8: input_profile_reset_bindings(INPUT_AUTO_PROFILE_FOR_KEYBOARD) break;
	}
}