// Inherit the parent event
//if !inview() exit;
draw_sprite_ext(spr_pylom_b,image_index,floor(x),floor(y),xsc,ysc,rot,image_blend,image_alpha)

draw_sprite_ext(spr_pylomlog,image_index,floor(x),floor(y),xsc,4,0,image_blend,image_alpha)

event_inherited();