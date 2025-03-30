var guiw=display_get_gui_width()
var guih=display_get_gui_height()

var steps = time;
var mins = 0;
var secs = 0;

var ping = last_ping_time

//Get secs
while steps > 60 {secs+=1; steps-=60;}

//Get mins
while secs > 60 {mins+=1; secs-=60;}

if secs<10 secs="0"+string(secs)
draw_set_font(global.omiFont);
draw_set_halign(fa_left);
	draw_text_outline(0,guih-32,$"ping: {ping}f", 1, c_black, 8, 1, 1, 0);
	if ping_time >= 180 {
		var last_p = (ping_time / 60) 
		draw_text_color(16, guih-24, $"WARNING: No responce from last ping {last_p}", c_red, c_red, c_red, c_red,1)	
	}
draw_set_halign(fa_middle);
draw_set_font(global.smallBoldFont);
if (time>=0) {
	draw_text_outline(guiw/2,guih-32,$"{mins}:{secs}", 1, c_black, 8, 1, 1, 0);
}
draw_text_outline(guiw/2,guih-16,$"actions left: {global.actions_left}", 1, c_black, 8, 1, 1, 0);
draw_set_halign(fa_left);