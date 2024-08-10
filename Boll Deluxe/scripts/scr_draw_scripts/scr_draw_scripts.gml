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
	var xpos = x_start, 
		ypos = y_start, 
		yprev, md7, 
		spr_width = sprite_get_width(sprite);
		
	var multx = (x_dest - x_start) / scan_times, 
		multy = (y_dest - y_start) / scan_times;
	
	for (var i = 0;i == clamp(i,-scan_times,scan_times);i += 1) {
		md7 = tan((i / scan_times) * (pi / 2));
		
		yprev = ypos; 
		ypos += multy * md7;
		xpos += multx * (md7 / 2);
		draw_sprite_part_ext(sprite,subimg,0,wrap_val(i + scan_offset,0,sprite_get_height(sprite)),spr_width,1,xpos - (md7 * (spr_width * 0.5)),ypos,md7,yprev - ypos,#FFFFFF,1) //draw_line
	}
}