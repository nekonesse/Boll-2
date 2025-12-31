// Inherit the parent event
event_inherited();

stun=max(stun-1,0);

cooldowntimer=max(cooldowntimer-1,0);

if !(stun) && !(blowing) && !(cooldowntimer) && check_rectangle_in_hitbox(x-((hit_sizex+90)*xsc),y-hit_sizey-16,x,y+hit_sizey,oPlayer) && !(revving) {
	revving=true;
	revtimer=90;
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

if !(stun) && !(revving) && !(blowing) && (hsp==0) {
	constantspd=0.5
	hp=2
}