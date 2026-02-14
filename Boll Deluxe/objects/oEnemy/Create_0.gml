///CHANGE STUFF IN VARIABLE DEFINITIONS TO TWEAK BASIC ENEMY BEHAVIORS!
enemyStomped = new Signal();
enemyCollidePlayer = new Signal();
enemyFireballed = new Signal();
enemyKilled = new Signal();
enemyTurnAround = new Signal();
enemyShelled = new Signal();
enemyRolledInto = new Signal();
grav=defaultgrav
_direction = -1
rot=0
xsc=1
ysc=1
hsp = 0
vsp = 0
gsp = 0
spawn_object=noone
no_dam = false;
deal_dam = true;
colangle = 0
phase_leeway = 0;

phaseid=noone;
flipped=0;
turned=0;
turning=0;
in_shell=false;
attach_to_ceiling=false;
onceiling=false;
collision_array=[oCollider, oEnemyGround];

killtype="";
killdir=0;
killhsp=1;
killvsp=-3;

piped = false
grounded = false
overridexsc = false
no_turn_anim = false;
no_slope_influence = false;
turnxsc = 1;

hit_sizex = 6
hit_sizey = 6

activation_region_width=32;
activation_region_height=32;

parent_pipe = noone;

image_xscale=1;
image_yscale=1;
depth=4;
sprindex_prev = sprite_index;

thrown = false;
carry_player = noone;
grabbed = false;
can_grab = false;

onThrown = new Signal();
onPickup = new Signal();

onPickup.Connect( self, function(carry_p) {
	carry_player = carry_p;
	phaseid = carry_p;
	phase_leeway = 8;
	grounded = false;
});

onThrown.Connect( self, function(thrown_p) {
	var ypos = y;
	var loops = 0;
	while(check_collision_line(x-hit_sizex,ypos+hit_sizey,x+hit_sizex-1,ypos+hit_sizey,COL_FLOOR)) {
		y--;
		ypos=y;
		loops++;
		if (loops > 100) break;
	}
	
	carry_player = thrown_p;
	if (carry_player.up) {
        vsp = -8
        hsp = carry_player.hsp
		grounded=false;
		make_particle(pImpact,x,y,2)
		VinylPlay(snd_enemykick)
    } else if (carry_player.down) {
        vsp = 0
        hsp = 0
    } else {
        vsp = -1
		hsp = (carry_player.xsc * 3)
		make_particle(pImpact,x,y,2)
		VinylPlay(snd_enemykick)
	}
	
	grabbed = false;
	thrown = true;
});

enemyStomped.Connect( self, function(hit_p) {
	if (!no_stomping) {
		hp-=1
		with(hit_p) {
			increase_combo(other.x,other.y);
			
			sig.Emit("enemy_stomped")
			instance_create_depth(x,y+hit_sizey,2,pImpact)
		}
		phaseid=hit_p
		phase_leeway=7;
		killtype="stomp"
	} else {
		with(hit_p) {
			sig.Emit("stomp_failed")
		}
		phaseid=hit_p
		phase_leeway=7;
	}
});

enemyCollidePlayer.Connect( self, function(hit_p) {
	with(hit_p) {
		sig.Emit("collide_with_enemy")
	}
	phaseid=hit_p
	phase_leeway=7;
});

enemyFireballed.Connect( self, function(proj, hit_p) {
	VinylPlay(snd_enemykick)
	hp-=1
	instance_create_depth(proj.x,proj.y,2,pImpact)
	killhsp=1
	xsc=esign(proj.hsp, xsc)
	killtype="spin"
});

enemyTurnAround.Connect( self, function() {
	turnxsc = xsc;
	_direction *= -1;
	turning = 10;
	prevsprite_index=sprite_index
	if (walker && !grounded) {
		hsp=-hsp;
	}
});

enemyShelled.Connect( self, function(hit_obj, kick_p) {
	killtype = "spin";
	killhsp = sign(hit_obj.hsp);
	phaseid=hit_obj;
	phase_leeway=7;
	hp-=1;
});

enemyRolledInto.Connect( self, function(hit_p) {
	hp-= 1
	vsp=-4;
	phaseid=hit_p
	phase_leeway=15;
	killdir= esign(x-x,1)
	killhsp= max(abs(hit_p.hsp)/1.75,2)
	xsc= esign(hit_p.hsp,hit_p.xsc)
	killvsp= -max(2,abs(hit_p.hsp)/1.5)
	killtype= "spin"
});