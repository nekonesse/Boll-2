event_inherited()
dy=0
hit=false;
image_speed=0;
spd=0
hit=0;
going=false;
eject=0;
dummyTimerReset = 4; //time (in frames) to hold on final "up" pos
dummyTimer = dummyTimerReset;
bumpMax = 10; //highest "up" pos for bumping
hitNegative = false; //used for the bumping "overshoot" anim end-bounce
no_hit = false;
default_depth = 4;
depth = default_depth;
amount=1; // the amount of items to hold
no_path_follow=false;
lose_amount=false;
eject_pause=30;

image_normal = sprite_index
image_hit = sprite_index
image_exausted = sprite_index

blockHit = new Signal();
blockBumpFinished = new Signal();
blockFinished = new Signal();

blockHit.Connect( self, function(hit_p, obj) {
	var _list, _num;
	
	if (going) {
		blockBumpFinished.Emit();
	}

	hit = hit_p;
	dy = -1 * hit;
	going = true;
	
	if (amount) {
		sprite_index = image_hit
	}
	
	if (lose_amount) {
		amount = max(amount - 1,0);
		if (amount == 0) {
			eject = 0;
		}
	}
	
	
	///Block bumping interactions
	if (hit==-1) {
		_list = ds_list_create();
	
		var coin = collision_rectangle(bbox_left,bbox_top-bumpMax,bbox_right-1,bbox_top, oCoin, false, true);
	
		if (coin) {
			global.coins_collected++;
			VinylPlay(snd_itemcoin);
			var i=instance_create_depth(coin.x,coin.y,0,pCoinCollected);
			i.vspeed=-3
			i.gravity=0.15*-sign(i.vspeed)
			instance_destroy(coin);
		}
	
		_num = check_rectangle_in_hitbox_list(bbox_left,bbox_top-bumpMax,bbox_right-1,bbox_top, oMushroom, _list);
	
		if (_num > 0) {
			var i=0;
		    repeat(_num) {
				var powerup = _list[| i];
				if (powerup.grounded) {
					powerup.vsp=-3;
					powerup.grounded=false;
				}
				i++;
		    }
		}

		ds_list_clear(_list);
	
		_num = check_rectangle_in_hitbox_list(bbox_left,bbox_top-bumpMax,bbox_right-1,bbox_top, oEnemy, _list);

		if (_num > 0) {
			var i=0;
		    repeat(_num) {
				var enemy = _list[| i];
				if (enemy.grounded) {
					enemy.hp -= 1;
					if (enemy.hp) {
						enemy.vsp=-3;
						enemy.grounded=false;
					}
					enemy.killtype="bump";
					enemy.xsc=sign(enemy.x-x) 
				}
				i++;
		    }
		}

		ds_list_destroy(_list);
	}
});