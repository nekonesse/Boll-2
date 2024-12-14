if (global.debug)
{
	draw_set_font(global.omiFont);
	draw_rect(x,y,bbox_right - x,bbox_bottom - y,#4DAAC0,0.125);
	draw_text(x,y,$"Zoom: {zoom}");
}