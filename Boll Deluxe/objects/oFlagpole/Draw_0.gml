draw_self()

if (reward != 0) {
	if (reward < 51) {
		draw_text_outline(x + 2, y - gfx_y - 160,string(reward),-1,#BC5B00,1,1,1,0)
		//draw_text(x + 2, y - gfx_y - 160, string(reward));
	} else {
		draw_sprite_ext(spr_p1UP, 0, x + 16, y - gfx_y - 160,0.5,0.5,0,#FFFFFF,1);
	}
}

if (state < 2) {
	draw_sprite(spr_flagFromPole, global.roomTimer div 8,x ,y + gfx_y);
	exit;
}