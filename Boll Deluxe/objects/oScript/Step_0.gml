
if script_onTrigger != "" {
	
	switch detection_type {
		case TRIGGER.ON_TOUCH: 
			if !is_triggered {
				with (oPlayer) {
					if rectangle_in_rectangle(other.x,other.y,other.x+other.sprite_width,other.y+other.sprite_height,x - hit_sizex, y- hit_sizey, x + hit_sizex, y+ hit_sizey ){
						other.is_triggered = true	
						txr_exec(global.scripts_level[? $"{script_onTrigger}"]);
					}	
				}
			} else {
				with (oPlayer) {
					if !rectangle_in_rectangle(other.x,other.y,other.x+other.sprite_width,other.y+other.sprite_height,x - hit_sizex, y- hit_sizey, x + hit_sizex, y+ hit_sizey ){
						other.is_triggered = false	
					}	
				}
			}
		break;
		case TRIGGER.OVERLAP_ONCE:
			if !only_once {
				with (oPlayer) {
					if rectangle_in_rectangle(other.x,other.y,other.x+other.sprite_width,other.y+other.sprite_height,x - hit_sizex, y- hit_sizey, x + hit_sizex, y+ hit_sizey ){
						other.only_once = true	
						txr_exec(global.scripts_level[? $"{script_onTrigger}"]);
					}	
				}
			}
		break;
		case TRIGGER.OVERLAP:
			other.is_triggered = false
			with (oPlayer) {
				if rectangle_in_rectangle(other.x,other.y,other.x+other.sprite_width,other.y+other.sprite_height,x - hit_sizex, y- hit_sizey, x + hit_sizex, y+ hit_sizey ){
					other.is_triggered = true	
					txr_exec(global.scripts_level[? $"{script_onTrigger}"]);
				}
			}
		break;		
		
		
	}
}

if script_onStep != "" {	
	txr_exec(global.scripts_level[? $"{script_onStep}"]);	
}