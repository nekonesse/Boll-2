// Inherit the parent event
event_inherited();

stun=max(stun-1,0);

//if check_rectangle_in_hitbox(x-((hit_sizex+64)*xsc),y-16,x-((hit_sizex+64)*xsc),y+16,oPlayer)

if !(blowing) && check_rectangle_in_hitbox(x-((hit_sizex+90)*xsc),y-hit_sizey-16,x,y+hit_sizey,oPlayer) && !(revving) {
	revving=true
	revtimer=90
	constantspd=0;
}

if (revving) {
	revtimer=max(revtimer-1,0)
	
	if !(revtimer) {
		revving=false;
		blowing=true
		blowtimer=90;
	}
}

if (blowing) {
	var list = ds_list_create();
	var num = check_rectangle_in_hitbox_list(x-((hit_sizex+64)*xsc),y-16,x,y+16,oPlayer,list)
	if (num > 0) {
		var i=0;
		repeat(num) {
			var pl = list[| i]
			with(pl) {
				hsp=-3*other.xsc
				gsp=-3*other.xsc
				
				if (state!="frozen") {
					VinylPlay(snd_playerfreeze)
					sig.Emit("on_freeze")
					frozen_health = 5
				}
			}
			i++;
		}
	}
	ds_list_destroy(list)
	
	if blowtimer mod 4 == 0 {
		var i=make_particle(pSmoke,x-8*xsc,y,depth-1,1,-2.5*xsc,irandom_range(0.25,-0.25))
		i.image_speed/=2
	}
	
	blowtimer=max(blowtimer-1,0)
	if !(blowtimer) {
		constantspd=0.5
		blowing=false
	}
}

if !(stun) && !(revving) && !(blowing) && (hsp==0) {
	constantspd=0.5
	hp=2
}