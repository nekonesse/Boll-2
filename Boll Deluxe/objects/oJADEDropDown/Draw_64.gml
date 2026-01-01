draw_gui(x-3,y-3,image_xscale+6,image_yscale+6,oJADEController.themeaccent4,1,true)
var i=0;
var f=draw_get_font();
draw_set_font(global.rulerGold)
var length = array_length(names);
var curs_x = window_mouse_get_x()
var curs_y = window_mouse_get_y()
repeat(length) {
	var over = point_in_rectangle(curs_x,curs_y,x,y+(20*i),x+sprite_width,y+19+(20*i))
	
	if (over) {
		draw_rect(x,y+(20*i),image_xscale,20,oJADEController.themeaccent3,1)
	}
	
	draw_text(x,y+(20*i)+4,names[i])
	
	i++;
	
	//divider
	if (i!=length) {
		draw_rect(x,y+(20*i)-1,image_xscale,1,oJADEController.themeaccent3,1)
	}
}
draw_set_font(f)