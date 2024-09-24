///@description Electrocute Player
for(var i = 0, len = array_length(connections); i < len; i++;) {
	var px1 = connections[i][0]
	var py1	= connections[i][1]
	var px2 = connections[i][2]
	var py2 = connections[i][3]
	var plr=collision_line(px1,py1,px2,py2,oPlayer,false,true)
	if (plr) {
		with (plr) {
			if !(electrocuted) && !(hurt) && !(dead)
			sig.Emit("electrocute");
		}
	}
}