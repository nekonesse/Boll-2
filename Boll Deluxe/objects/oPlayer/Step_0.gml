// this just makes sure that vsp and hsp actually work while in a pipe lol

if keyboard_check_pressed(vk_f4) greenmode=!greenmode

//updateBox.Emit()

if collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,oDeathPit,false,true) && !dead {
	hurt=1
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