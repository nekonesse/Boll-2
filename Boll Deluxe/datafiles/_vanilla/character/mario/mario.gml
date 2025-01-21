#define datalist
spriteEvents=split_string("idle,walk,run,wait,lookUp,crouchIdle,crouchWalk,crouchJump,crouchFall,crouchFireToss,crouchBonk,crouchFireToss,victory,hurt,dead,brake,jump,fall,bonk,runJump,runJumpFall,doubleJump,doubleJumpFall,doubleJumpBonk,wallSlide,wallJump,groundPound,groundPoundFall,slopeSlide,carryIdle,carryWalk,carryRun,carryLookUp,carryCrouch,carryJump,carryFall,carryBonk,carryKick,carryAirKick,roll,swim,swimPaddle,carrySwim,carryPaddle,spinJump,pushing,balancing,dive,bellySlide,fireToss,gateClimbing,flagPole,hang,monkeyBars,boarding,downPipeEnter,downPipeExit,upPipeEnter,upPipeExit,sidePipeEnter,sidePipeExit,doorEnter,doorExit",",");
sound_list=split_string("select,damage,die,jump,win,step,bonk",",");

#define create
slopesliding = 0;
no_move = 0;
fric = 0.07;
friction_mult = 1;
runvar = 0;
runjump = 0;
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
//invincible_type = 0;                                                                                //0 is off, 1 is hurt frames and 2 is invincibility
//invincible_timer = 0;

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
		if !(crouch) hit_sizey = 12
		else hit_sizey = 6
	} break
}

//if !invincibletimer {
//	switch (invincibletype) {
//		case 2 : {invincibletimer = 60 invincibletype = 1} break;
//		case 1 :
//		default: {invincibletimer = 0  invincibletype = 0} break;
//	}
//} else {
//	invincibletimer -= 1;
//	if !(global.roomTimer & 3) {
//		instance_create(random_range(x - 8, x + 8), random_range(y, y - hit_sizey), pShine)
//	}
//}

if (braking) xsc=brakedir
if !in_water()
maxspd = 2 + runvar + ((size != "basic" && !crouch) * 0.5) - (1.25*(crouch && grounded))
else maxspd = 1.5

#region PreventMovement
var no_move_prev = no_move;
no_move = 0;

if (state == "pound") || (alarm_get(2)) || (hurt) || (finish && posed && no_move_prev) {
	no_move = true;
}

#endregion
//add more checks here

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

if (state == "" || state == "jump") && !piped && !electrocuted && !electrocution_timer {
	if in_water() {
		grav=defaultgrav/4
	} else grav=defaultgrav
	
	if (bkey) && !(crouch) {
		run=1.5;
	} else {
		run = 0;
	}
	
	#region Fire Projectile
	
	if (bpress) && (size=="fire") && (has_fired < 2) && !(slopesliding) {
		var proj=instance_create_depth(x+(hit_sizex+3)*xsc,y+hit_sizey-12,2,oFireball)
		proj.hsp=2.5*xsc
		proj.vsp=2
		proj.owner=id
		VinylPlay(asset_get_index("snd_fireball"))
		
		has_fired+=1;
		frame=0;
		firing=15;
	}
	
	#endregion
	
	if (!grounded) {
		vsp = min(4, vsp + grav);
		canjump = max(0, canjump-1);
		
		// chearii: coneyor speed management
		if (abs(chsp * 100))
		{
			chsp *= 0.95;
			
			if (((chsp * 100) / 1) == 0)
			chsp = 0;
		}

		if (skidding) {
			stopsfx(charmName+"skid")
			skidding=0
		}
	} else {
		if (state == "") && (down) && !(piped) && !(skidding) {
			crouch=true;
		} else {
			if (!check_collision_line(x-hit_sizex,y-hit_sizey-8,x+hit_sizex,y-hit_sizey-8,COL_TOP) || size=="basic") {
				crouch = false
			}
		}
		
		hurt = false
		canjump = 5;  // Coyote frames
		runjump = 0;
	
		//maximum speed when sliding, infulence when sliding, influence on steep slopes, add steep influence while sliding?
		player_slide(12.5, 0.225, 0.32, false);
		
		//skidding
		if (((abs(gsp) >= 3) || skidding) && move != 0 && !check_signs_matching(gsp,move) && !crouch && !carrying) {
			if (!skidding) {
				skiddir = esign(move,xsc)
				dusttimer = 0;
				playsfx(charmName+"skid",1,1,0.75)
			}
			skidding = 1;
		}
		else if (skidding) {
			stopsfx(charmName+"skid")
			skidding=0
		}
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
if (state == "pound") && !piping {
	slopesliding = 0
	pound_timer = max(0,pound_timer-1);
	
	if (up) {
		state = "";
		pound_timer = 0;
	}
	
	if (pound_timer > 0) {
		hsp=0;
		grav=0;
		vsp = 0;
	} else {
		grav = defaultgrav;
		vsp = 7;
		pound_severity = vsp;
		hsp = 0;
	}
	
	//hittable block collision
	if (grounded) && (pound_timer <= 0) {
		var blocklist=ds_list_create();
		var num=collision_line_list(x-hit_sizex,y+hit_sizey+vsp+2,x+hit_sizex,y+hit_sizey+vsp+2,oHittable, false, true, blocklist, true)
		
		found_block=false;
		if (num > 0) {
			for (var i = 0; i < num; i+=1) {
				var blockcoll=ds_list_find_value(blocklist, i)
				if !(blockcoll.no_hit) && (pounding_block == true) && (blockcoll.amount != 0) {
					if (blockcoll.hit == 0) {
						found_block=true;
						signal_emit(blockcoll.blockHit, 1, id)
					}
				}
			}
			pounding_block = false
		}
		
		if !found_block {
			state = ""
			vsp = 0
			//create pound smoke
			var i=instance_create_depth(x-1, y + hit_sizey, 0, pSmoke);
			i.depth = (depth + 5);
			i.image_xscale = 1;
			i.hspeed=-3.25;
			i.friction=0.2;
			i.vspeed=-0.2;
			i.gravity=-0.04;
			var i=instance_create_depth(x+1, y + hit_sizey, 0, pSmoke);
			i.depth = (depth + 5);
			i.image_xscale = -1;
			i.hspeed=3.25;
			i.friction=0.2;
			i.vspeed=-0.2;
			i.gravity=-0.04;
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
if (state == "jump" || state == "") && !(grounded) && !piped {
	if in_water() state=""
	
	if (!akey && vsp < -2 && !canstopjump) //Make player jump lower when jump is released
	{
		vsp *= 0.6;
	}
	
	if (downpress) {
		pound_timer = 10
		state = "pound"
		playsfx(charmName+"pound")
		pounding_block = true
	}
	
	if (!alarm_get(2)) {
		steep_slope = false;
	}
	
	if (move != 0) && !(crouch) {
		//wall sliding
		var coll=check_collision_line(x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc),x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc),COL_WALL)
		if (!grounded) && (coll) && (vsp > 0){
			state = "wallslide"
		}
	}
}

if ((state == "" || state=="crouch") && apress && (canjump > 0 || underwater)) && !piped {
	grounded = false
	if (slopesliding) {
		crouch = false
	}
	if !in_water() {
		state = "jump"
		vsp = -(5.25+min(1,abs(hsp)/10)+(bool(poundjump)+0.5)); //preform the actual jump
		playsfx(charmName+"jump",1+(bool(poundjump)/4),0,1)
		if ((run && abs(hsp)>3) && !wallsliding) {
			//visual maxspeed jump
			runjump=1
		}
		canjump = 0;
		//Jump Particles
		if (poundjump) {
	 		var i=instance_create_depth(x-10,y-8,0,pSmoke);
			i.vspeed=-1;
			var i=instance_create_depth(x+8,y-8,0,pSmoke);
			i.vspeed=-1;
		}
		var i=instance_create_depth(x, y + hit_sizey, 0, pJumpDust);
		i.depth = (depth + 5);
		i.vspeed=(y-yprevious)/1.5
		i.friction=0.2
	} else { //swim
		vsp = -(2.25); //preform the actual jump
		playsfx(charmName+"swim",1,0,1)
		swim=24
	}
}
#endregion

#region Wallsliding

if (state == "wallslide") && !piped {
	vsp=1;
	var coll=check_collision_line(x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc),x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc),COL_WALL)
	
	if (move == 0 || !coll){
		state = "";
	}
	
	if (apress) {
		hsp=esign(move,xsc)*-2.5
		vsp=-5
		move=-move
		xsc=esign(hsp,xsc)
		no_move=true;
		alarm_set(2,12);
		playsfx(charmName+"jump",1,0,1)
		state = "jump";
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

if (grounded) {
	var i = instance_place(x, y + hit_sizey + 4,oCollider)
	if !is_undefined(i.my_friction) {
		friction_mult = i.my_friction;
	}
}

if ((ceil(abs(hsp))>3 || skidding) && grounded && state == "") {
	dusttimer = min(dusttimer + 1, (dusttimer + 1) mod 10);
	if (dusttimer == 1) {
		var part = pRunDust
		if (skidding) part = pSkidDust

		var i=instance_create_depth(x - (1 * xsc), y + hit_sizey, 0, part);
		i.depth = (depth + 5);
		i.image_xscale = xsc;
		i.hspeed=(2.25 - skidding) * -xsc;
		i.friction=0.2;
		i.vspeed=-0.1;
		i.gravity=-0.02;
	}
}

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

bonk=max(0,bonk-1)
poundjump=max(0,poundjump-1)
firing=max(0,firing-1)

runvar = approach_val(runvar,run,0.05)

grow = max(0, (grow - 1));

damagespecial = max(0, pound_severity);

swim = max(0, swim-1)

#define step_end

//player_grab();


#define draw

#region Sprite Manager
frspd=1

if (state == "") {
	if !(crouch) {
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
			}
			else {
				frspd=abs(hsp)/4
				if (frspd < 0.3) {
					frspd = 0.3;
				}
				spriteEvent="walk"
			}
		}
	} else {
		wait_timer = 0
		if (abs(hsp) < 0.25) {
			spriteEvent="crouchIdle"
		}
		else {
			spriteEvent="crouchWalk"
		}
	}
	
	if (!grounded) {
		if (vsp>0) {
			if !(crouch)  spriteEvent="fall"
			else spriteEvent="crouchFall"
		}
	}
	
	if (skidding) && !(crouch) {
		spriteEvent="brake" 
		xsc = -(skiddir)
	}
	
	if (in_water()) {
		if !swim
		spriteEvent="swim"
		else spriteEvent="swimPaddle"
	}

	if (finish && posed && no_move) {
		spriteEvent="victory"
	}
} else {
	wait_timer = 0
}
if (state == "jump") {
	if !(crouch)  spriteEvent="jump"
	else spriteEvent="crouchJump"
	if (vsp>0) { 
		if !(crouch)  spriteEvent="fall"
		else spriteEvent="crouchFall"
	}
	if (runjump) && !(crouch) spriteEvent="runJump"
	if (bonk) {
		if !(crouch)  spriteEvent="bonk"
		else spriteEvent="crouchBonk"
	}
}

if (slopesliding) {
	spriteEvent="slopeSlide"
}

if (state == "pound") {
	if (pound_timer > 0) spriteEvent="groundPound" else spriteEvent="groundPoundFall"
}

if (state == "wallslide") {
	spriteEvent="wallSlide"
}

if (firing) {
	if !(crouch) {
		spriteEvent="fireToss"
	} else spriteEvent="crouchFireToss"
}

if (hurt) {
	spriteEvent="hurt"
	if (dead) {
		spriteEvent="dead"
	}
}

if (electrocuted) {
	spriteEvent="hurt"
}
#endregion

#define upd_frame
if spriteEvent=="crouchIdle" {
	if oldSpriteEvent=="crouchWalk" || oldSpriteEvent=="crouchJump" || oldSpriteEvent=="crouchFall" || oldSpriteEvent=="crouchBonk" || oldSpriteEvent=="crouchFireToss" {
		var spri = get_spritenum(spriteEvent)
		frame = loops_list[spri]-1
	}
}

#define on_kill
stopsfx(charmName+"skid")
playsfx(charmName+"die")
dead=1
deadtimer=240;
deadgo=0;
gotimer=30;
vspeed=0;
gravity=0;

#define death
gotimer=max(0,gotimer-1);
deadtimer=max(0,deadtimer-1);

//wait for 'stun' animation and then start falling
if !(gotimer) && !(deadgo) {
	deadgo=1;
	vspeed=-4.5;
	gravity=0.15;
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
invincible_type = 2;                                                                               
invincible_timer = 510;

#define ceil_bonk
bonk = 12

#define floor_land
gsp = hsp

var i=instance_create_depth(x - 1, y + hit_sizey, 0, pSkidDust); //should prooobably get some kind of particle spawning function in later. too many giant blocks of particle here.
i.depth = (depth + 5);
i.image_xscale = 1;
i.hspeed=-2.25
i.friction=0.2;
i.vspeed=-0.1;
i.gravity=-0.02;
var i=instance_create_depth(x + 1, y + hit_sizey, 0, pSkidDust);
i.depth = (depth + 5);
i.image_xscale = -1;
i.hspeed=2.25
i.friction=0.2;
i.vspeed=-0.1;
i.gravity=-0.02;

#region Groundpound Land
if (state == "pound") {
	poundjump = 16;
	show_debug_message(colslope);
	if colslope != 0 {
		slopesliding = 1
		gsp = (-8 * dsin(colangle)) 
	}
	playsfx(charmName+"stomp");
} else {
	state = ""
	vsp = 0
}
#endregion
canstopjump = false


#define sprung
state = "jump";
crouch = false
canstopjump = true

#define enemy_stomped
if (state != "groundpound") {
	vsp=-4-akey*1.5
}

#define collide_with_enemy
var coll=check_hitbox_on_hitbox(id, oEnemy)
if (coll) && !(coll.no_dam) && (coll.phaseid!=id) {
	
if (coll) && !(slopesliding) {
	stopsfx(charmName+"damage")
	hurt=1
	hsp=2.25*-xsc
	vsp=-4
	canstopjump=true
	state=""
	grounded=false
	oldsize = size;
	switch (size) {
		case "basic":
		case "mini":
			signal_emit(sig, "on_kill", charmName)
			break;
		case "big":
			size = "basic";
			playsfx(charmName+"damage")
			break;
		default:
			size = "big";
			playsfx(charmName+"damage")
			break;
	}
	grow = 60;
} else {
	instance_create_depth(coll.x+coll.xsc,coll.y,2,pImpact)
	coll.hp-=1
	coll.phaseid=id
	coll.killdir=esign(coll.x-x,1)
	coll.killhsp=max(abs(hsp)/1.75,2)
	coll.xsc=esign(hsp,xsc)
	coll.killvsp=-max(2,abs(hsp)/1.5)
	coll.killtype="spin"
}
}

#define hurt_by_spike
stopsfx(charmName+"damage")
hurt=1
hsp=2.25*-xsc
vsp=-4
canstopjump=true
state=""
grounded=false
oldsize = size;
switch (size) {
	case "basic":
	case "mini":
		signal_emit(sig, "on_kill", charmName)
		break;
	case "big":
		size = "basic";
		playsfx(charmName+"damage")
		break;
	default:
		size = "big";
		playsfx(charmName+"damage")
	break;	
}	
grow = 60;

#define electrocute
state=""
electrocuted = true;
electrocution_timer=60;

#define hurt_by_electrocution
stopsfx(charmName+"damage")
electrocuted = false;
hurt=1
hsp=2.25*-xsc
vsp=-4
canstopjump=true
state=""
grounded=false
oldsize = size;
switch (size) {
	case "basic":
	case "mini":
		signal_emit(sig, "on_kill", charmName)
		break;
	case "big":
		size = "basic";
		playsfx(charmName+"damage")
		break;
	default:
		size = "big";
		playsfx(charmName+"damage")
		break;
}
grow = 60;


#define stomp_failed
show_debug_message("stomp_failed called")