#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
image_speed = 0;

name="sonic"

///These should all be moved to charm v
defaultgrav = 0.25; //for resetting gravity back to default
grav=defaultgrav //we're having an actual grav var now because changing gravity should be EASIER!!
maxspd = 0; //gets overridden in step event
accel =0.06; //how fast you gain speed
fric = 0.2; //friction, slipperiness
maxspd = 0; //gets overridden in step event
accel =0.06; //how fast you gain speed
fric = 0.2; //friction, slipperiness
size = 1;
starred = 0; //do not use size 4 for stars anymore that is kinda Bitch mode
vsp=0
hsp=0

move=0 //placeholder

xsc=1
ysc=1
rot=0
fr=0

realjump = 0;
canjump = 0;
bufferjump = 0;
wallbuffer = 0;
move_lock = false; //prevent player from moving, like piped
is_grinding = false; //is player grinding on rail
piped = false; //is player piping
grounded = false; //is player on the ground
dead = 0;
carrying = 0;
run=0;
wf=1;

windowscale=3;

antigrav = false;
canstopjump=0;
jump=0

window_set_cursor(cr_none)

//this should be all moved to an options screen later
window_set_size(480*windowscale,270*windowscale)

if !window_get_fullscreen()
{
    window_center();
}

viewh=view_hview[0]
vieww=view_wview[0]
#define Alarm_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=605
invert=0
arg0=hurt timer
*/
#define Alarm_1
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=605
invert=0
arg0=jump buffer
*/
#define Alarm_2
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=605
invert=0
arg0=walljump buffer
*/
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
view_hview[0]+=4*(keyboard_check(ord("1"))-keyboard_check(ord("2")))
view_wview[0]+=8*(keyboard_check(ord("1"))-keyboard_check(ord("2")))

if keyboard_check(ord("3")) {
view_hview[0]=viewh
view_wview[0]=vieww
}

if y > room_height+16 {
x=xstart
y=ystart
}
/// -S- this is literally the diegotc engine please remake this. Entirely.
//i will later, for now I'm gonna work on the level editor, might call it like, lemon-s- hahahahaha kil me - -S-
//Okay checkinf back on this, did you seriousy use grounded instead of jump i am gonig to kill you. - -S-
//-s- 'grounded' is a fucking variable to check on the ground or not, 'jump' is a variable to see if you have JUMPED !!! NOT JUST MIDAIR!! -cubie
image_speed = 0;
windowscale = clamp(windowscale,2,4)


if keyboard_check_pressed(107) || keyboard_check_pressed(187) {
    windowscale+=1
    window_set_size(480*windowscale,270*windowscale)
    window_center();
}

if keyboard_check_pressed(189) {
    windowscale-=1
    window_set_size(480*windowscale,270*windowscale)
    window_center();
}
// ^^ this is just random ass debug shit -cubie

input_get(-1)//we don't have the p2 shit yet
//please do not use p2 for it this time its so confusing on what the hell that means -cubie
//input get uses the boll variables
apress=abut
bpress=bkey
cpress=ckey

if global.lemonpause {
    if !paused {
        paused=1
    }
    if left && !right x-=2
    if right && !left x+=2
    if up && !down y-=2
    if down && !up y+=2

    exit
} else if paused && !global.lemonpause { //Upon removing lemonpause (entering live editor)
    inactive=0
    paused=0
    move=0
    hsp=0
    vsp=0
} //im just gonna like, leave this here for now - -S-

com_piping();

if piped exit;

maxspd = 2+(bkey)+(5*is_grinding);

//uuh this resets grav back to default. this is leftover from diegotc LOL, just add more checks here.
if (!antigrav) {
    grav = defaultgrav
}

if (!move_lock && !piped && !hurt) {
    move = -left + right
}

if (apress) && grounded == false {
    alarm[1] = 10; //ammount of frames for jump buffering
    alarm[2] = 10; //Walljump buffering
}
else if grounded == true {
    alarm[2] = 0;
    wallbuffer = 0;
}

if (alarm[1] > 0) && grounded == true {
bufferjump = 1;
alarm[1] = 0;
}

if move != 0 {
    hsp += move*accel
    hsp = clamp(hsp,-maxspd,maxspd)
} else {
    if grounded && !is_grinding
    hsp = lerp(hsp,0,fric)
}

//Fall off platform
if !grounded {
    vsp=min(4,vsp+grav)
    canjump -= 1 //Count down coyote time
} else {
    canjump = 7 //Coyote frames
}

if !(akey) {
    if (canstopjump=1 && vsp<-2 ) {
        vsp*=0.6
    }
}


grounded=false

//Jumping
if (canjump > 0 && (apress)) || (bufferjump) {
    fr=1
    bufferjump = 0;
    vsp = -6;
    jump=1
    canjump = 0;
    canstopjump=1;
}

collision();

com_grinding();

//this isj ust ... funny rotato
if place_meeting(x,y+1,slopel) && !place_meeting(x,y+1,groundblock)
rot=approach_val(rot,45,5);
else
rot=approach_val(rot,0,5);

//Switch direction
if (left) && !move_lock
xsc=-1
else if (right) && !move_lock
xsc=1
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_sprite_ext(sprite_index,fr,x,y,xsc,ysc,rot,c_white,image_alpha)
