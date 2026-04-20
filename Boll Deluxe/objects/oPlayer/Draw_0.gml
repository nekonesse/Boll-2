animate_player();

if (invincible_type == 1 && invincible_timer mod 5 < 2.5) exit;

if (CollageImageExists(oGameManager.PlayerColl.GetImageInfo(get_spriteindex()))) {
	if palette != 0 {
		pal_swap_set(oGameManager.playerPalettes[pNum],palette,false)
	}
	
	if (invincible_type == 2) {
		shader_set(shd_colormod)
		var unitime = shader_get_uniform(shd_colormod,"time")
		shader_set_uniform_f(unitime, global.roomTimer / game_get_speed(gamespeed_fps));
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
		draw_sprite_ext(spr_snowboard,0,floor(x)-lengthdir_x(3,sprite_angle-90),floor(y)+hit_sizey-lengthdir_y(3,sprite_angle-90),1,1,sprite_angle,c_white,1);
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
	
	if (invincible_type == 2) {
		var _star_shine_offset = ((global.roomTimer / 3) mod 5);
		var _final_angle = ((global.roomTimer + ((global.roomTimer & 1) * 90)) * 1.5) + ((_star_shine_offset) * 16)
		draw_sprite_circle(spr_pShineStarman,_star_shine_offset,floor(x),floor(y),1,1, (bbox_bottom - bbox_top) + 2, 2, (_final_angle / 360) * (pi * 4))
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