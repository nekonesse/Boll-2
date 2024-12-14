if (global.debug)
{
	draw_set_font(global.omiFont);
	draw_rect(x,y,bbox_right - x,bbox_bottom - y,#A22633,0.125);
	draw_text(x,y,"Camera Lock");
	draw_text(x,y+8,"X:"+string(x_limit)+", Y:"+string(y_limit));
}