/// @description Insert description here
// You can write your code in this editor


coll=instance_place(x,y-2-abs(y_diff),oPlayer);

if (coll) && (coll.grounded) {
	coll.x += x_diff;
	coll.y += y_diff;
}


if (place_meeting(x, y-2-abs(y_diff), oEnemy))
{
	var object = instance_place(x, y-2-abs(y_diff), oEnemy)
	object.x += x_diff;
	object.y += y_diff;
}