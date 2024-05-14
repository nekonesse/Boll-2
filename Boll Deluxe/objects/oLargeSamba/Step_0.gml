sprite_set_offset(sprite_index,sprite_width/2,sprite_height/2)

image_angle=wrap_val(image_angle,0,360)

player=instance_nearest(x,y,oPlayer)
if distance_to_point(player.x,player.y) < 96 {
	start_going=1
	lookdir=(player.x > x) ? 1 : -1;
}
else
{
image_angle=approach_val(image_angle, floor(image_angle/90)*90,2)
yy=approach_val(yy,0,1)
start_going=0
lookdir=0
}

if (start_going)
{
	var freq=60;
	t += freq / room_speed //change speed based on t, not in the function. you don't have to always add 1

	var b = t mod 90
	y = max(sqrt(2)*half_side_length*dcos(b)+y_start, sqrt(2)*half_side_length*dcos(b-90)+y_start )
	image_angle = t;
}