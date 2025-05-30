if script_onTrigger != "" {
	
	switch detection_type {
		case TRIGGER.ON_TOUCH: 
			if !is_triggered {
				with (oPlayer) {
					if rectangle_in_rectangle(other.bbox_left,other.bbox_top,other.bbox_right-1,other.bbox_bottom-1,x - hit_sizex, y- hit_sizey, x + hit_sizex, y+ hit_sizey ){
						other.is_triggered = true	
					}	
				}
				if is_triggered catspeak_execute(global.scripts_level[? $"{script_onTrigger}"]);
			} else {
				with (oPlayer) {
					if !rectangle_in_rectangle(other.bbox_left,other.bbox_top,other.bbox_right-1,other.bbox_bottom-1,x - hit_sizex, y- hit_sizey, x + hit_sizex, y+ hit_sizey ){
						other.is_triggered = false	
					}	      
				}
			}
		break;
		case TRIGGER.OVERLAP_ONCE:
			if !only_once {
				with (oPlayer) {
					if rectangle_in_rectangle(other.bbox_left,other.bbox_top,other.bbox_right-1,other.bbox_bottom-1,x - hit_sizex, y- hit_sizey, x + hit_sizex, y+ hit_sizey ) {
						other.only_once = true	
					}	
				}
				if only_once catspeak_execute(global.scripts_level[? $"{script_onTrigger}"]);
			}
		break;
		case TRIGGER.OVERLAP:
			is_triggered = false
			with (oPlayer) {
				if rectangle_in_rectangle(other.bbox_left,other.bbox_top,other.bbox_right-1,other.bbox_bottom-1,x - hit_sizex, y- hit_sizey, x + hit_sizex, y+ hit_sizey ){
					other.is_triggered = true	
				}
			}
			if is_triggered catspeak_execute(global.scripts_level[? $"{script_onTrigger}"]);
		break;
	}
}

if script_onStep != "" {	
	catspeak_execute(global.scripts_level[? $"{script_onStep}"]);	
}

node_path_movement()