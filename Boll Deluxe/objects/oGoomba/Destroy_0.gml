switch (killtype) {
	case "stomp": instance_create_depth(x,y+4,0,pStompedEnemy,{sprite_index : spr_goombastomped}) break;
	default: instance_create_depth(x,y,0,pSpinningEnemy,{sprite_index : spr_goombaspin, vspeed : -3, hspeed : xsc}) break;
}