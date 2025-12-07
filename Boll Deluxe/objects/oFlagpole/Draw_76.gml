///@description Process data here
var temp = abs(((gfx_y + 32) / -112) - 1);
if (state < 2) {
	if (state == 1 && player != noone) {
		if (reward == 0) {
			var maxreward = 51;
			reward = clamp(round(((y - player.y) / bbox_height) * (maxreward + 5)), 5, maxreward);
			//sound = VinylPlay(snd_flagpoleraise, true, 0.1, 0)
		}
		
		//VinylSetPitch(sound, lerp(0.5,2,temp))
		
		//for some reason gamemaker wont reconize this function so ill just leave everything
		//relating to the flagpoles sounds commented
		
		gfx_y += 2;
		if (gfx_y > -32) {
			gfx_y = -32
			state = 2;
			instance_create(x + 16, y + gfx_y + 16, pSmoke);
			//VinylStop(sound);
			exit;
		}
	}
	exit;
}

if (reward) {
	if (reward < 51) {
		draw_text(x + 2, y - 128, string(reward));
		global.coins_collected++;
		VinylPlay(snd_itemcoin);
		if global.roomTimer & 1 {
			instance_create_depth(x + random(32), y + random(8) - 128, depth + 1, pShine);
		}
		reward -= 1;
	} else {
		draw_text(x + 2, y - 128, string(reward));
		if (reward == 51) {
			VinylPlay(snd_1up);
			give_lives(playerNum, x + 16, y - 128);
			//TODO: Reward the correct player, playerNum is aways 0
			reward = 0;
		}
	}
}