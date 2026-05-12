if !surface_exists(menusurface) exit;

surface_set_target(menusurface);
draw_clear_alpha(c_black,0);

draw_set_font(global.rulerGold)

var _startStr = "[spr_rulergold][fa_center][fa_middle]",
	_yPos = 0,
	_xPos = room_width/2,
	_rmWid = room_width,
	_rmHei = room_height;


switch (crMenu) {
	case "mainmenu":
		draw_text_scribble(_xPos,24,$"{_startStr}Mario & Sonic\nBoll 2");
	
		_displayOPS = ["Level Select", "Settings", "Editor", "Exit Game"];
		var _yPos = (_rmHei/2)-(32*(array_length(_displayOPS)-1)/2)+24;
		var i=0;
		repeat (array_length(_displayOPS)) { // Looping through options to draw them on screen
			var color = "[c_white]"
			
			if (option=i) {
				selectArrowY = _yPos
				color = "[c_yellow]"
			}
			
			draw_text_scribble(_xPos,_yPos,$"{_startStr}{color}{_displayOPS[i]}");
				
			_yPos+=24;
			i++;
		}
		
		selectArrowYtrans = lerp(selectArrowYtrans,selectArrowY,0.25);
		
		selectArrowWidth = string_width(_displayOPS[option])/2
		selectArrowWidthtrans = lerp(selectArrowWidthtrans,selectArrowWidth,0.25);
		
		draw_text_scribble(_xPos-selectArrowWidthtrans-2,round(selectArrowYtrans),"[spr_rulergold][c_yellow][fa_middle][fa_right]>>");
		draw_text_scribble(_xPos+selectArrowWidthtrans+2,round(selectArrowYtrans),"[spr_rulergold][c_yellow][fa_middle][fa_left]<<");
	break;
	
	case "settings":
		draw_text_scribble(_xPos,16,$"{_startStr}SETTINGS");
	
		var scalestr = $"Window Scale:\n{temp_settings.resolution_scale}x"
		var fullscreentype;
		switch(temp_settings.fullscreen_type) {
			case 0: fullscreentype = "None" break;
			case 1: fullscreentype = "Windowed Borderless" break;
			case 2: fullscreentype = "Legacy Fullscreen" break;
		}
		var fullscr = $"Fullscreen:\n{fullscreentype}"
		var mastervol = $"Master Volume:\n{round(temp_settings.master_vol*100)}%"
		var musicvol = $"Music Volume:\n{round(temp_settings.music_vol*100)}%"
		var soundvol = $"Sound Volume:\n{round(temp_settings.sound_vol*100)}%"
		var alternatehud;
		switch(temp_settings.alternate_hud) {
			case 0: alternatehud = "Off" break;
			case 1: alternatehud = "On" break;
		}
		var althud = $"Alternate HUD:\n{alternatehud}"
		_displayOPS = [scalestr, fullscr, mastervol, musicvol, soundvol, althud, "Keybinds", "Apply Changes"];
		var _yPos = 24;
		var i=0;
		repeat (array_length(_displayOPS)) { // Looping through options to draw them on screen
			var color = "[c_white]"
			
			if (option=i) {
				selectArrowY = _yPos
				color = "[c_yellow]"
			}
			
			draw_text_scribble(_xPos,_yPos,$"[spr_rulergold][fa_center]{color}{_displayOPS[i]}");
			
			i++;
			if (i<=6) {
				_yPos+=32;
			} else {
				_yPos+=16;
			}
		}
		
		selectArrowYtrans = lerp(selectArrowYtrans,selectArrowY,0.25);
		
		selectArrowWidth = string_width(_displayOPS[option])/2
		selectArrowWidthtrans = lerp(selectArrowWidthtrans,selectArrowWidth,0.25);
		
		draw_text_scribble(_xPos-selectArrowWidthtrans-2,round(selectArrowYtrans),"[spr_rulergold][c_yellow][fa_right]>>");
		draw_text_scribble(_xPos+selectArrowWidthtrans+2,round(selectArrowYtrans),"[spr_rulergold][c_yellow][fa_left]<<");
	break;
	
	case "levelselectm":
		var _startStr = "[spr_omifont][fa_middle][fa_left]";
		draw_text_scribble(_rmWid/2,16,$"[spr_rulergold][fa_center][fa_middle]SELECT LEVEL")
		
		if (array_length(global.levellist)) {
			var _xPos = 56,
				_yPos = (_rmHei/2)-max((array_length(global.levellist)-1)/2,option)*16;
			var selected_opt = "";
			var i=0;
			repeat (array_length(global.levellist)) { // Looping through options to draw them on screen
				var color = "[c_white]"
				var struct = global.levellist[i];
			
				if (option=i) {
					selectArrowY = _yPos
					color = "[c_yellow]"
					selected_opt = struct.name;
				}
				
				draw_text_scribble(_xPos,_yPos,$"{_startStr}{color}{struct.name}");
				_yPos+=16;
				i++;
			}
		
			selectArrowYtrans = lerp(selectArrowYtrans,selectArrowY,0.25);
			
			selectArrowWidth = string_width(selected_opt)/2
			selectArrowWidthtrans = lerp(selectArrowWidthtrans,selectArrowWidth,0.25);
		
			draw_text_scribble(_xPos-2,round(selectArrowYtrans)+2,"[spr_rulergold][c_yellow][fa_middle][fa_right]>>");
		}
	break;
	
	case "cssm":
		draw_text_scribble(_rmWid/2,16,$"[spr_rulergold][fa_center][fa_middle]CHARACTER SELECT")
	break;
	
	case "keybindsm":
		draw_text_scribble(_rmWid/2,16,$"{_startStr}KEYBINDS")

		var _binds = ["right","left","up","down","a","b","c","v"];
		_displayOPS = ["Right","Left","Up","Down","A","B","C","V","Reset Bindings"];
		var _yPos = (_rmHei/2)-(16*(array_length(_displayOPS)-1)/2),
			_bindShow = "";
		var i=0;
		repeat (array_length(_displayOPS)) { // Looping through options to draw them on screen
			if (i!=8) _bindShow=$" : {input_binding_get_icon(input_binding_get(_binds[i]))}";
			else _bindShow = "";
			
			var color = "[c_white]"
			
			if (option=i) {
				selectArrowY = _yPos
				color = "[c_yellow]"
			}
			
			draw_text_scribble(_xPos,_yPos,$"{_startStr}{color}{_displayOPS[i]}{_bindShow} ");
			_yPos+=16;
			i++;
		}
		
		selectArrowYtrans = lerp(selectArrowYtrans,selectArrowY,0.25);
			
		var stringext = ""
		if (option!=8) stringext = $" : {input_binding_get_icon(input_binding_get(_binds[option]))}"
		selectArrowWidth = string_width(_displayOPS[option]+stringext)/2
		selectArrowWidthtrans = lerp(selectArrowWidthtrans,selectArrowWidth,0.25);
		
		draw_text_scribble(_xPos-selectArrowWidthtrans-2,round(selectArrowYtrans),"[spr_rulergold][fa_middle][c_yellow][fa_right]>>");
		draw_text_scribble(_xPos+selectArrowWidthtrans+2,round(selectArrowYtrans),"[spr_rulergold][fa_middle][c_yellow][fa_left]<<");
	break;
}
surface_reset_target()

draw_surface_ext(menusurface,1,1,1,1,0,c_black,1);
draw_surface(menusurface,0,0);