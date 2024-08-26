get_player_sheet();
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
	draw_text(x,y,warp_out)
}