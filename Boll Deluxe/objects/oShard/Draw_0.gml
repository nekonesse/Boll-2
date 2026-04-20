draw_self();

//var tri_angle = (360 / 3), color = #FF00FF,
//point = [
//	[x + ( dcos((tri_angle    ) + draw_angle) *-dsin(other_angle) * 20) ,y + (-dsin((tri_angle    ) + draw_angle) * dcos(other_angle) * 20) + (dsin(global.roomTimer + offset) * 4)] , 
//	[x + ( dcos((tri_angle * 2) + draw_angle) *-dsin(other_angle) * 20) ,y + (-dsin((tri_angle * 2) + draw_angle) * dcos(other_angle) * 20) + (dsin(global.roomTimer + offset) * 4)] , 
//	[x + ( dcos((tri_angle * 3) + draw_angle) *-dsin(other_angle) * 20) ,y + (-dsin((tri_angle * 3) + draw_angle) * dcos(other_angle) * 20) + (dsin(global.roomTimer + offset) * 4)]
//];

//draw_circle_color(x,y,24 + (dsin(global.roomTimer) * 4), #FFFFFF, #FFFFFF, true);

//draw_triangle_color(
//	point[0][0],
//	point[0][1],
//	point[1][0],
//	point[1][1],
//	point[2][0],
//	point[2][1],
	
//	image_blend, 
//	image_blend, 
//	image_blend, 
//	false
//);

////triangle outline so both angles dont cancel eachother out and make it invisible for a few frames
//draw_line_colour(point[0][0], point[0][1], point[1][0], point[1][1], image_blend, image_blend);
//draw_line_colour(point[2][0], point[2][1], point[1][0], point[1][1], image_blend, image_blend);
//draw_line_colour(point[0][0], point[0][1], point[2][0], point[2][1], image_blend, image_blend);