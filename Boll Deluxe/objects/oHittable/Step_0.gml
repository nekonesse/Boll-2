player=instance_place(x,y+1,oPlayer)
if player && ((!player.grounded && player.vsp > 0) || (player.jump))  { //temp state check
	event_user(0);
	oPlayer.vsp = 2;
	going = true;
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
			dy = 0;
			hit = 0;
			image_index = 1;
			hitNegative = false;
			dummyTimer = dummyTimerReset;
		}
	}
}