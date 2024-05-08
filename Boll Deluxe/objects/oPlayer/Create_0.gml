// Palette
pal_swap_init_system(shd_pal_swapper);
palette=0
palette_index=0

///// GENERAL /////
pNum = 0; //player number (P1, P2, etc.)
charmName = "testcharm"; //what charm this player character is using
size=0;
oldsize=0;

///// PHYSICS /////
grav=0.25; //we're having an actual grav var now because changing gravity should be EASIER!!
defaultgrav = grav; //for resetting gravity back to default
vsp=0;
hsp=0;

// chearii: we SRB2 in this house (conveyor speeds for moving platforms)
chsp = 0;
cvsp = 0;

maxspd = 0; //gets overridden in step event

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
move_lock = false;
piped = false; //tell me if you want this gone ok thanks
grounded = false;
dead = 0;
carrying = 0;
run=0;
collflags = 0; // collision flags

sprindex_prev = sprite_index;

canstopjump=1;
jump=0;
steps = 0
colslope = 0
steep_slope = 0
hurt=0;
image_speed=0
global.paused=0
depth=0;
drawStar=false 

//mycollisions = ds_list_create()
//feel free to delete this along with it's mentions and uses in the draw event
//instance_change(oPlayerTest,true)

// fracval setup
//setup_frac(self);

// boxpoly setup
//setup_box_poly(self);

// slope setup
//instance_make_slopevars(self);

///// EVENT SETUP /////
_loopThrough = function(_lookfor) { //Function to go through and collect string from specific parts of the GML file
	var _code		=file_text_open_read($"{working_directory}\\_vanilla\\character\\{charmName}\\{charmName}.gml");
	var _str		="",
		_cur		=file_text_read_string(_code),
		_NLstr		="",
		_fileSTR	="";
	
	//Looking for our section
	while (_cur!=$"#define {_lookfor}") {
		file_text_readln(_code);
		_cur	=file_text_read_string(_code);
	}
	//Getting the code from our section
	while (!file_text_eof(_code) and !string_starts_with(_NLstr,"#define")) {
	    file_text_readln(_code);
		_fileSTR	=file_text_read_string(_code);
		_NLstr		=_fileSTR;
		if (!string_starts_with(_NLstr,"#define"))
			_str +=$"{_fileSTR}\n";
	}
	file_text_close(_code);
	
	//Returning it to the caller
	return _str;
}

_createEvent = txr_compile(_loopThrough("create"));
if (_createEvent == undefined) {
    show_message(txr_error);
} 
txr_exec(_createEvent);

_stepEvent = txr_compile(_loopThrough("step"));
if (_stepEvent == undefined) {
    show_message(txr_error);
}

_spriteManagerEvent = txr_compile(_loopThrough("sprmanager"));
if (_spriteManagerEvent == undefined) {
    show_message(txr_error);
}

_spriteListEvent = txr_compile(_loopThrough("spritelist"));
if (_spriteListEvent == undefined) {
    show_message(txr_error);
}

replace_animdat($"{working_directory}\\_vanilla\\character\\{charmName}\\{charmName}.player.txt");
init_player();