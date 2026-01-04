// Inherit the parent event
event_inherited();

cooldowntimer=max(cooldowntimer-1,0);

if !(stun) && !(blowing) && !(cooldowntimer) && check_rectangle_in_hitbox(x-((hit_sizex+90)*xsc),y-hit_sizey-16,x,y+hit_sizey,oPlayer) && !(revving) {
	revving=true;
	revtimer=60;
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