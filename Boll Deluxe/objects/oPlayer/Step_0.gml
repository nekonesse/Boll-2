// this just makes sure that vsp and hsp actually work while in a pipe lol

if keyboard_check_pressed(vk_f4) greenmode=!greenmode

//updateBox.Emit()

if collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,oDeathPit,false,true) && !dead {
	hurt = 1
	invincible_type = 0
	sig.Emit("on_kill")
}


// chearii: guessing these are a buncha quickvars
right = input_check("right");
left = input_check("left");
up = input_check("up");
down = input_check("down");
downpress = input_check_pressed("down");
if !finish {
	akey = input_check("a");
	apress = input_check_pressed("a");
	bkey = input_check("b");
	bpress = input_check_pressed("b");
	ckey = input_check("c");
	cpress = input_check_pressed("c");
}

if left{
	move_dir = -1	
}
if right {
	move_dir = 1	
}

player_castlewalk()

steep_slope = false
if abs(colangle) > 60 && abs(colangle) < 300 {
	steep_slope = true	
}

if !dead && !no_step {
	txr_exec(global.scripts[? $"{charmName}_step"]);
}
else {
	txr_exec(global.scripts[? $"{charmName}_death"]);
}

if (electrocuted) {
	electrocution_timer=max(electrocution_timer-1,0);
	if !(electrocution_timer) {
		sig.Emit("hurt_by_electrocution")
	}
}

if (pollenated) && (xprevious!=x || yprevious!=y) {
	part_system_position(pollenPart,x,y)
}

if (invincible_timer) {
	invincible_timer --;
	switch (invincible_type) {
		case 2 : {
			if (invincible_timer <= 0) {
				invincible_timer = 90;
				invincible_type = 1;
				break;
			}
			instance_create(random_range(bbox_left,bbox_right),random_range(bbox_top,bbox_bottom),pShine)
		} break;
		case 1 : {
			visible = (invincible_timer & 1 == 0)
			
			//the visible variable just skips the draw events entirely.
			//if the player object relies on it, uncomment the line at 
			// the draw event and delete this one.
			
			if (invincible_timer <= 0) {
				invincible_type = 0;
			}
		} break;
		case 0 : {
			invincible_timer = 0;
			//visible = true;
		}
		default : break;
	}
}