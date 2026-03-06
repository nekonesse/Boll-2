node_path_movement();

if !(grabbed) {
	if !(check_rectangle_in_hitbox((-sprite_width/2)+1,sprite_width/2,(-sprite_height/2)+1,(sprite_height/2)-1, oPlayer)) {
		grab_delay = max(grab_delay-1, 0)
	}
    if !(grounded) { 
        vsp=min(vsp+grav,6);
    }
    
    if (grounded) {
		thrown = false;
		carry_player = noone;
		kickCombo = 0;
        if (bounce) {
            grounded = false
            bounce = false
            hsp = gsp / 2
            vsp = -1.5
        } else {
			hsp = approach_val(hsp, 0, 0.1);
        }
    }
    
    x += hsp
    y += vsp

    player_collision(true, false, (-sprite_width/2)+1,sprite_width/2,(-sprite_height/2)+1,(sprite_height/2)-1);
} else {
    grounded = false
	var enemy=check_rectangle_in_hitbox(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,oEnemy)
	
	if (enemy) { //make sure shell is actually colliding with an enemy before trying to kill the enemy it collided with???
		if !(enemy.unshellable) {
			if (enemy.phaseid==noone || enemy.phaseid.id!=id) {
				instance_create_depth(x+(sprite_width/2)*carry_player.xsc,y,2,pImpact)
			
				enemy.enemyShelled.Emit(id, carry_player);
	
				VinylPlay(snd_enemykick,false,1);
				
				onBreak.Emit();
			}
		} else {
			onBreak.Emit();
		}
	}
}


if (thrown) && (can_hit) {
	var blocklist=ds_list_create();
	var num=collision_line_list(bbox_left,bbox_top+min(0,vsp),bbox_right-1,bbox_top+min(0,vsp),oHittable, false, true, blocklist, true)

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
			make_particle(pImpact,x,bbox_top+min(0,vsp),2)
			onBreak.Emit();
		}
	}
		
	ds_list_destroy(blocklist);
	
	var enemy=check_rectangle_in_hitbox(bbox_left,bbox_top,bbox_right-1,bbox_bottom-1,oEnemy)

	if (enemy) { //make sure shell is actually colliding with an enemy before trying to kill the enemy it collided with???
		if !(enemy.unshellable) {
			if (enemy.phaseid==noone || enemy.phaseid.id!=id) {
				instance_create_depth(x,y,2,pImpact)
			
				enemy.enemyShelled.Emit(id, carry_player);
			
				if (carry_player==noone) || (carry_player.object_index != oPlayer) 
				carry_player=nearestplayer()
			
				kickCombo=min(kickCombo+1,8)
				VinylPlay(snd_enemykick,false,1,0.9+(kickCombo/10))
			
				if (kickCombo==8)
				give_lives(carry_player.pNum, enemy.x, enemy.y)
				else
				instance_create_depth(enemy.x,enemy.y,5,pScoreText,{image_index : kickCombo})
			}
		} else {
			onBreak.Emit();
		}
	}
}