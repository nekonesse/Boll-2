#define datalist
spriteEvents=split_string("idle,wait,lookUp,victory,crouch,hurt,dead,walk,run,runMax,wallRun,airWalk,brake,spring,springFall,jump,bonk,roll,spinDash,spinCharge,dropDash,carryIdle,carryWalk,carryRun,carryLookUp,carryCrouch,carryJump,carryFall,carryBonk,carryKick,carryAirKick,roll,carrySwim,pushing,balancing,dive,fireToss,electrocute,gateClimbing,flagPole,hang,monkeyBars,boarding,downPipeEnter,downPipeExit,upPipeEnter,upPipeExit,sidePipeEnter,sidePipeExit,doorEnter,doorExit",",");
sound_list=split_string("select,damage,die,jump,win,step,bonk,release,skid,spin,spindash,insta,dash,boom,firedash,dropdash",",");

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
grav=0.225;
defaultgrav = grav;
//spindash = 0;
wait_timer = 0;
dusttimer = 0;
spindashTotal = 0;
topspd = 4.5;
grow = 0;
state = "";
control_lock = 0;
dropdash_spd = 6;
max_dropdash_spd = 9;
dropdash = 0;
dropdash_timer = 0;
real_sprite_angle = 0;

// wallrun junk

// put this all in some Dumb Array
wallrundata = [ 0, 0, 0,
				0, 0, 0,
				0, 0, 0 ];

storeddir=0;
yvol=0;
wallrunperiod=0;


#define step_begin

// reset sprite angle
sprite_angle = real_sprite_angle;

// chearii: do speed updates BEFORE we hit a wall
// might lead to inconsistencies, but who cares?
wallrundata[0] = abs(hsp);
wallrundata[1] = abs((x - xprevious) div 1);
wallrundata[2] = sign(hsp);

wallrundata[3] = abs(vsp);
wallrundata[4] = abs((y - yprevious) div 1);
wallrundata[5] = sign(vsp);

// get the distance in total of the horizontal speed
wallrundata[6] = hsp;

// do the same for difference
wallrundata[7] = sqrt(wallrundata[1] * wallrundata[1]);

//ground speed
if (grounded) {
	wallrundata[8] = gsp;
}

#region Start Wallrunning
if (move!=0) && (vsp < 0) && (state!="wallrun") && (abs(wallrundata[8]) > 1) {
	//wall sliding
	var coll=check_collision_line(x+((hit_sizex+4)*xsc),y-((hit_sizey-2)*ysc),x+((hit_sizex+4)*xsc),y-((hit_sizey-2)*ysc),COL_WALL)
	if (!grounded)
	{
		if (coll)
		{
			storeddir=move;
			var maxsp = 8;
			var minsp = 4;
			yvol=median(abs(wallrundata[6]), minsp, maxsp) //get amount of upward velocity calculated from horizontal AND vertical speed
			state = "wallrun"
			no_move=true;
			wallrunperiod=5;
		}
	}
}
#endregion

#define step
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

if (state == "jump" || state == "roll" || state == "spindash") && (size != "mini") {
	hit_sizey = 6
}

if (braking) xsc=brakedir
topspd = 4 + ((size != "basic" || size != "mini") * 0.5);
maxspd = 12.5;
//add more checks here
var rolling = false
if (state == "roll") {
	rolling = true
}

if !(control_lock > 0 || state == "wallrun" || electrocuted || walljump) no_move = false

if (hurt) {
	no_move = true;
}

control_lock = max(0,control_lock - 1)

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
	walljump = false
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
	vsp = -6
	
	var vd=point_direction(0,0,hsp,vsp)+point_direction(0,0,1,colslope)
    var vm=point_distance(0,0,hsp,vsp)
    hsp=lengthdir_x(vm,vd)
    vsp=lengthdir_y(vm,vd)
    //adjust vsp and hsp to slope angle influence
	
	playsfx(charmName+"jump",1,0,1)
	canjump = 0;
	control_lock = 0;
}
#endregion

#region Wallrunning

if (state == "wallrun") && !piped {
	canstopjump=true;

	no_move=true;
	move=storeddir;
	if round(vsp) >= 0 {
		vsp=0
		wallrunperiod=max(0,wallrunperiod-1);
	} else {
		var wallfric=0.15
		yvol=max(-7, yvol-wallfric)
		vsp=-yvol
	}
	
	if !(check_collision_dot(x+(hit_sizex+3)*xsc,y,COL_WALL)) || (grounded) || !(wallrunperiod) {
		state = "";
		//wallrundata[0]=0;
		storedvsp=0;
		storeddir=0;
		walljump=false;
	}
	
	if (apress) {
		walljump=true;
		control_lock=15;
		wallrundata[6] *= 0.75;
		hsp=-3.5*esign(move,xsc)
		vsp=-5.5
		move=-move
		canstopjump=true;
		xsc=esign(hsp,xsc)
		no_move=true;
		alarm_set(2,15);
		playsfx(charmName+"jump",1,0,1)
		state = "jump";
		storedvsp=0;
		storeddir=0;
		wallrunperiod=5;
	}
}
#endregion



#region Rolling
if (state != "roll" || !grounded) && !(piped) {
	accel = 0.0425
	if (!grounded) {
		accel = 0.09375
		fastaccel = 0.09375
	}
	fastaccel = 0.7 //deaccel
	fric = 0.055
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

fric = fric * friction_mult;
	
player_movement_sonic();
basic_step_move();
post_wall();

if (grounded) {
	var i = instance_place(x, y + hit_sizey + 4,oCollider)
	if !is_undefined(i.my_friction) {
		friction_mult = i.my_friction;
	}
}

if ((ceil(abs(hsp))>3 && grounded && state == "") || skidding) {
	dusttimer = min(dusttimer + 1, (dusttimer + 1) mod 10);
	if (dusttimer == 1) {
		var part = pRunDust
		if (skidding) part = pSkidDust

		var i=instance_create_depth(x - (1 * xsc), y + hit_sizey, 0, part);
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

bonk=max(bonk,bonk-1)

grow = max(0, (grow - 1));

#define draw
#region Sprite Manager

frspd=1

real_sprite_angle = sprite_angle;

switch (state) {

	case "": {
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
			wait_timer = 0;
			if ((abs(gsp) > 2.5) && (move_dir == -sign(gsp))) {
				spriteEvent="brake"
			}
			
			if (spriteEvent=="brake") {
				if (move_dir == sign(gsp)) {
					spriteEvent = "walk"
				}
			}
			if (spriteEvent != "brake"){
			
				if (ceil(abs(gsp))>=topspd) {
					frspd=abs(gsp)/4
					spriteEvent="run"
				}
				else {
					frspd=abs(gsp)/4
					if (frspd < 0.3) {
						frspd = 0.3;
					}
					spriteEvent="walk"
				}
			}
		}
	} break;
	case "crouch": {
		spriteEvent="crouch"
	} break;
	case "jump": {
		spriteEvent="jump"
		if (bonk) {
			spriteEvent="bonk"
		}
	} break;
	case "roll": {
		if (state == "roll") {
			frspd=0.2+abs(gsp)/3
			spriteEvent="roll"
		}
	} break;
	case "spindash": {
		spriteEvent="spinDash"
	} break;
	case "wallrun": {
		frspd=abs(vsp)/4
		spriteEvent="wallRun"
	}
}

if (state != "") {
	wait_timer = 0;
}

if (dropdash && dropdash_timer >= 18) {
	spriteEvent="dropDash"
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
#endregion

//chopp: to handle any signals, make sure you define the code here with the same name 

#define on_kill
playsfx(charmName+"die")
give_lives(pNum, -1000, -1000, -1, -4, -4)
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

#define star
VinylPlay(asset_get_index("snd_powerup"));
invincible_type=2;
invincible_timer=510;

#define 1up
give_lives(pNum, x + (hit_sizex / 2), y - 8)

#define 3up
give_lives(pNum, x + (hit_sizex / 2), y - 8, 3, p3UP)

#define ceil_bonk
bonk = 12

#define floor_land
canstopjump = false;
if state!="wallrun" state = "";
bonk = 0;
gsp = hsp
wallrundata[0]=0;

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

if (dropdash && dropdash_timer >= 18) {
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
state = "";

#define enemy_stomped
vsp=-4-akey*1.5

#define collide_with_enemy
var coll=collision_rectangle(x-hit_sizex,y-hit_sizey,x+hit_sizex,y+hit_sizey, oEnemy, false, true)
if (coll) && (!coll.no_dam) {

if (coll) && (state!="roll") && (state!="spindash") {
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