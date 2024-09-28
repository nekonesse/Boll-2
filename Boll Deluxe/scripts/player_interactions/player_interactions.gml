function player_interactions(){
	if (piped) exit
	
	var enemystomp=collision_line(x-hit_sizex,y+hit_sizey+1,x+hit_sizex,y+hit_sizey+1, oEnemy, false, true)
	if (enemystomp) && !grounded && vsp > 0 {
		if !hurt
		enemystomp.enemyStomped.Emit(id);
	} else {
		var enemy=collision_point(x,y,oEnemy, false, true)
		if (enemy) && !hurt {
			enemy.enemyCollidePlayer.Emit(id);
		}
	}
	
	var spring = collision_line(x-hit_sizex,y+hit_sizey,x+hit_sizex,y+hit_sizey, oTerrainSpring, false, true)
	if (spring) {
		vsp=min(-spring.spring_power,vsp) //dont set vsp if it exceeds power
		grounded = false
		spring.image_speed=1
		sig.Emit("sprung")
	}
	
	var amp = collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oAmp, false, true)
	if (amp) && !(electrocuted) && !(hurt) && !(dead) {
		sig.Emit("electrocute");
	}
}