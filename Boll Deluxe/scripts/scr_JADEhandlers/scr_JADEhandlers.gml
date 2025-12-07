function draw_gui(_x, _y, w, h, color, alpha, outline=false){
	draw_sprite_stretched_ext(spr_JADEguibevel,outline,_x,_y,w,h,color,alpha)
}

function JADEsmallbuttons(_x, _y, _width, _height, spacing=8, is_toggle=true, inverted=false, _vertical=false) constructor {
	x = _x;
    y = _y;
	width = _width;
	height = _height;
	button_spacing = spacing;
	buttons = [];
	drawstruct = [];
	funcs = [];
	button_toggle = is_toggle;
	selected_button=-1;
	color_invert = inverted;
	vertical = _vertical;
	
	static add = function(name, func) {
		array_push(buttons, name)
		array_push(drawstruct,ScribblejrFitExt(name,fa_left,fa_center,global.rulerGold,1,width-4,height));
		array_push(funcs,func);
	}	
	
	static draw = function() {
		
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		
		var i=0;
		repeat(array_length(buttons)) {
			var _x1,_x2,_y1,_y2;
			if !(vertical) {
				_x1 = x+(width+button_spacing)*i
				_y1 = y
				_x2 = x+width+(width+button_spacing)*i
				_y2 = y+height
			} else {
				_x1 = x
				_y1 = y+(height+button_spacing)*i
				_x2 = x+width
				_y2 = y+height+(height+button_spacing)*i
			}
			
			var over = point_in_rectangle(curs_x,curs_y,_x1,_y1,_x2,_y2)
			
			if !color_invert
			var buttoncolor = oJADEController.themeaccent3
			else buttoncolor=oJADEController.themeaccent2
			
			if (selected_button == i) {
				if !color_invert
				buttoncolor = oJADEController.themeaccent2
				else
				buttoncolor = oJADEController.themeaccent3
			} else if (over) {
				buttoncolor = oJADEController.themeaccent4
			}
			
			draw_gui(_x1,_y1,width,height,buttoncolor, 1)
			drawstruct[i].Draw(_x1+2,_y1+height/2+3)
			i++;
		}
	}
	
	static update = function() {
		
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		
		var i=0;
		repeat(array_length(buttons)) {
			var _x1,_x2,_y1,_y2;
			if !(vertical) {
				_x1 = x+(width+button_spacing)*i
				_y1 = y
				_x2 = x+width+(width+button_spacing)*i
				_y2 = y+height
			} else {
				_x1 = x
				_y1 = y+(height+button_spacing)*i
				_x2 = x+width
				_y2 = y+height+(height+button_spacing)*i
			}
			
			var over = point_in_rectangle(curs_x,curs_y,_x1,_y1,_x2,_y2)
			
			var myfunc = funcs[i]
			if over {
				//if i havent already been selected
				if !(selected_button == i) || !(button_toggle) {
					selected_button=i
					myfunc();
				} else {
					//destroy my created gui, if i have one
					selected_button=-1
					instance_destroy(oJADEDropDown)
				}
				oJADEController.mbleftpress = false;
				break;
			}
			i++;
		}
	}
	
	static reset = function() {
		selected_button=-1
	}
}

function JADEiconbutton(_x, _y, _sprite, _func, is_toggle=true, inverted=false) constructor {
	x = _x;
    y = _y;
	sprite = _sprite
	width = sprite_get_width(sprite)+4;
	height = sprite_get_height(sprite)+4;
	funcs = _func
	button_toggle = is_toggle;
	selected_button=0;
	color_invert = inverted;
	created_gui = noone;
	over = false;
	
	static draw = function() {
		
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		
		var over = point_in_rectangle(curs_x,curs_y,x-2,y-2,x+width+2,y+height+2) && !collision_rectangle(x-2,y-2,x+width+2,y+height+2,oJADEDropDown,false,true)
			
		if !color_invert
		var buttoncolor = oJADEController.themeaccent3
		else buttoncolor=oJADEController.themeaccent2
			
		if (selected_button) {
			if !color_invert
			buttoncolor = oJADEController.themeaccent2
			else
			buttoncolor = oJADEController.themeaccent3
		} else if (over) {
			buttoncolor = oJADEController.themeaccent4
		}
			
		draw_gui(x-2,y-2,width,height,buttoncolor, 1)
		draw_sprite(sprite,0,x,y)
	}
	
	static update = function() {
		
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		
		var over = point_in_rectangle(curs_x,curs_y,x-2,y-2,x+width+2,y+height+2) && !collision_rectangle(x-2,y-2,x+width+2,y+height+2,oJADEDropDown,false,true)
		
		if over {
			//if i havent already been selected
			if !(selected_button) || !(button_toggle) {
				selected_button=true
				funcs()
			} else {
				//destroy my created gui, if i have one
				selected_button=false
				if (instance_exists(created_gui)) {
					instance_destroy(created_gui);
				}
				instance_destroy(oJADEDropDown);
			}
			oJADEController.mbleftpress = false;
		}
	}
	
	static reset = function() {
		selected_button=false
	}
}

function JADEtoolbar(_x, _y) constructor {
	x = _x;
    y = _y;
	buttons = [];
	size=28;
	spacing=8;
	
	static set = function(arr) {
		buttons = [];
		buttons = arr;		
	}
	
	static draw = function() {
		
		var curs_x = window_mouse_get_x();
		var curs_y = window_mouse_get_y();
		
		var length=array_length(buttons);
		var i=0;
		repeat(length) {
			var over = point_in_rectangle(curs_x,curs_y,x+(size+spacing)*i,y,x+size+(size+spacing)*i,y+size) && !instance_exists(oJADEGUIpar)
			
			var buttoncolor = oJADEController.themeaccent3
			
			if (oJADEController.selected_tool==buttons[i])
				buttoncolor = oJADEController.themeaccent1
			else if (over) buttoncolor = oJADEController.themeaccent4
			
			draw_gui(x+(size+spacing)*i,y,size,size,buttoncolor, 1)
			draw_sprite(spr_JADEtoolicons,buttons[i],x+(size/2)+(size+spacing)*i,y+size/2)
			i++;
		}
	}
	
	static update = function() {
		if instance_exists(oJADEGUIpar) exit;
		
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		
		var length=array_length(buttons);
		var i=0;
		repeat(length) {
			var over = point_in_rectangle(curs_x,curs_y,x+(size)*i,y,x+size+(size+spacing)*i,y+size)
		
			if over {
				oJADEController.selected_tool=buttons[i]
				break;
			}
			i++;
		}
	}
}

function JADEdropdown(_x,_y, names, func) {
	instance_destroy(oJADEDropDown)
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
	
	return inst
}

function JADElistcategory(_name) constructor {
	listname=_name;
	listcontents=[];
	collapsed = true;
	
	static collapse = function() {
		collapsed=!collapsed
	}
	
	static add = function(_item) {
		array_push(listcontents, _item)
	}
	
	static get_contents = function() {
		return listcontents;
	}
}

function JADElisthandler(_x, _y, _width, _height, _checkvar) constructor {
	x=_x;
	y=_y;
	width=_width;
	height=_height;
	listcontents=[];
	checkvar=_checkvar;
	listwidth = 0;
	listheight = 0;
	scroll_x = 0;
	scroll_y = 0;
	handle_x = 0;
	handle_y = 0;
	mouse_offset_x = 0;
	mouse_offset_y = 0;
	is_scrolling_x=0;
	is_scrolling_y=0;
	
	static add = function(_item) {
		array_push(listcontents, _item)
	}
	
	static get_contents = function() {
		return listcontents;
	}
	
	static draw = function() {
		draw_rect(x,y,width,height,oJADEController.themeaccent3,1)
		var prevarr=[];
		var currarr=[];
		var prevind=[];
		
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		var mbleft = mouse_check_button_pressed(mb_left);
		
		array_copy(currarr,0,listcontents,0,array_length(listcontents));
		var indent=0;
		var i=0;
		checkervalue=variable_instance_get(oJADEController, checkvar)
		
		var prevscissor = gpu_get_scissor();
		gpu_set_scissor(x,y,width,height);
		
		listwidth = 0;
		listheight = 0;
		
		var over = point_in_rectangle(curs_x,curs_y,x,y,x+width,y+height);
		
		draw_set_font(global.rulerGold)
		while(array_length(currarr)) { //this code is a fucking mess Im sorry.
			var item = currarr[0]
			array_delete(currarr,0,1);
			if (is_instanceof(item, JADEobj) || is_instanceof(item, JADEasset)) {
				var over_button = point_in_rectangle(curs_x,curs_y,x+indent+scroll_x,y+(24*i)+scroll_y,x+width+indent+scroll_x,y+24+(24*i)+scroll_y) && over
				if (mbleft) && (over_button) {
					variable_instance_set(oJADEController, checkvar, item)
					mbleft=0
				}
			
				if (checkervalue!=-1) && (checkervalue.uuid == item.uuid) {
					draw_rect(x+indent+scroll_x,y+(24*i)+2+scroll_y,width,20,oJADEController.themeaccent2,1)
				}
				else if (over_button) draw_rect(x+indent+scroll_x,y+(24*i)+2+scroll_y,width,20,oJADEController.themeaccent4,1,true)
				
				draw_rect(x+2+indent+scroll_x,y+24+(24*i)-1+scroll_y,width-4,2,oJADEController.themeaccent2,1) //divider
				draw_text(x+24+indent+scroll_x,y+8+(24*i)+scroll_y, item.name)
				
				if (!array_length(currarr)) && array_length(prevarr) {
					var temp=array_pop(prevarr)
					array_copy(currarr,0,temp,0,array_length(temp))
					indent=array_pop(prevind);
					
				}
			} else if is_instanceof(item, JADElistcategory) {
				var over_button = point_in_rectangle(curs_x,curs_y,x+indent+scroll_x,y+(24*i)+scroll_y,x+width+indent+scroll_x,y+24+(24*i)+scroll_y) && over
				if (mbleft) && (over_button) {
					item.collapse();
					scroll_x=clamp(scroll_x,-listwidth,0)
					mbleft=0
				}
				
				draw_gui(x+4+indent+scroll_x,y+(24*i)+1+scroll_y,width-8,22,oJADEController.themeaccent4,1) //button
				draw_text(x+8+24+indent+scroll_x,y+8+(24*i)+scroll_y,item.listname) //category name
				draw_sprite(spr_JADElistarrow,item.collapsed,x+8+indent+scroll_x,y+4+(24*i)+scroll_y) //collapse arrow
				
				if !(item.collapsed) {
					if array_length(currarr) {
						array_push(prevarr,variable_clone(currarr))
						array_push(prevind,indent);
					}
					currarr=[];
					array_copy(currarr,0,item.listcontents,0,array_length(item.listcontents))
					indent+=16;
					listwidth+=16;
				}
			}
			i++;
			if i>(height/24) listheight+=24
		}
		gpu_set_scissor(prevscissor);
		
		//Scrollbars
		var total_height=height+listheight
		var total_width=width+listwidth
		
		var over_vert_scrollbar = point_in_rectangle(curs_x,curs_y,x+width,y,x+width+4+8,y+height);
		var bar_height = max(6,(height/total_height)*height)
		
		var over_horizontal_scrollbar = point_in_rectangle(curs_x,curs_y,x,y+height,x+width,y+height+4+8);
		var bar_width = max(6,(width/total_width)*width)
		
		draw_gui(x+width+4,y,6,height,oJADEController.themeaccent2,1) //vertical scrollbar bg
		draw_gui(x+width+4,y+handle_y,6,bar_height,oJADEController.themeaccent4,1) //vertical scrollbar handle
		
		draw_gui(x,y+height+4,width,6,oJADEController.themeaccent2,1) //horizontal scrollbar bg
		draw_gui(x+handle_x,y+height+4,bar_width,6,oJADEController.themeaccent4,1) //horizontal scrollbar handle
		
		var mwheel = mouse_wheel_down() - mouse_wheel_up();
		if (mwheel == 0) {
			mwheel = keyboard_check(vk_down) - keyboard_check(vk_up)
		}
		
		if (over) && (mwheel != 0) {
			if !keyboard_check(vk_control) {
				scroll_y+=12*-mwheel
				scroll_y=clamp(scroll_y,-listheight,0)
				
				if (listheight)
				handle_y = -((height - bar_height) * scroll_y / (listheight))
			} else {
				scroll_x+=8*mwheel
				scroll_x=clamp(scroll_x,-listwidth,0)
				
				if (listwidth)
				handle_x = -((width - bar_width) * scroll_x / (listwidth))
			}
		}
		
		if (mbleft) {
			if (over_vert_scrollbar) && (height/total_height != 1) {
				if !is_scrolling_y {
					mouse_offset_y = (curs_y - (y + handle_y))	
				}
				is_scrolling_y=true
			} else if (over_horizontal_scrollbar) && (width/total_width != 1) {
				if !is_scrolling_x {
					mouse_offset_x = (curs_x - (x + handle_x))	
				}
				is_scrolling_x=true
			}
		}
		
		if (mouse_check_button_released(mb_left)) {
			is_scrolling_x=0
			is_scrolling_y=0
		}
		
		if (is_scrolling_y) {
			handle_y = curs_y - y - mouse_offset_y;
			handle_y = clamp( handle_y, 0, height - bar_height);
			
			scroll_y = -((listheight) * handle_y / (height - bar_height));
		} else if (is_scrolling_x) {
			handle_x = curs_x - x - mouse_offset_x;
			handle_x = clamp(handle_x, 0, width - bar_width);
			
			scroll_x = -((listwidth) * handle_x / (width - bar_width));
		}
	}
}

function JADEbglisthandler(_x, _y, _width, _height) : JADElisthandler(_x, _y, _width, _height, "") constructor {
	
	static draw = function() {
		draw_rect(x,y,width,height,oJADEController.themeaccent3,1)
		var prevarr=[];
		var currarr=[];
		var prevind=[];
		
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		var mbleft = mouse_check_button_pressed(mb_left);
		
		array_copy(currarr,0,listcontents,0,array_length(listcontents));
		var indent=0;
		var i=0;
		checkervalue=oJADEController.selected_layer.selected_bg
		
		var prevscissor = gpu_get_scissor();
		gpu_set_scissor(x,y,width,height);
		
		listwidth = 0;
		listheight = 0;
		
		var over = point_in_rectangle(curs_x,curs_y,x,y,x+width,y+height);
		
		draw_set_font(global.rulerGold)
		while(array_length(currarr)) { //this code is a fucking mess Im sorry.
			var item = currarr[0]
			array_delete(currarr,0,1);
			if (is_instanceof(item, JADEbackground)) {
				var over_button = point_in_rectangle(curs_x,curs_y,x+indent+scroll_x,y+(24*i)+scroll_y,x+width+indent+scroll_x,y+24+(24*i)+scroll_y) && over
				if (mbleft) && (over_button) {
					with(oJADEController.selected_layer) {
						selected_bg = item
						update_background();
					}
					mbleft=0
				}
			
				if (checkervalue!=-1) && (checkervalue.uuid == item.uuid) {
					draw_rect(x+indent+scroll_x,y+(24*i)+2+scroll_y,width,20,oJADEController.themeaccent2,1)
				}
				else if (over_button) draw_rect(x+indent+scroll_x,y+(24*i)+2+scroll_y,width,20,oJADEController.themeaccent4,1,true)
				
				draw_rect(x+2+indent+scroll_x,y+24+(24*i)-1+scroll_y,width-4,2,oJADEController.themeaccent2,1) //divider
				draw_text(x+24+indent+scroll_x,y+8+(24*i)+scroll_y, item.name)
				
				if (!array_length(currarr)) && array_length(prevarr) {
					var temp=array_pop(prevarr)
					array_copy(currarr,0,temp,0,array_length(temp))
					indent=array_pop(prevind);
					
				}
			} else if is_instanceof(item, JADElistcategory) {
				var over_button = point_in_rectangle(curs_x,curs_y,x+indent+scroll_x,y+(24*i)+scroll_y,x+width+indent+scroll_x,y+24+(24*i)+scroll_y) && over
				if (mbleft) && (over_button) {
					item.collapse();
					scroll_x=clamp(scroll_x,-listwidth,0)
					mbleft=0
				}
				
				draw_gui(x+4+indent+scroll_x,y+(24*i)+1+scroll_y,width-8,22,oJADEController.themeaccent4,1) //button
				draw_text(x+8+24+indent+scroll_x,y+8+(24*i)+scroll_y,item.listname) //category name
				draw_sprite(spr_JADElistarrow,item.collapsed,x+8+indent+scroll_x,y+4+(24*i)+scroll_y) //collapse arrow
				
				if !(item.collapsed) {
					if array_length(currarr) {
						array_push(prevarr,variable_clone(currarr))
						array_push(prevind,indent);
					}
					currarr=[];
					array_copy(currarr,0,item.listcontents,0,array_length(item.listcontents))
					indent+=16;
					listwidth+=16;
				}
			}
			i++;
			if i>(height/24) listheight+=24
		}
		gpu_set_scissor(prevscissor);
		
		//Scrollbars
		var total_height=height+listheight
		var total_width=width+listwidth
		
		var over_vert_scrollbar = point_in_rectangle(curs_x,curs_y,x+width,y,x+width+4+8,y+height);
		var bar_height = max(6,(height/total_height)*height)
		
		var over_horizontal_scrollbar = point_in_rectangle(curs_x,curs_y,x,y+height,x+width,y+height+4+8);
		var bar_width = max(6,(width/total_width)*width)
		
		draw_gui(x+width+4,y,6,height,oJADEController.themeaccent2,1) //vertical scrollbar bg
		draw_gui(x+width+4,y+handle_y,6,bar_height,oJADEController.themeaccent4,1) //vertical scrollbar handle
		
		draw_gui(x,y+height+4,width,6,oJADEController.themeaccent2,1) //horizontal scrollbar bg
		draw_gui(x+handle_x,y+height+4,bar_width,6,oJADEController.themeaccent4,1) //horizontal scrollbar handle
		
		var mwheel = mouse_wheel_down() - mouse_wheel_up();
		if (mwheel == 0) {
			mwheel = keyboard_check(vk_down) - keyboard_check(vk_up)
		}
		
		if (over) && (mwheel != 0) {
			if !keyboard_check(vk_control) {
				scroll_y+=12*-mwheel
				scroll_y=clamp(scroll_y,-listheight,0)
				
				if (listheight)
				handle_y = -((height - bar_height) * scroll_y / (listheight))
			} else {
				scroll_x+=8*mwheel
				scroll_x=clamp(scroll_x,-listwidth,0)
				
				if (listwidth)
				handle_x = -((width - bar_width) * scroll_x / (listwidth))
			}
		}
		
		if (mbleft) {
			if (over_vert_scrollbar) && (height/total_height != 1) {
				if !is_scrolling_y {
					mouse_offset_y = (curs_y - (y + handle_y))	
				}
				is_scrolling_y=true
			} else if (over_horizontal_scrollbar) && (width/total_width != 1) {
				if !is_scrolling_x {
					mouse_offset_x = (curs_x - (x + handle_x))	
				}
				is_scrolling_x=true
			}
		}
		
		if (mouse_check_button_released(mb_left)) {
			is_scrolling_x=0
			is_scrolling_y=0
		}
		
		if (is_scrolling_y) {
			handle_y = curs_y - y - mouse_offset_y;
			handle_y = clamp( handle_y, 0, height - bar_height);
			
			scroll_y = -((listheight) * handle_y / (height - bar_height));
		} else if (is_scrolling_x) {
			handle_x = curs_x - x - mouse_offset_x;
			handle_x = clamp(handle_x, 0, width - bar_width);
			
			scroll_x = -((listwidth) * handle_x / (width - bar_width));
		}
	}
}

function JADEobj(_uuid, _sprite,_xoff,_yoff,_width,_height,_can_xscale,_can_yscale,_name,_nodeable,_sizex,_sizey) constructor {
	uuid = _uuid;
	sprite = _sprite;
	xoff = _xoff;
	yoff = _yoff;
	width = _width;
	height = _height;
	can_xscale = _can_xscale;
	can_yscale = _can_yscale;
	name = _name;
	nodeable = _nodeable;
	sizex = _sizex;
	sizey = _sizey;
}

function JADEasset(_uuid, _sprite,_xoff,_yoff,_width,_height,_can_xscale,_can_yscale,_name,_sizex,_sizey) constructor {
	uuid = _uuid;
	sprite = _sprite;
	xoff = _xoff;
	yoff = _yoff;
	width = _width;
	height = _height;
	can_xscale = _can_xscale;
	can_yscale = _can_yscale;
	name = _name;
	sizex = _sizex;
	sizey = _sizey;
}

function JADEbackground(_uuid, _sprite, _xoff,_yoff,_width,_height,_tiled_h,_tiled_v,_parallax_x,_parallax_y,_attach_x,_attach_y,_name) constructor {
	uuid = _uuid;
	sprite = _sprite;
	xoff = _xoff;
	yoff = _yoff;
	width = _width;
	height = _height;
	name = _name;
	tiled_h = _tiled_h;
	tiled_v = _tiled_v;
	parallax_x = _parallax_x;
	parallax_y = _parallax_y;
	attach_x = _attach_x;
	attach_y = _attach_y;
}

function JADEpropertylisthandler(_x, _y, _width, _height) constructor {
	x=_x;
	y=_y;
	width=_width;
	height=_height;
	listwidth = 0;
	listheight = 0;
	scroll_x = 0;
	scroll_y = 0;
	handle_x = 0;
	handle_y = 0;
	mouse_offset_x = 0;
	mouse_offset_y = 0;
	is_scrolling_x=0;
	is_scrolling_y=0;
	typing_box=0;
	
	static draw = function(objarr) {
		draw_rect(x,y,width,height,oJADEController.themeaccent3,1)
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		var mbleft = mouse_check_button_pressed(mb_left);
		var over = point_in_rectangle(curs_x,curs_y,x,y,x+width,y+height);
		listwidth = 0;
		listheight = 0;
		
		if array_length(objarr) {
			var obj = oJADEController.object_map[| objarr[0]]
			var arr = oJADEController.properties.property_data[$ obj[0]]
			var arrvar = oJADEController.properties.property_values[$ obj[0]]
			var data = oJADEController.obj_data[$ obj[0]]
			
			var prevscissor = gpu_get_scissor();
			gpu_set_scissor(x,y,width,height);
			
			draw_set_font(global.rulerGold)
			
			draw_rect(x+15,y+15,66,66,c_white,1,true)
			draw_text(x+16,y+96,data.name)
			
			obj[1]=JADEnumberinput(x+96, y+16, "X", obj[1], 100)
			
			obj[2]=JADEnumberinput(x+96, y+56, "Y", obj[2], 101)
			
			draw_rect(x+8,y+128,width-16,2,oJADEController.themeaccent2,1)
			
			var i=0;
			repeat(array_length(arr)) { 
				var item = arr[i]
				
				switch (item[$ "type"]) {
					case "checkbox": {
						obj[5][i][1]=JADEcheckbox(x+16,y+144+32*i, item[$ "name"], obj[5][i][1])
					} break;
					case "number_input": {
						if !item[$ "absolute"]
						obj[5][i][1]=JADEnumberinput(x+16,y+144+32*i, item[$ "name"], obj[5][i][1],102+i)
						else obj[5][i][1]=JADEnumberinput(x+16,y+144+32*i, item[$ "name"], obj[5][i][1],102+i,0)
					} break;
					case "number_range_input": {
						obj[5][i][1]=JADEnumberinput(x+16,y+144+32*i, item[$ "name"], obj[5][i][1],102+i,item[$ "minimum"],item[$ "maximum"])
					} break;
					case "string_input": {
						obj[5][i][1]=JADEstringinput(x+16,y+144+32*i, item[$ "name"], obj[5][i][1],102+i)
					} break;
					case "dropdown": {
						JADEdropdownproperty(x+16,y+144+32*i, item[$ "name"], obj[5][i][1], i, objarr[0], item[$ "dropdowndata"], item[$ "dropdownnames"])
					} break;
				}
				
				i++;
				if i>(height/32) listheight+=32
			}
			gpu_set_scissor(prevscissor);
		}
		
		//Scrollbars
		#region Scrolling
		var total_height=height+listheight
		var total_width=width+listwidth
		
		var over_vert_scrollbar = point_in_rectangle(curs_x,curs_y,x+width,y,x+width+4+8,y+height);
		var bar_height = max(6,(height/total_height)*height)
		
		var over_horizontal_scrollbar = point_in_rectangle(curs_x,curs_y,x,y+height,x+width,y+height+4+8);
		var bar_width = max(6,(width/total_width)*width)
		
		draw_gui(x+width+4,y,6,height,oJADEController.themeaccent2,1) //vertical scrollbar bg
		draw_gui(x+width+4,y+handle_y,6,bar_height,oJADEController.themeaccent4,1) //vertical scrollbar handle
		
		draw_gui(x,y+height+4,width,6,oJADEController.themeaccent2,1) //horizontal scrollbar bg
		draw_gui(x+handle_x,y+height+4,bar_width,6,oJADEController.themeaccent4,1) //horizontal scrollbar handle
		
		var mwheel = mouse_wheel_down() - mouse_wheel_up();
		if (mwheel == 0) {
			mwheel = keyboard_check(vk_down) - keyboard_check(vk_up)
		}
		
		if (over) && (mwheel != 0) {
			if !keyboard_check(vk_control) {
				scroll_y+=12*-mwheel
				scroll_y=clamp(scroll_y,-listheight,0)
				
				if (listheight)
				handle_y = -((height - bar_height) * scroll_y / (listheight))
			} else {
				scroll_x+=8*mwheel
				scroll_x=clamp(scroll_x,-listwidth,0)
				
				if (listwidth)
				handle_x = -((width - bar_width) * scroll_x / (listwidth))
			}
		}
		
		if (mbleft) {
			if (over_vert_scrollbar) && (height/total_height != 1) {
				if !is_scrolling_y {
					mouse_offset_y = (curs_y - (y + handle_y))	
				}
				is_scrolling_y=true
			} else if (over_horizontal_scrollbar) && (width/total_width != 1) {
				if !is_scrolling_x {
					mouse_offset_x = (curs_x - (x + handle_x))	
				}
				is_scrolling_x=true
			}
		}
		
		if (mouse_check_button_released(mb_left)) {
			is_scrolling_x=0
			is_scrolling_y=0
		}
		
		if (is_scrolling_y) {
			handle_y = curs_y - y - mouse_offset_y;
			handle_y = clamp( handle_y, 0, height - bar_height);
			
			scroll_y = -((listheight) * handle_y / (height - bar_height));
		} else if (is_scrolling_x) {
			handle_x = curs_x - x - mouse_offset_x;
			handle_x = clamp(handle_x, 0, width - bar_width);
			
			scroll_x = -((listwidth) * handle_x / (width - bar_width));
		}
		#endregion
	}
	
	static updatefromdropdown = function(ind, propind, objind) {
		if ind==-1 exit;
		
		var obj = oJADEController.object_map[| objind]
		var arr = oJADEController.properties.property_data[$ obj[0]]
		var item = arr[propind]
		
		obj[5][oJADEController.property_dropdown_index][1]=item[$ "dropdowndata"][ind]
	}
}

function JADEproperties() constructor {
	property_data = {};
	property_values = {};
	static initProperties = function(obj) {
		var objn;
		if (object_exists(obj)) {
			objn = object_get_name(obj)
		} else if (sprite_exists(obj)) {
			objn = sprite_get_name(obj)
		}
		property_data[$ objn]=[]
		property_values[$ objn]=[];
	}
	
	static addCheckbox = function(obj, name, variable_name, default_val) {
		var objn = object_get_name(obj)
		var struct = {};
		struct[$ "type"]="checkbox"
		struct[$ "name"]=name
		array_push(property_data[$ objn], struct)
		array_push(property_values[$ objn], [variable_name, default_val])
	}
	
	static addStringInput = function(obj, name, variable_name, default_val) {
		var objn = object_get_name(obj)
		var struct = {};
		struct[$ "type"]="string_input"
		struct[$ "name"]=name
		array_push(property_data[$ objn], struct)
		array_push(property_values[$ objn], [variable_name, default_val])
	}
	
	static addNumberInput = function(obj, name, variable_name, default_val, is_absolute=false) {
		var objn = object_get_name(obj)
		var struct = {};
		struct[$ "type"]="number_input"
		struct[$ "name"]=name
		struct[$ "absolute"]=is_absolute
		array_push(property_data[$ objn], struct)
		array_push(property_values[$ objn], [variable_name, default_val])
	}
	
	static addNumberRangeInput = function(obj, name, variable_name, default_val, _min, _max) {
		var objn = object_get_name(obj)
		var struct = {};
		struct[$ "type"]="number_range_input"
		struct[$ "name"]=name
		struct[$ "minimum"]=_min
		struct[$ "maximum"]=_max
		array_push(property_data[$ objn], struct)
		array_push(property_values[$ objn], [variable_name, default_val])
	}
	
	static addDropdown = function(obj, name, variable_name, default_val, options_name, options_data) {
		var objn = object_get_name(obj)
		var struct = {};
		struct[$ "type"]="dropdown"
		struct[$ "name"]=name
		struct[$ "dropdownnames"]=options_name
		struct[$ "dropdowndata"]=options_data
		array_push(property_data[$ objn], struct)
		array_push(property_values[$ objn], [variable_name, default_val])
	}
	
	static getDefaultValues = function(obj) {
		return property_values[$ obj]
	}
}

function JADEnumberinput(_x, _y, _name, _var, _type_index, _min=NaN, _max=NaN) {
	
	var curs_x = window_mouse_get_x()
	var curs_y = window_mouse_get_y()
	
	var mbleft = mouse_check_button_pressed(mb_left) && !oJADEController.pressed_dropdown;
	var pressed_button = false;
	
	draw_set_font(global.rulerGold)
	draw_text(_x,_y+6, $"{_name}:")
	var spacing = string_width($"{_name}:")+8
	
	draw_sprite_stretched(spr_JADEinputbox, 0,_x+spacing,_y,48,24)
	draw_sprite(spr_JADEinputscroll, 0, _x+48+spacing,_y)
	
	if oJADEController.is_typing != _type_index
		ScribblejrFitExt(_var,fa_left,fa_top,global.rulerGold,1,40,20).Draw(_x+4+spacing,_y+6)
	else
		ScribblejrFitExt(keyboard_string,fa_left,fa_top,global.rulerGold,1,40,20).Draw(_x+4+spacing,_y+6)
	
	var overtop = point_in_rectangle(curs_x,curs_y,_x+48+spacing,_y,_x+48+12+spacing,_y+12);
	var overbot = point_in_rectangle(curs_x,curs_y,_x+48+spacing,_y+12,_x+48+12+spacing,_y+24);
	var overinp = point_in_rectangle(curs_x,curs_y,_x+spacing,_y,_x+48+spacing,_y+24);
	
	//up
	if (mbleft) && (overtop) {
		pressed_button=true;
		if _max==NaN
		return _var+1
		else return min(_var+1,_max)
	}
			
	//down
	if (mbleft) && (overbot) {
		pressed_button=true;
		if _min==NaN
		return _var-1
		else return max(_var-1,_min)
	}
	
	//start typing
	if (mbleft) && (overinp) {
		oJADEController.is_typing = _type_index;
		keyboard_string="";
		pressed_button=true;
	}
	
	if mouse_wheel_up() && (overtop || overbot || overinp) {
		if _max==NaN
		return _var+1
		else return min(_var+1,_max)
	}
	
	if mouse_wheel_down() && (overtop || overbot || overinp) {
		if _min==NaN
		return _var-1
		else return max(_var-1,_min)
	}
	
	//unselect when clicking off
	if (mbleft) && (oJADEController.is_typing == _type_index) && !(pressed_button) {
		keyboard_string="";
		oJADEController.is_typing = -1;
	}
	
	if (keyboard_check_pressed(vk_enter)) && (oJADEController.is_typing == _type_index) {
		oJADEController.is_typing = -1;
		return unreal(string_digits(keyboard_string),_var)
	}
	
	return _var
}

function JADEstringinput(_x, _y, _name, _var, _type_index, _width=64) {
	
	var curs_x = window_mouse_get_x()
	var curs_y = window_mouse_get_y()
	
	var mbleft = mouse_check_button_pressed(mb_left) && !oJADEController.pressed_dropdown;
	var pressed_button = false;
	
	draw_set_font(global.rulerGold)
	draw_text(_x,_y+6, $"{_name}:")
	var spacing = string_width($"{_name}:")+8
	
	draw_sprite_stretched(spr_JADEinputbox, 0,_x+spacing,_y,_width,24)
	
	if oJADEController.is_typing != _type_index
		ScribblejrFitExt(_var,fa_left,fa_middle,global.omiFont,1,_width-8,20).Draw(_x+4+spacing,_y+12)
	else
		ScribblejrFitExt(keyboard_string,fa_left,fa_middle,global.omiFont,1,_width-8,20).Draw(_x+4+spacing,_y+12)
	
	var overinp = point_in_rectangle(curs_x,curs_y,_x+spacing,_y,_x+_width+spacing,_y+24);

	//start typing
	if (mbleft) && (overinp) {
		oJADEController.is_typing = _type_index;
		keyboard_string="";
		pressed_button=true;
	}

	//unselect when clicking off
	if (mbleft) && (oJADEController.is_typing == _type_index) && !(pressed_button) {
		keyboard_string="";
		oJADEController.is_typing = -1;
	}
	
	if (keyboard_check_pressed(vk_enter)) && (oJADEController.is_typing == _type_index) {
		oJADEController.is_typing = -1;
		return keyboard_string
	}
	
	return _var
}

function JADEcheckbox(_x, _y, _name, _var) {
	
	var curs_x = window_mouse_get_x()
	var curs_y = window_mouse_get_y()
	
	var mbleft = mouse_check_button_pressed(mb_left) && !oJADEController.pressed_dropdown;
	
	draw_set_font(global.rulerGold)
	draw_text(_x,_y+6, $"{_name}:")
	var spacing = string_width($"{_name}:")+8
	
	draw_sprite(spr_JADEcheckbox, bool( _var),_x+spacing,_y)
	
	var overinp = point_in_rectangle(curs_x,curs_y,_x+spacing,_y,_x+24+spacing,_y+24);
	
	if (mbleft) && (overinp) {
		return !bool(_var)
	}
	
	return _var
}

function JADEdropdownproperty(_x, _y, _name, _var, _index, obj_ind, _options, _names) {
	
	static inst = noone;
	
	var curs_x = window_mouse_get_x()
	var curs_y = window_mouse_get_y()
	
	var mbleft = mouse_check_button_pressed(mb_left) && !oJADEController.pressed_dropdown;
	
	draw_set_font(global.rulerGold)
	draw_text(_x,_y+6, $"{_name}:")
	var spacing = string_width($"{_name}:")+8
	
	draw_sprite_stretched(spr_JADEdropdownbox, 0,_x+spacing,_y,128,24)
	ScribblejrFitExt(_names[array_get_index(_options,_var)],fa_left,fa_middle,global.omiFont,1,94,16).Draw(_x+4+spacing,_y+12)
	
	var overinp = point_in_rectangle(curs_x,curs_y,_x+spacing,_y,_x+128+spacing,_y+24);
	
	if (mbleft) && (overinp) {
		show_debug_message(inst)
		show_debug_message(typeof(inst))
 		if !instance_exists(inst){
			if oJADEController.property_dropdown_index!=_index {
				oJADEController.property_dropdown_index = _index
				oJADEController.property_object_index = obj_ind
				inst=JADEdropdown(_x+spacing,_y+24,_names, function(name,ind) {
					oJADEController.propertylist.updatefromdropdown(ind, oJADEController.property_dropdown_index, oJADEController.property_object_index);
					oJADEController.property_dropdown_index=-1;
					oJADEController.property_object_index = -1;
				})
			} else {
				instance_destroy(oJADEDropDown,false)
				oJADEController.property_dropdown_index=-1;
				oJADEController.property_object_index = -1;
			}
		} else {
			instance_destroy(inst,false)
			oJADEController.property_dropdown_index=-1;
			oJADEController.property_object_index = -1;
		}
	}
}

function JADElayerlisthandler(_x, _y, _width, _height, _checkvar) constructor {
	x=_x;
	y=_y;
	width=_width;
	height=_height;
	listcontents=[];
	checkvar=_checkvar;
	listwidth = 0;
	listheight = 0;
	scroll_x = 0;
	scroll_y = 0;
	handle_x = 0;
	handle_y = 0;
	mouse_offset_x = 0;
	mouse_offset_y = 0;
	is_scrolling_x=0;
	is_scrolling_y=0;
	
	static add = function(_item) {
		show_debug_message(_item)
		array_push(listcontents, _item)
		var i=0;
		var foundind=0;
		var len=array_length(listcontents);
		repeat (len) {
			if is_instanceof(listcontents[i], JADElistunselectable) {
				foundind=i;
				break;
			}
			i++;
		}
		i=0;
		repeat (len) {
			if !is_instanceof(listcontents[i], JADElistunselectable) {
				listcontents[i].layerdepth=(i-foundind)*100;
				layer_depth(listcontents[i].my_layer,listcontents[i].layerdepth)
			}
			i++;
		}
	}
	
	static get_contents = function() {
		return listcontents;
	}
	
	static update_depths = function() {
		var foundind=0;
		var i=0;
		repeat(array_length(listcontents)) {
			if is_instanceof(listcontents[i], JADElistunselectable) {
				foundind=i;
				break;
			}
			i++;
		}
		i=0;
		repeat(array_length(listcontents)) {
			var struct = listcontents[i]
			if !is_instanceof(struct, JADElistunselectable) {
				with(struct) {
					var new_depth = (i-foundind)*100;
					change_depth(new_depth);
				}
			}
			i++;
		}
	}
	
	static wipe = function() {
		var i=0;
		repeat(array_length(listcontents)) {
			var struct = listcontents[i]
			if !is_instanceof(struct, JADElistunselectable) {
				with(struct) {
					cleanup();
				}
			}
			i++;
		}
		listcontents = [];
	}
	
	static draw = function() {
		draw_set_font(global.rulerGold)
		
		draw_text(x,y-16,"Layers")
		
		draw_rect(x,y,width,height,oJADEController.themeaccent3,1)
		
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		var mbleftpress = mouse_check_button_pressed(mb_left);
		
		var prevscissor = gpu_get_scissor();
		gpu_set_scissor(x,y,width,height);
		
		checkervalue=variable_instance_get(oJADEController, checkvar)
		
		listwidth = 0;
		listheight = 0;
		
		var over_list = point_in_rectangle(curs_x,curs_y,x,y,x+width,y+height);
		
		var i=0;
		repeat(array_length(listcontents)) { //this code is a fucking mess Im sorry.
			var item = listcontents[i]
			if !is_instanceof(item, JADElistunselectable) {
				var over_button = point_in_rectangle(curs_x,curs_y,x+scroll_x,y+(24*i)+scroll_y,x+width+scroll_x,y+24+(24*i)+scroll_y) && over_list
				var over_up_arrow = point_in_rectangle(curs_x,curs_y,x+width-16+scroll_x,y+(24*i)+scroll_y,x+width-16+scroll_x+12,y+(24*i)+scroll_y+12) && over_list
				var over_down_arrow = point_in_rectangle(curs_x,curs_y,x+width-16+scroll_x,y+(24*i)+scroll_y+13,x+width-16+scroll_x+12,y+(24*i)+scroll_y+24) && over_list
				if (mbleftpress) {
					if (over_up_arrow) {
						array_delete(listcontents,i,1)
						array_insert(listcontents,max(i-1,0),item)
						update_depths();
						mbleftpress=0
					} else if (over_down_arrow) {
						array_delete(listcontents,i,1)
						array_insert(listcontents,i+1,item)
						update_depths();
						mbleftpress=0
					} else if (over_button) {
						variable_instance_set(oJADEController, checkvar, item)
						oJADEController.update_layer(item);
						oJADEController.selected_array = [];
						if is_instanceof(item, JADEtilelayer) {
							with(oJADEController) {
								deco_mode_type = "tile";
								tilepicker.pan_x = 0;
								tilepicker.pan_y = 0;
								current_tile_id = -1
								current_tile_id = []
								current_tile_id[0][0] = 0
								tile_sel_height = 0
								tile_sel_width = 0
								toolbarbuttons.set(toolbar[1])
							}
						} else if is_instanceof(item, JADEassetlayer) {
							with(oJADEController) {
								deco_mode_type = "asset";
								toolbarbuttons.set(toolbar[3])
							}
						} else if is_instanceof(item, JADEbackgroundlayer) {
							with(oJADEController) {
								deco_mode_type = "bg";
								toolbarbuttons.set(toolbar[2])
							}
						}
						mbleftpress=0
					}
				}
				
				var layer_selected = (checkervalue!=noone) && (checkervalue.name == item.name)
				
				if (layer_selected) {
					draw_rect(x+scroll_x,y+(24*i)+1+scroll_y,width,22,oJADEController.themeaccent4,1,true)
					draw_rect(x+scroll_x+1,y+(24*i)+2+scroll_y,width-2,20,oJADEController.themeaccent4,1,true)
				}
				
				
				draw_sprite(spr_JADEinputscroll,0,x+width-16+scroll_x,y+(24*i)+scroll_y)
				
				var index=0;
				if is_instanceof(item, JADEassetlayer) {
					index=1;
				} else if is_instanceof(item, JADEbackgroundlayer) {
					index=2;
				}
				
				draw_sprite(spr_JADElayericons,index,x+4+scroll_x,y+4+(24*i)+scroll_y)
			} else {
				draw_rect(x+scroll_x,y+(24*i)+2+scroll_y,width,20,oJADEController.themeaccent1,1,false)
			}
			draw_rect(x+2+scroll_x,y+24+(24*i)-1+scroll_y,width-4,2,oJADEController.themeaccent2,1) //divider
			draw_text(x+24+scroll_x,y+8+(24*i)+scroll_y, item.name)
			i++;
			if i>(height/24) listheight+=24
		}
		gpu_set_scissor(prevscissor);
		
		//Scrollbars
		var total_height=height+listheight
		var total_width=width+listwidth
		
		var over_vert_scrollbar = point_in_rectangle(curs_x,curs_y,x+width,y,x+width+4+8,y+height);
		var bar_height = max(6,(height/total_height)*height)
		
		var over_horizontal_scrollbar = point_in_rectangle(curs_x,curs_y,x,y+height,x+width,y+height+4+8);
		var bar_width = max(6,(width/total_width)*width)
		
		draw_gui(x+width+4,y,6,height,oJADEController.themeaccent2,1) //vertical scrollbar bg
		draw_gui(x+width+4,y+handle_y,6,bar_height,oJADEController.themeaccent4,1) //vertical scrollbar handle
		
		draw_gui(x,y+height+4,width,6,oJADEController.themeaccent2,1) //horizontal scrollbar bg
		draw_gui(x+handle_x,y+height+4,bar_width,6,oJADEController.themeaccent4,1) //horizontal scrollbar handle
		
		var mwheel = mouse_wheel_down() - mouse_wheel_up();
		if (mwheel == 0) {
			mwheel = keyboard_check(vk_down) - keyboard_check(vk_up)
		}
		
		if (over_list) && (mwheel != 0) {
			if !keyboard_check(vk_control) {
				scroll_y+=12*-mwheel
				scroll_y=clamp(scroll_y,-listheight,0)
				
				if (listheight)
				handle_y = -((height - bar_height) * scroll_y / (listheight))
			} else {
				scroll_x+=8*mwheel
				scroll_x=clamp(scroll_x,-listwidth,0)
				
				if (listwidth)
				handle_x = -((width - bar_width) * scroll_x / (listwidth))
			}
		}
		
		if (mbleftpress) {
			if (over_vert_scrollbar) && (height/total_height != 1) {
				if !is_scrolling_y {
					mouse_offset_y = (curs_y - (y + handle_y))	
				}
				is_scrolling_y=true
			} else if (over_horizontal_scrollbar) && (width/total_width != 1) {
				if !is_scrolling_x {
					mouse_offset_x = (curs_x - (x + handle_x))	
				}
				is_scrolling_x=true
			}
		}
		
		if (mouse_check_button_released(mb_left)) {
			is_scrolling_x=0
			is_scrolling_y=0
		}
		
		if (is_scrolling_y) {
			handle_y = curs_y - y - mouse_offset_y;
			handle_y = clamp( handle_y, 0, height - bar_height);
			
			scroll_y = -((listheight) * handle_y / (height - bar_height));
		} else if (is_scrolling_x) {
			handle_x = curs_x - x - mouse_offset_x;
			handle_x = clamp(handle_x, 0, width - bar_width);
			
			scroll_x = -((listwidth) * handle_x / (width - bar_width));
		}
	}
}

function JADElistunselectable(_name) constructor {
	name = _name;
}

function JADEtilelayer(_name,_tileset) constructor {
	name = _name
	layerdepth = 0;
	tilemap = ds_list_create();
	tileset = _tileset
	tileset_info = global.tilesets[$ tileset]
	sprite = tileset_info[0]
	my_layer = layer_create(layerdepth,name)
	my_deco_layer = layer_tilemap_create(my_layer,0,0,tileset_info[1],ceil(room_width/16),ceil(room_height/16))
	layer_script_begin(my_layer, tile_layer_alpha_check);
	layer_script_end(my_layer, function() {shader_reset()});
	static change_depth = function(_depth) {
		layerdepth = _depth;
		layer_depth(my_layer,layerdepth);
	}
	
	static update_tileset = function(_tileset) {
		tileset = _tileset
		tileset_info = global.tilesets[$ tileset]
		sprite = tileset_info[0]
		tilemap_tileset(my_deco_layer,tileset_info[1])
	}
	
	static cleanup = function() {
		ds_list_destroy(tilemap)
		layer_tilemap_destroy(my_deco_layer)
		layer_destroy(my_layer)
	}
}

function JADEassetlayer(_name) constructor {
	name = _name
	layerdepth = 0;
	assetmap = ds_list_create();
	my_layer = layer_create(layerdepth,name)
	my_deco_layer = my_layer
	parallax_x = 0;
	parallax_y = 0;
	layer_script_begin(my_layer, tile_layer_alpha_check);
	layer_script_end(my_layer, function() {shader_reset()});
	
	static change_depth = function(_depth) {
		layerdepth = _depth;
		layer_depth(my_layer,layerdepth);
	}
	
	static cleanup = function() {
		ds_list_destroy(assetmap)
		layer_destroy(my_layer)
	}
}

function JADEbackgroundlayer(_name, _background) constructor {
	name = _name
	selected_bg = _background
	parallax_x = 0;
	parallax_y = 0;
	tiled_h = 0;
	tiled_v = 0;
	attach_x = 0;
	attach_y = 0;
	if is_struct(selected_bg) {
		sprite = selected_bg.sprite;
		parallax_x = selected_bg.parallax_x;
		parallax_y = selected_bg.parallax_y;
		tiled_h = selected_bg.tiled_h;
		tiled_v = selected_bg.tiled_v;
		attach_x = selected_bg.attach_x;
		attach_y = selected_bg.attach_y;
	} else sprite = spr_BGtest
	layerdepth = 0;
	my_layer = layer_create(layerdepth,name)
	my_deco_layer = layer_background_create(my_layer,sprite)
	off_x = 0;
	off_y = 0;
	var height = sprite_get_height(sprite)
	off_y = room_height-height;
	layer_y(my_layer,off_y);
	layer_script_begin(my_layer, tile_layer_alpha_check);
	layer_script_end(my_layer, function() {shader_reset()});
	
	static update_background = function() {
		if is_struct(selected_bg) {
			sprite = selected_bg.sprite;
			parallax_x = selected_bg.parallax_x;
			parallax_y = selected_bg.parallax_y;
			tiled_h = selected_bg.tiled_h;
			tiled_v = selected_bg.tiled_v;
			attach_x = selected_bg.attach_x;
			attach_y = selected_bg.attach_y;
		} else sprite = spr_BGtest;
		var height = sprite_get_height(sprite)
		var width = sprite_get_height(sprite)
		off_y = clamp(off_y,sprite_get_yoffset(sprite),room_height-height-sprite_get_yoffset(sprite))
		off_x = clamp(off_x,sprite_get_xoffset(sprite),room_width-width-sprite_get_xoffset(sprite))
		layer_x(my_layer,off_x);
		layer_y(my_layer,off_y);
		layer_background_sprite(my_deco_layer, sprite)
		layer_background_htiled(my_deco_layer, tiled_h)
		layer_background_vtiled(my_deco_layer, tiled_v)
	}
	
	static update_settings = function() {
		layer_background_sprite(my_deco_layer, sprite)
		layer_background_htiled(my_deco_layer, tiled_h)
		layer_background_vtiled(my_deco_layer, tiled_v)
	}
	
	static change_depth = function(_depth) {
		layerdepth = _depth;
		layer_depth(my_layer,layerdepth);
	}
	
	static cleanup = function() {
		layer_background_destroy(my_deco_layer)
		layer_destroy(my_layer)
	}
}

function JADEtilepicker(_x,_y,_width,_height) constructor {
	x = _x;
	y = _y;
	width = _width;
	height = _height;
	tile_zoom = 1;
	pan_x = 0;
	pan_y = 0;
	start_pan_x = 0;
	start_pan_y = 0;
	initial_pan_x = 0;
	initial_pan_y = 0;
	panning = 0;
	tile_drag = false;
	tile_sel_last_x = 0;
	tile_sel_last_y = 0;
	
	static draw = function() {
		var tileset = global.tilesets[$ oJADEController.current_tileset]
		
		draw_set_font(global.rulerGold)
		draw_text(x+2,y-16,$"Tile Picker - {tileset[2]}")
		
		draw_rect(x-1,y-1,width+2,height+2,oJADEController.themeaccent4,1,true)
		draw_rect(x,y,width,height,oJADEController.themeaccent2,1,false)
		
		var scissor = gpu_get_scissor();
		gpu_set_scissor(x,y,width,height)
		
		draw_sprite(tileset[0],0,x+pan_x,y+pan_y)
		
		var t_size = 16 * tile_zoom
		var t_width = sprite_get_width(tileset[0])
		var t_height = sprite_get_height(tileset[0])
		if !(tile_drag) { //draw selection rectangle (after selection)
			var tiles = oJADEController.current_tile_id
			if array_length(tiles) {
				var t_x,t_y,t_w,t_h;
				t_x = x+((tiles[0][0] mod (t_width / 16))* (16 * tile_zoom))
				t_y = y+(floor(tiles[0][0] / (t_width/16))* (16 * tile_zoom))
				t_w = (oJADEController.tile_sel_width + 1)* 16 * tile_zoom
				t_h = (oJADEController.tile_sel_height + 1) * 16 * tile_zoom
				
				draw_rect(t_x+pan_x,t_y+pan_y,t_w,t_h,c_white,1,true)
			}
		} else { //draw tile selecting rectangle
			var curs_x = window_mouse_get_x()
			var curs_y = window_mouse_get_y()
			var sel_x = curs_x - x - pan_x
			var sel_y = curs_y - y - pan_y
			var pos_x = clamp(floor(sel_x / t_size),0,t_width)*t_size
			var pos_y = clamp(floor(sel_y / t_size),0,t_height)*t_size
			var boxw = max(pos_x - tile_sel_last_x*t_size,0)
			var boxh = max(pos_y - tile_sel_last_y*t_size,0)
			draw_rect(x+(tile_sel_last_x*t_size)+pan_x,y+(tile_sel_last_y*t_size)+pan_y,min(abs(boxw+16),t_width-tile_sel_last_x*t_size),min(abs(boxh+16),t_height-tile_sel_last_y*t_size),c_white,1,true)
		}
		
		gpu_set_scissor(scissor)
	}
	
	static update = function() {
		var curs_x = window_mouse_get_x()
		var curs_y = window_mouse_get_y()
		var over = point_in_rectangle(curs_x, curs_y,x,y,x+width-1,y+height-1)
		
		
		var mbleftpress = mouse_check_button_pressed(mb_left);
		var mbleft = mouse_check_button(mb_left);
		var mbleftrel = !mbleft
		
		var tileset = global.tilesets[$ oJADEController.current_tileset]
		var t_size = 16 * tile_zoom
		var t_width = sprite_get_width(tileset[0])
		var t_height = sprite_get_height(tileset[0])
		var sel_x = curs_x - x - pan_x
		var sel_y = curs_y - y - pan_y
		var pos_x = clamp(floor(sel_x / t_size),0,(t_width/16)-1)
		var pos_y = clamp(floor(sel_y / t_size),0,(t_height/16)-1)
		
		//select single tile/start tile dragging
		if (over) {
			if (mbleftpress && !tile_drag) {
				show_debug_message("go!")
				with(oJADEController) {
					current_tile_id = -1
					current_tile_id = []
					current_tile_id[0][0] = pos_x + (pos_y * (t_width/16))
					tile_sel_height = 0
					tile_sel_width = 0
				}
				tile_sel_last_x = pos_x
				tile_sel_last_y = pos_y
				tile_drag = true
			}
			
			if (mouse_check_button_pressed(mb_middle)) {
				start_pan_x=curs_x;
				start_pan_y=curs_y;
				initial_pan_x=pan_x;
				initial_pan_y=pan_y;
				panning=true;
			}
		}
		
		if !mouse_check_button(mb_middle) {
			panning = false;
		}
		
		if (panning) {
			pan_x = clamp(initial_pan_x+curs_x-start_pan_x,-(t_width-width),0);
			pan_y = clamp(initial_pan_y+curs_y-start_pan_y,-(t_height-height),0);
		}
		
		if (mbleft && tile_drag) {
			oJADEController.tile_sel_width = clamp(pos_x - tile_sel_last_x,0,(t_width/16)-1)
			oJADEController.tile_sel_height = clamp(pos_y - tile_sel_last_y,0,(t_height/16)-1)
		}
		
		//complete tile dragging
		if (mbleftrel && tile_drag) {
			with(oJADEController) {
				var i=0;
				repeat(tile_sel_width+1) {
					var j=0;
					repeat(tile_sel_height+1) {
						current_tile_id[i][j] = (other.tile_sel_last_x + i) + ((other.tile_sel_last_y + j) * (t_width/16))
						j++;
					}
					i++;
				}
			}
			tile_drag = false
		}
	}
}