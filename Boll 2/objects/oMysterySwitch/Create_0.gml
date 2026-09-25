event_inherited();

onreactivate_link = [];

on_sprite = spr_mysteryswitchon;
off_sprite = spr_mysteryswitchoff;
switch_state = false;

activateLink.Destroy();

activateLink.Connect(self, function(index, obj) {
	activated_by_link = true;
	switch(index) {
		case 0:
			hitSwitch.Emit();
		break;
		case 1:
			reactivateSwitch.Emit();
		break;
	}
});


hitSwitch.Destroy();

hitSwitch.Connect( self, function(_obj) {
	if !(switch_state) {
		trigger_links(ontrigger_link);
		
		if (_obj.object_index == oPlayer) || object_is_ancestor(_obj.object_index,oEnemy) && (image_angle == 0) {
			_obj.vsp=0;
		}
		
		switch_state = true;
		event_user(0);
		
		VinylPlay(snd_switch);
	}
});

reactivateSwitch = new Signal();

reactivateSwitch.Connect( self, function() {
	if (switch_state) {
		trigger_links(onreactivate_link);
		
		switch_state = false;
		event_user(0);
		
		VinylPlay(snd_switch);
	}
});