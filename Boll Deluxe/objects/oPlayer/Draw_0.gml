if palette pal_swap_set(palette,palette_index,0)
var _interval=8;
if ((alarm[11] % 8) <= _interval/2){
draw_sprite_ext(sprite_index,image_index,floor(x),floor(y),xsc,ysc,rot,c_white,1)
}else{
	switch(oldsize) {
		case 0: draw_sprite_ext(spr_player,image_index,floor(x),floor(y),xsc,ysc,rot,c_white,1) break;
		case 1: draw_sprite_ext(spr_playerbig,image_index,floor(x),floor(y),xsc,ysc,rot,c_white,1) break;
	}
}

pal_swap_reset();

// chearii: uncomment for fuckin polygon debug

/*var _drawcolor = draw_get_color();
draw_set_color(c_red);
draw_box_poly();
draw_set_color(_drawcolor);*/

/*draw_set_alpha(0.5)
draw_rectangle_color(bbox_left,bbox_top,bbox_right,bbox_bottom,c_red,c_red,c_red,c_red,false)
draw_set_alpha(1)
*/