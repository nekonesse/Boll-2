///@description Process data here
draw_self()

if (state < 2) {
	if (reward != 0) {
		draw_text(x + 2, y - gfx_y - 160, string(reward));
	}
	if (state == 1 && player != noone) {
		if (reward == 0) {
			var maxreward = 50;
			reward = clamp(round(((y - player.y) / bbox_height) * (maxreward + 5)), 5, maxreward);
		}
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

if (reward) {
	draw_text(x + 2, y - 128, string(reward));
	global.coins_collected++;
	VinylPlay(snd_itemcoin);
	instance_create_depth(x + random(32), y + random(8) - 128, depth + 1, pGlitter);
	reward -= 1;
}