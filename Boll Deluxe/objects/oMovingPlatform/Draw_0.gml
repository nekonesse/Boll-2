fr+=0.2
if floor(fr) >= 3
fr=0

draw_sprite_ext(sprite_index,image_index,floor(x),floor(y),image_xscale,image_yscale,image_angle,c_white,1)
draw_sprite(spr_movingplatformwheel,floor(fr),floor(x),floor(y))