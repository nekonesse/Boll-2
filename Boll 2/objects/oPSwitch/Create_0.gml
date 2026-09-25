event_inherited();
going=0;
collision_array=[oCollider, oBarrier];
parentblock = noone;
activated_by_link = false;
ontrigger_link = [];

bumpable = false;

hitSwitch = new Signal();

activateLink = new Signal();

activateLink.Connect(self, function(index, obj) {
	activated_by_link = true;
	switch(index) {
		case 0:
			hitSwitch.Emit();
		break;
	}
});

hitSwitch.Connect( self, function(_obj) {
	oGameManager.pswitch_timer = 60 * 10;
	
	if (_obj.object_index == oPlayer) || object_is_ancestor(_obj.object_index,oEnemy) && (image_angle == 0) {
		_obj.vsp=0;
	}
	
	trigger_links(ontrigger_link);
	
	var i=instance_create_depth(x,y,depth, oPSwitchDead)
	i.image_angle = image_angle;
	
	instance_activate_object(oBrick);
	instance_activate_object(oCoin);
	var bricks, coins, c = 0;
	bricks = -1; coins = -1
	with (oBrick) {
		var pstruct = getnodevars();
		bricks[c++] = pstruct;
		bricks[c++] = depth;
		bricks[c++] = y;
		bricks[c++] = x;
		
		instance_destroy();
	}
	
	c = 0
	
	with (oCoin) {
		var pstruct = getnodevars();
		coins[c++] = pstruct;
		coins[c++] = depth;
		coins[c++] = y;
		coins[c++] = x;
		
		instance_destroy();
	}
	
	if (bricks != 1) {
		c = 0; 
		while (c < array_length(bricks)) {
			instance_create_depth(bricks[c++], bricks[c++], bricks[c++], oCoin, bricks[c++]);
		}
	}
	
	if (coins != -1) {
		c = 0; 
		while (c < array_length(coins)) {
			instance_create_depth(coins[c++], coins[c++], coins[c++], oBrick, coins[c++]);
		}
	}
	
	VinylPlay(snd_switch);
	instance_destroy();
});