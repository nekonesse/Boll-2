
function JADE_draw_object(obj,alpha) {
	var data = obj_data[$ obj[0]]
	var vxsc = 1;
	var vysc = 1;
	var voffx = 0;
	var voffy = 0;
	var frame = 0;
	var property = obj[5]
	var spr = data.sprite
	switch(obj[0]) {
		case "oCollider":
		case "oSemilider":
			if (property[0][1]) {
				frame=1;
			}
		break;
		case "oSemiSlope":
		case "oSlopeCollider":
			if (property[0][1]) {
				vxsc=-1;
				voffx=16*(obj[3]*data.sizex);
			}
			if (property[2][1]) {
				frame=1;
			}
		break;
		case "oIcicle":
			if !(property[0][1]) {
				spr=spr_iciclesolid;
			}
		break;
		case "oFrozenItem":
			switch (property[0][1]) {
				case "coin": {
					frame=0
				} break;
				case "mushroom": {
					frame=1
				} break;
				case "fireflower": {
					frame=2
				} break;
				case "thunderflower": {
					frame=3
				} break;
			    case "star": {
			        frame=4
			    } break;	
			    case "1up": {
			        frame=5
			    } break;
			    case "3up": {
			        frame=6
			    } break;
				case "mysteryorb": {
			        frame=7
			    } break;
			}
		break;
		case "oMonitor":
			switch (property[0][1]) {
				case "coin": {
					frame = 1;
				} break;
				case "fireflower": {
					frame = 2;
				} break;
				case "thunderflower": {
					frame = 4;
				} break;
			    case "star": {
					frame = 5;
			    } break;	
			    case "1up": {
					frame = 9; 
			    } break;
			    case "3up": {
					frame = 10; 
			    } break;
			    case "poison": {
					frame = 12; 
			    } break;
				default: frame = 0;
			}
		break;
	}
	draw_sprite_ext(spr,frame,obj[1]+(data.xoff*obj[3])+voffx,obj[2]+(data.yoff*obj[4]),(obj[3]*data.sizex)*vxsc,(obj[4]*data.sizey)*vysc,0,c_white,alpha);
}