/// \file  scr_fx.gml
/// \brief Handling of visual effects and shaders.

// thinker function for "1UP!" text
function fx_1up_thinker(obj)
{
    var y_update_speeds = [ 0.25, 0.25, 0.5, 1, 1, 1, 1, 1 ];

    var timer_prev;
    var player_dead = false, disable_fx = false;

    if ((disable_fx) || (player_dead))
    {
        return;
    }
    else
    {
        timer_prev = obj.timer;
        if (timer_prev == 0)
        {
            instance_destroy(obj);
        }
        else
        {
            obj.timer = (timer_prev - 1);

            // timer's divided by 16 here
            var moveval = (y_update_speeds[obj.timer >> 4]);

            if (obj.y > 3)
                obj.y -= moveval;

            if (obj.timer == 4)
                instance_create_depth(
                    x - sprite_xoffset, y - sprite_yoffset, depth - 1, pSparkles1UP);
        }
    }
}

// drawer function, scales the sprite based on a timer variable
function draw_1up_text(obj, spr = spr_p1UP)
{
    var scale_factor;              // factor that's subtracted from the final scale value
    var scale_final = 512;         // final scaling
    var scaling_sub = 0x00F00000;  // AKA 15728640, but that doesn't look as nice
    var in_view;                   // what it says on the tin

    with(obj)
    {
        in_view = on_screen_xy()
    }

    if (in_view)
    {
        // when less than 5 tics are left on the timer, the sprite's frame becomes a golden flash
        if (obj.timer < 5)
            obj.sprimage = 1;
        else
            obj.sprimage = 0;

        // manic scaling magic; don't ask me how this works, it just does
        if (obj.timer < 32)
            scale_factor = 256;
        else if (obj.timer < 49)
            scale_factor = (((obj.timer * 0x100000 - scaling_sub >> 16) & 0xFFFFFFFF) & 0xFFFF);
        else
            scale_factor = 512;

        scale_final -= (scale_factor - 256);

        // divide to make a decimal value
        scale_final /= 512;

        // draw the effect
        draw_sprite_ext(spr,
                        obj.sprimage,
                        x div 1,
                        y div 1,
                        scale_final,
                        scale_final,
                        0,
                        obj.image_blend,
                        obj.image_alpha);
    }
}

// drawer (and thinker) for 1up sparkles
function fx_1up_sparkles(obj, spr = spr_pSparkles1UP)
{
    // tempvar setup
    var vis_x, vis_y;               // integer versions of the effect object's actual position
    var draw_x, draw_y, drawframe;  // the positions and animation frame of each sparkle
    var idx;                        // where an array is indexed
    var manip_time;                 // slightly altered timer value, mainly for drawframe

    var sparkle_timeroffset = [ 18, 16, 14, 12, 10, 0 ];
    var sparkle_posoffset = [ 4, 8, 12, 0, 22, 6, 8, 4, 24, -2 ];
    var sparkle_frames = [ 4, 3, 2, 1, 0 ];

    var in_view;  // self-explanatory: boolean for if the effect object is in the viewport

    // chearii: change this to actually handle player death stuff at some point
    var player_dead = false;

    // hack for in_view
    with(obj)
    {
        in_view = on_screen_xy()
    }

    // init draw vals
    draw_x = 0;
    draw_y = 0;
    drawframe = 0;

    // get vis coords
    vis_x = obj.x div 1;
    vis_y = obj.y div 1;

    if (obj.timer == 0)  // if time's up, we go bye bye
    {
        instance_destroy(obj);
        return;
    }
    else
    {
        if (!in_view)  // not in the view? not here anymore!
        {
            instance_destroy(obj);
            return;
        }

        if (!player_dead)  // if the player isn't dead, keep decrementing the timer
            obj.timer--;
    }

    // spawn at least 5 sparkles
	var i=4;
    repeat (4)
    {
        idx = (i & 0xff);
        manip_time = (obj.timer - (sparkle_timeroffset[idx] & 0xFF)) + 10;

        if ((manip_time & 0xff) < 10)  // only do this if manip_time is below 10 tics
        {
            // get the sparkle's X position
            draw_x = sparkle_posoffset[idx * 2] + vis_x;

            // and the Y position
            draw_y = sparkle_posoffset[idx * 2 + 1] + vis_y;

            // and the animation frame
            drawframe = sparkle_frames[(manip_time * 0x1000000 >> 25)];

            // and now to draw the sprite
            draw_sprite(spr, drawframe, draw_x, draw_y);
		}
		i--;
    }
}