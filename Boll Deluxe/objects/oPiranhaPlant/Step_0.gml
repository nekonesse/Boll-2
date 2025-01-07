if (parent_pipe == noone) {
	player_collision();
	x+=hsp
	y+=vsp
	exit
}

if !(go) {
	timer=max(0,timer-1)

	if  !(timer) {
		if (exposed) {
			go=-0.5
		} else if !(collision_rectangle(x-24,0,x+24,room_height,oPlayer,true,true)) { //turns out i didnt need to do anything fancy here LOL
			go=0.5
		}
	} 
}

if (go != 0) {
	travel=approach_val(travel,32*esign(go,1),go)
	travel=clamp(travel,-32,32) //i genuinely dont know why this is nessecary considering approach_val should already clamp
	
	if !place_meeting(x,y,parent_pipe) && !(exposed) {
		exposed=true;
		y=parent_pipe.bbox_top;
		timer=90;
		go=0;
	} else if y==parent_pipe.bbox_bottom-1 && (exposed) {
		exposed=false;
		timer=120;
		go=0;
	}
}

y=floor(parent_pipe.bbox_bottom-1)-travel
x=parent_pipe.x