if !surface_exists(menusurface) exit;

surface_set_target(menusurface);
draw_clear_alpha(c_black,0);

draw_set_font(global.rulerGold);

draw_text_scribble(room_width, room_height, $"[spr_rulergold][fa_bottom][fa_right][c_white]{version}");

if (on_title) {
    if (on_title > 24)
        draw_text_scribble(room_width / 2, (room_height) - 60, "[spr_rulergold][fa_center][fa_middle][c_white]Press Any Button");
    draw_sprite(spr_TECHDEMO_logo, 0, room_width / 2, (room_height / 2));
} else {
    
    var _startStr = "[spr_rulergold][fa_center][fa_middle]",
        _startStr_Settings = "[spr_rulergold][fa_left][fa_middle]",
    	_yPos = 0,
    	_xPos = room_width/2,
        _xPos_Settings = 48,
        _xPos_SettingsHeader = 32,
    	_rmWid = room_width,
    	_rmHei = room_height;
    
    
    switch (crMenu) {
    	case "mainmenu":
    		draw_sprite(spr_TECHDEMO_logo, 0, room_width / 2, (room_height / 2) - (dsin(title_offset) * 48));
    	
    		_displayOPS = ["Level Select", "Settings", "Editor", "Exit Game"];
            
    		var _yPos = (_rmHei/2)-(24*(array_length(_displayOPS)-1)/2)+(_rmHei * 0.30);
    		var i=0;
    		repeat (array_length(_displayOPS)) { // Looping through options to draw them on screen
    			var color = "[c_white]"
    			
    			if (option=i) {
    				selectArrowY = _yPos
    				color = "[c_yellow]"
    			}
    			
    			draw_text_scribble(_xPos,_yPos,$"{_startStr}{color}{_displayOPS[i]}");
    				
    			_yPos+=16;
    			i++;
    		}
    		
    		selectArrowYtrans = lerp(selectArrowYtrans,selectArrowY,0.25);
    		
    		selectArrowWidth = string_width(_displayOPS[option])/2
    		selectArrowWidthtrans = lerp(selectArrowWidthtrans,selectArrowWidth,0.25);
    		
    		draw_text_scribble(_xPos-selectArrowWidthtrans-2,round(selectArrowYtrans),"[spr_rulergold][c_yellow][fa_middle][fa_right]>>");
    		draw_text_scribble(_xPos+selectArrowWidthtrans+2,round(selectArrowYtrans),"[spr_rulergold][c_yellow][fa_middle][fa_left]<<");
            
            //draw_text_scribble(_xPos,room_height * 0.8,$"{_startStr}[c_yellow]>>{_displayOPS[option]}<<");
    	break;
    	
    	case "settings":
    		draw_text_scribble(_xPos_SettingsHeader,24,$"{_startStr_Settings}SETTINGS");
    	
    		var scalestr = $"Window Scale: {temp_settings.resolution_scale}x"
    		var fullscreentype, fulldesctype;
    		switch(temp_settings.fullscreen_type) {
    			case 0: fulldesctype = "Run in a regular window." fullscreentype = "None" break;
    			case 1: fulldesctype = "Run in a borderless window.\nRecommended." fullscreentype = "Windowed Borderless" break;
    			case 2: fulldesctype = "Run using legacy fullscreen\nbehaviour.\n\nNot recommended, but may be\nnecessary for older hardware." fullscreentype = "Legacy Fullscreen" break;
    		}
    		var fullscr = $"Fullscreen: {fullscreentype}"
            var fullscr_desc = $"Whether the game will\nbe in fullscreen.\n\nCurrent setting:\n{fulldesctype}"
    		var mastervol = $"Master Volume: {round(temp_settings.master_vol*100)}%"
    		var musicvol = $"Music Volume: {round(temp_settings.music_vol*100)}%"
    		var soundvol = $"Sound Volume: {round(temp_settings.sound_vol*100)}%"
    		_displayOPS = [scalestr, fullscr, mastervol, musicvol, soundvol, "Accessibility", "Keybinds", "Apply Changes"];
            _displayDesc =
            ["The size of the game window,\nin integer scales.",
             fullscr_desc,
             "Determines how loud or quiet\nthe game in general will be.",
             "Determines how loud or quiet\nmusic and jingles will be.",
             "Determines how loud or quiet\nsound effects and voices will be.",
             "Accessibility options for\ncertain players.\nThese are off by default\nand do not affect gameplay,\nonly audio and visuals.",
             "Bind keyboard keys or\ncontroller buttons\nto game actions.",
             "Save and apply any\nsettings changes."];
    		var _yPos = 56;
    		var i=0;
    		repeat (array_length(_displayOPS)) { // Looping through options to draw them on screen
    			var color = "[c_white]"
    			
    			if (option=i) {
    				selectArrowY = _yPos
    				color = "[c_yellow]"
    			}
    			
    			draw_text_scribble(_xPos_Settings,_yPos,$"{_startStr_Settings}{color}{_displayOPS[i]}");
    			
    			i++;
    			if (i<=5) {
    				_yPos+=16;
    			} else {
    				_yPos+=24;
    			}
    		}
    		
    		selectArrowYtrans = lerp(selectArrowYtrans,selectArrowY,0.25);
    		
    		selectArrowWidth = string_width(_displayOPS[option]) / 2
    		selectArrowWidthtrans = lerp(selectArrowWidthtrans,selectArrowWidth,0.25);
    		
            if (option >= 0 && option < array_length(_displayDesc))
                draw_text_scribble(room_width - 16, 32, $"[spr_rulergold][fa_right][fa_top][c_white]{_displayDesc[option]}");
            
    		draw_text_scribble(_xPos_Settings - 12, round(selectArrowYtrans), "[spr_rulergold][c_yellow][fa_right]>>");
    		//draw_text_scribble(_xPos_Settings+selectArrowWidthtrans+2 + (selectArrowWidth),round(selectArrowYtrans),"[spr_rulergold][c_yellow][fa_left]<<");
    	break;
    	
    	case "accessibility":
    		draw_text_scribble(_xPos_SettingsHeader,24,$"{_startStr_Settings}ACCESSIBILITY SETTINGS");
    		
    		var alternatehud;
    		switch(temp_settings.alternate_hud) {
    			case 0: alternatehud = "Off" break;
    			case 1: alternatehud = "On" break;
    		}
    		var althud = $"Alternate HUD: {alternatehud}"
    		
    		var sensitivesounds;
    		switch(temp_settings.sensitive_sound) {
    			case 0: sensitivesounds = "On" break;
    			case 1: sensitivesounds = "Off" break;
    		}
    		var sensitivesnd = $"Sensitive Sounds: {sensitivesounds}"
    		
    		_displayOPS = [althud, sensitivesnd, "Apply Changes", "Back"];
            _displayDesc =
            ["Uses an alternate HUD font\nfor players that struggle\nwith reading the original HUD.",
             "Removes specific sounds that\nmay potentially trigger or\notherwise cause discomfort\nin certain players.",
             "Save and apply any\nsettings changes."];
    		var _yPos = 80;
    		var i=0;
    		repeat (array_length(_displayOPS)) { // Looping through options to draw them on screen
    			var color = "[c_white]"
    			
    			if (option=i) {
    				selectArrowY = _yPos
    				color = "[c_yellow]"
    			}
    			
    			draw_text_scribble(_xPos_Settings,_yPos,$"{_startStr_Settings}{color}{_displayOPS[i]}");
    			
    			i++;
    			if (i<=6) {
    				_yPos+=24;
    			} else {
    				_yPos+=16;
    			}
    		}
    		
    		selectArrowYtrans = lerp(selectArrowYtrans,selectArrowY,0.25);
    		
    		selectArrowWidth = string_width(_displayOPS[option]) / 2
    		selectArrowWidthtrans = lerp(selectArrowWidthtrans,selectArrowWidth,0.25);
            
            if (option >= 0 && option < array_length(_displayDesc))
                draw_text_scribble(room_width - 16, 32, $"[spr_rulergold][fa_right][fa_top][c_white]{_displayDesc[option]}");
    		
    		draw_text_scribble(_xPos_Settings - 12, round(selectArrowYtrans), "[spr_rulergold][c_yellow][fa_right]>>");
    		//draw_text_scribble(_xPos_Settings+selectArrowWidthtrans+2 + (selectArrowWidth),round(selectArrowYtrans),"[spr_rulergold][c_yellow][fa_left]<<");
    	break;
    	
    	case "levelselectm":
    		var _startStr = "[spr_rulergold][fa_middle][fa_left]";
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
    				
    				draw_text_scribble(_xPos,_yPos+3,$"{_startStr}{color}{struct.name}");
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
    		
    	break;
    	
    	case "keybindsm":
    		draw_text_scribble(_rmWid/2,16,$"{_startStr}KEYBINDS")
    
    		var _binds = [INPUT_VERB.RIGHT,INPUT_VERB.LEFT,INPUT_VERB.UP,INPUT_VERB.DOWN,INPUT_VERB.A,INPUT_VERB.B,INPUT_VERB.C,INPUT_VERB.V,"reset"];
    		_displayOPS = ["Right","Left","Up","Down","Button A","Button B","Button C","Button V","Reset Bindings"];
    		var _yPos = (_rmHei/2)-(16*(array_length(_displayOPS)-1)/2),
    			_bindShow = "";
    		var i=0;
    		repeat (array_length(_displayOPS)) { // Looping through options to draw them on screen
    			if (i<8) _bindShow=$" : {InputIconGet(_binds[i])}";
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
    		if (option<8) stringext = $" : {InputIconGet(_binds[option])}"
    		selectArrowWidth = string_width(_displayOPS[option]+stringext)/2
    		selectArrowWidthtrans = lerp(selectArrowWidthtrans,selectArrowWidth,0.25);
    		
    		draw_text_scribble(_xPos-selectArrowWidthtrans-2,round(selectArrowYtrans),"[spr_rulergold][fa_middle][c_yellow][fa_right]>>");
    		draw_text_scribble(_xPos+selectArrowWidthtrans+2,round(selectArrowYtrans),"[spr_rulergold][fa_middle][c_yellow][fa_left]<<");
    	break;
    }
}
surface_reset_target()

draw_surface_ext(menusurface,1,1,1,1,0,c_black,1);
draw_surface(menusurface,0,0);