/*if palette pal_swap_set(palette,palette_index,0)
var _interval=8;
if ((alarm[11] % 8) <= _interval/2) {
draw_sprite_ext(sprite_index,image_index,floor(x),floor(y),xsc,ysc,rot,c_white,1)
} else {
	switch(oldsize) {
		case 0: draw_sprite_ext(spr_player,image_index,floor(x),floor(y),xsc,ysc,rot,c_white,1) break;
		case 1: draw_sprite_ext(spr_playerbig,image_index,floor(x),floor(y),xsc,ysc,rot,c_white,1) break;
	}
}

if (keyboard_check_pressed(vk_f12)) {if drawStar {drawStar=false} else {drawStar=true}}

if (drawStar) {
	draw_sprite_circle(spr_pSparkles1UP,(global.roomTimer div 2) mod 6,x,(y-8)-(16*sign(size)),1,1,16+(sign(size)*8),2,global.roomTimer * 0.125)
}

pal_swap_reset();

// chearii: uncomment for fuckin polygon debug

/*var _drawcolor = draw_get_color();
draw_set_color(c_red);
draw_box_poly();
draw_set_color(_drawcolor);*/
animate_player();
draw_player();

if (global.debug) {
	draw_set_alpha(0.5)
	draw_rectangle_color(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,c_red,c_red,c_red,c_red,false)
	draw_set_alpha(1)

	draw_text(x,y,sprite)
}

//draw_text(x,y,string(fr)+"\n"+string(frame))

//draw_text(x,y,AnimationData)

//draw_line(x div 1,bbox_bottom div 1, (x div 1) + 1, bbox_bottom div 1);
//draw_line(bbox_right div 1,bbox_bottom div 1, (bbox_right div 1) + 1, bbox_bottom div 1);

//var bboxvsheight = abs(sprite_height - (abs(bbox_bottom - bbox_top) div 1));

//draw_line_color(x div 1, (y - sprite_yoffset) div 1, x div 1, ((y - sprite_yoffset) div 1) + bboxvsheight, c_red, c_red);

//draw_line_color(x div 1, (y - sprite_yoffset) div 1, x div 1, ((bbox_bottom + 8 )div 1), c_green, c_green);