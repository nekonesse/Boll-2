x = camera_get_view_x(view_camera[0])
y = camera_get_view_y(view_camera[0])

if (x != xprevious) { //check only if its moved to prevent needless updates to layers that may be very cost-heavy
	xdiff = x / (room_width - RESOLUTION_X);
	layer_x(sky_layer,0)
	layer_x(clouds_layer,floor(x/2))
	layer_x(hills_layer,floor(x/4))
	layer_x(hills2_layer,floor(x/8))
}

if (y != yprevious) { //same thing applies here
	ydiff = y / (room_height - RESOLUTION_Y);
	layer_y(sky_layer,y)
	layer_y(clouds_layer,y+54)
	layer_y(clouds3d_layer,-16)
	layer_y(hills_layer,room_height-120)
	layer_y(hills2_layer,room_height-80)
}

//draw_sprite_tiled_ext(spr_BGtest,0,x / 2,y - (ydiff * (ysc div 2)),1,1,#FFFFFF,1)

/*shader_set(shd_mode7Ceiling);
		
shader_set_uniform_f_array(shaderUV,[spriteUV[0],spriteUV[1],spriteUV[2],spriteUV[3]]);
shader_set_uniform_f_array(offset,[global.roomTimer * 2, global.roomTimer * -0.75]);
shader_set_uniform_f(angle, 180);
shader_set_uniform_f(height, 128);
shader_set_uniform_f(mapSize, xsc);
shader_set_uniform_f(horizon, 128);
	shader_set_uniform_f(pos, 96);
		
draw_sprite_ext(spr_plains_bg_transition,0,240,135,16,2,0,#FFFFFF,1);
shader_reset();