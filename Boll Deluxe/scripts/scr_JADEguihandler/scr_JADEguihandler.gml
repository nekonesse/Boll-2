function draw_gui(_x, _y, w, h, color, alpha, outline=false){
	draw_sprite_stretched_ext(spr_JADEguibevel,outline,_x,_y,w,h,color,alpha)
}

function JADEsmallbuttons(_x, _y, _width, _height) constructor {
	x = _x;
    y = _y;
	width = _width;
	height = _height;
	buttons = [];
	drawstruct = [];
	funcs = [];
	
	static add = function(name, func) {
		array_push(buttons, name)
		array_push(drawstruct,ScribblejrFitExt(name,fa_left,fa_center,global.rulerGold,1,width,height));
		array_push(funcs,func);
	}	
	
	static draw = function(spacing=8) {
		
		var curs_x = window_mouse_get_x() //((mouse_x - cam_x)/oJADEController.zoom_level)/(cam_w/guiw);
		var curs_y = window_mouse_get_y() //((mouse_y - cam_y)/oJADEController.zoom_level)/(cam_h/guih);
		
		var i=0;
		repeat(array_length(buttons)) {
			var over = point_in_rectangle(curs_x,curs_y,x+(width+spacing)*i,y,x+width+(width+spacing)*i,y+height)
			
			var buttoncolor = oJADEController.themeaccent3
			
			if (oJADEController.selected_button[0]==self && oJADEController.selected_button[1] == i)
			buttoncolor = oJADEController.themeaccent2
			else if (over) buttoncolor = oJADEController.themeaccent4
			
			draw_gui(x+(width+spacing)*i,y,width,height,buttoncolor, 1)
			drawstruct[i].Draw(x+2+(width+spacing)*i,y+height/2)
			i++;
		}
	}
	
	static update = function(spacing=8) {
		
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		
		var i=0;
		repeat(array_length(buttons)) {
			var over = point_in_rectangle(curs_x,curs_y,x+(width+spacing)*i,y,x+width+(width+spacing)*i,y+height)
			
			var myfunc = funcs[i]
			if over {
				//if i havent already been selected
				if !(oJADEController.selected_button[0]==self && oJADEController.selected_button[1] == i) {
					oJADEController.selected_button=[self,i]
					myfunc();
				} else {
					//destroy my created gui, if i have one
					oJADEController.selected_button=[-1,-1]
					instance_destroy(oJADEGUIpar)
				}
			}
			i++;
		}
	}
}

function JADEdropdown(_x,_y, names, func) {
	instance_destroy(oJADEGUIpar)
	draw_set_font(global.rulerGold)
	var inst=instance_create_depth(_x+3,_y+3,oJADEController.depth-1,oJADEDropDown)
	var i=0;
	var maxwidth=0;
	repeat(array_length(names)) {
		if maxwidth<string_width(names[i]) {
			maxwidth=string_width(names[i])
		}
		i++;
	}
	inst.image_xscale=max(96,maxwidth)
	inst.image_yscale=(16*array_length(names))
	inst.names=names
	inst.func=func
}