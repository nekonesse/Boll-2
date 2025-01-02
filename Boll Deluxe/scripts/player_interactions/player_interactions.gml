function player_interactions(){
	if (piped) exit
	
	var enemystomp=collision_line(x-hit_sizex,y+hit_sizey+1,x+hit_sizex,y+hit_sizey+1, oEnemy, false, true)
	if (enemystomp) && !grounded && vsp > 0 {
		if !(hurt) && !(dead) 
		enemystomp.enemyStomped.Emit(id);
	} else {
		var enemy=collision_point(x,y,oEnemy, false, true)
		if (enemy) && !(hurt) && !(dead)  {
			enemy.enemyCollidePlayer.Emit(id);
		}
	}
	
	var spring = collision_line(x-hit_sizex,y+hit_sizey,x+hit_sizex,y+hit_sizey, oTerrainSpring, false, true)
	if (spring) && !(hurt) && !(dead) {
		vsp=min(-spring.spring_power,vsp) //dont set vsp if it exceeds power
		grounded = false
		spring.image_speed=1
		sig.Emit("sprung")
		if (spring.object_index == oPollenFlower) {
			pollenated=true
			if !part_system_exists(pollenPart) {
				pollenPart=part_system_create(pPollenParticles);
				part_system_depth(pollenPart,-1)
				part_system_position(pollenPart,x+8,y+8)
				part_system_global_space(pollenPart,true)
			}
		}
	}
	
	var amp = collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oAmp, false, true)
	if (amp) && !(electrocuted) && !(hurt) && !(dead) {
		sig.Emit("electrocute");
	}
	
	var list=ds_list_create();
	var num=collision_line_list(x-(hit_sizex),y+hit_sizey+1,x+(hit_sizex),y+hit_sizey+1, oHittable, false, true, list, true)
	if (num > 0) {
		var totaldy=0;
		for (var i = 0; i < num; ++i) {
			var hittable=list[| i]
			if !(hurt) && !(dead)  {
				if(abs(hittable.dy) > abs(totaldy)) {
					totaldy=hittable.dy //get the greatest block's dy
				}
		
				if (hittable.object_index == oNoteBlock) {
					if !(hittable.do_bump) {
						hittable.blockHit.Emit(1, id);
						grounded=false;
						canstopjump = true
						vsp=-5-akey*1.5
					}
				}
			}
		}
		dy=totaldy
	} else dy=0
	
	#region Solid Spike Collision
	var spike=collision_line(x-hit_sizex,y+(hit_sizey-2)-vsp,x-hit_sizex,y-(hit_sizey-2)-vsp, oSolidSpike, false, true)
	if (spike) && (spike.dir="right" || spike.dir="none") {
		sig.Emit("hurt_by_spike")
	}
	
	var spike=collision_line(x+hit_sizex,y+(hit_sizey-2)-vsp,x+hit_sizex,y-(hit_sizey-2)-vsp, oSolidSpike, false, true)
	if (spike) && (spike.dir="left" || spike.dir="none") {
		sig.Emit("hurt_by_spike")
	}
	
	var spike=collision_line(x-hit_sizex-hsp,y+hit_sizey,x+hit_sizex-hsp,y+hit_sizey, oSolidSpike, false, true)
	if (spike) && (spike.dir="up" || spike.dir="none") {
		sig.Emit("hurt_by_spike")
	}
	
	var spike=collision_line(x-hit_sizex-hsp,y-hit_sizey,x+hit_sizex-hsp,y-hit_sizey, oSolidSpike, false, true)
	if (spike) && (spike.dir="down" || spike.dir="none") {
		sig.Emit("hurt_by_spike")
	}
	#endregion
	
	var chainsaw=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oChainsaw, false, true)
	if (chainsaw) {
		sig.Emit("hurt_by_spike")
	}
	
	var mysteryorb=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oMysteryOrb, false, true)
	if (mysteryorb) && !(finish) {
		instance_destroy(mysteryorb);
		finish=1;
	}
	
	var steely = collision_rectangle(x-hit_sizex,y-(hit_sizey-1),x+hit_sizex,y+(hit_sizey-1), oBigSteely, true, true)
	if (steely) && (abs(steely.hsp)>0) && !(hurt) && !(dead) {
		sig.Emit("hurt_by_spike");
	}
	
	var flagpole=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oFlagpole, false, true)
	if (flagpole) && !(finish) {
		if (flagpole.state == 0) {
			finish = 1;
			flagpole.state = 1;
			flagpole.player = self;
		}
	}
}