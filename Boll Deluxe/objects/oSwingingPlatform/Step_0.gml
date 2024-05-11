orbit_angle = -(wave_val(0,180,orbit_speed));


var oldx, oldy

oldx = floor(newx)
oldy = floor(newy)

newx = (targetx) + (orbit_length * dcos(orbit_angle));
newy = (targety)- (orbit_length * dsin(orbit_angle));

x = floor(newx)
y = floor(newy)

if x>xprevious
dir=1;
else if x<xprevious
dir=-1;

if y>xprevious
ydir=1;
else if y<xprevious
ydir=-1;


x_diff = (x - oldx);
y_diff = (y - oldy);

if (place_meeting(x, y-4, oEnemy))
{
	var object = instance_place(x, y-4, oEnemy)
	object.x += x_diff;
	object.y += y_diff;
	
}