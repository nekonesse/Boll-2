var i;
if (egg == "3") {
	for (i = 0; i < 320; i++) {
		draw_sprite_part_ext(sprite_index,frame,0,ysc * (i / 320),xsc,1,(i & 1) ^ (global.roomTimer & 1),i,1,1,#FFFFFF,1)
	}
	draw_text(view_get_xport(0) + 320,room_height/2,"egg = "+string(egg)+"\nroomTimer = "+string(global.roomTimer)+"\nframe = "+string(frame))
}