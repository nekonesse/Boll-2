if inactive || global.paused exit

if inview()
draw_sprite_ext(sprite_index,image_index,floor(x),floor(y),xsc,ysc,rot,image_blend,image_alpha)

draw_rectangle_color(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,c_red,c_red,c_red,c_red,false);