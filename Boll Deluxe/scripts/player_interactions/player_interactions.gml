function player_interactions(){
	var spring=check_collision_line(x-hit_sizex,y+hit_sizey+vsp+1,x+hit_sizex,y+hit_sizey+vsp+1, COL_BOTTOM, oTerrainSpring)
	if (spring) {
		vsp=min(-spring.spring_power,vsp) //dont set vsp if it exceeds power
		spring.image_speed=1
		sig.Emit("sprung")
	}
}