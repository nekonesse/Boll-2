player=instance_place(x,y+2,oPlayer)
if player && ((!player.grounded && player.vsp < 0) || (player.jump)) && !no_hit { //temp state check
	blockHit.Emit(-1, player)
}

///HIT IS DIRECTION OF BUMP, -1 IS UP, 1 IS DOWN
if (hit != 0)
{
	if going {
		if dummyTimer > 0 {
			dy = approach_val(dy, bumpMax * -hit, 1.5);
			var doneCheck = (hit == -1 ? (round(dy) >= bumpMax) : (round(dy) <= -bumpMax))
			if doneCheck {
				dummyTimer--;
				if dummyTimer <= 0 {
					going = false;
				}
			}
		}
	} else {
		if !hitNegative {
			dy = approach_val(dy, -1 * -hit, 2);
			var doneCheck = (hit == -1 ? round(dy) <= -1 : round(dy) >= 1)
			if doneCheck
				hitNegative = true;
		} else {
			blockFinished.Emit()
			dy = 0;
			hit = 0;
			image_index = 1;
			hitNegative = false;
			dummyTimer = dummyTimerReset;
		}
	}
}