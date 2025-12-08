event_inherited();
if is_array(pathing) physics_enabled = false;

switch (content) {
	case "coin": {
		monitor_frame = 1;
	} break;
	
	case "fireflower": {
		monitor_frame = 2;
	} break;
	
	case "thunderflower": {
		monitor_frame = 4;
	} break;
    
    case "star": {
		monitor_frame = 5;
    } break;	
    
    case "1up": {
		monitor_frame = 9; 
    } break;
    
    case "3up": {
		monitor_frame = 10; 
    } break;
	
    case "poison": {
		monitor_frame = 12; 
    } break;
	
	default: monitor_frame = 0;
}