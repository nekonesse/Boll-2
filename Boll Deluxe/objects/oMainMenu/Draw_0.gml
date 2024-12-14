var _startStr = "[basicPlaceholderF][fa_center][fa_middle]",
	_yPos = 0,
	_xPos = room_width/2,
	_rmWid = room_width,
	_rmHei = room_height;


switch (crMenu) {
	case "mainmenu":
		_displayOPS = ["level selector", "keybinds", "editor", "title screen", "exit game"];
		var _yPos = (_rmHei/2)-(32*(array_length(_displayOPS)-1)/2);
		for (var i=0; i<array_length(_displayOPS); i++;) { // Looping through options to draw them on screen
			if (option=i)
				draw_text_scribble(_xPos,_yPos,$"{_startStr}>> {_displayOPS[i]} <<");
			else
				draw_text_scribble(_xPos,_yPos,$"{_startStr}{_displayOPS[i]}");
				
			_yPos+=32;
		}
	break;
	
	case "levelselectm":
		var _startStr = "[spr_omifont][fa_center][fa_left]";
		draw_text_scribble(_rmWid/2,16,$"[basicPlaceholderF][fa_center][fa_middle]SELECT LEVEL")
	
		_displayOPS = global.levellist;
		var _xPos = 56,
			_yPos = (_rmHei/2)-(16*(array_length(_displayOPS)-1)/2);
		for (var i=0; i<array_length(_displayOPS); i++;) { // Looping through options to draw them on screen
			if (option=i)
				draw_text_scribble(_xPos,_yPos,$"{_startStr} -- {_displayOPS[i]}");
			else
				draw_text_scribble(_xPos,_yPos,$"{_startStr}{_displayOPS[i]}");
				
			_yPos+=16;
		}
	break;
	
	case "cssm":
		draw_text_scribble(_rmWid/2,16,$"[basicPlaceholderF][fa_center][fa_middle]CHARACTER SELECT")
	break;
	
	case "keybindsm":
		draw_text_scribble(_rmWid/2,16,$"{_startStr}KEYBINDS")

		_displayOPS = ["right","left","up","down","a","b","c","reset"];
		var _yPos = (_rmHei/2)-(16*(array_length(_displayOPS)-1)/2),
			_bindShow = "";
		for (var i=0; i<array_length(_displayOPS); i++;) { // Looping through options to draw them on screen
			if (i!=7) _bindShow=$" : {input_binding_get_icon(input_binding_get(_displayOPS[i]))}";
			else _bindShow = "";
			if (option=i)
				draw_text_scribble(_xPos,_yPos,$"{_startStr} >> {_displayOPS[i]}{_bindShow} <<");
			else
				draw_text_scribble(_xPos,_yPos,$"{_startStr}{_displayOPS[i]}{_bindShow} ");
				
			_yPos+=16;
		}
	break;
}
