/// @description Insert description here
// You can write your code in this editor

no_collide = false

with (oPlayer)
{
	if (grounded) && collision_line(x-hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),x+hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),other,false,true) {
		x += other.x_diff;
		y += other.y_diff;
	}
}

if (place_meeting(x, y-4, oEnemy))
{
	var object = instance_place(x, y-4, oEnemy)
	object.x += x_diff;
	object.y += y_diff;
}