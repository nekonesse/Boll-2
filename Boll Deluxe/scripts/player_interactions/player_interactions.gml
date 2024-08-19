function player_interactions(){
	//var spring=check_collision_line(x-hit_sizex,y+hit_sizey+vsp+1,x+hit_sizex,y+hit_sizey+vsp+1, COL_BOTTOM, oTerrainSpring)
	//if (spring & grounded) {
	//	vsp=min(-spring.spring_power,vsp) //dont set vsp if it exceeds power
	//	//grounded = false
	//	spring.image_speed=1
	//	sig.Emit("sprung")
	//}
	
	//var enemy=check_collision_line(x-hit_sizex,y+hit_sizey+vsp+1,x+hit_sizex,y+hit_sizey+vsp+1, COL_BOTTOM, oEnemy)
	//if (enemy) {
	//	vsp=min(-spring.spring_power,vsp) //dont set vsp if it exceeds power
	//	spring.image_speed=1
	//	sig.Emit("sprung")
	//}
	var spring = collision_line(x-hit_sizex,y+hit_sizey+1,x+hit_sizex,y+hit_sizey+1, oTerrainSpring, false, true)
	if (spring) {
		vsp=min(-spring.spring_power,vsp) //dont set vsp if it exceeds power
		grounded = false
		spring.image_speed=1
		sig.Emit("sprung")
	}
}