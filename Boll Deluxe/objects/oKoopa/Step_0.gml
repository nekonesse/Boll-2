if global.paused exit

no_dam = false

if (in_shell) {
	if (!shell_move) {
		no_dam = true
		in_shell--; //Decreases the time for the koopa to get up
		if (!in_shell) {
			constantspd = 0.5 
			no_stomping = false
			koopaEscapeShell.Emit();
		} //Gets the Koopa to pull itself from the ground and continue walking in the direction the shell is facing
	}
}

event_inherited();

var enemy=check_hitbox_on_hitbox(id,oEnemy)

if (enemy) { //make sure shell is actually colliding with an enemy before trying to kill the enemy it collided with???
	if (in_shell) && (abs(hsp)) {
		if !(enemy.unshellable) {
			if (enemy.phaseid==noone || enemy.phaseid.id!=id) {
				instance_create_depth(x+hit_sizex*xsc,y,2,pImpact)
			
				enemy.enemyShelled.Emit(id, kickedplayer);
			
				if (kickedplayer==noone) || (kickedplayer.object_index != oPlayer) 
				kickedplayer=nearestplayer()
			
				kickCombo=min(kickCombo+1,8)
				VinylPlay(snd_enemykick,false,1,0.9+(kickCombo/10))
			
				if (kickCombo==8)
				give_lives(kickedplayer.pNum, x + (hit_sizex / 2), y - 8)
				else
				instance_create_depth(enemy.x,enemy.y,5,pScoreText,{image_index : kickCombo})
			}
		} else {
			instance_destroy();
			killtype="spin";
		}
	}
}

var blocklist=ds_list_create();
var num=collision_line_list(x+(hit_sizex*-xsc)+hsp,y-(hit_sizey-2),x+(hit_sizex*-xsc)+hsp,y+(hit_sizey-2),oHittable, false, true, blocklist, true)

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

event_user(0);