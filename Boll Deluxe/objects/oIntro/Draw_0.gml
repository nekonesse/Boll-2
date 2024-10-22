var i,md7,ypos = RESOLUTION_Y / 2, xpos = RESOLUTION_X / 2, yprev = 0;

if (egg == "3") {
	for (i = 0; i < 320; i++) {
		draw_sprite_part_ext(sprite_index,frame,0,ysc * (i / 320),xsc,1,(i & 1) ^ (global.roomTimer & 1),i,1,1,#FFFFFF,1)
	}
	//draw_text(view_get_xport(0) + 320,room_height/2,"egg = "+string(egg)+"\nroomTimer = "+string(global.roomTimer)+"\nframe = "+string(frame))
} else {
	if (frame >= 1) {
		draw_rectangle_color(0,0,RESOLUTION_X,RESOLUTION_Y div 2,#5949D6,#5949D6,#B676B3,#B676B3,false)
		draw_rectangle_color(0,RESOLUTION_Y div 2,RESOLUTION_X,RESOLUTION_Y,#B676B3,#B676B3,#FF9B99,#FF9B99,false)

		// "look at my texture pages." -blue circle
		//                         - @mostersmth
		
		shader_set(shd_scrollTexturePage)
		
		var uni_x = shader_get_uniform(shd_scrollTexturePage, "xpos");
		var uni_y = shader_get_uniform(shd_scrollTexturePage, "ypos");
		
		shader_set_uniform_f(uni_x,modulo(global.roomTimer,0,1600) / 1600);
		shader_set_uniform_f(uni_y,modulo(-global.roomTimer,0,100) / 100);
		
		draw_sprite_tiled(spr_titleclouds,0,x,y)
		shader_reset();
	}
	
	draw_circle_color(bollStruct.x,bollStruct.y,bollStruct.z + 80,c_blue,c_blue,false)
	
	if (frame >= 1) {
		//draw_text_transformed(161,16,"MARIO & SONIC IN...\n  BOLL DELUXE!!!",1,1,0)
		draw_text_transformed(161,16,"    look at my\n  texture pages.",1,1,0)
	}
	
	//draw_text(0,0,string(bollStruct.z)+"\n"+string(bollStruct.biggestZ)+"\n"+string(frame))
	
	
	//draw_sprite(sonic,0,view_xport + stretch,view_yport)
	//draw_sprite(mario,global.roomTimer div 5,view_xport - stretch,view_yport)
	//draw_sprite_ext(sprite_index,0,view_xport,view_yport,stretch,1,0,c_white,1)
}

if (flash && flash <= 30) {
	draw_rect(0,0,RESOLUTION_X,RESOLUTION_Y,#FFFFFF,flash / 30)
}