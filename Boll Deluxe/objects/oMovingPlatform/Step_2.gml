/// @description Insert description here
// You can write your code in this editor

no_collide = false

with (oPlayer)
{
	var diff = y - yprevious
	if !grounded && (diff < 0 ) {
		other.no_collide = true
	}
	
	if (grounded && 
	collision_line(bbox_left, bbox_bottom + 2, bbox_right, bbox_bottom + 2, other, false, true) )
	{
		x += other.x_diff;
		y = other.y-(bbox_bottom - bbox_top) -4;
	
	}
}