//if !inview() exit

draw_sprite_ext(sprite_index,image_index,floor(x),floor(y)-1*(ysc<0),xsc,ysc,rot,image_blend,image_alpha)

if global.debug {
	draw_rect(x-hit_sizex,y-hit_sizey,hit_sizex*2,hit_sizey*2,c_red,0.5)
}