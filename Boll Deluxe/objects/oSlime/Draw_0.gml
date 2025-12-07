// don't bother rendering if we're not active
if (!(active && ready))
{
	exit;	
}

if (global.debug)
{
	//draw_circle(x,y,8,true);
	
	//draw_circle_color(x - (morph.vis_width div 2), y, 8, c_red, c_red, true);
	//draw_circle_color(x + (morph.vis_width div 2), y, 8, c_red, c_red, true);
	//draw_circle_color(x,y - morph.vis_height,8,c_blue,c_blue,true);
	
	// draw the actual sprite bounds
	draw_rectangle_color(x - (morph.vis_width div 2),
						 y - morph.vis_height,
						 x + (morph.vis_width div 2),
						 y,
						 c_purple,
						 c_purple,
						 c_purple,
						 c_purple,
						 true);
						 
	draw_text(x,y,colactive)
						 

}

// only do eye logic if we have to
if (eyes_visible)
{
	var eyeposy=y-16
	var eyeposx=x
	var nearplayer=instance_nearest(x,y,oPlayer)

	if instance_exists(oPlayer) {
		var eyetargetx=lengthdir_x(24,point_direction(eyeposx,eyeposy,nearplayer.x,nearplayer.y))
		var eyetargety=lengthdir_y(12,point_direction(eyeposx,eyeposy,nearplayer.x,nearplayer.y))
	} else {
		var eyetargetx=0
		var eyetargety=0
	}

	eyedestx=lerp(eyedestx,eyetargetx,0.05)
	eyedesty=lerp(eyedesty,eyetargety,0.05)

	var eye_scale = int64((morph_scale / 65535) * 16);
	var eye_scale_h = eye_scale div 2;

	var eyelocx=median(-eye_scale,floor(eyedestx),eye_scale)
	var eyelocy=median(-eye_scale_h,floor(eyedesty),eye_scale_h)

	draw_sprite(
		spr_slime_eye,eye_frame,
		floor(eyeposx+eyexpos+eyelocx-6),
		floor(eyeposy+morph.vis_y+eyelocy)
	);
	draw_sprite(
		spr_slime_eye,eye_frame,
		floor(eyeposx+eyexpos+eyelocx+2),
		floor(eyeposy+morph.vis_y+eyelocy)
	);
}

if (global.debug)
{
	var line;
	if (array_length(morph.debug_col) > 0)
	{
		var len = array_length(morph.debug_col);
		
		var i=0;
		repeat (len)
		{
			if (!is_array(morph.debug_col[i]))
			{
				continue;	
			}
			
			line = morph.debug_col[i];
			
			draw_line(line[0], global.camera_y + line[1], line[2], global.camera_y + line[1]);
			i++;
		}
	}
	
	// cost estimator
	draw_set_color(c_red);
	draw_text(x,y-128,$"(cost)\nthinker: {max(0, cur_delta - last_delta) / 1000}ms ({(max(0, cur_delta - last_delta)) / delta_time * 100}%)");
	draw_set_color(c_white);	
}