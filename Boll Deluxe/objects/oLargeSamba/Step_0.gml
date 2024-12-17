sprite_set_offset(sprite_index,sprite_width/2,sprite_height/2)

image_angle = wrap_val(image_angle,0,360)

player = instance_nearest(x,y,oPlayer)
if distance_to_point(player.x,player.y) < 96 {
	if (start_going == 0) {
		image_angle = angle_buffer
		t = (image_angle div 90) * 90
	}
	start_going = 1
	lookdir = (player.x > x) ? 1 : -1;
} else {
	if (start_going) {
		angle_buffer = image_angle
	}
	image_angle = approach_val(image_angle, floor(image_angle/90)*90,2)
	yy = approach_val(yy,0,1)
	start_going = 0
	lookdir = 0
}

if (start_going)
{
	t += 1 //room_speed 
	//change speed based on t, not in the function. you don't have to always add 1

	image_angle = t;
}

image_angle = image_angle mod 360
gfx_y = dsin(image_angle*2) * 12;
gfx_y *= -sign(gfx_y);