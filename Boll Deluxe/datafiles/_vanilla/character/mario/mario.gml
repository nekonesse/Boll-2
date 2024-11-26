#define datalist
spriteEvents=split_string("idle,walk,run,wait,lookUp,crouch,victory,hurt,dead,brake,jump,fall,bonk,runJump,runJumpFall,doubleJump,doubleJumpFall,doubleJumpBonk,wallSlide,wallJump,groundPound,groundPoundFall,slopeSlide,carryIdle,carryWalk,carryRun,carryLookUp,carryCrouch,carryJump,carryFall,carryBonk,carryKick,carryAirKick,roll,swim,swimPaddle,carrySwim,carryPaddle,spinJump,pushing,balancing,dive,bellySlide,fireToss,gateClimbing,flagPole,hang,monkeyBars,boarding,downPipeEnter,downPipeExit,upPipeEnter,upPipeExit,sidePipeEnter,sidePipeExit,doorEnter,doorExit",",");
sound_list=split_string("select,damage,die,jump,win,step,bonk",",");

#define create
slopesliding = 0;
no_move = 0;
fric = 0.07;
runvar = 0;
runjump = 0;
dusttimer = 1;
skidding = 0;
skiddir = 0;
pound_timer = 0;
storedxsc = 1;
poundjump = 0;
grow = 0;
state = "";
groundpound_land=false;
pounding_block = false;

#define stop
hsp = 0;
gsp = 0;
vsp = 0;
state = "";
no_move = 1;

//chopp: oops rewriting the entire players script
#define step

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
		hit_sizey = 12
	} break
}

if (braking) xsc=brakedir
maxspd = 2 + runvar + ((size != "basic") * 0.5);

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
	grav = defaultgrav;
	
	if (bkey) {
		run=1.5;
	} else {
		run = 0;
	}
	
	if (bpress) && (size=="fire") && !(has_fired) {
		var proj=instance_create_depth(x+(hit_sizex+3)*xsc,y+hit_sizey-8,2,oFireball)
		proj.hsp=2.5*xsc
		proj.vsp=-2
		proj.owner=id
		
		has_fired+=1;
	}
	
	if (!grounded) {
		vsp = min(4, vsp + grav);
		canjump -= 1;
		
		// chearii: coneyor speed management
		if (abs(chsp * 100))
		{
			chsp *= 0.95;
			
			if (((chsp * 100) / 1) == 0)
			chsp = 0;
		}
	} else {
		hurt = false
		canjump = 5;  // Coyote frames
		runjump = 0;
	
		//maximum speed when sliding, infulence when sliding, influence on steep slopes, add steep influence while sliding?
		player_slide(12.5, 0.225, 0.32, false);
		
		//temp skidding
		if (sign(gsp)!=esign(move,xsc)) {
			if (abs(hsp)>2 && !carry && !skidding) {
				skidding=1
				//playsfx(name+"skid",1)
				skiddir=esign(move,xsc)
			}
		} else {
			skidding=0
		}
	}
}

if (state == "") && !(hurt) {
	canstopjump = false
	if (!abs(sign(colslope)) && (abs(hsp) < 0.25)){
		slopesliding = 0
		crouch = 0
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
		hsp = 0;
	}
	
	//hittable block collision
	if (grounded) && (pound_timer <= 0) {
		var blocklist=ds_list_create();
		var num=collision_line_list(x-(hit_sizex-1),y+hit_sizey+vsp+2,x+(hit_sizex-1),y+hit_sizey+vsp+2,oHittable, false, true,blocklist, true)
		
		found_block=false;
		if (num > 0) {
			for (var i = 0; i < num; i+=1;) {
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
if (state == "jump" || state == "") && !(grounded) && !piped {
	slopesliding = 0
	crouch = 0
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
	
	if (move != 0) {
		//wall sliding
		var coll=check_collision_line(x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc),x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc),COL_WALL)
		if (!grounded) && (coll) && (vsp > 0){
			state = "wallslide"
		}
	}
}

if (state == "" && apress && canjump > 0) && !piped {
	state = "jump"
	grounded = false
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
	
player_movement();
player_interactions();
player_collision();
post_wall();

if (ceil(abs(hsp))>3 && grounded && state == "") {
	dusttimer = min(dusttimer + 1, (dusttimer + 1) mod 10);
	if (dusttimer == 1) {
		var i=instance_create_depth(x - (1 * xsc), y + hit_sizey, 0, pRunDust);
		i.depth = (depth + 5);
		i.image_xscale = xsc;
		i.hspeed=2.25 * -xsc;
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

runvar = approach_val(runvar,run,0.05)

grow = max(0, (grow - 1));

#define draw

#region Sprite Manager
frspd=1

if (state == "") {
	if (ceil(abs(hsp))>3) spriteEvent="run"
	else if !(round(abs(hsp))) {
		spriteEvent="idle"
	}
	else {
		frspd=abs(hsp)/4
		spriteEvent="walk"
	}
	
	if (!grounded) {
		if (vsp>0) spriteEvent="fall"
	}
	
	if (crouch) spriteEvent="crouch"
	
	if (skidding) {
		spriteEvent="brake" 
		xsc = -(skiddir)
	}

	if (finish && posed && no_move) {
		spriteEvent="victory"
	}
}

if (state == "jump") {
	spriteEvent="jump"
	if (vsp>0) spriteEvent="fall"
	if (runjump) spriteEvent="runJump"
	if (bonk) spriteEvent="bonk"
}

if (state == "pound") {
	if (pound_timer > 0) spriteEvent="groundPound" else spriteEvent="groundPoundFall"
}

if (state == "wallslide") {
	spriteEvent="wallSlide"
}

if (slopesliding) {
	spriteEvent="slopeSlide"
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

//chopp: to handle any signals, make sure you define the code here with the same name 

#define on_kill
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
if (size == "basic" || size == "mini") {
	oldsize = size;
	size = "big";
	grow = 60;
}

#define fireflower
oldsize = size;
size = "fire";
grow = 60;

#define thunderflower
oldsize = size;
size = "thunder";
grow = 60;

#define ceil_bonk
bonk = 12

#define floor_land
gsp = hsp
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
canstopjump = true

#define enemy_stomped
if (state != "groundpound") {
	vsp=-4-akey*1.5
}

#define hurt_by_enemy
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