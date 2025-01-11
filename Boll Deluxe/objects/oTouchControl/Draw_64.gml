draw_sprite_part(spr_touchPad,0,8,8,64,64,PadX,PadY) //Pad base

if up draw_sprite_part(spr_touchPad,0,301,8,64,64,PadX,PadY) //up
if down draw_sprite_part(spr_touchPad,0,154,8,64,64,PadX,PadY) //down
if left draw_sprite_part(spr_touchPad,0,81,8,64,64,PadX,PadY) //left
if right draw_sprite_part(spr_touchPad,0,227,8,64,64,PadX,PadY) //right

draw_sprite_part(spr_touchPad,0,8+57*akey,78,48,48,AbutX,AbutY) //A button
//draw_sprite_part(spr_touchPad,0,8+57*bkey,78,48,48,480-64,270-64) //B button

draw_sprite(spr_JADEcursor,0,mouse_x,mouse_y) //test cursor