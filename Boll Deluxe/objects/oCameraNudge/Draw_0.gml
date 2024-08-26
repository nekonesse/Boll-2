if (global.debug)
{
	draw_set_font(smallF);
	draw_rect(x,y,bbox_right - x,bbox_bottom - y,#38D79B,0.125);
	draw_text(x,y,"Nudge");
	draw_text(x,y+8,"X:"+string(nudge_x)+", Y:"+string(nudge_y));
}