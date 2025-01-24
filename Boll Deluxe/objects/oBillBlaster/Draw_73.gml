if global.debug {
	var xsize = hit_sizex div 2,
		ysize = hit_sizey div 2;
	
	draw_rect(//ground
		x + xsize, y, xsize + (hit_sizex), hit_sizey - 1,
		#FF0000,
		0.25
	)
	
	draw_rect(//player
		x - 8, -9999999, hit_sizex + 8, room_height + 9999999,
		#00FF00,
		0.25
	)
	
	draw_point_color(x + xsize, y + ysize,global.roomTimer & 1?#000000:#FFFFFF)
}