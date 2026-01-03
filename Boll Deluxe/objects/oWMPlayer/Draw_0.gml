animate_player();

if (invincible_type == 1 && invincible_timer mod 5 < 2.5) exit;

if (CollageImageExists(oGameManager.PlayerColl.GetImageInfo(get_spriteindex()))) {
	if palette != 0 {
		pal_swap_set(oGameManager.playerPalettes[pNum],palette,false)
	}
	draw_player();
	if palette != 0 {
		pal_swap_reset()
	}
	shader_reset();
}

if (global.debug) {
	draw_set_font(global.omiFont)
	draw_set_alpha(0.5)
	draw_rectangle_color(floor(x)-hit_sizex,floor(y)-hit_sizey,floor(x)+hit_sizex,floor(y)+hit_sizey,c_red,c_red,c_red,c_red,false)
	gpu_set_blendmode(bm_add);
	draw_box_poly(self);
	gpu_set_blendmode(bm_normal);
	draw_set_alpha(1)
	draw_text(x,y,warp_out)
}