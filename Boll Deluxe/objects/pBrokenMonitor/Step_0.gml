if !grounded { 
	vsp=min(vsp+grav,6);
}

x += hsp
y += vsp

player_collision(true, false, (-sprite_width/2)+1,sprite_width/2,(-sprite_height/2)+1,(sprite_height/2)-1);