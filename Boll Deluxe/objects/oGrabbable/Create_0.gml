event_inherited();
hsp = 0;
vsp = 0;
gsp = 0;
grounded = false;
grav = 0.2;
bounce = false;
collision_array = [oCollider]

depth=10;

thrown = false;
carry_player = noone;
grabbed = false;
grab_delay = 0;
kickCombo = 0;

onThrown = new Signal();
onPickup = new Signal();
onBreak = new Signal();

onPickup.Connect( self, function(carry_p) {
	no_collide = true;
	carry_player = carry_p;
});

onThrown.Connect( self, function(thrown_p) {
	carry_player = thrown_p;
	
	var ypos = y;
	var loops = 0;
	while(check_collision_line((x-sprite_width/2),(ypos-sprite_height/2),x+sprite_width/2,ypos+(sprite_height/2)-1,COL_FLOOR)) {
		y--;
		ypos=y;
		loops++;
		if (loops > 100) break;
	}
	
	if (carry_player.up) {
        vsp = -8
        hsp = carry_player.hsp
		make_particle(pImpact,x,y,2)
		VinylPlay(snd_enemykick)
	} else if (carry_player.down) {
        vsp = 0
        hsp = 0
		bounce = false
    } else {
        vsp = -1
		hsp = (carry_player.xsc * 3)
		make_particle(pImpact,x,y,2)
		VinylPlay(snd_enemykick)
    }
	
	grabbed = false;
	thrown = true;
});

onBreak.Connect( self, function() {
});

node_init_vars()