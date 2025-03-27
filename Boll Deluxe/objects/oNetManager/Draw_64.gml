/*var guiw=display_get_gui_width()
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
if (time>=0) {
	draw_text(200,200,$"{mins}:{secs}");
}*/