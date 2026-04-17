event_inherited();
hsp = 0
vsp = 0
gsp = 0
grav = 0.2
grounded = 0;
bounce = false
hit_sizex = 8
hit_sizey = 8
bounce_speed = vsp
collision_array=[oCollider, oBarrier];

physics_enabled = false;
bumpable = false;

static_frame = 0;
monitor_frame = 0;

sprite_index = spr_monitorstatic;
image_speed = 0.25;
true_img_index = 0;

blockHit.Destroy();

blockHit.Connect( self, function(hit_p, obj) {
	var brkvsp = 0;
	var broken_player = noone;
	if (obj.object_index == oPlayer) {
		broken_player = obj
		if ((obj.y-hit_sizey >= bbox_bottom+obj.vsp) && obj.vsp < 0 && !obj.grounded) {
			//ok so the problem is this cant work for now under semisolids,
			//as its an issue with the general collision system so it will never work until thats fixed
			brkvsp = -3;
			if (bumpable) {
				vsp = brkvsp;
				physics_enabled = true;
				bumpable = false;
				exit;
			}
		}
	} else if (obj.object_index == oKoopa) || object_is_ancestor(obj.object_index,oKoopa) {
		if (obj.in_shell) {
			broken_player = obj.kickedplayer
		}
	}
	var i=instance_create_depth(x,y,0,oMonitorPopup)
	i.itemfr = monitor_frame;
	i.player = broken_player;
	VinylPlay(snd_monitor)
	instance_create_depth(x,y,0,pSmoke)
	with (instance_create_depth(x,y,0,pBrokenMonitor)) {
		vsp = brkvsp;
	}
	instance_destroy();
});