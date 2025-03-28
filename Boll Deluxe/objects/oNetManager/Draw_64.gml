var guiw=display_get_gui_width()
var guih=display_get_gui_height()

var steps = time;
var mins = 0;
var secs = 0;

//Get secs
while steps > 60 {secs+=1; steps-=60;}

//Get mins
while secs > 60 {mins+=1; secs-=60;}

if secs<10 secs="0"+string(secs)
draw_set_font(global.smallBoldFont);
draw_set_halign(fa_middle);
if (time>=0) {
	draw_text_outline(guiw/2,guih-32,$"{mins}:{secs}", 1, c_black, 8, 1, 1, 0);
}
draw_text_outline(guiw/2,guih-16,$"actions left: {global.actions_left}", 1, c_black, 8, 1, 1, 0);
draw_set_halign(fa_left);