event_inherited();
hsp = 0
vsp = 0
gsp = 0
grav = 0.2
bounce = false
hit_sizex = 8
hit_sizey = 8
bounce_speed = vsp
physics_enabled = false;
static_frame = 0;

monitor_frame = 0;

sprite_index = spr_monitorstatic;
image_speed = 1;

blockHit.Destroy();

blockHit.Connect( self, function(hit_p, obj) {
	var i=instance_create_depth(x,y,0,oMonitorPopup)
	i.itemfr = monitor_frame
	if (obj.object_index == oPlayer) {
		i.player = obj
	} else if (obj.object_index == oKoopa) || object_is_ancestor(obj.object_index,oKoopa) {
		if (in_shell) {
			i.player = obj.kickedplayer
		}
	}
	VinylPlay(snd_monitor)
	instance_create_depth(x,y,0,pSmoke)
	instance_create_depth(x,y,0,pBrokenMonitor)
	instance_destroy();
});