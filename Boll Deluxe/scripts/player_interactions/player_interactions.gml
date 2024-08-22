function player_interactions(){
	var enemy=collision_line(x-hit_sizex,y+hit_sizey+1,x+hit_sizex,y+hit_sizey+1, oEnemy, false, true)
	if (enemy) {
	
	}
	var spring = collision_line(x-hit_sizex,y+hit_sizey+1,x+hit_sizex,y+hit_sizey+1, oTerrainSpring, false, true)
	if (spring && vsp > 0) {
		vsp=min(-spring.spring_power,vsp) //dont set vsp if it exceeds power
		grounded = false
		spring.image_speed=1
		sig.Emit("sprung")
	}
}