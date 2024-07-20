#define datalist
sprite_list=split_string("stand,wait,lookup,pose,crouch,knock,dead,walk,run,maxrun,brake,spring,springfall,jump,bonk,ball,spindash,spincharge,dropdash,push,balance,fire,dash,specfall,climbing,flagslide,hanging,hangmove,grinding,piping,pipingup,sidepiping,doorenter,doorexit",",");
sound_list=split_string("select,damage,die,jump,win,step,bonk,release,skid,spin,spindash,insta,dash,boom,firedash,dropdash",",");

#define create
jump = 0;
slopesliding = 0;
spin = 1;
no_move = 0;
fric = 0.0625;
runjump = 0;
skidding = 0;
skiddir = 0;
pound_timer = 0;
pound = 0;
storedxsc = 1;
spindashActive = 0;
spindashTotal = 0;

#define step

if (braking) xsc=brakedir
maxspd = 3.5;
no_move = !(!spin && !spindashActive);
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
	vsp = min(7, vsp + grav);
	canjump -= 1;
	
	// chearii: coneyor speed management
	if (abs(chsp * 100))
	{
		chsp *= 0.95;
		
		if (((chsp * 100) / 1) == 0)
		chsp = 0;
	}
} else {
	canjump = 5;  // Coyote frames
	jump = 0;
	runjump = 0;
	
	#region // Crouch, Spindash
	if (down) && (hsp==0) && (grounded) {
		crouch=1;
	}
	else if (down) && (hsp!=0) {
		if (!spin) playsfx(charmName+"spin")
		stopsfx(charmName+"spindash")
		stopsfx(charmName+"release")
		spin=1;
	}
	else if (hsp!=0) {
		crouch=0;
		spindashActive = 0;
	}
	
	if (crouch) && (apress) && (hsp==0) && (!slopesliding) {
		spindashActive = 1;
		spindashTotal += 1;
		hsp=0;
		stopsfx(charmName+"spindash")
		playsfx(charmName+"spindash",1+((spindashTotal-1)/10))
	}
	
	if (spindashTotal>6) spindashTotal = 6;
	else if (spindashTotal>1) spindashTotal -= 1/60;
	
	if (!crouch) && (spindashTotal>0) {
		hsp = (2+(spindashTotal/3))*xsc;
		spindashTotal = 0;
		spindashActive = 0;
		crouch = 0;
		stopsfx(charmName+"spindash")
		playsfx(charmName+"release")
	}
	#endregion
	
	//maximum speed when sliding, infulence when sliding, influence on steep slopes, add steep influence while sliding?
	player_slide(5.5, 0.225, 0.32, false);

}

//End slope sliding (THIS CANNOT BE IN THE PLAYER_SLIDE FUNCTION WITHOUT REWORKING IT !!!!)
if ((!abs(sign(colslope)) && (abs(hsp) < 0.25)) || jump) {
	slopesliding = 0;
	spin = 0;
	crouch = 0;
}
	
#region Jumping
if (!akey) //Make player jump lower when jump is released
{
	if ((canstopjump == 1) && (vsp < -2))
	{
	    vsp *= 0.6;
	}
}

//Actual Jump
if ((canjump > 0) && (apress) && (!spindashActive)) {
	jump = 1;
	bufferjump = 0;
	groundtime = 0;
	grounded = false
	vsp = -(5.6+min(1,abs(hsp)/10)); //jump power
	canjump = 0;
	canstopjump = 1;
	spin = 0;
	steep_slope = false;
	no_move = false;
	playsfx(charmName+"jump")
}

if (jump) {
	steep_slope = false;
	no_move = false;
}

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
	
player_movement_sonic();
player_collision();
post_wall();

// check to see if we need to update the polybox
if (sprindex_prev != sprite_index) {
	//obj_update_poly_from_bounding(self);
	sprindex_prev = sprite_index;
}

// Switch direction
//add more checks here to prevent left/right changing direction
if (left || right) && !(slopesliding) && !(pound_timer || pound) && !(spindashActive)
xsc = esign(move, 1)

bonk=max(bonk,bonk-1)

runvar = approach_val(runvar,run,0.05)

#define sprmanager

frspd=1
if (spin) sprite="ball"
else if (!grounded) {
	if (bonk) sprite="bonk"
	else if (vsp>0 && !jump) sprite="springfall"
	else if (jump) sprite="jump"
}
else if (spindashActive) {
	frspd=1+(spindashTotal/10)
	sprite="spindash"
}
else if (crouch) sprite="crouch"
else if (skidding) {
	sprite="stand" 
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

show_debug_message("Heh, eatted it!");

#define ceil_bonk

bonk = 12

#define floor_land

if (pound) {
	playsfx(charmName+"stomp")
}

bonk = 0;
pound = 0;
pound_timer = 0;