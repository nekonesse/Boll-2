sky_layer=layer_create(2000);
sky_bg=layer_background_create(sky_layer,spr_plains_bg_sky)
clouds_layer=layer_create(1900);
clouds_bg=layer_background_create(clouds_layer,spr_plains_bg_clouds)
hills_layer=layer_create(1800);
hills_bg=layer_background_create(hills_layer,spr_plains_bg_hills)
hills2_layer=layer_create(1700);
hills2_bg=layer_background_create(hills2_layer,spr_plains_bg_hills2)
clouds3d_layer=layer_create(1850);
clouds3d_bg=layer_background_create(clouds3d_layer,spr_plains_bg_3d_clouds)

clouds_3d_surface=surface_create(480,270)

layer_background_htiled(clouds_bg,true)
layer_background_visible(clouds_bg,true)
layer_background_htiled(clouds3d_bg,true)
layer_background_visible(clouds3d_bg,true)
layer_background_htiled(sky_bg,true)
layer_background_visible(sky_bg,true)
layer_background_htiled(hills_bg,true)
layer_background_visible(hills_bg,true)
layer_background_htiled(hills2_bg,true)
layer_background_visible(hills2_bg,true)

var tile_layer_3d = function() {
	surface_set_target(oBackgroundManager.clouds_3d_surface)
	shader_set(shd_mode7Ceiling);
	draw_clear_alpha(c_black, 0);
	
	var pos = shader_get_uniform(shd_mode7Ceiling, "position");
	var offset = shader_get_uniform(shd_mode7Ceiling, "offset");
	var angle = shader_get_uniform(shd_mode7Ceiling, "angle");
	var height = shader_get_uniform(shd_mode7Ceiling, "height");
	var mapSize = shader_get_uniform(shd_mode7Ceiling, "mapSize");
	var horizon = shader_get_uniform(shd_mode7Ceiling, "horizon");
	var shaderUV = shader_get_uniform(shd_mode7Ceiling, "spriteUV");
	
	var bgsprite=layer_background_get_sprite(clouds3d_bg);
	
	var spriteUV = sprite_get_uvs(bgsprite,0);
	spriteUV[2] = spriteUV[2] - spriteUV[0];
	spriteUV[3] = spriteUV[3] - spriteUV[1];
	
	shader_set_uniform_f_array(shaderUV,[spriteUV[0],spriteUV[1],spriteUV[2],spriteUV[3]]);
	shader_set_uniform_f_array(offset,[-floor(oBackgroundManager.x/16),global.roomTimer/2]);
	shader_set_uniform_f(angle, 0);
	shader_set_uniform_f(height, 64);
	shader_set_uniform_f(mapSize, sprite_get_width(bgsprite)/1.5);
	shader_set_uniform_f(horizon, 64);
}

var tile_layer_shader_reset = function() {
	shader_reset();
	surface_reset_target();
	
	draw_surface(oBackgroundManager.clouds_3d_surface,oBackgroundManager.x,oBackgroundManager.y-16)
}

layer_script_begin(clouds3d_layer, tile_layer_3d);
layer_script_end(clouds3d_layer, tile_layer_shader_reset);

// these variables should help positioning backgrounds comprised of only one non-looping image
// if only one of those axis should not loop, then only use one
xdiff = 0
ydiff = 0