function basicLink(_name, _var, _can_input=true, _minoutputs=1, _maxoutputs=NaN) constructor {
	name = _name;
	myvar = _var;
	can_input = _can_input;
	outputs = [];
	width = 196;
	height = 48;
	
	static draw = function(_x,_y) {
		var color = oJADEController.themeaccent3;
		
		draw_gui(_x,_y,196,24,color,1);
		ScribblejrShrinkExt(name,fa_left,fa_top,global.rulerGold,1,190,20).Draw(_x+2,_y+6);
		
		var curs_x = window_mouse_get_x();
		var	curs_y = window_mouse_get_y();
		var mbleft = mouse_check_button_pressed(mb_left);
		color = oJADEController.themeaccent2;
		
		var i=0;
		var offset = 0;
		var i=0;
		while (i < array_length(outputs)) {
			if !struct_exists(oJADEController.object_uuids,outputs[i][0]) {
				array_delete(outputs,i,1);
			} else {
				if (mbleft) && (point_in_rectangle(curs_x, curs_y, _x+8+188-16,_y+24+6+offset,_x+8+188+4,_y+24+6+12+offset)) {
					array_delete(outputs,i,1);
					break;
				}
				
				offset += 24;
				i++;
			}
		}
		
		i=0;
		offset = 0;
		repeat(array_length(outputs)) {
			draw_gui(_x+8,_y+24+offset,188,24,color,1,true);
			ScribblejrShrinkExt(outputs[i][0],fa_left,fa_top,global.rulerGold,1,172,20).Draw(_x+16, _y+24+6+offset)
			draw_sprite(spr_JADEdeleteiconsmall,0,_x+8+188-16,_y+24+6+offset);
			
			offset += 24;
			i++;
		}
		
		height = 48+offset;
		
		draw_gui(_x+8,_y+24+offset,188,24,color,1,true);
		draw_sprite(spr_JADEaddiconsmall,0,_x+16,_y+24+6+offset);
		if (mbleft) && (point_in_rectangle(curs_x, curs_y, _x+8+6,_y+24+6+offset,_x+8+6+12,_y+24+6+12+offset)) {
			oJADEController.choosing_link = self;
		}
	}
	
	static export_contents = function() {
		var struct = {};
		var i=0;
		while (i < array_length(outputs)) {
			if !struct_exists(oJADEController.object_uuids,outputs[i][0]) {
				array_delete(outputs,i,1);
			} else {
				i++;
			}
		}
		
		struct[$ "outputs"] = outputs;
		struct[$ "var"] = myvar;
		
		return struct;
	}
	
	static import_contents = function(struct) {
		outputs = struct[$ "outputs"];
	}
};

function inputLink(_name) constructor {
	name = _name;
	can_input = true;
	outputs = [];
	width = 196;
	height = 24;
	
	static draw = function(_x,_y) {
		var color = oJADEController.themeaccent3;
		
		draw_gui(_x,_y,196,24,color,1);
		ScribblejrShrinkExt(name,fa_left,fa_top,global.rulerGold,1,190,20).Draw(_x+2,_y+6);
	}
	
	static export_contents = function() {
		return {};
	}
	
	static import_contents = function(struct) {
		//
	}
};

function trigger_links(_arr, _obj=id) {
	if !(activated_by_link) {
		var l=0;
		repeat(array_length(_arr)) {
			var ob = oGameManager.object_uuids[$ _arr[l][0]];
			instance_activate_object(ob);
			if (instance_exists(ob)) {
				ob.activateLink.Emit(_arr[l][1], _obj);
			}
			l++;
		}
	}
}