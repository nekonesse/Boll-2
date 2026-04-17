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
physics_enabled = false;
static_frame = 0;

monitor_frame = 0;

sprite_index = spr_monitorstatic;
image_speed = 0.25;
true_img_index = 0;

blockHit.Destroy();

blockHit.Connect( self, function(hit_p, obj) {
	var i=instance_create_depth(x,y,0,oMonitorPopup), brkvsp = 0;
	i.itemfr = monitor_frame
	if (obj.object_index == oPlayer) {
		i.player = obj
		if (obj.bbox_top > (y + 8) && obj.vsp < 0) {
			with (obj) {
				vsp = 2;
				
				VinylPlay(snd_blockbump);
				sig.Emit("ceil_bonk");
				colflags |= COL_CEILI;
			}
			brkvsp = -1.2;
		}
	} else if (obj.object_index == oKoopa) || object_is_ancestor(obj.object_index,oKoopa) {
		if (obj.in_shell) {
			i.player = obj.kickedplayer
		}
	}
	VinylPlay(snd_monitor)
	instance_create_depth(x,y,0,pSmoke)
	with (instance_create_depth(x,y,0,pBrokenMonitor)) {
		vsp = brkvsp;	
	}
	instance_destroy();
});