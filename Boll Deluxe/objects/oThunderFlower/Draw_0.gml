fr+=0.3
if fr >= 6 fr=0

pal_swap_set(spr_thunderflowerpal,1+floor(fr),false)
draw_sprite_ext(sprite_index,image_index,x,y,xsc,ysc,rot,c_white,1)
pal_swap_reset();