right	=input_check_pressed("right");
left	=input_check_pressed("left");
up		=input_check_pressed("up");
down	=input_check_pressed("down");
akey	=(input_check_pressed("a") || input_check_pressed("enter"));
bkey	=input_check_pressed("b");
ckey	=input_check_pressed("c");

if (!optionLock) OptionMover();

switch (crMenu) {
	case "mainmenu":
		optMAX = 2;
		if (akey) {
			switch option {
				case 0: crMenu="levelselectm" option=0 break;
				case 1: crMenu="keybindsm" option=0 break;
				case 2: game_end(); break;
			}
		}
	break
	
	case "levelselectm":
		optMAX = array_length(global.levellist)-1;
		if (akey) {
			global.nextlevel=global.levellist[option];
			room_goto(rLDTKload);
		}
		if (bkey) backAmenu("mainmenu");
	break
	
	case "keybindsm":
		var _binds = ["right","left","up","down","a","b","c"];
		optMAX = array_length(_binds);
		if (akey) {
			if (option!=7) {
				rebindKey(_binds[option])
			} else {
				input_profile_reset_bindings(INPUT_AUTO_PROFILE_FOR_KEYBOARD);
			}
		}
		if (bkey) backAmenu("mainmenu");
	break
}