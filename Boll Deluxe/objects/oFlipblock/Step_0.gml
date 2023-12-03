// THIS JUST DOESNT WORK HALF THE TIME GRR!!
player = instance_place(x, y + 1, oPlayer);

// temp state check
if ((hit == 0) && (player) && ((!player.grounded && player.vsp > 0) || (player.jump)) &&
    (!place_meeting(x + 1, y, player)) && (!place_meeting(x - 1, y, player)))
{
    hit = 1;
    flip_time = 300;
    player.vsp = 2;
}

image_speed = hit;

if (hit != 0)
{
    //mask_index = spr_empty;
	no_collide = true;
}
else if ((hit == 0) && (!place_meeting(x, y, oPlayer)))
{
    //mask_index = sprite_index;
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

        if (flip_time == 0)
            hit = 0;
    }
}