if !global.debug exit;

// get camera lengths
var xwidth = camera_get_view_width(view_camera[0]);
var ywidth = camera_get_view_height(view_camera[0]);

// left, top, right, bottom
var camdata = [ x_final - (xwidth div 2), y_final - 8 - (ywidth div 2),
				x_final + (xwidth div 2), y_final - 8 + (ywidth div 2)
				];

draw_rect(x - xsensor,y - 16,xsensor * 2,24,#FF0000,0.125)
//draw_rect(x-8,y,16,ysensor * 1.333,#FFFF00,0.125)
draw_rect(x-8,y-ysensor,16,ysensor,#FFFF00,0.125)
draw_self()
draw_text(x,y,string(state)+"\n"+string(xdist)+"\n"+string(xsc)+"\n"+string(ydist))
if (xcorrect)
{
	draw_text(x,y-48,"Correcting X position")
}
draw_rect(x_final-8,y_final,16,16,#00FF00,0.5)

draw_rectangle(camdata[0] + 1,camdata[1] + 1,camdata[2] - 1,camdata[3] - 1,true);