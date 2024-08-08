var i,md7,ypos = RESOLUTION_Y / 2, xpos = RESOLUTION_X / 2, yprev = 0;

if (egg == "3") {
	for (i = 0; i < 320; i++) {
		draw_sprite_part_ext(sprite_index,frame,0,ysc * (i / 320),xsc,1,(i & 1) ^ (global.roomTimer & 1),i,1,1,#FFFFFF,1)
	}
	draw_text(view_get_xport(0) + 320,room_height/2,"egg = "+string(egg)+"\nroomTimer = "+string(global.roomTimer)+"\nframe = "+string(frame))
} else {
	if (frame >= 1) {
		mode_seven(spr_titleclouds,0,240,RESOLUTION_Y div 3,240,0,-global.roomTimer)
	}
	
	//this does nothing btw
	shader_set(shd_flatcolor)
	vertex_submit(boll, pr_trianglelist, sprite_get_texture(spr_Samba, 0));
	shader_reset()
	
	//draw_circle_color(bollStruct.x,bollStruct.y,bollStruct.z + 80,c_blue,c_blue,false)
	
	if (frame >= 1) {draw_text_transformed(183,148,"CIRCOL\nDELUXE",2,2,0)}
	
	draw_text(0,0,string(bollStruct.z)+"\n"+string(bollStruct.biggestZ)+"\n"+string(frame))
	
	
	//draw_sprite(sonic,0,view_xport + stretch,view_yport)
	//draw_sprite(mario,global.roomTimer div 5,view_xport - stretch,view_yport)
	//draw_sprite_ext(sprite_index,0,view_xport,view_yport,stretch,1,0,c_white,1)
}