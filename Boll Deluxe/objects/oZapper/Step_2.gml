///@description Electrocute Player
var i=0;
var len = array_length(connections)
repeat(len) {
	var px1 = connections[i][0]
	var py1	= connections[i][1]
	var px2 = connections[i][2]
	var py2 = connections[i][3]
	with(oPlayer) {
		if lines_intersect(px1,py1,px2,py2,x-hit_sizex,y+hit_sizey,x+hit_sizex,y+hit_sizey,true) || 
		   lines_intersect(px1,py1,px2,py2,x-hit_sizex,y-hit_sizey,x+hit_sizex,y-hit_sizey,true) || 
		   lines_intersect(px1,py1,px2,py2,x-hit_sizex,y-hit_sizey,x-hit_sizex,y+hit_sizey,true) || 
		   lines_intersect(px1,py1,px2,py2,x+hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,true) {
			if !(electrocuted) && !(hurt) && !(dead)
			sig.Emit("electrocute");
		}
	}
	i++;
}