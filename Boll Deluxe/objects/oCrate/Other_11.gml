///@description Empty Contents on break
var j, i = noone;
var p=nearestplayer();
var s=-esign(p.x-x,1);
switch (content) {
	case "coin": {
		var i=instance_create_depth(x,y,0,pCoinCollected)
		i.vspeed=3*-1
		i.gravity=0.15*-sign(i.vspeed)
		VinylPlay(snd_itemcoin);
		global.coins_collected++;
		exit;
	} break;
	
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
    
    case "3up": {
        j = o3up;
    } break;
	
    case "poison": {
        j = oPoisonShroom;
    } break;
	
	default: exit; //assume that the box is empty and dont proceed with spawning the object
}

i = instance_create_depth(x,y,0,j);
i.vsp=-4
i.hsp=1.5*s
i.phaseid=p.id;
i.phase_leeway=10;
VinylPlay(snd_itemappear);