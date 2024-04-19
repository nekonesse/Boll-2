x = camera_get_view_x(view_camera[view_current])
y = camera_get_view_y(view_camera[view_current])
ydiff = y / (room_height - 270);

draw_sprite_tiled_ext(spr_BGtest,0,x / 2,y - (ydiff * (ysc div 2)),1,1,#FFFFFF,1)