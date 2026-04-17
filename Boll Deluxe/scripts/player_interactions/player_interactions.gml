function player_interactions(){
	if (piped) || (hurt) || (dead)  exit
	
	switch(state) {
		case "boarding":
		case "frozen":
			var enemy=check_hitbox_on_hitbox(id, oEnemy)
			if (enemy) && (enemy.phaseid==noone || enemy.phaseid.id!=id) {
				if !(enemy.unshellable) {
					enemy.enemyRolledInto.Emit(id);
				}
			}
		break;
		default:
			var enemystomp=check_rectangle_in_hitbox(x-hit_sizex,y+hit_sizey+vsp,x+hit_sizex,y+hit_sizey+vsp, oEnemy)
			if (enemystomp) && (enemystomp.phaseid==noone || enemystomp.phaseid.id!=id) && !(enemystomp.damage_on_contact) && !(enemystomp.no_stomping) && !(enemystomp.grabbed) && !(grounded) && (vsp > 0) && (can_stomp) && (y+hit_sizey+vsp < enemystomp.y) && (invincible_type != 2) {
				enemystomp.enemyStomped.Emit(id);
				enemystomp.phaseid=id;
				enemystomp.phase_leeway=3;
			} else {
				var enemy=check_hitbox_on_hitbox(id, oEnemy)
				if (enemy) {
					if (enemy.phaseid==noone || enemy.phaseid.id!=id) && !(enemy.grabbed) && !(can_grab && enemy.can_grab && bkey && !is_grabbing) {
						if (invincible_type != 2) {
							enemy.enemyCollidePlayer.Emit(id);
						} else {
							make_particle(pImpact,enemy.x+enemy.xsc,enemy.y,2)
							increase_combo(enemy.x,enemy.y);
							enemy.phaseid = id;
							enemy.phase_leeway = 15;
							with(enemy) {
								hp=0
							}
						}
					}
				}
			}
		break;
	}
	
	var spring = collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oTerrainSpring, false, true)
	if (spring) && !(hurt) && !(dead) && !(sprung)  {
		switch(spring.image_angle) {
			case 0:
			vsp=min(-spring.spring_power,vsp) //dont set vsp if it exceeds power
			grounded = false
			sig.Emit("sprung_up")
			break;
			
			case 180:
			vsp=max(spring.spring_power,vsp)
			sig.Emit("sprung_down")
			break;
			
			case 90:
			hsp=min(-spring.spring_power,hsp)
			if (grounded) gsp=hsp
			
			if (state!="frozen")
			xsc = -1
			
			sig.Emit("sprung_side")
			break;
			
			case 270:
			hsp=max(spring.spring_power,hsp)
			if (grounded) gsp=hsp
			
			if (state!="frozen")
			xsc = 1
			
			sig.Emit("sprung_side")
			break;
		}
		spring.image_speed=1
		spring.image_index=1;
		if (spring.object_index == oPollenFlower) {
			pollenated=true
			if !part_system_exists(pollenPart) {
				pollenPart=part_system_create(pPollenParticles);
				part_system_depth(pollenPart,-1)
				part_system_position(pollenPart,x+8,y+8)
				part_system_global_space(pollenPart,true)
			}
		} else {
			VinylPlay(snd_terrainspring)
		}
		sprung=5;
	}
	
	sprung = max(sprung-1,0);
	
	var amp = collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oAmp, false, true)
	if (amp) && !(electrocuted) && !(hurt) && !(dead) {
		if !(invincible_type && invincible_timer) {
			sig.Emit("electrocute");
		}
	}
	
	var list=ds_list_create();
	var num=collision_line_list(x-(hit_sizex),y+hit_sizey+1,x+(hit_sizex),y+hit_sizey+1, oHittable, false, true, list, true)
	if (num > 0) {
		var totaldy=0;
		var i=0;
		repeat (num) {
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
			i++;
		}
		dy=totaldy
	} else dy=0
	
	ds_list_destroy(list);
	
	#region Solid Spike Collision
	var spike=collision_line(x-hit_sizex+hsp,y-hit_sizey+2,x-hit_sizex+hsp,y+hit_sizey-abs(vsp), oSolidSpike, false, true)
	if (spike) && (spike.dir="right" || spike.dir="none") && !(hurt) {
		if !(invincible_type && invincible_timer) {
			sig.Emit("hurt_by_spike")
		}
	}
	
	var spike=collision_line(x+hit_sizex+hsp,y-hit_sizey+2,x+hit_sizex+hsp,y+hit_sizey-abs(vsp), oSolidSpike, false, true)
	if (spike) && (spike.dir="left" || spike.dir="none") && !(hurt) {
		if !(invincible_type && invincible_timer) {
			sig.Emit("hurt_by_spike")
		}
	}
	
	var spike=collision_line(x-hit_sizex-1,y+hit_sizey+1,x+hit_sizex-1,y+hit_sizey+1, oSolidSpike, false, true)
	if (spike) && (spike.dir="up" || spike.dir="none") && !(hurt) {
		if !(invincible_type && invincible_timer) {
			sig.Emit("hurt_by_spike")
		}
	}
	
	var spike=collision_line(x-hit_sizex-1,y-hit_sizey+vsp,x+hit_sizex-1,y-hit_sizey+vsp, oSolidSpike, false, true)
	if (spike) && (spike.dir="down" || spike.dir="none") && !(hurt) {
		if !(invincible_type && invincible_timer) {
			sig.Emit("hurt_by_spike")
		}
	}
	#endregion
	
	var chainsaw=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oChainsaw, false, true)
	if (chainsaw) && !(hurt) {
		if !(invincible_type && invincible_timer) {
			sig.Emit("hurt_by_spike")
		}
	}
	
	var mysteryorb=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oMysteryOrb, false, true)
	if (mysteryorb) && !(finish) {
		instance_destroy(mysteryorb);
		finish=1;
	}
	
	var steely = collision_rectangle(x-hit_sizex,y-(hit_sizey-1),x+hit_sizex,y+(hit_sizey-1), oBigSteely, true, true)
	if (steely) && !(hurt) && !(dead) {
		if !(invincible_type && invincible_timer) {
			sig.Emit("hurt_by_spike");
		}
	}
	
	var flagpole=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oFlagpole, false, true)
	if (flagpole) && !(finish) && !(dead) {
		if (flagpole.state == 0) {
			finish = 1;
			flagpole.state = 1;
			flagpole.player = id;
		}
	}
	
	var bearballoon=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oPolarBearBalloon, false, true)
	if (bearballoon) && !(hurt) && !(dead) {
		if vsp >= 0 vsp=-(2.5+akey*1.5);
		sig.Emit("sprung");
		instance_create_depth(bearballoon.x,bearballoon.y,-5,pImpact)
		instance_destroy(bearballoon);
	}
	
	var crate=collision_line(x-(hit_sizex-1)-hsp,y+hit_sizey+vsp,x+(hit_sizex-1)-hsp,y+hit_sizey+vsp, oCrate, false, true) 
	if (crate) && (vsp>=0) && !(hurt) && !(dead) {
		vsp = -(2.5+akey*1.5);
		sig.Emit("sprung");
		crate.blockHit.Emit(-1, id);
	}
	
	var coin=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oCoin, false, true)
	if (coin) && !(hurt) && !(dead) {
		collect_coins(1);
		instance_create_depth(coin.x,coin.y,0,pGlitter);
		instance_destroy(coin);
	}
	
	var dotcoin=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oDottedCoin, false, true)
	if (dotcoin) && !(hurt) && !(dead) {
		with(dotcoin) {
			if !triggered
			event_user(0);
		}
	}
	
	var item=check_hitbox_on_hitbox(id, oMushroom)
	if (item) && !(hurt) && !(dead) && (item.phaseid!=id) {
		item.itemCollected.Emit(id);
	}
	
	var icicle=collision_rectangle(x-hit_sizex+hsp,y-hit_sizey,x+hit_sizex+hsp,y+hit_sizey-2-max(0,vsp),oIcicle,true,true)
	if (icicle) && !(icicle.no_collide) && !(hurt) && !(dead) {
		if !(invincible_type && invincible_timer) && (state != "frozen") {
			sig.Emit("hurt_by_spike")
		}
		
		if !(icicle.can_fall) && (invincible_type != 1) || (invincible_type == 2) || (state == "frozen") {
			with(icicle) {
				breakIcicle();
			}
		}
	}
	
	if (collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,oSnowboardGiver,false,true)) && (state != "boarding") {
		state = "boarding";
		sig.Emit("start_boarding");
		if (is_grabbing) {
			up=false;
			down=true;
			instance_destroy(grabbed_obj);
			grabbed_obj = noone;
			is_grabbing = false;
		}
		while (check_collision_line(x-hit_sizex,y+hit_sizey,x+hit_sizex,y+hit_sizey,COL_BOTTOM)) {
			y-=1
		}
		hsp = 0;
		vsp = 0;
	}
}