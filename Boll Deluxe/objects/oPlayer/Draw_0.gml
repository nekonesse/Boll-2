animate_player();

if (invincible_type == 1 && invincible_timer mod 5 < 2.5) exit;

if (CollageImageExists(oGameManager.PlayerColl.GetImageInfo(get_spriteindex()))) {
	if palette != 0 {
		pal_swap_set(oGameManager.playerPalettes[pNum],palette,false)
	}
	
	if (afterimage)
	{
		for (var i = 0; i < 3; ++i) 
		{
			if((global.roomTimer mod 3) = i )
			{
				if(hsp != 0 || vsp != 0)
				{
					var gap = 6 - (2 * i);
					draw_player(
						record_sprite[max(record_timer - gap, 0) mod 60], 
						record_frame[max(record_timer - gap, 0) mod 60],
						record_x[max(record_timer - gap, 0) mod 60], 
						record_y[max(record_timer - gap, 0) mod 60], 
						record_xscale[max(record_timer - gap, 0) mod 60], 
						record_yscale[max(record_timer - gap, 0) mod 60], 
						record_angle[max(record_timer - gap, 0) mod 60],
					)
				}
			}
		}
	}
	if (state == "boarding") {
		draw_sprite(spr_snowboard,0,floor(x),floor(y)+hit_sizey-3)
	}
	var normal_spr = oGameManager.PlayerColl.GetImageInfo(get_spriteindex())
	draw_player(normal_spr, frame);
	if palette != 0 {
		pal_swap_reset()
	}
	shader_reset();
	if (state == "frozen") {
		draw_sprite(spr_playericecube,5-frozen_health,floor(x),floor(y))
	}
}

if (global.debug) {
	draw_set_font(global.omiFont)
	draw_set_alpha(0.5)
	draw_rectangle_color(
		floor(x)-hit_sizex,
		floor(y)-hit_sizey,
		floor(x)+hit_sizex,
		floor(y)+hit_sizey,
		c_red,c_red,c_red,c_red,
		false
	)
	draw_set_alpha(1)
}