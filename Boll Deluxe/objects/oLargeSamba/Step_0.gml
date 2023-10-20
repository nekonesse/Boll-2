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
	image_angle+=-lookdir*2
	r=degtorad(image_angle)*2.5
	sr=sin(r)
	yy=(-sr)*lookdir
	y+=yy
	x+=lookdir*2
}