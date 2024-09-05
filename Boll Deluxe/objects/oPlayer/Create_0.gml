//PLAYER SIGNALS

sig_names = ["jumped", "mushroom", "fireflower"]
// MAKE SURE THE NAME ACTUALLY EXISTS IN THE CHARM OR THE PROGRAM WILL FREEZE!! - chopp
sig = new Signal();
updateBox = new Signal();

sig.Connect( self, function(str_var) {
    
	txr_exec(global.scripts[? $"{charmName}_{str_var}"]);

});

// Palette
pal_swap_init_system(shd_pal_swapper);
palette=0
palette_index=0

greenmode=0

///// GENERAL /////
pNum = 0; //player number (P1, P2, etc.)
charmName = global._playerChars[pNum]; //what charm this player character is using
size="basic";
oldsize="basic";
colangle = 0;

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
fric = 0.0625; //slipperiness
move=0

xsc=1
ysc=1
rot=0
fr=0
frame=0

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
move_lock = false;
piped = false; //tell me if you want this gone ok thanks
grounded = false;
dead = 0;
carrying = 0;
run=0;
bonk=0;
collflags = 0; // collision flags

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
image_speed=0
depth=0;
image_xscale = 1
image_yscale = 1
drawStar=false;

// boxpoly setup
setup_box_poly(id);

// camera
my_camera=instance_create(x,y,oCamera)

my_camera.target = self;

if (!global.zoom_on_start)
{
	my_camera.zoom = 1;	
}

sheet=-1;
var dir=$"{working_directory}\\_vanilla\\character\\{charmName}\\{charmName}";

player_sheets = {};
for (var i = 0; i < array_length(global.powerups); i += 1) {
	player_sheets[$ global.powerups[i]] = sprite_add_ext($"{dir}-{global.powerups[i]}.png",0,0,0,true);
	if (!sprite_exists(player_sheets[$ global.powerups[i]])) {
		show_debug_message($"tried to add player sheet but no sheet for size '{global.powerups[i]}' exists? defaulting to basic sheet")
	}
}

///// EVENT SETUP /////

txr_exec(global.scripts[? $"{charmName}_create"]);
start_hit_sizex = hit_sizex
start_hit_sizey = hit_sizey

init_player();