draw_sprite_ext(sprite_index,image_index,floor(x),floor(y),image_xscale,image_yscale,0,image_blend,image_alpha)


if global.debug {
	draw_set_color(c_lime)
	draw_line(x-(hit_sizex-2),y+hit_sizey+5,x+(hit_sizex-2),y+hit_sizey+5)	
	draw_line(x,y,x+lengthdir_x(16,colangle+90),y+lengthdir_y(16,colangle+90))
	
	draw_set_font(global.omiFont)
	var coll=collision_line(x-hit_sizex,y+hit_sizey+2,x+hit_sizex,y+hit_sizey+2,oCollider,true,true)
		
	var left=(coll) && (x > coll.bbox_right) && (y < (coll.bbox_top+2))
	var right=(coll) && (x < coll.bbox_left) && (y < (coll.bbox_top+2))
	draw_set_color(c_white)
}