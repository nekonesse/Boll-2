switch (killtype) {
	case "stomp": instance_create_depth(x,y+4,0,pStompedEnemy,{sprite_index : spr_icesnifit_stomp}) break;
	default: instance_create_depth(x,y,0,pSpinningEnemy,{sprite_index : spr_icesnifit_spin, vspeed : killvsp, hspeed : killhsp*xsc}) break;
}