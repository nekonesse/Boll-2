///@description Empty Contents on finish
var j, i = noone; //i dont know whats the empty resource id
var pl=nearestplayer();
switch (content) {
	
	case "mushroom": {
		j = oMushroom;
	} break;
	
	case "fireflower": {
		if pl.size=="basic" || pl.size=="mini"
		j = oMushroom;
		else
		j = oFireFlower;
	} break;
	
	case "thunderflower": {
		if pl.size=="basic" || pl.size=="mini"
		j = oMushroom;
		else
		j = oThunderFlower;
	} break;
    
    case "star": {
        j = oStar;
    } break;	
    
    case "1up": {
        j = o1up;
    } break;
    
    case "3up": {
        j = o3up;
    } break;
    
    case "poison": {
        j = oPoisonShroom;
    } break;
	
	default: exit; //assume that the box is empty and dont proceed with spawning the object
}

i = instance_create_depth(x,y,0,j);
i.depth=oGameManager.piping_object_depth

if place_meeting(x,y+1,oCollider) {
	i.going = -1;
} else if place_meeting(x,y-1,oCollider) {
	i.going = 1;
} else {
	i.going = hit;
}
i.parentblock = id;
VinylPlay(snd_itemappear);