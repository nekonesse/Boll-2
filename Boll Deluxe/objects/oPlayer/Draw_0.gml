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
if (sheet != -1) {
	if (greenmode) {
		shader_set(shd_flatcolor);
		
		var uni_r = shader_get_uniform(shd_flatcolor, "red");
		var uni_g = shader_get_uniform(shd_flatcolor, "green");
		var uni_b = shader_get_uniform(shd_flatcolor, "blue");
		shader_set_uniform_f(uni_r,0)
		shader_set_uniform_f(uni_g,1)
		shader_set_uniform_f(uni_b,0)
	}
	draw_player();
	shader_reset();
}

if (global.debug) {
	draw_set_font(smallF)
	draw_set_alpha(0.5)
	draw_rectangle_color(floor(x)-hit_sizex,floor(y)-hit_sizey,floor(x)+hit_sizex,floor(y)+hit_sizey,c_red,c_red,c_red,c_red,false)
	draw_set_alpha(1)
	draw_text(x,y,warp_timer)
}