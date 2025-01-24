with(oPlayer) {
	var platform=collision_rectangle(x-hit_sizex+other.x_diff,y-hit_sizey+abs(other.y_diff),x+hit_sizex+other.x_diff,y+hit_sizey+2+abs(other.y_diff),oSwingingPlatform,false,true)
	if (platform) && (platform.id==other.id) && (grounded) {
		x += other.x_diff;
		y += other.y_diff;
	}
}

if (place_meeting(x, y-2-abs(y_diff), oEnemy))
{
	var object = instance_place(x, y-2-abs(y_diff), oEnemy)
	object.x += x_diff;
	object.y += y_diff;
}