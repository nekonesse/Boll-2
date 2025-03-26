event_inherited();
flip_time = 0;
stop_bump = 0;

bbox_mem = [bbox_left,bbox_right,bbox_top,bbox_bottom];

blockHit.Connect( self, function(hit_p, obj) {
    
	flip_time = 300;
	image_speed = abs(hit);
	//hit = hit_p;
	//dy = -1 * hit;
	//obj.vsp = 2;
	//going = true;
	
	//sprite_index = image_hit

});

blockFinished.Connect( self, function() {
    
	//event_user(1);
	//image_speed=0;
	//sprite_index = image_exausted
	no_hit = true
	no_collide = true
});