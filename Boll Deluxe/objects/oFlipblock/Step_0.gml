// THIS JUST DOESNT WORK HALF THE TIME GRR!!
player = instance_place(x, y + 1, oPlayer);

// temp state check
if ((hit == 0) && (player) && ((!player.grounded && player.vsp > 0) || (player.jump)) &&
    (!place_meeting(x + 1, y, player)) && (!place_meeting(x - 1, y, player)))
{
    event_user(0);
    flip_time = 300;
    player.vsp = 2;
}

image_speed = abs(hit);

if (hit != 0)
{
	if !(stop_bump) {
		dy = abs(wave_val(0,16,0.25))
		if (round(dy)>=2) going = 1;
		if (round(dy)==0) && (going) {
			going = 0;
			stop_bump = 1;
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