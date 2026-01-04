//PLAYER SIGNALS

sig = new Signal();
updateBox = new Signal();
sig.Connect( self, function(str_var) {
	catspeak_execute(global.scripts[? $"{charmName}_{str_var}"]);
});

// Palette
//palette=0
//palette_index=0

grabbed_obj = noone;
is_grabbing = false;
input_enable = false
///// GENERAL /////

pNum = 0; //player number (P1, P2, etc.)
charmName = global._playerChars[pNum]; //what charm this player character is using
size="basic";
oldsize="basic";
colangle = 0;
palette=0

hit_sizex = 6
hit_sizey = 6
collision_array=[oCollider, oGrate];

///// PHYSICS /////
grav=0.25; //we're having an actual grav var now because changing gravity should be EASIER!!
defaultgrav = grav; //for resetting gravity back to default
vsp=0;
hsp=0;
gsp=0;

// chearii: we SRB2 in this house (conveyor speeds for moving platforms)
chsp = 0;
cvsp = 0;

maxspd = 0; //gets overridden in step event
steep_slope = false

// chearii: accel and friction were 0.5 and 0.4, respectively. I'm just changing them to their SMW values
accel = 0.09375; //how fast you gain speed
fastaccel = 0.3125; // accel during a turnaround
skid_accel = 0.16125; // accel while skidding ?
fric = 0.0625; //slipperiness
friction_mult = 1; //multiplier for friction (e.g. ice blocks)
move=0

xsc=1
ysc=1
rot=0
fr=0
frame=0
fhaslooped=0
dy=0

cantslowanim=0
flash=0
water=0
animf=0
frspd=1
sid=0
realjump = 0;
canjump = 0;
bufferjump = 0;
wallbuffer = 0;
no_move = false;
no_step = false;
move_lock = false;
piped = false; //tell me if you want this gone ok thanks
grounded = false;
dead = 0;
finish = 0;
posed = 0;
carrying = 0;
run=0;
bonk=0;
collflags = 0; // collision flags
electrocuted = false; //if player is electrocuted by something
electrocution_timer = 0; //for the electrocuted animation
grow=0;
can_break_bricks=false;
has_fired=0;
wait_timer=0;	//wait animation
was_frozen=false;
frozen_health=5;
sprung=0;

pollenated=false;
pollenPart=-1;

stompCombo=0;

//warping stuff
warp_timer = 0;
warp_dir = 0;
warp_coll = noone;
warp_out = false; //if the player is warping out a pipe rather than warping in
warp_type = ""; //type of warping (for sprite managers)

sprindex_prev = sprite_index;

canstopjump=1;
jump=0;
steps = 0;
colslope = 0;
steep_slope = 0;
slopesliding = 0;
hurt=0;
invincible_timer=0;
invincible_type=0;
image_speed=0
depth=0;
image_xscale = 1
image_yscale = 1

// chearii: special case for dealing damage to enemies
damagespecial = -1;

// boxpoly setup
setup_box_poly(id);

// camera
my_camera=instance_create(x,y,oCamera)

my_camera.target = self;

if (!global.zoom_on_start)
{
	my_camera.zoom = 1;	
}

//sheet=global.player_sheets[0][0]

//Sprite Events
spriteEvent="idle"

///// EVENT SETUP /////

catspeak_execute(global.scripts[? $"{charmName}_create"])

start_hit_sizex = hit_sizex
start_hit_sizey = hit_sizey

init_player();

right = false
left = false
up = false
down = false
downpress = false

akey = false
apress = false
bkey = false
bpress = false
ckey = false
cpress = false

death_time = false
death_time_counter = 0

if (global.checkpointX != no_checkpoint && global.checkpointY != no_checkpoint) {
	x = global.checkpointX + 32 - (8 * global.checkpointDir)
	y = global.checkpointY + 40
	xsc = (!global.checkpointDir * 2) - 1 // (0 or 1 -> 1 or -1)
}