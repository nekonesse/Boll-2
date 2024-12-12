///  @description manage morphing sprites
global.drawcost = 0;
global.drawcost_pct = 0;

if instance_exists(oSlime) {
	var delta_timer = get_timer();

	last_delta = 0;
	last_delta += delta_timer;
	
	shader_set(shd_morphing);

	var _tex = sprite_get_uvs(spr_slime_morphcone, 0);

	morph_uv_left = _tex[0];
	morph_uv_right = _tex[2];
	morph_uv_top = _tex[1];
	morph_uv_bottom = _tex[3];

	with(oSlime) {
		var finy = camera_y;
		var exceed = max(0, y - camera_y - (CAMERA_MAX_HEIGHT - 8));

		finy += exceed;
	
		morph_set_shader_data(morph);
	
		draw_sprite(spr_slime_morphcone,0,camera_x + morph.exceed_x,finy);
	}

	shader_reset();
	
	global.drawcost = abs(get_timer() - last_delta);
	global.drawcost_pct = (global.drawcost / delta_time) * 100;
}