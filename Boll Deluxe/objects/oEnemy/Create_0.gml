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
colangle = 0
phase_leeway = 0;

phaseid=noone;
flipped=0;
turned=0;
turning=0;
in_shell=false;
collision_array=[oCollider, oEnemyGround];

killtype="";
killdir=0;
killhsp=1;
killvsp=-3;

piped = false
grounded = false
overridexsc = false

hit_sizex = 6
hit_sizey = 6

activation_region_width=32;
activation_region_height=32;

image_xscale=1;
image_yscale=1;
depth=4;
sprindex_prev = sprite_index;

// boxpoly setup
setup_box_poly(id);

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
	_direction *= -1;
	turning = 10;
	prevsprite_index=sprite_index
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
	phaseid=id
	phase_leeway=15;
	killdir= esign(x-x,1)
	killhsp= max(abs(hit_p.hsp)/1.75,2)
	xsc= esign(hit_p.hsp,hit_p.xsc)
	killvsp= -max(2,abs(hit_p.hsp)/1.5)
	killtype= "spin"
});