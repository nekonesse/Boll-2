if (popup_text) {
	draw_set_color($009be2)
	draw_set_font(fntBollPartyFont)
	draw_set_halign(fa_center)
	draw_set_valign(fa_center)
	draw_text_outline(floor(draw_x),floor(draw_y),finalvalue[0],1,c_black,8,scale_x,scale_y,0)
	
	if (timer) draw_y-=0.2
	
	timer-=1
	if (!timer) {
		timer=0
		draw_x=approach_val(draw_x,256,16)
		draw_y=approach_val(draw_y,32,16)
		scale_x=approach_val(scale_x,4,0.5)
		scale_y=approach_val(scale_y,4,0.5)
	}
}