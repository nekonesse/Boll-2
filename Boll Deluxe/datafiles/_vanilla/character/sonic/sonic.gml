#define datalist
spriteEvents=split_string("idle,wait,lookUp,pose,crouch,knock,dead,walk,run,runMax,brake,spring,springFall,jump,bonk,ball,spinDash,spinCharge,dropDash,carryIdle,carryWalk,carryRun,carryLookUp,carryCrouch,carryJump,carryFall,carryBonk,carryKick,carryAirKick,roll,carrySwim,pushing,balancing,dive,fireToss,gateClimbing,flagPole,hang,monkeyBars,boarding,downPipeEnter,downPipeExit,upPipeEnter,upPipeExit,sidePipeEnter,sidePipeExit,doorEnter,doorExit",",");
sound_list=split_string("select,damage,die,jump,win,step,bonk,release,skid,spin,spindash,insta,dash,boom,firedash,dropdash",",");

#define create
jump = 0;
slopesliding = 0;
no_move = 0;
//accel = 0.046875
//fastaccel = 0.5 //deaccel
//fric = 0.046875
skidding = 0;
skiddir = 0;
storedxsc = 1;
grav=0.225;
defaultgrav = grav;
//spindash = 0;
spindashTotal = 0;
topspd = 4.5;
grow = 0;
state = "";
control_lock = 0;
dropdash_spd = 6;
max_dropdash_spd = 9;
dropdash = 0;
dropdash_timer = 0;

#define step

switch (size) {
	case "basic": {
		hit_sizey = 6
	} break
	case "mini": {
		hit_sizey = 3
	} break
	default: {
		hit_sizey = 12
	} break
}
if (state == "jump" || state == "roll" || state == "spindash") && (size != "mini") {
	hit_sizey = 6
}

if (braking) xsc=brakedir
topspd = 4 + ((size != "basic" || size != "mini") * 0.5);
maxspd = 12.5;
no_move = false
//add more checks here
var rolling = false
if (state == "roll") {
	rolling = true
}

if (control_lock > 0 || hurt) no_move = true


if !(piped) && !(electrocuted) && !(electrocution_timer) {
	
// Fall off platform
if (!grounded) {
	vsp = min(7, vsp + grav);
	canjump -= 1;
	
	if (vsp < 0 && vsp > -2 ) {
		hsp -= hsp / 32
	}
	// chearii: coneyor speed management
	if (abs(chsp * 100))
	{
		chsp *= 0.95;
		
		if (((chsp * 100) / 1) == 0)
		chsp = 0;
	}
	// Switch direction
	//add more checks here to prevent left/right changing direction
	if (left || right) && !(piped) {
		xsc = esign(move, xsc)
	}
} else {
	hurt = false
	canjump = 5;  // Coyote frames
	if !(hurt) canstopjump = false
	//add more checks here to prevent left/right changing direction
	if (left || right) && !(state == "spindash") {
		xsc = esign(gsp, xsc)
	}
	
	#region Crouch, Spindash
	if (state == "") && (down) && (abs(gsp) <= 0.5) && !(piped){
		state = "crouch"
	}
	
	if (state == "crouch") && !(piped) {
		no_move = true
		if (!down) state = ""
		
		if (apress || bpress || cpress) && (abs(gsp) <= 0.5) {
			state = "spindash"
			spindashTotal = 0
			playsfx(charmName+"spindash",1+(spindashTotal/10))
		}
	}
	
	if (state == "spindash") && !(piped) {
		no_move = true
		spindashTotal -= spindashTotal / 32
		if (apress || bpress || cpress) {
			frame = 0
			spindashTotal = min(spindashTotal + 2, 8)
			show_debug_message(spindashTotal)
			stopsfx(charmName+"spindash")
			playsfx(charmName+"spindash",1+(spindashTotal/10))
		}
		
		if (!down || !(abs(gsp) <= 0.5)) {
			state = "roll"
			gsp = (4 + (floor(spindashTotal) / 2.5)) * xsc
			//apply spindash speed based off amount of spindash presses
			stopsfx(charmName+"spindash")
			playsfx(charmName+"release")
		}
	}

	#endregion
	control_lock= max(0,control_lock - 1)
	//handles slope influence
	if (state == "roll") && !(piped) {
		player_slide_sonic(0.125, rolling, 0.078125, 0.3125);
	}
	
	if (steep_slope) && (state == "" || state == "crouch" || state == "spindash") { //slide down steep slopes
		gsp -= (0.225 * dsin(colangle))
		no_move = 1
	}
}

}
	
#region Jumping
if (state == "jump") && !(piped){
	slopesliding = 0
	if (!akey && vsp < -2 && !canstopjump) //Make player jump lower when jump is released
	{
		vsp = -2
	}

	if (vsp >= -2 && apress && dropdash == 0) {
		dropdash = 1
	}

	if (dropdash == 1) {
		if (akey){
			dropdash_timer++
			if (dropdash_timer == 18) {
				playsfx("sonicdropdash")
			}
		} else {
			stopsfx("sonicdropdash")
			dropdash = 2
			dropdash_timer = 0
		}
	}
	
}

if (state == "" || state == "roll") && (apress) && (canjump > 0) && !(piped){
	state = "jump"
	grounded = false
	colangle = colangle * 0.9
	vsp -= (6) * dcos(colangle/8);
	hsp -= (6) * dsin(colangle);
	playsfx(charmName+"jump",1,0,1)
	canjump = 0;
	control_lock = 0;
}

#endregion

#region Rolling
if (state != "roll" || !grounded) && !(piped) {
	accel = 0.0425
	if (!grounded) {
		accel = 0.09375
		fastaccel = 0.09375
	}
	fastaccel = 0.45 //deaccel
	fric = 0.0425
}


if (state == "" || state == "crouch" || state == "spindash") && (grounded && down && abs(gsp) > 1 ) && !(piped) {
	stopsfx(charmName+"spin")
	playsfx(charmName+"spin")
	state = "roll"
}

if (state == "roll" && grounded) && !(piped) {
	accel = 0
	if (sign(gsp) == move_dir) {
		if (sign(gsp) == -1){
			gsp = min(0, gsp + fric)
		}else{
			gsp = max(0, gsp - fric)
		}
	}
	fastaccel = 0.125
	fric = 0.0234375
	//taken from the sonic physics guide
	if abs(gsp) < 0.5 {
		state = ""
	}
}
#endregion

	
player_movement_sonic();
player_interactions();
player_collision();
post_wall();

// check to see if we need to update the polybox
if (sprindex_prev != sprite_index) {
	//obj_update_poly_from_bounding(self);
	sprindex_prev = sprite_index;
}

bonk=max(bonk,bonk-1)

grow = max(0, (grow - 1));

#define draw
#region Sprite Manager

frspd=1

if (state == "") {
	if (ceil(abs(gsp))>3) {
		frspd=abs(gsp)/4
		spriteEvent="run"
	}
	else if !(abs(gsp)){ 
		spriteEvent="idle"
	}
	else {
		frspd=abs(gsp)/4
		spriteEvent="walk"
	}
}

if (state == "roll" || state == "jump") {
	if state!="jump" frspd=0.2+abs(gsp)/3
	else frspd=1
	spriteEvent="ball"
	if (bonk) {
		frspd=1
		spriteEvent="bonk"
	}
}

if (state == "spinDash") {
	spriteEvent="spinDash"
}

if (hurt) {
	spriteEvent="knock"
	if (dead) {
		spriteEvent="dead"
	}
}
#endregion

//chopp: to handle any signals, make sure you define the code here with the same name 

#define on_kill
playsfx(charmName+"die")
dead=1
deadtimer=240;
vspeed=-5;
gravity=0.15;

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
show_debug_message("eatted it :)");
if (size != "fire") {
	oldsize = size;
	size = "big";
	grow = 60;
}

#define fireflower
show_debug_message("dranked it :)");
oldsize = size;
size = "fire";
grow = 60;

#define ceil_bonk
bonk = 12

#define floor_land
canstopjump = false;
state = "";
bonk = 0;
gsp = hsp
//landing speed lol
if (colangle < 0) colangle += 360
show_debug_message(colangle)

if (colangle >= 24 && colangle <= 90)
{
    if (colangle >= 45)
	{
		if (abs(hsp) <= abs(vsp)) {
			gsp = vsp * -sign(dsin(colangle))
		}
		
	}else{
		if (abs(hsp) <= abs(vsp/2)) {
			gsp = vsp * 0.5 * -sign(dsin(colangle))
		}
	}
}

if (colangle <= 336 && colangle >= 270)
{
	if (colangle <= 315)
	{
		if (abs(hsp) <= abs(vsp)) {
			gsp = vsp * -sign(dsin(colangle))
		}
	}else{
		if (abs(hsp) <= abs(vsp/2)) {
			gsp = vsp * 0.5 * -sign(dsin(colangle))
		}
	}
}

if (dropdash == 1 && dropdash_timer >= 18) {
	stopsfx("sonicdropdash")
	playsfx("sonicrelease")
	if (sign(hsp) == move_dir) {
		gsp = (gsp / 4) + (dropdash_spd * move_dir)
	} else {
		if (colangle == 0) {
			gsp = dropdash_spd * move_dir
		} else {
			gsp = (gsp / 2) + (dropdash_spd * move_dir)
		}
	}
	state = "roll";
	gsp = clamp(gsp,-max_dropdash_spd, max_dropdash_spd)
	
}
dropdash_timer = 0
dropdash = 0
	
vsp = 0

#define sprung
canstopjump = true;
state = "spring";

#define enemy_stomped
vsp=-4-akey*1.5

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