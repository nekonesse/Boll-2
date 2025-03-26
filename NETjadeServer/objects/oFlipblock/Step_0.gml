event_inherited()

var _plr_clipping =
    collision_rectangle(bbox_mem[0], bbox_mem[2], bbox_mem[1], bbox_mem[3], oPlayer, false, true);

if (flip_time > 50)
{
    if (!_plr_clipping)
    {
        flip_time = max(0, flip_time - 1);
    }
} else {
	hit = 0;
	no_hit = false
	no_collide = false
	image_speed = 0
	image_index = 0
}

if !(going)
image_speed = (abs(flip_time/300)*1.5);
//prevent overshooting