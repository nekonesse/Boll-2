if array_length(connections) {
	fr+=0.125;
	if fr>=sprite_get_number(spr_current) fr=0;
} else fr=0;

for(var i = 0, len = array_length(connections); i < len; i++;) { 
	draw_sprite_ext(spr_current,fr,connections[i][0],connections[i][1],point_distance(connections[i][0],connections[i][1],connections[i][2],connections[i][3])/sprite_get_width(spr_current),1,point_direction(connections[i][0],connections[i][1],connections[i][2],connections[i][3]),c_white,1)
}