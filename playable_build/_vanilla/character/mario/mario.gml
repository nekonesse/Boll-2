#define datalist
spriteEvents=split_string("idle,walk,run,wait,lookUp,crouchIdle,crouchWalk,crouchJump,crouchFall,crouchFireToss,crouchBonk,crouchFireToss,victory,hurt,dead,brake,jump,fall,bonk,runJump,runJumpFall,doubleJump,doubleJumpFall,doubleJumpBonk,wallSlide,wallJump,groundPound,groundPoundFall,slopeSlide,carryIdle,carryWalk,carryRun,carryLookUp,carryJump,carryFall,carryBonk,carrySpinJump,carrySpinJumpFall,carryCrouchIdle,carryCrouchWalk,carryCrouchJump,carryCrouchFall,carryCrouchBonk,carryKick,carryAirKick,roll,swim,swimPaddle,carrySwim,carryPaddle,spinJump,spinJumpFall,pushing,balancing,dive,bellySlide,fireToss,electrocute,gateClimbing,flagPole,hang,monkeyBars,boarding,snowboarding,downPipeEnter,downPipeExit,upPipeEnter,upPipeExit,sidePipeEnter,sidePipeExit,doorEnter,doorExit",",");
sound_list=split_string("damage,die,dive,fireball,flip,jump,kick,pound,rollout,select,skid,spin,spinbounce,spinjump,stomp,swim,wallkick",",");

#define create
slopesliding = 0;
no_move = 0;
fric = 0.07;
friction_mult = 1;
runvar = 0;
runjump = false;
starmanjump = false;
dusttimer = 1;
skidding = 0;
skiddir = 0;
wait_timer = 0;
pound_timer = 0;
pound_severity = -1;
storedxsc = 1;
poundjump = 0;
grow = 0;
state = "";
groundpound_land=false;
pounding_block = false;
walljump = false;
firing = 0;
crouch = false;
topspd = 0;
invincible_type = 0; //0 is off, 1 is hurt frames and 2 is invincibility
invincible_timer = 0;
found_block = false;
spinjump = false;
stun = false;
wallkick = false;
was_in_water = false;
gotimer = 0;
dead=0
deadtimer=0;
deadgo=0;
swim=0;
kick=0;

//we do this in create because its a function, and we only need to do it once
#region Water Handling Setup
water = function() {

grav = defaultgrav / 5
no_move = false
steep_slope = false
move_lock = false
accel = 0.05
fastaccel = 0.05
if (grounded) {
maxspd = 0.98
} else {
	maxspd = 1.52	
}

xsc = esign(move, xsc)


component_gravity_coneyor()

if grounded {
	vsp = 0
}
//fric = fric * friction_mult;

#region Swimming
	if (apress) {
		grounded = false
		var v_move = (down - up)
		if (vsp > 0 || down) {
			vsp = 0;
		}
		vsp -= 1.1 - (0.5 * bool(down)) + (0.6 * bool(up))
		vsp = max(vsp, -1.5 - (0.8 * bool(up)));
		playsfx(charmName+"swim",1,0,1)
		swim=24
	}
#endregion

was_in_water = true

player_movement();
basic_step_move();
post_wall();

swim = max(0, swim-1)

}
#endregion

#define stop
hsp = 0;
gsp = 0;
vsp = 0;
state = "";
no_move = 1;
stopsfx(charmName+"skid")

//chopp: oops rewriting the entire players script
#define step

// chearii: pound severity, probably only for slimes tbh
pound_severity = -1;

//Change hitbox size based on powerup
//your hitbox is in the center so the hitbox variables should be HALF of the total box size.
hit_sizex = 6;
switch (size) {
	case "basic": {
		can_break_bricks=false
		hit_sizey = 6
	} break
	case "mini": {
		can_break_bricks=false
		hit_sizey = 3
	} break
	default: {
		can_break_bricks=true
		if !(crouch) {
			hit_sizey = 12
		} else {
			hit_sizey = 6
		}
	} break
}

//ajust topspeed based on slope direction and value
var slope_value = (0.5 * dsin(colangle))
if (sign(gsp) != sign(dsin(colangle))){
	slope_value = 0 - slope_value
}
if (!grounded || steep_slope || slopesliding) {
	slope_value = 0
}

var base_top = 2
if (crouch && grounded) {
	base_top = 0.5
}

topspd = base_top + runvar + (base_top * slope_value) + ((invincible_type == 2) / 1.25);
maxspd = 9

#region PreventMovement
var no_move_prev = no_move;
no_move = 0;
//add more checks here
if (state == "pound") || (state=="dive") || (alarm_get(2)) || (hurt) || (stun) || (finish && posed && no_move_prev) {
	no_move = true;
}

can_grab = true;
if (state == "pound") || (state == "dive") || (spinjump) || (hurt) || (stun) || (finish && posed && no_move_prev) {
	can_grab = false;
}

can_stomp = true
if (state == "pound") {
	can_stomp = false;
}

#endregion

#region Jump Out Of Water
if in_water(){
	if (!was_in_water) {
		
		vsp /= 5
		was_in_water = true
		state = ""
		swim = 0
	}
	water();
	exit
} else {
	if (was_in_water) {
		//if we are at the TOP of the water, not the bottom or side
		if collision_line(x,y,x,y+hit_sizey+abs(vsp),asset_get_index("oWater"),false,true) {
			if (!grounded) {
				state = "jump"
				if (up) {
					vsp = -5
				} else {
					vsp = -3.5
				}
				canstopjump=true
			}
		}
		accel = 0.09375; //how fast you gain speed
		fastaccel = 0.3125; // accel during a turnaround
		skid_accel = 0.16125; // accel while skidding ?
		fric = 0.07; //slipperiness
		friction_mult = 1; //multiplier for friction (e.g. ice blocks)
		maxspd = 1.5
		was_in_water = false
		runjump = false
	}
}
#endregion

#region Normal
if ((apress) && !(grounded)) && !piped {
	alarm_set(0,5);  // ammount of frames for jump buffering
	alarm_set(1,3);  // Walljump buffering
} else if (grounded) {
	alarm_set(1,0)
	wallbuffer = 0;
}

if ((alarm_get(0) > 0) && (grounded)) {
	bufferjump = 1;
	alarm_set(0,0)
}

if (state == "" || state == "jump" || state == "dive") && !piped && !electrocuted && !electrocution_timer {
	if in_water() {
		grav=defaultgrav/4
	} else {
		grav=defaultgrav
	}
	
	if (bkey) && !(crouch) {
		run=1.5;
		//show_debug_message("is_rinning")
	} else {
		run = 0;
	}
	
	#region Fire Projectile
	
	if (bpress) && (size=="fire") && state != "dive"&& (has_fired < 2) && !(slopesliding) {
		var proj=instance_create_depth(x+(hit_sizex+3)*xsc,y+hit_sizey-12,2,oFireball)
		proj.hsp=3.75*xsc
		if !(up) {
			proj.vsp = 2
		} else {
			proj.vsp = -4;
		}
		proj.owner=id
		VinylPlay(asset_get_index("snd_fireball"))
		
		has_fired+=1;
		frame=0;
		firing=15;
	}
	
	#endregion
	
	if (!grounded) {
		component_gravity_coneyor()

		if (skidding) {
			stopsfx(charmName+"skid")
			skidding=0
		}
		
	} else {
		
		crouch=component_mario_crouch();
		
		if (hurt) {
			hurt = false;
			if !(was_frozen) {
				invincible_type = 1;
				invincible_timer = 75;
			}
		}
		
		was_frozen = false
		
		canjump = 5;  // Coyote frames
		runjump = false
	
		//maximum speed when sliding, infulence when sliding, influence on steep slopes, add steep influence while sliding?
		player_slide(12.5, 0.225, 0.32, false);
		
		//mario's going to fast friction. (outside of normal top speed)
		//this makes it work more like mario world
		//while still having a total speed cap
		if (!slopesliding && !no_move){
			if (abs(gsp) > topspd){
				if (gsp > 0){
					gsp = min(topspd, gsp - ((fric * 2.24) * friction_mult))
				}else{
					gsp = max(-topspd, gsp + ((fric * 2.24) * friction_mult))
				}
			}
		}
		
		//skidding
		component_mario_skid()
	}
}

if (state == "") && !(hurt) {
	canstopjump = false
	if (!abs(sign(colslope)) && (abs(hsp) < 0.25)){
		slopesliding = 0
	}
}

#endregion

#region Groundpound
if (state == "pound") && !(piped) && !(stun) {
	component_mario_groundpound()
	
	//hittable block collision
	if (grounded) && (pound_timer <= 0) {
		found_block = false;
		var blocklist=ds_list_create();
		var num=collision_line_list(x-hit_sizex,y+hit_sizey+vsp+2,x+hit_sizex,y+hit_sizey+vsp+2, oHittable, false, true, blocklist, true)

		if (num > 0) {
			var i = 0;
			while (i < num) {
				var blockcoll=ds_list_find_value(blocklist, i)
				if !(blockcoll.no_hit) && (pounding_block == true) && (blockcoll.amount != 0) {
					found_block=true;
					if (blockcoll.hit == 0) {
						signal_emit(blockcoll.blockHit, 1, id)
					}
				}
				i += 1;
			}
			pounding_block = false
		}
		
		if !(found_block) {
			state = ""
			vsp = 0
			//create pound smoke
			make_particle(pSmoke, x-1, y + hit_sizey, depth + 5, 1, -3.25, -0.2, -0.04, 0.2);
			make_particle(pSmoke, x-1, y + hit_sizey, depth + 5, -1, 3.25, -0.2, -0.04, 0.2);
			pound_timer = 0;
		}
		
		if (down) {
			pounding_block = true
		}
		ds_list_destroy(blocklist)
	}
}
#endregion

#region Jumping
var underwater=in_water()
if (state == "jump" || state == "") && !(grounded) && !piped && !(stun) {
	if (underwater) {
		state=""
	}
	
	if !(spinjump) {
		if (!akey && vsp < -2.6 && !canstopjump) {//Make player jump lower when jump is released
			vsp = -2.6;
		}
	} else {
		if (!ckey && vsp < -2.6 && !canstopjump) { //Make player jump lower when jump is released
			vsp = -2.6;
		}
	}
	
	if (downpress && !is_grabbing) && !(hurt) && !(stun) {
		component_mario_start_groundpound()
	}
	
	if (!alarm_get(2)) {
		steep_slope = false;
	}
	
	#region Wallsliding
	if (move != 0) && !(crouch) && !(spinjump) && (state != "pound"){
		//wall sliding
		var coll=check_valid_wall(x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc),x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc))
		if (!grounded) && (!is_grabbing) && !(stun) && !(hurt) && (coll) && (vsp > 0) {
			state = "wallslide"
		}
	}
	#endregion
}

if ((state == "" || state=="crouch") && !hurt && !stun && apress && canjump > 0 && !spinjump) && !piped && !(underwater) {
	grounded = false;
	starmanjump = false;
	state = "jump"
	vsp = -(4.65+(clamp(abs(hsp)/3.14,0.5,1.7) * 1.2)+(bool(poundjump)+0.5)); //preform the actual jump
	
	playsfx(charmName+"jump",1+(bool(poundjump)/4),0,1)
	if (run && abs(hsp)>3) && !(is_grabbing) {
		//visual maxspeed jump
		runjump=true
	}
	
	if (invincible_type == 2) {
		starmanjump = true;
		runjump = false;
	}
	
	canjump = 0;
	//Jump Particles
	if (poundjump) {
		make_particle(pSmoke, x-10, y-8, depth + 5, 1, 0, -1);
		make_particle(pSmoke, x+8, y-8, depth + 5, 1, 0, -1);
	}
	if (slopesliding) {
		crouch = false
		slopesliding = false;
	}
	
	make_particle(pJumpDust, x, y + hit_sizey, depth + 5, 1, 0, (y-yprevious)/1.5, 0, 0.2);
}
#endregion

if (state == "wallslide") && !piped && !(stun) {
	component_mario_wallslide()
}

#region Spinjumping & Diving

if (cpress && !is_grabbing) && !(stun) {
	if (grounded) {
		component_mario_start_spinjump();
	} else if (state != "dive" && !stun && !hurt && !spinjump && !up && (!crouch || state == "pound")) {
		component_mario_start_dive();
	}
}

#endregion

if (colangle != 0 && slopesliding) {
	fric = 0.048; //limit friction for more slideee
	// weeeeee
} else if (!slopesliding && steep_slope) {
	fric = 0.048;
} else {
	fric = 0.0625;
}

fric = fric * friction_mult;
	
player_movement();
basic_step_move();
post_wall();

component_get_ground_friction()

component_mario_skidding_fx()

// check to see if we need to update the polybox
if (sprindex_prev != sprite_index) {
	//obj_update_poly_from_bounding(self);
	sprindex_prev = sprite_index;
}

// Switch direction
//add more checks here to prevent left/right changing direction
if (left || right) && (state == "" || state == "jump") && !slopesliding && !piped {
	xsc = esign(move, xsc)
}

poundjump=max(0,poundjump-1);
firing=max(0,firing-1);

runvar = approach_val(runvar,run,0.05);
damagespecial = max(0, pound_severity);

bonk=max(0,bonk-1);
grow=max(0,grow-1);
kick=max(0,kick-1);

#define step_end

//player_grab();


#define draw

#region Sprite Manager
frspd=1

if (state == "") {
	//icy slippy
	var speed_mult = 1;
	if (friction_mult>0) && (grounded) {
		speed_mult = 1/(friction_mult);
	}
	
	if !(crouch) {
		if !(is_grabbing) {
			if (abs(gsp) == 0) {
				wait_timer += 1
				spriteEvent="idle"
				if (wait_timer > 440) {
					spriteEvent="wait"
				}
				if (up) {
					wait_timer = 0
					spriteEvent="lookUp"
				}
			} else {
				wait_timer = 0
				if (ceil(abs(gsp))>3.25) {
					spriteEvent="run"
				} else {
					frspd=max(abs(hsp)/4,0.3)*speed_mult
					spriteEvent="walk"
				}
			}
		} else {
			if (abs(gsp) == 0) {
				wait_timer = 0
				spriteEvent="carryIdle"
				if (up) {
					wait_timer = 0
					spriteEvent="carryLookUp"
				}
			} else {
				wait_timer = 0
				if (ceil(abs(gsp))>3.25) {
					spriteEvent="carryRun"
				} else {
					frspd=max(abs(hsp)/4,0.3)*speed_mult
					spriteEvent="carryWalk"
				}
			}
		}
	} else {
		wait_timer = 0
		if (move == 0) {
			if !(is_grabbing) {
				spriteEvent="crouchIdle"
			} else {
				spriteEvent="carryCrouchIdle"
			}
		}
		else {
			if !(is_grabbing) {
				spriteEvent="crouchWalk"
			} else {
				spriteEvent="carryCrouchWalk"
			}
		}
	}
	
	if (!grounded) {
		if (vsp>0) {
			if !(crouch) {
				if !is_grabbing {
					spriteEvent="fall"
				} else {
					spriteEvent="carryFall"
				}
			} else {
				if !is_grabbing {
					spriteEvent="crouchFall"
				} else {
					spriteEvent="carryCrouchFall"
				}
			}
		}
	}
	
	if (skidding) && !(crouch) {
		spriteEvent="brake" 
		xsc = -(skiddir)
	}
	
	if (in_water()) {
		if !(swim) {
			if !(is_grabbing) {
				spriteEvent="swim"
			} else { 
				spriteEvent="carrySwim"
			}
			frspd=1
		} else {
			if !(is_grabbing) {
				spriteEvent="swimPaddle"
			} else {
				spriteEvent="carryPaddle"
			}
			frspd=1.2
		}
	}

	if (finish && posed && no_move) {
		spriteEvent="victory"
	}
} else {
	wait_timer = 0
}

if (state == "jump") {
	if !(crouch) {
		if !(is_grabbing) {
			spriteEvent="jump"
		} else {
			spriteEvent="carryJump"
		}
	} else {
		if !(is_grabbing) {
			spriteEvent="crouchJump"
		} else {
			spriteEvent="carryCrouchJump"
		}
	}
	
	if (vsp>0) {
		if !(crouch) {
			if !(is_grabbing) {
				spriteEvent="fall"
			} else {
				spriteEvent="carryFall"
			}
		} else {
			if !(is_grabbing) {
				spriteEvent="crouchFall"
			} else {
				spriteEvent="carryCrouchFall"
			}
		}
	}
	
	if (starmanjump) {
		spriteEvent="roll"
	} else if (runjump) && !(crouch) && !(is_grabbing) && (invincible_type != 2) {
		spriteEvent="runJump"
	}
	
	if (bonk) {
		if !(crouch) {
			if !(is_grabbing) {
				spriteEvent="bonk"
			} else {
				spriteEvent="carryBonk"
			}
		} else {
			if !(is_grabbing) {
				spriteEvent="crouchBonk"
			} else {
				spriteEvent="carryCrouchBonk"
			}
		}
	}
	
	if (spinjump) {
		if !(vsp>1) {
			if !(is_grabbing) {
				spriteEvent="spinJump"
			} else {
				spriteEvent="carrySpinJump"
			}
		} else {
			if !(is_grabbing) {
				spriteEvent="spinJumpFall"
			} else {
				spriteEvent="carrySpinJumpFall"
			}
		}
	}
	
	if (wallkick){
		spriteEvent="wallJump"
	}
}

if (kick) {
	frspd=1;
	if (grounded) {
		spriteEvent="carryKick"
	} else {
		spriteEvent="carryAirKick"
	}
}

if (state == "dive") {
	frspd=1;
	spriteEvent="dive"
}

if (slopesliding) {
	frspd=1;
	spriteEvent="slopeSlide"
}

if (state == "pound") {
	frspd=1;
	if (pound_timer > 0) {
		spriteEvent="groundPound" 
	} else {
		spriteEvent="groundPoundFall"
	}
}

if (state == "wallslide") {
	frspd=1;
	spriteEvent="wallSlide"
}

if (firing) && !(is_grabbing) {
	if !(crouch) {
		spriteEvent="fireToss"
	} else {
		spriteEvent="crouchFireToss"
	}
	frspd=1;
}

if (hurt || stun || state == "frozen") {
	frspd=1;
	spriteEvent="hurt"
	if (dead) {
		spriteEvent="dead"
	}
}

if (electrocuted) {
	frspd=1;
	spriteEvent="electrocute"
}

if (state == "boarding") {
	spriteEvent="boarding";
}

if (piped) {
	switch(warp_type) {
		case "enter_pipe_down":
			spriteEvent="downPipeEnter";
		break;
		case "exit_pipe_down":
			spriteEvent="downPipeExit";
		break;
		case "enter_pipe_up":
			spriteEvent="upPipeEnter";
		break;
		case "exit_pipe_up":
			spriteEvent="upPipeExit";
		break;
		case "enter_pipe_side":
			spriteEvent="sidePipeEnter";
		break;
		case "exit_pipe_side":
			spriteEvent="sidePipeExit";
		break;
	}
}

#endregion


#define upd_frame
//this is because the crouch animation has a transition frame, and if we reset back to idle the transition frame will play again, we dont want that
if (spriteEvent=="crouchIdle") {
	if (oldSpriteEvent=="crouchWalk" || oldSpriteEvent=="crouchJump" || oldSpriteEvent=="crouchFall" || oldSpriteEvent=="crouchBonk" || oldSpriteEvent=="crouchFireToss" || oldSpriteEvent=="carryCrouchIdle"  || oldSpriteEvent=="carryCrouchWalk" || oldSpriteEvent=="carryCrouchJump"  || oldSpriteEvent=="carryCrouchFall" || oldSpriteEvent=="carryCrouchBonk") {
		var spri = sprite_arrposition(spriteEvent)
		frame = loops_list[spri]-1
	}
} else if (spriteEvent=="carryCrouchIdle") {
	if (oldSpriteEvent=="crouchIdle" || oldSpriteEvent=="crouchWalk" || oldSpriteEvent=="crouchJump" || oldSpriteEvent=="crouchFall" || oldSpriteEvent=="crouchBonk" || oldSpriteEvent=="crouchFireToss" || oldSpriteEvent=="carryCrouchWalk" || oldSpriteEvent=="carryCrouchJump"  || oldSpriteEvent=="carryCrouchFall" || oldSpriteEvent=="carryCrouchBonk") {
		var spri = sprite_arrposition(spriteEvent)
		frame = loops_list[spri]-1
	}
} else if (spriteEvent=="swimPaddle" || spriteEvent=="carryPaddle") {
	if (swim >= 23) {
		frame = 0
	}
}

#define on_kill
stopsfx(charmName+"skid")
playsfx(charmName+"die")
give_lives(pNum, -1000, -1000, -1, -4, -4)
dead=1
deadtimer=240;
deadgo=0;
gotimer=30;
vspeed = 0;
gravity = 0;

#define death
gotimer=max(0,gotimer-1);
deadtimer=max(0,deadtimer-1);

//wait for 'stun' animation and then start falling
if !(gotimer) && !(deadgo) {
	deadgo=1;
	vspeed = -4.5;
	gravity = 0.15;
}

//so the camera doesnt move
if (my_camera) {
	my_camera.locked = true;
}

//complete the death animation and restart the level
if !(deadtimer) {
	finish_death();
}

#define mushroom
if (size!="basic" && size!="mini" ) {
	reserve_item(oMushroom);
}

VinylPlay(asset_get_index("snd_powerup"))
if (size == "basic" || size == "mini") {
	oldsize = size;
	size = "big";
	grow = 60;
}

#define fireflower
if (size!="basic" && size!="big" && size!="mini") {
	switch(size) {
		case "fire":
			reserve_item(oFireFlower);
		break;
		case "thunder":
			reserve_item(oThunderFlower);
		break;
	}
}

VinylPlay(asset_get_index("snd_powerup"))
if (size != "fire") {
	oldsize = size;
	size = "fire";
	grow = 60;
}

#define thunderflower
if (size!="basic" && size!="big" && size!="mini") {
	switch(size) {
		case "fire":
			reserve_item(oFireFlower);
		break;
		case "thunder":
			reserve_item(oThunderFlower);
		break;
	}
}

VinylPlay(asset_get_index("snd_powerup"))
if (size != "thunder") {
	oldsize = size;
	size = "thunder";
	grow = 60;
}

#define star
VinylPlay(asset_get_index("snd_powerup"));
with (oGameManager) {
	event_user(2);
}
invincible_type = 2;                                                                               
invincible_timer = 510;


#define 1up
give_lives(pNum, x + (hit_sizex / 2), y - 8)

#define 3up
give_lives(pNum, x + (hit_sizex / 2), y - 8, 3, p3UP)

#define poison
if !(invincible_type && invincible_timer) {
	stopsfx(charmName+"damage")
	hurt=1
	hsp= -2.25 * xsc
	vsp= -4
	canstopjump=true
	state=""
	grounded=false
	oldsize = size;
	switch (size) {
		case "basic": {
			signal_emit(sig, "on_kill", charmName)
		} break
		case "big": {
			size = "basic";
			playsfx(charmName+"damage")
		} break
		default: {
			size = "big";
			playsfx(charmName+"damage")
		} break
	}
	grow = 60;
}

#define ceil_bonk
bonk = 12

#define wall_hit
if (state == "dive") {
	VinylPlay(asset_get_index("snd_blockbump"))
	make_particle(pImpact, x + hit_sizex*xsc, y)
	make_particle(pBonkStars, x + hit_sizex*xsc, y)
	hit_block(x+(hit_sizex+1)*xsc,y-hit_sizey+2,x+(hit_sizex+1)*xsc,y+hit_sizey-2)
	hsp= -1 * xsc
	vsp= -2
	canstopjump=true
	state=""
	stun=1
	grounded=false
}

#define floor_land
if (invincible_type != 2) && !(slopesliding) {
	stompCombo = 0;
}

gsp = hsp

#region Groundpound Land
if (state == "pound") {
	poundjump = 16;
	show_debug_message(colslope);
	if colslope != 0 {
		slopesliding = 1
		gsp = (-6 * dsin(colangle)) 
	}
	playsfx(charmName+"stomp");
} else if (state != "frozen") && (state != "boarding") {
	state = ""
	make_particle(pSkidDust, x - 1, y + hit_sizey, depth + 5, 1, -2.25, -0.1, -0.02, 0.2);
	make_particle(pSkidDust, x + 1, y + hit_sizey, depth + 5, -1, 2.25, -0.1, -0.02, 0.2);
}
#endregion
vsp = 0

canstopjump = false
spinjump = false
stun = false;
wallkick = false;
starmanjump = false;

#define sprung_up
if (state != "frozen") && (state != "boarding") {
	state = "jump";
}
runjump = 0;
crouch = false;
slopesliding = false;
canstopjump = true;
stun = false;
starmanjump = false;

#define enemy_stomped
if (state != "pound") {
	vsp= -(4+akey*2.5)
}

#define collide_with_enemy
var coll=check_hitbox_on_hitbox(id, oEnemy)
if (coll) && !(coll.no_dam) && (coll.phaseid!=id) {
	if (coll) && ((!slopesliding && state != "pound") || coll.damage_on_contact) && !(invincible_type && invincible_timer) {
		stopsfx(charmName+"skid")
		stopsfx(charmName+"damage")
		hurt=1
		hsp= -2.25 * xsc
		vsp= -4
		canstopjump=true
		state=""
		grounded=false
		oldsize = size;
		switch (size) {
			case "basic": {
				signal_emit(sig, "on_kill", charmName)
			} break
			case "big": {
				size = "basic";
				playsfx(charmName+"damage")
			} break
			default: {
				size = "big";
				playsfx(charmName+"damage")
			} break
		}
		grow = 60;
	} else if (state == "pound") {
		make_particle(pImpact,coll.x,coll.y,2)
		increase_combo(coll.x,coll.y);
		signal_emit(coll.enemyPounded, id);
	} else if (slopesliding) {
		signal_emit(coll.enemyRolledInto, id);
	}
}

#define hurt_by_spike
	stopsfx(charmName+"skid")
	stopsfx(charmName+"damage")
	hurt=1
	hsp= -2.25 * xsc
	vsp= -4
	canstopjump=true
	state=""
	grounded=false
	oldsize = size;
	switch (size) {
		case "basic": {
			signal_emit(sig, "on_kill", charmName)
		} break
		case "big": {
			size = "basic";
			playsfx(charmName+"damage")
		} break
		default: {
			size = "big";
			playsfx(charmName+"damage")
		} break
	}
	grow = 60;


#define electrocute

	state=""
	electrocuted = true;
	electrocution_timer=60;


#define hurt_by_electrocution
	stopsfx(charmName+"skid")
	stopsfx(charmName+"damage")
	electrocuted = false;
	hurt=1
	hsp= -2.25 * xsc
	vsp= -4
	canstopjump=true
	state=""
	grounded=false
	oldsize = size;
	switch (size) {
		case "basic": {
			signal_emit(sig, "on_kill", charmName)
		} break
		case "big": {
			size = "basic";
			playsfx(charmName+"damage")
		} break
		default: {
			size = "big";
			playsfx(charmName+"damage")
		} break
	}
	grow = 60;

#define enter_pipe
stopsfx(charmName+"skid")

#define on_freeze
stopsfx(charmName+"skid")

#define start_boarding
stopsfx(charmName+"skid")

#define throw_object
if !(down) {
	kick=12;
}