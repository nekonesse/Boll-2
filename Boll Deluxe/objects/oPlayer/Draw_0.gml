var _interval=8;
if ((alarm[11] % 8) <= _interval/2){
draw_sprite_ext(sprite_index,image_index,x,y,xsc,ysc,rot,c_white,1)
}else{
	switch(oldsize) {
		case 0: draw_sprite_ext(spr_player,image_index,x,y,xsc,ysc,rot,c_white,1) break;
		case 1: draw_sprite_ext(spr_playerbig,image_index,x,y,xsc,ysc,rot,c_white,1) break;
	}
}
draw_set_alpha(0.5)
draw_rectangle_color(bbox_left,bbox_top,bbox_right,bbox_bottom,c_red,c_red,c_red,c_red,false)
draw_set_alpha(1)
