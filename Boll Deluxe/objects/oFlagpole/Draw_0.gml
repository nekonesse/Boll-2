draw_self()

if (state < 2) {
	if (debugVal != 0) {
		draw_text(x + 2, y - gfx_y - 160, string(debugVal));
	}
	if (state == 1) {
		debugVal = clamp(round(((y - instance_place(x,y,oPlayer).y) / bbox_height) * 50), 5, 50);
		gfx_y += 2;
		if (gfx_y > -32) {
			gfx_y = -32
			state = 2;
			instance_create(x + 16, y + gfx_y + 16, pSmoke);
			exit;
		}
	}
	draw_sprite(spr_flagFromPole, global.roomTimer div 8,x ,y + gfx_y);
	exit;
}
if (debugVal) {
	draw_text(x + 2, y - 128, string(debugVal));
	global.coins_collected++;
	VinylPlay(snd_itemcoin);
	instance_create_depth(x + random(32), y + random(8) - 128, depth + 1, pGlitter);
	debugVal -= 1;
}