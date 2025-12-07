///  @description manage morphing sprites
global.drawcost = 0;
global.drawcost_pct = 0;

if instance_exists(oSlime) {
	var delta_timer = get_timer();

	last_delta = 0;
	last_delta += delta_timer;
	
	var appcoords = [surface_get_width(application_surface),
					 surface_get_height(application_surface)];
	
	var morph_surface = surface_create(appcoords[0], appcoords[1]);
	
	surface_set_target(morph_surface);
	draw_clear_alpha(c_black, 0);
	

	shader_set(shd_morphing);

	var _tex = sprite_get_uvs(spr_slime_morphcone, 0);

	morph_uv_left = _tex[0];
	morph_uv_right = _tex[2];
	morph_uv_top = _tex[1];
	morph_uv_bottom = _tex[3];
	
	var shinecoords = ds_list_create();
	var shinex, shiney, shinediff;

	with(oSlime) {
		var finy = global.camera_y;
		var exceed = max(0, y - global.camera_y - (CAMERA_MAX_HEIGHT - 8));

		finy += exceed;
	
		morph_set_shader_data(morph);

		draw_sprite(spr_slime_morphcone,0,morph.exceed_x,exceed);
		
		shiney = min((CAMERA_MAX_HEIGHT - 8), y - global.camera_y) - int64(morph.vis_height / 1.37);
		
		shinediff = (morph.shader_data[1][max(0, shiney)] + max(0, shiney) & 0xff) div 2;
		
		shinex = (128 - int64(morph.shader_data[0][max(0, shiney)] * 256))
					+ global.camera_x + morph.exceed_x;
		
		shinex -= (shinediff - int64(shinediff * 0.41));
		
		ds_list_add(shinecoords,[ shinex, shiney, exceed ]);
	}

	shader_reset();
	surface_reset_target();
	
	gpu_set_blendenable(false)
	gpu_set_colorwriteenable(false,false,false,true);
	draw_set_alpha(0);
	draw_rectangle(0,0,appcoords[0],appcoords[1],false);
	
	draw_set_alpha(1);
	draw_surface(morph_surface, global.camera_x, global.camera_y);
	gpu_set_blendenable(true);
	gpu_set_colorwriteenable(true,true,true,true);
	
	gpu_set_blendmode_ext(bm_dest_alpha,bm_inv_dest_alpha);
	gpu_set_alphatestenable(true);
	
	surface_set_target(morph_surface);
	
	var len = ds_list_size(shinecoords);
	var pos;
	
	var i=0;
	repeat (len)
	{
		pos = shinecoords[|i];
		draw_sprite(spr_slime_shine,0,pos[0]-global.camera_x,pos[1] + pos[2]);
		i++;
	}
	
	surface_reset_target();
	
	ds_list_destroy(shinecoords);
	
	gpu_set_alphatestenable(false);
	gpu_set_blendmode(bm_normal);
	
	shader_set(shd_outline);
	
	var tex, tw, th, slime_outline_color;
	tex = surface_get_texture(morph_surface);
	tw = texture_get_texel_width(tex);
	th = texture_get_texel_height(tex);
	slime_outline_color = 0x317440;
	
	shader_set_uniform_f(u_texel, tw, th);
	set_outlinecolor_from_hex(slime_outline_color);
	
	draw_set_alpha(0.90);
	draw_surface(morph_surface, global.camera_x, global.camera_y);
	draw_set_alpha(1.0);
	
	shader_reset();
	
	surface_free(morph_surface);
	
	global.drawcost = abs(get_timer() - last_delta);
	global.drawcost_pct = (global.drawcost / delta_time) * 100;
	show_debug_message("test!")
}