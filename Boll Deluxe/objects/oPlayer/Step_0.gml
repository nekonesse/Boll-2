// this just makes sure that vsp and hsp actually work while in a pipe lol

//updateBox.Emit()

if collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey,oDeathPit,false,true) && !dead {
	hurt = 1
	invincible_type = 0
	state = "";
	sig.Emit("on_kill")
}


// chearii: guessing these are a buncha quickvars
if (input_enable) {
	right = input_check("right");
	rightpress = input_check_pressed("right");
	left = input_check("left");
	leftpress = input_check_pressed("left");
	up = input_check("up");
	uppress = input_check_pressed("up");
	down = input_check("down");
	downpress = input_check_pressed("down");
	if !finish {
		akey = input_check("a");
		apress = input_check_pressed("a");
		bkey = input_check("b");
		bpress = input_check_pressed("b");
		ckey = input_check("c");
		cpress = input_check_pressed("c");
		vpress = input_check_pressed("v");
	}
}
player_castlewalk()

steep_slope = false
if (abs(colangle) > 60) {
	steep_slope = true
}

switch(state) {
	case "frozen":
		state = "frozen"
		can_grab = false;
	
		hit_sizex=15;
		hit_sizey=15;
	
		gsp -= (0.25 * dsin(colangle)) //regular slope speed
	
		no_move = true
	
		if in_water() {
			grav=defaultgrav/4
		} else {
			grav=defaultgrav
		}
	
		fric = 0
	
		maxspd = 10;
		topspd = 3.5;
	
		component_gravity_coneyor();
	
		player_movement();
		basic_step_move();
		post_wall();
	
		if (apress) {
			frozen_health-=1
			var j=noone
			j = instance_create(x-8,y+8,pDestruction) with(j){image_index=10 hspeed=-1+other.hsp/2 vspeed=-2} //bottom left
			j = instance_create(x-8,y-8,pDestruction) with(j){image_index=10 hspeed=1+other.hsp/2 vspeed=-2} //bottom right
			j = instance_create(x+8,y+8,pDestruction) with(j){image_index=10 hspeed=-1+other.hsp/2 vspeed=-4} //top left
			j = instance_create(x+8,y-8,pDestruction) with(j){image_index=10 hspeed=1+other.hsp/2 vspeed=-4} //top right
			if !(frozen_health) {
				state="jump"
				vsp=-2;
				grounded=false;
				was_frozen = true;
				y-=8
				VinylPlay(snd_iceshatter)
				exit
			}
			VinylPlay(snd_icestruggle)
		}
	break;
	case "boarding":
		state = "boarding";
		can_grab = false;
		
		defaultgrav = 0.25;
		maxspd = 10;
		topspd = 3.5;
		var accel_real = 0.25;
		
		if (abs(hsp) < topspd) && !(bonk) {
			hsp += (xsc * accel_real);
		}
		
		if (abs(hsp) > topspd) {
			hsp -= hsp / 32
		}
		
		if (grounded) {
			bonk = false;
			gsp = hsp;
			vsp = 0;
			sprite_angle = approach_val(sprite_angle,colangle,5);
		} else {
			sprite_angle = approach_val(sprite_angle,0,5);
		}
	
		//gsp -= (0.25 * dsin(colangle)) //regular slope speed
	
		no_move = true
	
		if in_water() {
			grav=defaultgrav/4
		} else {
			grav=defaultgrav
		}
		
		if (!akey && vsp < -2.6 && !canstopjump) { 
			vsp = -2.6;
		}
		
		if (apress) && (grounded) {
			vsp = -5.5;
			grounded = false;
			if (collision_line(x,y,x,y+hit_sizey+4,oSnowboardRamp,true,false)) {
				vsp -= 2;
			}
		}
	
		component_gravity_coneyor();
		
		basic_step_move();
		post_wall();
	break;
	default:
		if !dead && !no_step {
			catspeak_execute(global.scripts[? $"{charmName}_step"]);
		} else if (dead) {
			catspeak_execute(global.scripts[? $"{charmName}_death"]);
		}
		
		player_warping();
		
		if (vpress) && (oGameManager.reserved_item!=noone) {
			var i=instance_create_depth(x,y,0,oGameManager.reserved_item)
			i.vsp=-2;
			i.hsp=xsc*2;
			i.phaseid=id;
			i.phase_leeway = 0;
			
			with(oGameManager) {
				reserved_item = noone;
			}
			VinylPlay(snd_itemappear);
		}
	break;
}

if (electrocuted) {
	hsp=0;
	gsp=0;
	vsp=0;
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
				oGameManager.alarm[0]=1
				invincible_timer = 60;
				grow=0;
				invincible_type = 1;
				break;
			}
			
			if (global.roomTimer & 0b11 == 2) {
				instance_create(random_range(bbox_left - 4,bbox_right + 4),random_range(bbox_top-8,bbox_bottom),pShine)
			} else if !(global.roomTimer & 0b11) {
				with (instance_create(x, y, pShineStarman)) {
					owner = other;
				}
			}
		} break;
		case 1 : {
			
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
		} break;
	}
}

if death_time {
	oGameManager.fadein = true
	oGameManager.fadeprog += 0.082
	if (death_time_counter == 0) oGameManager.fadeprog = 0
	
	death_time_counter++
	
	
	if (death_time_counter > 60) && !(global.midTransition) {
		if (global.lives[0] < 1) { //game over. couldnt care less if player 2 has -4 lives You. Are. Not. Implemented!!
			VinylStopAll();
			VinylPlay(mus_gameover, 0, 0.4);
			var goto = rMainMenu;
			if (global.jade_testing) goto = rEditor;
			
			TransitionStart(goto,sq_gameover,-1);
			exit;
		}
		room_restart();
	}
}

var hidden_layers = oGameManager.hidden_tile_layers
var i=0;
repeat(array_length(hidden_layers)) {
	var _layer = hidden_layers[i]
	if (collision_point(x,y,_layer.my_deco_layer,false,true)!=noone) {
		_layer.touched = true;
	}
	i++;
}