right=input_check_pressed("right");
left=input_check_pressed("left");
up=input_check_pressed("up");
down=input_check_pressed("down");
akey=(input_check_pressed("jump") || input_check_pressed("enter"));
bkey=input_check_pressed("action");
ckey=input_check_pressed("special");

if (up)
selectedlevel-=1
else if (down)
selectedlevel+=1

selectedlevel=clamp(selectedlevel,0,array_length(global.levellist))

if (akey) {
	if (selectedlevel==0) { 
		room_goto(rMainMenu)
	} else {
		global.nextlevel=global.levellist[selectedlevel-1]
		event_user(0)
		room_goto(rLDTKload)
	}
}