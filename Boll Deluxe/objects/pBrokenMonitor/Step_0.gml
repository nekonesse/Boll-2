if !grounded { 
	vsp=min(vsp+grav,6);
}

x += hsp
y += vsp

player_collision(true, false, (bbox_left-x),bbox_right-x,(bbox_top-y)+1,(bbox_bottom-y)-1);