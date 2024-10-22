function makeboll(color1 = c_fuchsia,color2 = c_blue,color3 = c_white) {
	
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_normal();
	vertex_format_add_color();
	vertex_format_add_texcoord();
	var vtf = vertex_format_end();

	var b = buffer_load($"{working_directory}\\_vanilla\\media\\boll.buf")
	var model = vertex_create_buffer_from_buffer(b, vtf);
	buffer_delete(b);
	
	return model
//	i have no idea if this works, im just doing this out of intuition
//	i had to convert that .d3d file to .buf so if it doesnt work blame in on the conversion
//	istg if i have to convert that by hand :stare:
}

function draw_sprite_circle(sprite,subimg,xdraw,ydraw,xscale,yscale,radius,quantity,circleAngle){
	var tempReal=0;
	repeat(quantity){
		draw_sprite_ext(sprite,subimg,
		((radius)*sin(tempReal+(circleAngle)))+xdraw,
		((radius)*cos(tempReal+(circleAngle)))+ydraw,
		xscale,yscale,0,#FFFFFF,1)
		tempReal+=(pi*2)/quantity
	}
}

function mode_seven(sprite, subimg, x_start, y_start, x_dest, y_dest, scan_offset, scan_times = 255) {
	draw_text(x_start,y_start,"mode_seven() IS OBSOLETED!!")
}