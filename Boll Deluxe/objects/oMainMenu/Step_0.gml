if (!optionLock) {
	right	=input_check_pressed("right");
	left	=input_check_pressed("left");
	up		=input_check_pressed("up");
	down	=input_check_pressed("down");
	akey	=(input_check_pressed("a") || input_check_pressed("enter"));
	bkey	=input_check_pressed("b");
	ckey	=input_check_pressed("c");
} else {
	right	=0;
	left	=0;
	up		=0;
	down	=0;
	akey	=0;
	bkey	=0;
	ckey	=0;
}

if (!optionLock) {
	OptionMover();

	switch (crMenu) {
		case "mainmenu":
			optMAX = 3;
			if (akey) {
				switch option {
					case 0: crMenu="levelselectm" option=0 break;
					case 1: crMenu="keybindsm" option=0 break;
					case 2: room_goto(rEditor) option=0 break;
					case 3: game_end(); break;
				}
			}
		break
	
		case "levelselectm":
			optMAX = array_length(global.levellist)-1;
			if (akey) {
				crMenu="cssm";
				//option=0;
				global.nextlevel=global.levellist[option];
				optionLock=1;
				instance_create_depth(x,y,depth,oCSS);
			}
			if (bkey) {
				backAmenu("mainmenu");
			}
		break
		
		case "cssm":
			//if (!instance_exists(oCSS)) instance_create_depth(x,y,depth,oCSS);
			//optMAX = 0;
			if (bkey) {
				backAmenu("levelselectm");
			}
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
}