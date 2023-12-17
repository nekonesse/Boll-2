orbit_angle = -(wave_val(0,180,orbit_speed));

x = ((targetx) + lengthdir_x(orbit_length, orbit_angle));
y = ((targety) + lengthdir_y(orbit_length, orbit_angle));

x_diff = (x - xprevious);
y_diff = (y - yprevious);

if x>xprevious
dir=1;
else if x<xprevious
dir=-1;

if y>xprevious
ydir=1;
else if y<xprevious
ydir=-1;

var player = oPlayer
if (player && place_meeting(x, y-4, oPlayer))
{
	var collider=collision_rectangle((player.x)+8*dir,player.bbox_bottom,(player.x)+(8+x_diff)*dir,player.bbox_top,oCollider,false,true)
	if (!collider) {
		player.x += x_diff;
	}
	//optimize this into 1 thing later im lazy lol
	if (ydir) {
		var collider=collision_rectangle(player.bbox_left,player.y,player.bbox_right,player.y+y_diff,oCollider,false,true)
	} else { 
		var collider=collision_rectangle(player.bbox_left,player.y-16,player.bbox_right,player.y-(16+y_diff),oCollider,false,true)
	}
	if (!collider) {
		player.y += y_diff;
	}
	
}

if (place_meeting(x, y-4, oEnemy))
{
	var object = instance_place(x, y-4, oEnemy)
	object.x += x_diff;
	object.y += y_diff;
	
}