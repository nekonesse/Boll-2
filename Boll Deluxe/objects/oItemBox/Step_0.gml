player=instance_place(x,y+1,oPlayer)
if player && ((!player.grounded && player.vsp > 0) || (player.jump)) { //temp state check
	if !(hitted) {
		event_user(0)
	}
	oPlayer.vsp = 2
	hitted = 1
	going = true;
}

if (hitted)
{
	sprite_index=spr_emptybox
	image_speed=0
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
				event_user(1);
				dy = 0;
				hit = 0;
				image_index = 1;
				hitNegative = false;
				dummyTimer = dummyTimerReset;
			}
		}
	}
}
else
{
sprite_index=spr_itembox
image_speed=1
}