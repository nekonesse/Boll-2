
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
		default: break;
	}
	draw_sprite_ext(spr,frame,obj[1]+(data.xoff*obj[3])+voffx,obj[2]+(data.yoff*obj[4]),(obj[3]*data.sizex)*vxsc,(obj[4]*data.sizey)*vysc,0,c_white,alpha);
	
	//overlay
	switch(obj[0]) {
		case "oTyler":
			var tilesetarr = global.tilesets[$ property[1][1]]
			var t_width = sprite_get_width(tilesetarr[0])/16
			var uv = property[0][1]
			var off_x = property[2][1]
			var off_y = property[3][1]
			var repeat_x = property[6][1]
			var repeat_y = property[7][1]
			var mirror = property[8][1]
			var flip = property[9][1]
			var rotate = property[10][1]
			
			shader_set(shd_alpha)
			var shalpha = shader_get_uniform(shd_alpha, "alpha");
			shader_set_uniform_f(shalpha,0.5)

			var i=0;
			repeat(uv[2]*(repeat_x+1)) {
				var j=0;
				repeat(uv[3]*(repeat_y+1)) {
					var tile_index = (uv[0]+(i mod uv[2]))+((uv[1]+(j mod uv[3]))*t_width);
		
					var tiledata = tile_index;
					if (mirror) {
						tiledata |= tile_mirror;
					}
					if (flip) {
						tiledata |= tile_flip;
					}
					if (rotate) {
						tiledata |= tile_rotate;
					}
					draw_tile(tilesetarr[1],tiledata,0,obj[1]+i*16+off_x,obj[2]+j*16+off_y);
					j++;
				}
				i++;
			}
			
			shader_reset();
		break;
		default: break;
	}
}