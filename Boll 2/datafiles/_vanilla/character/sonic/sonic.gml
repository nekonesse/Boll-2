#define datalist
spriteEvents=split_string("idle,wait,lookUp,victory,crouch,hurt,dead,walk,run,runMax,wallRun,wallJump,airWalk,brake,spring,springFall,jump,bonk,roll,spinDash,spinCharge,dropDash,airDash,carryIdle,carryWalk,carryRun,carryLookUp,carryCrouch,carryJump,carryFall,carryBonk,carryKick,carryAirKick,roll,carrySwim,pushing,balancing,dive,fireToss,electrocute,gateClimbing,flagPole,hang,monkeyBars,boarding,snowBoarding,frozen,downPipeEnter,downPipeExit,upPipeEnter,upPipeExit,sidePipeEnter,sidePipeExit,doorEnter,doorExit",",");
sound_list=split_string("airdash,damage,die,jump,release,skid,spin,spindash,bounce",",");

#define create
jump = 0;
slopesliding = 0;
no_move = 0;
//accel = 0.046875
//fastaccel = 0.5 //deaccel
//fric = 0.046875
friction_mult = 1;
skidding = 0;
skiddir = 0;
storedxsc = 1;
//spindash = 0;
wait_timer = 0;
dusttimer = 0;
spindashTotal = 0;
//topspd = 3.5;
grav = 0.19
defaultgrav = grav
grow = 0;
state = "";
control_lock = 0;
real_sprite_angle = 0;
walljump = false;
airdash = false;
boundjump = 0;
activebound = false;
base_terminal_vel = terminal_vel;
kick = 0;

// wallrun junk
wallrunstored_hsp = 0;
wallrunstored_gsp = 0;

storeddir=0;
yvol=0;
wallrunperiod=0;

dead=0;
deadtimer=0;

rollup_factor = (0.078125 / 2)
rolldown_factor = (0.3125 / 2)
nonroll_factor = (0.105 / 2)

#define step_begin

// reset sprite angle
sprite_angle = real_sprite_angle;

// chearii: do speed updates BEFORE we hit a wall

// get the distance in total of the horizontal speed
wallrunstored_hsp = hsp;

#region Start Wallrunning
var _move = (right-left) 
if (_move!=0 || walljump) && !(grounded) && (vsp <= 0 || airdash) && (state!="wallrun") && !(activebound) && !(is_grabbing) && (abs(wallrunstored_hsp) > 1.5) {
	var coll=check_valid_wall(x+((hit_sizex+1)*xsc)+hsp,y-((hit_sizey-2)*ysc)+vsp,x+((hit_sizex+1)*xsc)+hsp,y-((hit_sizey-2)*ysc)+vsp)
	if (coll) {
		storeddir=esign(_move,xsc);
		var maxsp = 8;
		var minsp = 4;
		yvol=clamp(abs(max(wallrunstored_hsp,vsp)), minsp, maxsp) //get amount of upward velocity calculated from horizontal AND vertical speed
		if (airdash) {
			vsp = -yvol;
		}
		wallrunstored_gsp = 0;
		wallrunstored_hsp = 0;
		airdahs = false;
		state = "wallrun"
		walljump = false;
		no_move=true;
		wallrunperiod=5;
	}
}
#endregion

#define step
terminal_vel = base_terminal_vel

hit_sizex = 6
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
		hit_sizey = 12
	} break
}

if ((state == "jump" && !is_grabbing) || state == "roll" || state == "spindash" || state == "crouch") && (size != "mini") {
	hit_sizey = 6
}

topspd = 3 + ((size != "mini") * 0.5) + ((invincible_type == 2) / 1.25);

maxspd = 11;
if (state == "roll") {
	maxspd = 9;
}

var no_move_prev = no_move;
if !(control_lock > 0 || state == "wallrun" || electrocuted || walljump || steep_slope) {
	no_move = false
}

if (hurt) {
	no_move = true;
}

can_grab = true;
if (state == "wallrun") || (state == "roll") || (state == "spindash") || (airdash) || (activebound) || (hurt) || (finish && posed && no_move_prev) {
	can_grab = false;
}

control_lock = max(0,control_lock - 1)

if !(piped) && !(electrocuted) && !(electrocution_timer) {
	
	#region Fire Projectile
	
	if (bpress) && (size=="fire") && (has_fired < 2) && (state != "roll") && (state != "wallrun"){
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
		if (activebound) {
			terminal_vel = 8;
		}
		component_gravity_coneyor()
		skidding = 0;
		// Switch direction
		//add more checks here to prevent left/right changing direction
		var _move = 0
		if !(no_move) {
			_move = (right - left);
		}
		if (left || right) && !(piped) {
			xsc = esign(_move, xsc)
		}
	} else {
		walljump = false
		canjump = 5;  // Coyote frames
		
		if (hurt) {
			hurt = false;
			if !(was_frozen) {
				invincible_type = 1;
				invincible_timer = 75;
			}
		}
		
		if !(hurt) {
			canstopjump = false
		}
		
		if (state == "") {
			component_sonic_skid()
			if (skidding) {
				dusttimer = min(dusttimer + 1, (dusttimer + 1) mod 7);
				if (dusttimer == 1) {
					var part = pSkidDust
					make_particle(part, x - (1 * xsc), y + hit_sizey, depth + 5, xsc, (1.25) * -xsc, -0.1, -0.02, 0.2); 
				}
			}
		}
		
		//add more checks here to prevent left/right changing direction
		if (left || right) && !(state == "spindash") {
			xsc = esign(gsp, xsc)
		}
		
		#region Crouch, Spindash
		if (state == "" && down && abs(gsp) <= 0.5 && !piped) {
			state = "crouch"
		}
		
		if (state == "crouch") && !(piped) {
			no_move = true
			if (!down) {
				state = ""
			}
			
			if (apress || bpress || cpress && abs(gsp) <= 0.5) && !(is_grabbing) {
				component_sonic_start_spindash()
			}
		}
		
		if (state == "spindash") && !(piped) {
			component_sonic_spindash()
		}
		#endregion
		
		//handles slope influence
		if !(piped) {
			if (state == "roll") {
				player_slide_sonic(nonroll_factor, true, rollup_factor, rolldown_factor);
			}
			
			if (steep_slope) { //slide down steep slopes
				gsp -= (0.225 * dsin(colangle))
			} else {
				if (state != "roll") && !(piped) {
					player_slide_sonic(nonroll_factor, false, rollup_factor, rolldown_factor);
				}
			}
		}
	}
}
	
#region Jumping
if (state == "jump") && !(piped) && !(hurt) && (state!="spindash") {
	slopesliding = 0
	
	#region Bound Jump
	if (cpress && vsp >= -2.6 && !activebound) && !(is_grabbing) && !(airdash) {
		activebound = true;
		afterimage = true;
		walljump = false;
		vsp = 8;
		hsp = (hsp / 2);
		stopsfx("sonicbounce")
		playsfx("sonicbounce")
	}
	#endregion
	
	if (((!akey && !boundjump) || (!ckey && boundjump)) && vsp < -2.6 && !canstopjump) { //Make player jump lower when jump is released
		vsp = -2.6;
	}
	
	#region Air Dash
	if (apress) && !(airdash) && !(is_grabbing) && !(walljump) {
		if (vsp < -2.6) {
			vsp = -2.6;
		}
		playsfx("sonicairdash")
		airdash = true;
		var _move = (right-left)
		if (_move == 0) {
			_move = xsc	
		}
		var divisi = max(1,abs(hsp)/3)
		var dash_speed = 3/divisi;
		hsp += (dash_speed * _move);
	}
	#endregion
}

if (state == "" || state == "roll") && (apress) && (canjump > 0) && !(piped) {
	var speed_bonus = min((abs(hsp) / 5) * 0.3, 1.3)
	component_sonic_start_jump(5.2 + speed_bonus)
	airdash = false;
}
#endregion

#region Wallrunning

if (state == "wallrun") && !piped {
	canstopjump=true;

	no_move=true;
	move=storeddir;
	if (round(vsp) >= 0) {
		vsp=0
		wallrunperiod=max(0,wallrunperiod-1);
	} else {
		var wallfric=0.15
		yvol=max(-7, yvol-wallfric)
		vsp= -yvol
	}
	
	var coll=check_valid_wall(x+((hit_sizex+1)*xsc)+hsp,y-((hit_sizey-2)*ysc)+vsp,x+((hit_sizex+1)*xsc)+hsp,y-((hit_sizey-2)*ysc)+vsp)
	
	if !(coll) || (grounded) || !(wallrunperiod) {
		state = "";
		storedvsp=0;
		storeddir=0;
		walljump=false;
	}
	
	if (apress) {
		walljump=true;
		control_lock=15;
		wallrunstored_hsp *= 0.75;
		hsp = -3.5*esign(storeddir,xsc)
		vsp = -5.5
		move = -move
		canstopjump=true;
		xsc = esign(hsp,xsc)
		no_move=true;
		alarm_set(2,15);
		playsfx(charmName+"jump",1,0,1)
		state = "jump";
		airdash = false;
		storedvsp=0;
		storeddir=0;
		wallrunperiod=5;
	}
}
#endregion



#region Rolling
//not rolling stats
if (state != "roll" || !grounded) && !(piped) {
	accel = 0.046875
	fastaccel = 0.4 //deaccel
	fric = 0.046875
	if (!grounded) {
		accel = 0.09375
		fastaccel = 0.09375
	}
}


if (state == "" || state == "crouch" || state == "spindash") && (grounded && down && abs(gsp) > 1 ) && !(is_grabbing) && !(piped) {
	stopsfx(charmName+"spin")
	playsfx(charmName+"spin")
	state = "roll"
}

if (state == "roll" && grounded) && !(piped) {
	component_sonic_roll()
} else {
	component_sonic_standing()
}
#endregion



fric = fric * friction_mult;
	
player_movement_sonic();
basic_step_move();
post_wall();

component_get_ground_friction()
if (!skidding) {
	if ((ceil(abs(hsp))>3 && grounded && state == "")) {
		dusttimer = min(dusttimer + 1, (dusttimer + 1) mod (10 - floor(abs(gsp)-3)));
		if (dusttimer == 1) {
			var part = pRunDust
	
			var i=instance_create_depth(x - (1 * xsc), y + hit_sizey, 0, part);
			i.depth = (depth + 5);
			i.image_xscale = xsc;
			i.hspeed = -2.25 * xsc;
			i.friction =0.2;
			i.vspeed = -0.1;
			i.gravity = -0.02;
		}
	}
}

// check to see if we need to update the polybox
if (sprindex_prev != sprite_index) {
	//obj_update_poly_from_bounding(self);
	sprindex_prev = sprite_index;
}

bonk=max(0,bonk-1)	
grow=max(0,grow-1);
kick=max(0,kick-1);

#define draw
#region Sprite Manager

frspd=1

real_sprite_angle = sprite_angle;

switch (state) {

	case "": {
		if (abs(gsp) == 0) {
			if !(is_grabbing) {
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
				spriteEvent="carryIdle"
				if (up) {
					spriteEvent="carryLookUp"
				}
			}
		} else {
			wait_timer = 0;
			
			if !(is_grabbing) {
				if (!skidding) {
					//icy slippy
					var speed_mult = 1;
					if (friction_mult>0) && (grounded) {
						speed_mult = 1/(friction_mult);
					}
				
					if (ceil(abs(gsp))>=3.4) {
						frspd=(abs(gsp)/4)*speed_mult;
						spriteEvent="run";
					}
					else if (ceil(abs(gsp))>=5.9){
						frspd=max(0.3, abs(gsp)/4)*speed_mult;
						spriteEvent="maxrun";
					}
					else {
						frspd=max(0.3, abs(gsp)/4)*speed_mult;
						spriteEvent="walk";
					}
				} else {
					spriteEvent="brake";
				}
			} else {
				var speed_mult = 1;
				if (friction_mult>0) && (grounded) {
					speed_mult = 1/(friction_mult);
					frspd=max(0.3, abs(gsp)/4)*speed_mult;
					spriteEvent="carryWalk";
				}
			}
		}
	} break;
	case "crouch": {
		if !(is_grabbing) {
			spriteEvent="crouch";
		} else {
			spriteEvent="carryCrouch";
		}
	} break;
	case "jump": {
		if !(is_grabbing) {
			spriteEvent="jump";
			if (airdash) {
				spriteEvent="airDash"
			}
			if (walljump) {
				spriteEvent="wallJump"
			}
			if (bonk) {
				spriteEvent="bonk";
			}
		} else {
			spriteEvent="carryJump";
			if (vsp>0) {
				spriteEvent="carryFall";
			}
			if (bonk) {
				spriteEvent="carryBonk";
			}
		}
	} break;
	case "roll": {
		if (state == "roll") {
			frspd=0.2+abs(gsp)/3;
			spriteEvent="roll";
		}
	} break;
	case "spindash": {
		spriteEvent="spinDash";
	} break;
	case "wallrun": {
		frspd=abs(vsp)/4;
		spriteEvent = "wallRun"
	} break;
	case "boarding":
		spriteEvent="snowBoarding";
	break;
	case "frozen":
		spriteEvent="frozen";
	break;
}

if (kick) {
	if (grounded) {
		spriteEvent="carryKick"
	} else {
		spriteEvent="carryAirKick"
	}
}

if (state != "") {
	wait_timer = 0;
}

if (hurt) {
	spriteEvent="hurt"
	if (dead) {
		spriteEvent="dead"
	}
}

if (electrocuted) {
	spriteEvent="electrocute"
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

//chopp: to handle any signals, make sure you define the code here with the same name 

#define on_kill
playsfx(charmName+"die")
give_lives(pNum, -1000, -1000, -1, -4, -4)
dead=1
deadtimer=240;
vspeed = -5;
gravity = 0.15;

#define death
deadtimer=max(0,deadtimer-1);

//so the camera doesnt move
if (my_camera) {
	my_camera.locked = true;
}

//complete the death animation and restart the level
if !(deadtimer) {
	finish_death();
}

#define mushroom
VinylPlay(asset_get_index("snd_powerup"))
if (size == "basic" || size == "mini") {
	oldsize = size;
	size = "big";
	grow = 60;
}

#define fireflower
VinylPlay(asset_get_index("snd_powerup"))
oldsize = size;
size = "fire";
grow = 60;

#define thunderflower
VinylPlay(asset_get_index("snd_powerup"))
oldsize = size;
size = "thunder";
grow = 60;

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

#define floor_land
if (invincible_type != 2) && (state != "roll") && (state != "spindash") {
	stompCombo = 0;
}

canstopjump = false;
if (state!="wallrun") && (state!="frozen") && (state!="boarding") {
	state = "";
	make_particle(pSkidDust, x - 1, y + hit_sizey, depth + 5, 1, -2.25, -0.1, -0.02, 0.2);
	make_particle(pSkidDust, x + 1, y + hit_sizey, depth + 5, -1, 2.25, -0.1, -0.02, 0.2);
}
bonk = 0;
gsp = hsp;

//landing speed lol
if (abs(colangle) >= 24 && abs(colangle) <= 90)
{
    if (abs(colangle) >= 45)
	{
		gsp = (hsp + (vsp * -sign(dsin(colangle)) / 2))
	}else{
		gsp = (hsp + (vsp * -sign(dsin(colangle)) / 3.5))
	}
	gsp = min(abs(gsp), 5.25) * sign(gsp)
}

vsp = 0

airdash = false;

if (activebound) {
	var heights = [5.33,5.8,6.25]
	vsp -= heights[boundjump] * dcos(colangle);
	hsp -= heights[boundjump] * dsin(colangle);
	activebound = false;
	grounded = false;
	state = "jump"
	afterimage = false;
	boundjump = min(2, boundjump + 1);
} else {
	boundjump = 0;
}

#define sprung_up
canstopjump = true;
crouch = false;
if (state != "frozen") {
	state = "jump";
}
activebound = false;

#define enemy_stomped
vsp= -(4+akey*1.5)
walljump = false;

#define collide_with_enemy
var coll=check_hitbox_on_hitbox(id, oEnemy)
if (coll) && !(coll.no_dam) && (coll.phaseid!=id) {
	if ((state != "roll" && state != "spindash" && state != "jump") || (airdash) || (walljump) || coll.damage_on_contact) && !(invincible_type && invincible_timer) {
		if (coll.deal_dam) {
			stopsfx(charmName+"damage")
			hurt=1
			hsp = -2.25 * xsc
			vsp = -4
			canstopjump=true
			state=""
			grounded=false
			activebound = false;
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
	} else if (state == "spindash") || (state == "roll") || (state == "jump") {
		signal_emit(coll.enemyRolledInto, id);
		activebound = false;
	}
}


#define hurt_by_spike

stopsfx(charmName+"damage")
hurt= 1
hsp= -2.25 * xsc
vsp= -4
canstopjump=true
state=""
activebound = false;
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
activebound = false;
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

#define throw_object
if !(down) {
	kick=12;
}