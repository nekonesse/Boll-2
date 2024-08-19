#define datalist
sprite_list=split_string("stand,wait,lookup,pose,crouch,hurt,dead,walk,run,brake,jump,bonk,fall,runjump,longjump,sideflip,doublejump,doublejumpbonk,doublejumpfall,wallslide,groundpound,slide,standcarry,lookupcarry,crouchcarry,walkcarry,jumpcarry,bonkcarry,fallcarry,doublejumpcarry,throw,airthrow,roll,poundfall,swim,paddle,swimcarry,spinjump,fire,push,balancing,bellyslide,dive,capeflight,climbing,flagslide,hanging,hangmove,grind,piping,pipingup,sidepiping,doorenter,doorexit",",");
sound_list=split_string("select,damage,die,jump,win,step,bonk",",");

#define create
jump = 0;
slopesliding = 0;
no_move = 0;
fric = 0.0625;
runvar = 0;
runjump = 0;
skidding = 0;
skiddir = 0;
pound_timer = 0;
pound = 0;
storedxsc = 1;
wallsliding = false;

#define step

if (braking) xsc=brakedir
maxspd = 2+runvar;
no_move = !(!pound && !pound_timer);
//add more checks here

if ((apress) && !(grounded)) {
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

// Fall off platform
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
	
	#region Groundpound
	if (downpress) && !(pound_timer) && !(pound) {
		pound_timer=10;
		hsp=0;
		grav=0;
		playsfx(charmName+"pound")
	}
	
	if (pound_timer) && !(pound) {
		pound_timer = max(0,pound_timer-1);
		
		if !(pound_timer) {
			pound = 1;
			grav = defaultgrav;
		}
		vsp = 0;
	}
	
	if (pound) {
		vsp = 7;
		hsp = 0;
	}
	#endregion
} else {
	canjump = 5;  // Coyote frames
	jump = 0;
	runjump = 0;
	if (pound) {
		vsp = 0;
		pound = false;
	}
	//maximum speed when sliding, infulence when sliding, influence on steep slopes, add steep influence while sliding?
	player_slide(5.5, 0.225, 0.32, false);
	
	//temp skidding
	if (sign(hsp)!=esign(move,xsc)) {
		if (abs(hsp)>2 && !carry && !skidding) {
			skidding=1
			//playsfx(name+"skid",1)
			skiddir=esign(move,xsc)
		}
	} else {
		skidding=0
	}

}

//End slope sliding (THIS CANNOT BE IN THE PLAYER_SLIDE FUNCTION WITHOUT REWORKING IT !!!!)
if ((!abs(sign(colslope)) && (abs(hsp) < 0.25)) || jump) {
	slopesliding = 0
	crouch = 0
}
	
#region Jumping
if (!akey) //Make player jump lower when jump is released
{
	if ((canstopjump) && (vsp < -2))
	{
	    vsp *= 0.6;
	}
}

//Actual Jump
if ((canjump > 0 || wallsliding) && (apress))
{
	jump = 1;
	bufferjump = 0;
	groundtime = 0;
	grounded = false
	if (wallsliding) {xsc=-xsc hsp=(4*xsc)}
	vsp = -(6+min(1,abs(hsp)/10)-(wallsliding*2)); //jump power
	canjump = 0;
	canstopjump = 1;
	steep_slope = false;
	no_move = false;
	//check if speed is high enough for visual run jump
	if ((run && abs(hsp)>3) || wallsliding) {runjump=1} 
	playsfx(charmName+"jump")
	wallsliding = false;
}

if (jump && (!pound && !pound_timer)) {
	steep_slope = false;
	no_move = false;
}

#region Walljump/slide
if (move != 0) {
	//wall sliding
	var coll=check_collision_line(x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc),x+((hit_sizex+1)*xsc),y-((hit_sizey-2)*ysc),COL_WALL)
	if (!grounded) && (coll) && (vsp > 0) && !(move_lock) {
		vsp=min(vsp,0.75);
		wallsliding=true;
	} else {
		if (wallsliding) xsc=-xsc;
		wallsliding=false;
	}
} else {
	wallsliding=false;
}
#endregion

#endregion

#region Running
if (bkey) {
	run=1.5;
} else {
	run = 0;
}
#endregion

if (colangle != 0 && slopesliding){
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

// check to see if we need to update the polybox
if (sprindex_prev != sprite_index) {
	//obj_update_poly_from_bounding(self);
	sprindex_prev = sprite_index;
}

// Switch direction
//add more checks here to prevent left/right changing direction
if (left || right) && !(slopesliding) && !(pound_timer || pound)
xsc = esign(move, 1)

bonk=max(bonk,bonk-1)

runvar = approach_val(runvar,run,0.05)

#define sprmanager

frspd=1
if (slopesliding) sprite="slide"
else if (!grounded) {
	if (wallsliding) sprite="wallslide"
	else if (pound_timer) sprite="groundpound"
	else if (pound) sprite="poundfall"
	else if (bonk) sprite="bonk"
	else if (vsp>0 && !runjump) sprite="fall"
	else if (jump) if (runjump) sprite="runjump" else sprite="jump"
}
else if (crouch) sprite="crouch"
else if (skidding) {
	sprite="brake" 
	xsc = -(skiddir)
}
else if (ceil(abs(hsp))>3) sprite="run"
else if !(abs(hsp)) sprite="stand"
else {
	frspd=abs(hsp)/4
	sprite="walk"
}

//chopp: to handle any signals, make sure you define the code here with the same name 

#define jumped
show_debug_message("Situation becomes worse....");

#define mushroom
show_debug_message("eatted it :)");

#define ceil_bonk
bonk = 12

#define floor_land
if (pound) {
	playsfx(charmName+"stomp")
}

bonk = 0;
pound = 0;
pound_timer = 0;

#define sprung
canstopjump=0;
bonk = 0;
pound = 0;
pound_timer = 0;