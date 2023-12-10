orbit_angle = -(wave_val(0,180,orbit_speed));

x = ((targetx) + lengthdir_x(orbit_length, orbit_angle));
y = ((targety) + lengthdir_y(orbit_length, orbit_angle));

x_diff = (x - xprevious);
y_diff = (y - yprevious);

var player = instance_place(x, y -1, oPlayer)
if (player && player.grounded)
{
	player.x += x_diff;
	player.y += y_diff;
	
}