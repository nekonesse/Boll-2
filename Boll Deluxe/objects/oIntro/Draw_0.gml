if (egg == "3") {
	var i=0;
	repeat (320) {
		draw_sprite_part_ext(sprite_index,frame,0,ysc * (i / 320),xsc,1,(i & 1) ^ (global.roomTimer & 1),i,1,1,#FFFFFF,1)
		i++;
	}
	//draw_text(view_get_xport(0) + 320,room_height/2,"egg = "+string(egg)+"\nroomTimer = "+string(global.roomTimer)+"\nframe = "+string(frame))
} else {
	if (frame >= 1) {
		draw_rectangle_color(0,0,RESOLUTION_X,135,#5949D6,#5949D6,#B676B3,#B676B3,false)
		draw_rectangle_color(0,135,RESOLUTION_X,RESOLUTION_Y,#B676B3,#B676B3,#FF9B99,#FF9B99,false)
		
		shader_set(shd_mode7Ceiling);
		
		shader_set_uniform_f_array(shaderUV,[spriteUV[0],spriteUV[1],spriteUV[2],spriteUV[3]]);
		shader_set_uniform_f_array(offset,[global.roomTimer * 2, global.roomTimer * -0.75]);
		shader_set_uniform_f(angle, 180);
		shader_set_uniform_f(height, 128);
		shader_set_uniform_f(mapSize, xsc);
		shader_set_uniform_f(horizon, 128);
		shader_set_uniform_f(pos, 96);
		
		draw_sprite_ext(spr_titleclouds,0,240,135,16,2,0,#FFFFFF,1);
		shader_reset();
	}
	
	draw_circle_color(bollStruct.x,bollStruct.y + bolldive,bollStruct.z + 80,c_blue,c_blue,false)
	
	if (frame >= 1) {
		draw_text_transformed(161,16,"boll 2",1,1,0)
	}
	
	
	//draw_text(0,0,string(bollStruct.z)+"\n"+string(bollStruct.biggestZ)+"\n"+string(frame))
	
	
	//draw_sprite(sonic,0,view_xport + stretch,view_yport)
	//draw_sprite(mario,global.roomTimer div 5,view_xport - stretch,view_yport)
	//draw_sprite_ext(sprite_index,0,view_xport,view_yport,stretch,1,0,c_white,1)
}

if (flash && flash <= 30) {
	draw_rect(0,0,RESOLUTION_X,RESOLUTION_Y,#FFFFFF,flash / 30)
	xsc = sprite_get_width(spr_titleclouds)
}