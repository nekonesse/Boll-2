#define spritelist
sprite_list=[];
array_push(sprite_list,"stand","wait","lookup","pose","crouch","hurt","dead","walk","run","brake","jump","bonk","fall","runjump","longjump")

#define create
jump = 0;


#define step

maxspd = 2;	
	
if (grounded) && (down || steep_slope) {
	hsp += 0.1 * colslope
}

if ((apress) && !(grounded))
{
	
	alarm_set(0,5);  // ammount of frames for jump buffering
	alarm_set(1,3);  // Walljump buffering
}
else if (grounded == true)
{
	alarm_set(1,0)
	wallbuffer = 0;
}

if ((alarm_get(0) > 0) && (grounded))
{
	bufferjump = 1;
	alarm_set(0,0)
}

// Fall off platform
if (!grounded)
{
	vsp = min(4, vsp + grav);
	canjump -= 1;
	
	// chearii: coneyor speed management
	if (abs(chsp * 100))
	{
		chsp *= 0.95;
		
		if (((chsp * 100) / 1) == 0)
		chsp = 0;
	}
}
else
{
	canjump = 5;  // Coyote frames
	jump = 0;
}	
	
// Jumping
if (!akey)
{
	if ((canstopjump == 1) && (vsp < -2))
	{
	    vsp *= 0.6;
	}
}

if ((canjump > 0) && (apress))
{
	jump = 1;
	bufferjump = 0;
	groundtime = 0;
	grounded = false
	vsp = -6;
	canjump = 0;
	canstopjump = 1;
	//sig.Emit("jumped")
}

player_movement();	
player_collision();
//show_debug_message(test[3]);




// polygons!!!!!
// nekonesse: i beg of you turn this into a basic script/function for charm users....

// check to see if we need to update the polybox
if (sprindex_prev != sprite_index) {
	//obj_update_poly_from_bounding(self);
	sprindex_prev = sprite_index;
}

// Pipes ??? (works now)
// if (grounded && down && place_meeting(x, y + 4, oPipeUp)) {  
    // with instance_place(x, y + 4, oPipeUp) {
        // if (canenter) {
            // with other {  
                // alarm[3] = 80;
                // piped = 1;
                // vsp = 1.5;
                // hsp = 0;
                // //x_frac = intlib_make_fixedpoint((other.x + (other.sprite_width / 2))) >> FRACBITS;
            // }
            // // sorry about the global variables here but the player object isnt
            // // persistent so im overpreparing for room reloads lol
            // global.exitlocation = target;  
            
            // global.exittype = warptypes.pipe;  
        // }
    // }
// }

coll = instance_place(x, y, oMushroom);

if (coll) {
    oldsize = size;

    if (size < 1)
        size = 1;

    //alarm[11] = 60;
    instance_destroy(coll);
}

// Switch direction
if (left || right)
xsc = esign(move, 1)

#define sprmanager

frspd=1
if (vsp>0) sprite="fall"
else if (jump) sprite="jump"
else if !(round(abs(hsp))) sprite="stand"
else {
	frspd=abs(hsp)/4
	sprite="walk"
}

//chopp: to handle any signals, make sure you define the code here with the same name 

#define jumped

show_debug_message("Situation becomes worse....");

