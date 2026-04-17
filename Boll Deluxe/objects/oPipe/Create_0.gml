event_inherited()
warpname="" //name of this pipe
warptarget="" //name of other pipe to warp to
warplevel="" //Level warping for stuff like warp zones.
mytargetpipe=noone;

assist = noone;
content = "nothing";
spawn_timer = 120;
spawning = spawn_timer;
stop_spawning = false;

depth = 0;

spawnObject = function() {
	var j = noone;

	switch content {
		case "piranha plant": {
			j = oPiranhaPlant;
			stop_spawning = true;
		} break;
	
		case "jumping piranha": {
			j = oJumpingPiranha;
			stop_spawning = true;
		} break;
	
		case "mushroom": {
			j = oMushroom;
		} break;
	
		default : exit;
	}

	assist = instance_create(x, y, j);
	with (assist) {
		if (object_get_parent(object_index) == oMushroom) || (object_index == oMushroom) {
			parentblock = other;
			going = 1;
			break;
		}
	
		parent_pipe = other;
		rot = other.image_angle;
		if (object_get_parent(object_index) != oPiranhaPlant && object_index != oPiranhaPlant && object_index != oJumpingPiranha) {
			other.assist = noone;
			break;
		}
		
		if (object_index == oJumpingPiranha) {
			dojump=true;
		}
	}
}