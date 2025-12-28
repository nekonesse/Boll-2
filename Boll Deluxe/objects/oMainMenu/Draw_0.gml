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
	
	case "levelselectm":
		var _startStr = "[spr_omifont][fa_center][fa_left]";
		draw_text_scribble(_rmWid/2,16,$"[spr_rulergold][fa_center][fa_middle]SELECT LEVEL")
	
		_displayOPS = global.levellist;
		if (array_length(_displayOPS)) {
			var _xPos = 56,
				_yPos = (_rmHei/2)-max((array_length(_displayOPS)-1)/2,option)*16;
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
		}
	break;
	
	case "cssm":
		draw_text_scribble(_rmWid/2,16,$"[spr_rulergold][fa_center][fa_middle]CHARACTER SELECT")
	break;
	
	case "keybindsm":
		draw_text_scribble(_rmWid/2,16,$"{_startStr}KEYBINDS")

		var _binds = ["right","left","up","down","a","b","c"];
		_displayOPS = ["Right","Left","Up","Down","A","B","C","Reset"];
		var _yPos = (_rmHei/2)-(16*(array_length(_displayOPS)-1)/2),
			_bindShow = "";
		var i=0;
		repeat (array_length(_displayOPS)) { // Looping through options to draw them on screen
			if (i!=7) _bindShow=$" : {input_binding_get_icon(input_binding_get(_binds[i]))}";
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
		if (option!=7) stringext = $" : {input_binding_get_icon(input_binding_get(_binds[option]))}"
		selectArrowWidth = string_width(_displayOPS[option]+stringext)/2
		selectArrowWidthtrans = lerp(selectArrowWidthtrans,selectArrowWidth,0.25);
		
		draw_text_scribble(_xPos-selectArrowWidthtrans-2,round(selectArrowYtrans),"[spr_rulergold][fa_middle][c_yellow][fa_right]>>");
		draw_text_scribble(_xPos+selectArrowWidthtrans+2,round(selectArrowYtrans),"[spr_rulergold][fa_middle][c_yellow][fa_left]<<");
	break;
}
surface_reset_target()

draw_surface_ext(menusurface,1,1,1,1,0,c_black,1);
draw_surface(menusurface,0,0);