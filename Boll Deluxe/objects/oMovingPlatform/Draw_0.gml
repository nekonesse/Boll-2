fr+=0.2
if floor(fr) >= 3
fr=0

draw_self();
draw_sprite(spr_movingplatformwheel,floor(fr),x,y)