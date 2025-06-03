function post_wall(){
	//left wall stop
	if check_collision_line(x - hit_sizex - 1,y - (hit_sizey-2),x - hit_sizex - 1,y + (hit_sizey-2),COL_WALL) and hsp < 0.000{
		var oldhsp = hsp;
		
		if (state == "frozen") {
			state="jump"
			vsp=-2;
			grounded=false;
			y-=8
			var j=noone
			j = instance_create(x-8,y+8,pDestruction) with(j){image_index=10 hspeed=-1 vspeed=-2} //bottom left
			j = instance_create(x-8,y-8,pDestruction) with(j){image_index=10 hspeed=1 vspeed=-2} //bottom right
			j = instance_create(x+8,y+8,pDestruction) with(j){image_index=10 hspeed=-1 vspeed=-4} //top left
			j = instance_create(x+8,y-8,pDestruction) with(j){image_index=10 hspeed=1 vspeed=-4} //top right
			VinylPlay(snd_iceshatter)
		}
		
		hsp = 0
		if grounded {
			gsp = 0	
		}
		
		if (object_index==oPlayer) && (oldhsp != 0) {
			sig.Emit("wall_hit")
		}
	}
	
	//right wall stop
	if check_collision_line(x + hit_sizex + 1,y - (hit_sizey-2),x + hit_sizex + 1,y + (hit_sizey-2),COL_WALL) and hsp > 0.000{
		var oldhsp = hsp;
		
		if (state == "frozen") {
			state="jump"
			vsp=-2;
			grounded=false;
			y-=8
			var j=noone
			j = instance_create(x-8,y+8,pDestruction) with(j){image_index=10 hspeed=-1 vspeed=-2} //bottom left
			j = instance_create(x-8,y-8,pDestruction) with(j){image_index=10 hspeed=1 vspeed=-2} //bottom right
			j = instance_create(x+8,y+8,pDestruction) with(j){image_index=10 hspeed=-1 vspeed=-4} //top left
			j = instance_create(x+8,y-8,pDestruction) with(j){image_index=10 hspeed=1 vspeed=-4} //top right
			VinylPlay(snd_iceshatter)
		}
		
		hsp = 0
		if grounded {
			gsp = 0	
		}
		
		if (object_index==oPlayer) && (oldhsp != 0) {
			sig.Emit("wall_hit")
		}
	}
}