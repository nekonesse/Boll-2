/// @description Insert description here
// You can write your code in this editor

no_collide = false

if (place_meeting(x, y-4, oEnemy))
{
	var object = instance_place(x, y-4, oEnemy)
	object.x += x_diff;
	object.y += y_diff;
}