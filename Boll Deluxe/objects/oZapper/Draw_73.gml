var i=0;
var len=array_length(connections);
repeat(len) { 
	if is_array(connections[i]) {
		var x1=connections[i][0]
		var x2=connections[i][2]
		var y1=connections[i][1]
		var y2=connections[i][3]
		draw_sprite_ext(spr_electriccurrent,(global.roomTimer/4) mod 3,x1,y1,point_distance(x1,y1,x2,y2)/sprite_get_width(spr_electriccurrent),1,point_direction(x1,y1,x2,y2),c_white,1)
	}
	i++;
}