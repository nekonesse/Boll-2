///@description Empty Contents on break
show_debug_message("responded");

var j = noone;
switch (content) {
	case "goomba": {
		j= oGoomba;
	} break;
	
	default: break;
}

if (j != noone) {
	var i = instance_create_depth(x,y,0,j);
}

instance_create_depth(x,y,0,pSmoke);
instance_destroy();