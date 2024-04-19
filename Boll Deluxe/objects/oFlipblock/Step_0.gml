// THIS JUST DOESNT WORK HALF THE TIME GRR!!
player = instance_place(x, y + 1, oPlayer);

// temp state check
if ((hit == 0) && (player) && ((!player.grounded && player.vsp > 0) || (player.jump))){
    event_user(0);
    flip_time = 300;
    player.vsp = 2;
	going = true
}

image_speed = abs(hit);

if (hit != 0)
{
	if !(stop_bump)
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
				stop_bump = 1;
				hitNegative = false;
				dummyTimer = dummyTimerReset;
			}
		}
	}
	no_collide = true;
}
else if ((hit == 0) && (!place_meeting(x, y, oPlayer)))
{
	no_collide = false;
    image_index = 0;
}

var _plr_clipping =
    collision_rectangle(bbox_mem[0], bbox_mem[2], bbox_mem[1], bbox_mem[3], oPlayer, false, true);

if (flip_time)
{
    if (!_plr_clipping)
    {
        flip_time = max(0, flip_time - 1);

        if !(flip_time) {
			hit = 0;
			stop_bump = 0;
		}
    }
}