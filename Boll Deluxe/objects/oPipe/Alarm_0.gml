var j = noone;

if collision_rectangle(x-24,0,x+24,room_height + 255,oPlayer,false,true) {
	alarm[0] |= 0b100;
	exit;
}

alarm[0] = -1;

show_debug_message("creating " + content);
switch content {
	case "piranha plant": {
		j = oPiranhaPlant;
	} break;
	
	case "jumping piranha": {
		j = oJumpingPiranha;
	} break;
	
	case "mushroom": {
		j = oMushroom;
	} break;
	
	default : exit;
}

assist = instance_create(x, y, j);
with (assist) {
	if (object_get_parent(object_index) == oMushroom) {
		parentblock = other;
		going = 1;
		break;
	}
	
	parent_pipe = other;
	if (object_index != oPiranhaPlant && object_index != oJumpingPiranha) {
		other.assist = noone;
		rot = other.image_angle;
		break;
	}
}