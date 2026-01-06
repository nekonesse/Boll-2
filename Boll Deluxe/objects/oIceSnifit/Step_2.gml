///@description Ice Blowing
event_inherited();

if (blowing) {
	var list = ds_list_create();
	var num = check_rectangle_in_hitbox_list(x-((hit_sizex+64)*xsc),y-24,x-((hit_sizex+8)*xsc),y+24,oPlayer,list)
	if (num > 0) {
		var foundplayer = false;
		var i=0;
		repeat(num) {
			var pl = list[| i]
			with(pl) {
				if !(dead) && !(hurt) && !(state == "frozen") && !(piped) {
					hsp=-3*other.xsc
					gsp=-3*other.xsc
				
					if (state!="frozen") {
						foundplayer=true
						state = "frozen"
						sig.Emit("on_freeze")
						while (check_collision_line(x-hit_sizex,y+hit_sizey,x+hit_sizex,y+hit_sizey,COL_BOTTOM)) {
							y-=1
						}
						frozen_health = 5
						other.phaseid = id;
						other.phase_leeway = 5;
					}
				}
			}
			i++;
		}
		if (foundplayer) VinylPlay(snd_playerfreeze)
	}
	ds_list_destroy(list)
	
	if blowtimer mod 4 == 0 {
		var i=make_particle(pSmoke,x-8*xsc,y,depth-1,1,-2.5*xsc,random_range(0.5,-0.5))
		i.image_speed/=2
	}
	
	blowtimer=max(blowtimer-1,0)
	if !(blowtimer) {
		constantspd=0.5
		blowing=false
		cooldowntimer=180;
	}
}