if (laserlength!=0) {
	if state==2 {
		draw_sprite_stretched(spr_stopboblaser,0, x-12, y+hit_sizey, 24, laserlength-12)
	}
	else {
		draw_sprite_stretched(spr_stopboblaser,0, x-12, y+hit_sizey+(maxlaserlength-laserlength), 24, laserlength-12)
	}
	
	if (laserlength==maxlaserlength && global.roomTimer mod 4 < 2) || (state!=2)
	draw_sprite(spr_stopboblaser, 1, x, y+hit_sizey+maxlaserlength-12-16)
}

draw_line_color(x-1,y-hit_sizey,x-1,y-hit_sizey-(linelength-10), c_black, c_black)
event_inherited();

flare_frame+=0.25;
if flare_frame > 7 {
	flare_fading=true;
	flare_frame=6;
}

if (flare_fading) flare_alpha=max(0,flare_alpha-0.02)

draw_sprite_ext(spr_stopboblight,floor(flare_frame),x,y+8-(7*state),1,1,0,c_white,flare_alpha)

if (state==2 && flare_frame > 4) {
	elec_frame+=0.2;
	if elec_frame > 2
	elec_frame=0;
	
	draw_sprite(spr_stopbobelec, elec_frame, x, y)
}