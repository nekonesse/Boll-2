if (egg=="3") {
	if (global.roomTimer mod 2 == 0) {
	for (i=0;i<320;i++) {
		draw_sprite_part_ext(introBLAST,frame,0,i div 2,128,1,0+i mod 2,i,2,1,#FFFFFF,1)
	}
	} else {
		for (i=0;i<320;i++) {
			draw_sprite_part_ext(introBLAST,frame,0,i div 2,128,1,0+((i mod 2)*-1)+1,i,2,1,#FFFFFF,1)
		}
	}
	draw_text(0,room_height/2,"egg = "+string(egg)+"\nroomTimer = "+string(global.roomTimer)+"\nframe = "+string(frame))
	//draw_sprite_ext(introBLAST,frame,0,0,2,2,0,#FFFFFF,1)
}