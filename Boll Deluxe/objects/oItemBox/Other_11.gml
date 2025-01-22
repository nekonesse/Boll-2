///@description Empty Contents on finish
var j, i = noone; //i dont know whats the empty resource id
switch (content) {
	
	case "mushroom": {
		j = oMushroom;
	} break;
	
	case "fireflower": {
		j = oFireFlower;
	} break;
	
	case "thunderflower": {
		j = oThunderFlower;
	} break;
    
    case "star": {
        j = oStar;
    } break;	
    
    case "1up": {
        j = o1up;
    } break;
	
	default: exit; //assume that the box is empty and dont proceed with spawning the object
}

i = instance_create_depth(x,y,0,j);
i.going = hit;
i.parentblock = id;
VinylPlay(snd_itemappear);