if global.paused exit

no_dam = false

if (in_shell) {
	if !(shell_move) {
		can_grab = true;
		in_shell--; //Decreases the time for the koopa to get up
		if !(in_shell) {
			image_index=0;
			getup_timer = getup_timer_max;
			no_stomping = false;
			if (grabbed) {
				if instance_exists(carry_player) {
					x=carry_player.x;
					with(carry_player) {
						grabbed_obj = noone;
						is_grabbing = false;
					}
				}
				grabbed=false;
				carry_player = noone;
				phaseid = noone;
				phase_leeway = 0;
				no_dam = false;
			}
			can_grab = false;
		} else {
			no_dam = true;
		}
	} else {
		can_grab = false;
		var blocklist=ds_list_create();
		var num=collision_line_list(x+(hit_sizex*_direction)+hsp,y-(hit_sizey-2),x+(hit_sizex*_direction)+hsp,y+(hit_sizey-2),oHittable, false, true, blocklist, true)

		var found_block=false;
		if (num > 0) {
			var i=0;
			repeat (num) {
				var blockcoll=ds_list_find_value(blocklist, i)
				if !(blockcoll.no_hit) && (blockcoll.amount != 0) {
					if (blockcoll.hit == 0) {
						found_block=true;
						blockcoll.blockHit.Emit(-1, id)
					}
				}
				i++;
			}
			if (found_block) {
				enemyTurnAround.Emit();
			}
		}
		
		ds_list_destroy(blocklist);
		
		var enemy=check_hitbox_on_hitbox(id,oEnemy)

		if (enemy) { //make sure shell is actually colliding with an enemy before trying to kill the enemy it collided with???
			if !(enemy.unshellable) {
				if (enemy.phaseid==noone || enemy.phaseid.id!=id) {
					instance_create_depth(x+hit_sizex*xsc,y,2,pImpact)
			
					enemy.enemyShelled.Emit(id, kickedplayer);
			
					if (kickedplayer==noone) || (kickedplayer.object_index != oPlayer) 
					kickedplayer=nearestplayer()
			
					kickCombo=min(kickCombo+1,8)
					VinylPlay(snd_enemykick,false,1,0.9+(kickCombo/10))
			
					if (kickCombo==8)
					give_lives(kickedplayer.pNum, enemy.x, enemy.y)
					else
					instance_create_depth(enemy.x,enemy.y,5,pScoreText,{image_index : kickCombo})
				}
			} else {
				instance_destroy();
				killtype="spin";
			}
		}
	}
} else {
	can_grab = false;
}

if (thrown) {
	var blocklist=ds_list_create();
	var num=collision_line_list(x-(hit_sizex-2),y-hit_sizey+min(0,vsp),x+(hit_sizex),y-hit_sizey+min(0,vsp),oHittable, false, true, blocklist, true)

	var found_block=false;
	if (num > 0) {
		var i=0;
		repeat (num) {
			var blockcoll=ds_list_find_value(blocklist, i)
			if !(blockcoll.no_hit) && (blockcoll.amount != 0) {
				if (blockcoll.hit == 0) {
					found_block=true;
					blockcoll.blockHit.Emit(-1, id)
				}
			}
			i++;
		}
		if (found_block) {
			make_particle(pImpact,x,y-hit_sizey+min(0,vsp),2)
			vsp = 2;
		}
	}
		
	ds_list_destroy(blocklist);
	
	var enemy=check_hitbox_on_hitbox(id,oEnemy)

	if (enemy) { //make sure shell is actually colliding with an enemy before trying to kill the enemy it collided with???
		if !(enemy.unshellable) {
			if (enemy.phaseid==noone || enemy.phaseid.id!=id) {
				instance_create_depth(x+hit_sizex*xsc,y,2,pImpact)
			
				enemy.enemyShelled.Emit(id, kickedplayer);
			
				if (kickedplayer==noone) || (kickedplayer.object_index != oPlayer) 
				kickedplayer=nearestplayer()
			
				kickCombo=min(kickCombo+1,8)
				VinylPlay(snd_enemykick,false,1,0.9+(kickCombo/10))
			
				if (kickCombo==8)
				give_lives(kickedplayer.pNum, enemy.x, enemy.y)
				else
				instance_create_depth(enemy.x,enemy.y,5,pScoreText,{image_index : kickCombo})
			}
		} else {
			instance_destroy();
			killtype="spin";
		}
	}
}

if (getup_timer) {
	getup_timer--;
	if !(getup_timer) {
		constantspd = 0.5;
		koopaEscapeShell.Emit();
	}
}

event_inherited();

event_user(0);