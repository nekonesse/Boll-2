/// @description Insert description here
// You can write your code in this editor




with (oPlayer)
{
	if (grounded && 
	collision_line(bbox_left, bbox_bottom + 3, bbox_right, bbox_bottom + 3, other, false, true) )
	{
		x += other.x_diff;
		y += other.y_diff;
	
	}
}