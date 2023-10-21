right=input_check_pressed("right");
left=input_check_pressed("left");
up=input_check_pressed("up");
down=input_check_pressed("down");
akey=(input_check_pressed("jump") || input_check_pressed("enter"));
bkey=input_check_pressed("action");
ckey=input_check_pressed("special");

selectedoption=wrap_val(selectedoption,0,2)

if (up)
selectedoption-=1
else if (down)
selectedoption+=1

if (akey) {
	switch selectedoption {
		case 0: room_goto(rLevelSelect) break;
		case 1: room_goto(rKeybinding) break;
		case 2: game_end(); break;
	}
}