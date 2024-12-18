if (eject == 0 && eject_pause) {
	eject_pause--;
	exit;
}
///HIT IS DIRECTION OF BUMP, -1 IS UP, 1 IS DOWN
if (hit != 0)
{
	if (eject != 0) {
		eject = hit;
	}
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
			blockBumpFinished.Emit();
			if (lose_amount) {
				amount = max(amount - 1,0);
				if (amount == 0) {
					eject = 0;
				}
			}
			if (!(amount) || !(lose_amount)) && (eject == 0) {
				blockFinished.Emit();
			} else {
				sprite_index = image_normal;	
			}
			dy = 0;
			hit = eject;
			hitNegative = false;
			dummyTimer = dummyTimerReset;
			if (eject != 0) {
				eject_pause = 30;
				going = true;
			}
		}
		depth=default_depth;
	}
}