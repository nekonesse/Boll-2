draw_sprite_ext(sprite_index,image_index,x,y-dy,image_xscale+abs(dy)/24,image_yscale+abs(dy)/24,0,c_white,1)
draw_sprite_ext(spr_flipblockeyes,image_index,x,y-dy,1+abs(dy)/24,1+abs(dy)/24,0,c_white,1)

if global.debug draw_text(x,y,image_speed)