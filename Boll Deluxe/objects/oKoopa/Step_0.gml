if global.paused exit

no_dam = false

if (in_shell) {
	if (!shell_move) {
		no_dam = true
		in_shell--; //Decreases the time for the koopa to get up
		if (!in_shell) {
			y -= 9; 
			constantspd = 0.5 
			no_stomping = false
		} //Gets the Koopa to pull itself from the ground and continue walking in the direction the shell is facing
	}
}

event_inherited();

var enemy=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,oEnemy, false, true)

var checky=y;
y=-2147483647
var nearenemy=instance_nearest(x,checky,oEnemy)
y=checky

if (check_hitbox_on_hitbox(id,nearenemy)) && (enemy != noone) { //make sure shell is actually colliding with an enemy before trying to kill the enemy it collided with???
	if (in_shell) && (abs(hsp)) {
		if !(enemy.unshellable) {
			VinylPlay(snd_enemykick)
			enemy.killtype="spin";
			enemy.killhsp = sign(hsp);
			instance_create_depth(x+hit_sizex*xsc,y,2,pImpact)
			enemy.hp-=1;
		} else {
			instance_destroy();
			killtype="spin";
		}
	}
}

var blocklist=ds_list_create();
var num=collision_line_list(x+(hit_sizex*-xsc)+hsp,y-(hit_sizey-1),x+(hit_sizex*-xsc)+hsp,y+(hit_sizey-1),oHittable, false, true, blocklist, true)

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