/*player=collision_rectangle(bbox_left+2,bbox_bottom-1,bbox_right-2,bbox_bottom+2,oPlayer,false,true)
if player && ((!player.grounded && player.vsp < 0) || (player.jump)) && !no_hit { //temp state check
	blockHit.Emit(-1, player)
}*/

///HIT IS DIRECTION OF BUMP, -1 IS UP, 1 IS DOWN
if (hit != 0)
{
	if going {
		if dummyTimer > 0 {
			dy = approach_val(dy, bumpMax * -hit, 2);
			var doneCheck = (hit == -1 ? (round(dy) >= bumpMax) : (round(dy) <= -bumpMax))
			if doneCheck {
				dummyTimer--;
				if dummyTimer <= 0 {
					going = false;
				}
			}
		}
		depth=default_depth-10;
	} else {
		if !hitNegative {
			dy = approach_val(dy, -1 * -hit, 2);
			var doneCheck = (hit == -1 ? round(dy) <= -1 : round(dy) >= 1)
			if doneCheck
				hitNegative = true;
		} else {
			amount--;
			if !(amount) {
				blockFinished.Emit();
			} else {
				sprite_index = image_normal;	
			}
			dy = 0;
			hit = 0;
			//image_index = 1;
			hitNegative = false;
			dummyTimer = dummyTimerReset;
		}
		depth=default_depth;
	}
}